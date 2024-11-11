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
                const grouped = sortedNotes.reduce((acc: { [date: string]: Note[] }, note: Note) => {
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

    const formatDate = (dateString: string) => {
        const date = new Date(dateString);
        const formattedDate = new Intl.DateTimeFormat(
            'en-US', { weekday: 'short', month: 'short', day: 'numeric' }
        ).format(date);
        const year = date.getFullYear();
        return { formattedDate, year };
    };

    const formatTime = (timestamp: string) => {
        const date = new Date(parseInt(timestamp));
        return new Intl.DateTimeFormat(
            'en-US', { hour: 'numeric', minute: 'numeric', hour12: true }
        ).format(date);
    };

    return (
        <div className="p-4 list-notes">
            <h2 className="text-2xl font-bold mb-4">Journal so far</h2>
            {Object.keys(groupedNotes).map(date => {
                const { formattedDate, year } = formatDate(date);
                return (
                    <div key={date} className="mb-6">
                        <div className="flex justify-between items-center mb-2">
                            <h3 className="text-xl font-bold">{formattedDate}</h3>
                            <span className="text-xl font-bold">{year}</span>
                        </div>
                        <ul className="space-y-4">
                            {groupedNotes[date].map(note => (
                                <li key={note.id} className="p-4 border rounded shadow w-full">
                                    <p><span className="font-semibold text-gray-600">{formatTime(note.createdAt)} </span>
                                    <span className="text-green-50">{`[${note.userIdentifier}]`}</span> {`:${note.transcription}`}</p>
                                </li>
                            ))}
                        </ul>
                    </div>
                );
            })}
        </div>
    );
};

export default ListNotes;
