import { useEffect, useState } from "react";
import CreateNote from "./pages/CreateNote";
import ListNotes from "./pages/ListNotes";

// @ts-ignore
const IS_WEBGPU_AVAILABLE = !!navigator.gpu;

function App() {
    const [menuOpen, setMenuOpen] = useState(false);
    const [hashPath, setHashPath] = useState(window.location.hash);

    const toggleMenu = () => {
        setMenuOpen(!menuOpen);
    };

    const listenToUrlChange = () => {
        const newHashPath = window.location.hash;
        console.log("Navigated to " + newHashPath);
        setHashPath(newHashPath);
    };
    useEffect(() => {
        window.addEventListener("hashchange", listenToUrlChange);
        return () => {
            window.removeEventListener("hashchange", listenToUrlChange);
        };
    }, []);

    const switchPage = (newPage: string) => {
        location.hash = newPage;
        setMenuOpen(false);
    }

    return IS_WEBGPU_AVAILABLE ? (
        <div className='flex flex-col justify-center items-center min-h-screen'>
            <div className='container flex flex-col justify-center items-center'>
                <div className='absolute top-4 left-4 z-20'>
                    <button onClick={toggleMenu} className='hamburger'>
                        {menuOpen ? '✖' : '☰'}
                    </button>
                </div>
                <div className={`menu ${menuOpen ? 'open' : ''}`}>
                    <a onClick={() => {switchPage("new")}} className='menu-item'>Write a new entry...</a>
                    <a onClick={() => {switchPage("list")}} className='menu-item'>Journal so far</a>
                </div>
                <h1 className='text-5xl font-extrabold tracking-tight text-slate-900 sm:text-7xl text-center'>
                    Whisper Notes
                </h1>
                {hashPath === "#list" ? <ListNotes /> : <CreateNote />}
            </div>

            <div className='bottom-4 credits'>
                <p>
                Made with{" "}
                <a
                    className='underline'
                    href='https://github.com/xenova/transformers.js'
                >
                    🤗 Transformers.js
                </a>
                </p>
                <p>
                Developed by{" "}
                <a
                    className='underline'
                    href='https://github.com/shivanshs9'
                >
                    @shivanshs9
                </a> 🚀
                </p>
                <p>
                    Big Thanks to the original <a className="underline" href="https://github.com/xenova/whisper-web">Whisper Web</a> project! ❤️
                </p>
            </div>
        </div>
    ) : (
        <div className='fixed w-screen h-screen bg-black z-10 bg-opacity-[92%] text-white text-2xl font-semibold flex justify-center items-center text-center'>
            WebGPU is not supported
            <br />
            by this browser :&#40;
        </div>
    );
}

export default App;
