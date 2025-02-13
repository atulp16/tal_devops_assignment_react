import React from "react";
import ReactDOM from "react-dom";
import App from "./App";  // Import the main component of your app
import "./index.css";    // Optional: If you have global styles

// Render the App component into the root div of index.html
ReactDOM.render(
  <React.StrictMode>
    <App />
  </React.StrictMode>,
  document.getElementById("root")
);
