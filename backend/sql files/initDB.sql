CREATE TABLE IF NOT EXISTS session (
    sid VARCHAR PRIMARY KEY,
    sess JSON NOT NULL,
    expire TIMESTAMP(6) WITHOUT TIME ZONE NOT NULL
);

CREATE INDEX IF NOT EXISTS "IDX_session_expire" ON session (expire ASC);

CREATE TABLE IF NOT EXISTS feedback (
    id SERIAL PRIMARY KEY,
    message TEXT NOT NULL,
    datetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    session_id TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS weekly_themes (
    id SERIAL PRIMARY KEY,
    start_date DATE NOT NULL UNIQUE,
    title VARCHAR(255) NOT NULL, 
    description TEXT,
    suggested_hours NUMERIC DEFAULT 2.0
);

CREATE TABLE IF NOT EXISTS group_events (
    id SERIAL PRIMARY KEY,
    creator_id TEXT NOT NULL,
    title TEXT NOT NULL,
    description TEXT,
    duration NUMERIC NOT NULL,
    deadline TIMESTAMP NOT NULL,
    finalised BOOLEAN NOT NULL,
    date_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS group_availability (
    id SERIAL PRIMARY KEY,
    group_event_id INTEGER REFERENCES group_events(id) ON DELETE CASCADE,
    participant_name TEXT NOT NULL,
    available_slots JSONB
);  

