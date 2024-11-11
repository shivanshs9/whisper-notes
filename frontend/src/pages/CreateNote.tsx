import { AudioManager } from "../components/AudioManager";
import Transcript from "../components/Transcript";
import { useTranscriber } from "../hooks/useTranscriber";

const CreateNote = () => {
    const transcriber = useTranscriber();

    return (
        <div>
            <h2 className='mt-3 mb-5 px-4 text-center text-1xl font-semibold tracking-tight text-slate-900 sm:text-2xl'>
                Write Notes on the Go! <br />
                ML-powered speech recognition directly in your browser.
            </h2>
            <AudioManager transcriber={transcriber} />
            <Transcript transcribedData={transcriber.output} />
        </div>
    );
};

export default CreateNote;
