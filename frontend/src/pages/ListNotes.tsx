import { useEffect, useState } from "react";
import { NoteServiceClient } from "../generated/notes.client";
import { GrpcTransport } from "../services";
import { Note } from "../generated/notes";

const noteClient = new NoteServiceClient(GrpcTransport);

const ListNotes = () => {
    const [groupedNotes, setGroupedNotes] = useState<{ [date: string]: Note[] }>({});

    useEffect(() => {
        const fetchNotes = async () => {
            try {
                const call = await noteClient.listNotes({});
                if (call.status.code !== 'OK') {
                    console.warn(call);
                    return;
                }
                const sortedNotes = call.response.notes.sort((a, b) => parseInt(b.createdAt) - parseInt(a.createdAt));
                const grouped = sortedNotes.reduce((acc: {[date: string]: Note[]}, note: Note) => {
                    const date = new Date(parseInt(note.createdAt)).toLocaleDateString();
                    if (!acc[date]) {
                        acc[date] = [];
                    }
                    acc[date].push(note);
                    return acc;
                }, {});
                setGroupedNotes(grouped);
            } catch (error) {
                console.error(error);
            }
        };

        fetchNotes();
    }, []);

    return (
        <div className="p-4">
            <h2 className="text-2xl font-bold mb-4">List of Notes</h2>
            {Object.keys(groupedNotes).map(date => (
                <div key={date} className="mb-6">
                    <h3 className="text-xl font-bold mb-2">{date}</h3>
                    <ul className="space-y-4">
                        {groupedNotes[date].map(note => (
                            <li key={note.id} className="p-4 border rounded shadow">
                                <p className="text-lg font-semibold text-gray-600">{new Date(parseInt(note.createdAt)).toLocaleTimeString()}</p>
                                <p>{note.transcription}</p>
                            </li>
                        ))}
                    </ul>
                </div>
            ))}
        </div>
    );
};

export default ListNotes;
