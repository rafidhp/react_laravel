import React from "react";
import { Link } from "react-router-dom";

function Home() {
    return (
        <div>
            <h1>Home Page (React)</h1>
            <nav>
                <Link to="/react-page">Go to React Page</Link><br />
                <a href="/test">Go to Laravel Testing</a>
            </nav>
        </div>
    );
}

export default Home;
