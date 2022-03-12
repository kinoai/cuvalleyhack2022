import React from "react";
import ReactDOM from "react-dom";
import "./index.css";
import { BrowserRouter as Router, Route, Routes } from "react-router-dom";
import {
  Navigation,
  Footer,
  Model,
  Chart
} from "./components";

ReactDOM.render(
  <Router>
    <Navigation />
    <Routes>
      <Route path="/" element={<Chart />} />
      <Route path="/model" element={<Model />} />
    </Routes>
    <Footer />
  </Router>,

  document.getElementById("root")
);
