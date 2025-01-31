import { useState } from "react";
import reactLogo from "./assets/react.svg";
import viteLogo from "/vite.svg";

function App() {
  const [count, setCount] = useState(0);

  return (
    <>
      <div>
        <div className="p-8 bg-red-500">
          {/* Regular button with CSS from App.css */}
          <button onClick={() => setCount((count) => count + 1)}>Regular Button - count is {count}</button>

          {/* Tailwind styled button */}
          <button
            className="bg-yellow-500 hover:bg-blue-700 text-pink font-bold py-2 px-4 rounded ml-4"
            onClick={() => setCount((count) => count + 1)}
          >
            Tailwind Button - count is {count}
          </button>
        </div>
        <a href="https://vite.dev" target="_blank">
          <img src={viteLogo} className="logo" alt="Vite logo" />
        </a>
        <a href="https://react.dev" target="_blank">
          <img src={reactLogo} className="logo react" alt="React logo" />
        </a>
      </div>
      <h1>Vite + React</h1>
      <div className="card">
        <button onClick={() => setCount((count) => count + 1)}>count is {count}</button>
        <p>
          Edit <code>src/App.tsx</code> and save to test HMR
        </p>
      </div>
      <p className="read-the-docs">Click on the Vite and React logos to learn more</p>
    </>
  );
}

export default App;
