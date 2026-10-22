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

const SCOPES = ["https://www.googleapis.com/auth/calendar.events"]; // read and write calendar events

let userTokens = null;

app.use(express.json()); // sets middleware to convert JSON into js objects
app.use(express.urlencoded({ extended: true }));

app.get("/", (req, res) => { // for root route
    if (userTokens) {
        res.send("<p>we have a token for u !! </p><p><a href='/api/calendar/events'>View upcoming events</a></p>");
    } else {
        res.send("<p>We have no tokens :c</p><p><a href='/api/auth/google'>Click here to connect to google calendar</a></p>");
    }
}); 

app.get("/api/auth/google", (req, res) => {
    const authUrl = auth.generateAuthUrl({
        access_type: "offline",
        scope: SCOPES,
        prompt: "consent"
    });
    res.redirect(authUrl);
}); 

app.get("/api/auth/callback", async (req, res) => {
    const code = req.query.code;
    const error = req.query.error;
    
    if (error) { // if the auth returned an error
        return res.status(400).json({ error: `google auth failed: ${error} :c` });
    }
    if (!code) { // ensuring it returned a code
        return res.status(400).json({ error: "No authorisation code given :c" });
    }
    try {
        const { tokens } = await auth.getToken(code);

        auth.setCredentials(tokens);
        userTokens = tokens;

        console.log("Successfully authenticated !! woop woop anyways tokens:");
        console.log("Access token: ", tokens.access_token);
        console.log("Refrest token: ", tokens.refresh_token);

        res.redirect("/");
    } catch (error) {
        console.error("Error exchanging token: ", error);
        res.status(500).json({ error: "Server error during authentication :c" });
    }
});

app.get("/api/calendar/events", async (req, res) => {
    if (!userTokens) {
        return res.status(401).send("Not Authenticated, go to /api/auth/google first !!");
    }
    try {
        const calendar = google.calendar({ version: "v3", auth: auth });
        const response = await calendar.events.list({
            calendarId: "primary",
            timeMin: new Date().toISOString(),
            maxResults: 10,
            singleEvents: true,
            orderBy: "startTime"
        });  

        const events = response.data.items;
        
        if (!events || events.length === 0) {
            return res.json({ message: "No events found. :c"});
        }

        const formattedEvents = events.map(events =>({
            summary: events.summary || "No Name !!",
            start: events.start.dateTime || events.start.date,
            end: events.end.dateTime || events.end.date
        })); 

        return res.json(formattedEvents);

    } catch (error) {
        console.error(":c Error getting calendar events: ", error);
        res.status(500).send(":c Failed to get calendar events");
    }
});

app.post("/api/calendar/add-event", async (req, res) => {
    if (!userTokens) {
        return res.status(401).send("Not Authenticated, go to /api/auth/google first !!");
    }

    const { summary, description, startISO, endISO} = req.body;

    if (!summary || !startISO || !endISO) {
        return res.status(400).send("Missing fields :c");
    }
 
    try {
        const calendar = google.calendar({ version: "v3", auth: auth });

        const event = {
            summary: summary,
            description: description || "Created with sharcPlanner",
            start: {
                dateTime: startISO
            },
            end: {
                dateTime: endISO
            },
        };

        const response = await calendar.events.insert({
            calendarId: "primary",
            requestBody: event
        });

        console.log("Event created !!");
        console.log("Event link:", response.data.htmlLink);

        res.json({ 
            message: "Event created successfully",
            link: response.data.htmlLink,
            event: response.data
        });

    } catch (error) {
        console.error(":c Error adding calendar event: ", error);
        res.status(500).send(":c Failed to create event :c");
    }
});

app.listen(PORT, () => { 
    console.log(`Server running on port ${PORT} yippie !!`) // `` for formatting
});
