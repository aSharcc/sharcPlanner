import express from "express"; // for post and get
import "dotenv/config"; // for geting stuff from .env
import { google } from "googleapis";

const app = express(); // start the webapp with express
const PORT = process.env.PORT || 8000; // set the port to what's in .env else 8000

const auth = new google.auth.OAuth2({
    clientId: process.env.GOOGLE_CLIENT_ID,
    clientSecret: process.env.GOOGLE_CLIENT_SECRET,
    redirectUri: process.env.GOOGLE_REDIRECT_URI
});

app.use(express.json()); // sets middleware to convert JSON into js objects

app.get("/", (req, res) => { // for root route
    res.send("it's running !! (i think)"); // send confirmation
});

app.get("/api/auth/google", (req, res) => {

});

app.listen(PORT, () => { // 
    console.log(`Server running on port ${PORT}`) // `` for formatting
});
