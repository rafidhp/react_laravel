import React from "react";
import { Link } from "react-router-dom";

const About = () => {
    return (
        <div>
            <h1>About Page (React)</h1>
            <nav>
                <Link to="/">Go to Home</Link><br />
                <a href="/test">Go to Laravel Testing</a>
            </nav>
        </div>
    );
}

export default About;
