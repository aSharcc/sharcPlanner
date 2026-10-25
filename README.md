# sharcPlanner (rawr)
An AI powered task schedeuling assitant that breaks down goals into smaller, achievable steps and automatically syncs them to your google calendar

## Privacy and TOS info

This app accesses Google Calendar events. The data is used solely to generate AI study schedules and is not shared or sold. The app is provided "as-is" for project purposes.

## Features
- **Google OAuth2 Authentication:** Securely connects your google account to manage events directly
- **Two Modes:**
    - **Manual Mode:** Standard calendar event creation with user inputted information
    - **AI Mode:** User inputs goal, total hours and deadline then these are passed to Google Gemini and generate a structured schedule
- **Google Calendar Sync:** Automatically syncs to Google calendarr

## Technical Information
- **Backend:** Node.js, Express.js
- **AI:** Google Gemini 3.5 flash lite
- **Frontend:** html, JavaScript and Pico CSS
   
## How to run locally
### 1. What you need
- Node.js installed 
- A Google Cloud Console project with google calendar api activated
- A Gemini API key

### 2. Clone Repo
- git clone https://github.com/aSharcc/sharcPlanner.git

### 3. Install Dependancies
- npm install express dotenv/config googleapis @google/genai

### 4. Configure .env
- A .env file with:
    PORT=8000
    GOOGLE_CLIENT_ID=
    GOOGLE_CLIENT_SECRET=
    GOOGLE_REDIRECT_URI="http://localhost:8000/api/auth/callback"
    GEMINI_API_KEY=
    GEMINI_MODEL="models/gemini-3.5-flash-lite"

    Make sure http://localhost:8000/api/auth/callback is a authorised redirect URI in your google project settings

### 5. Run the server
- node server.js