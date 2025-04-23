import React from 'react';
import { BrowserRouter as Router, Routes, Route, Link } from 'react-router-dom';

import Home from './pages/Home.jsx';
import ReactPage from './pages/ReactPage.jsx';
import About from './pages/About.jsx';

export default function AppRouter() {
    return (
        <Router>
            <Routes>
                <Route path="/" element={<Home />} />
                <Route path="/react-page" element={<ReactPage />} />
                <Route path='/about' element={<About />} />
            </Routes>
        </Router>
    );
}
