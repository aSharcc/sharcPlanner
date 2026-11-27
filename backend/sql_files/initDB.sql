CREATE EXTENSION IF NOT EXISTS "pgcrypto";
CREATE TABLE IF NOT EXISTS session (
    sid VARCHAR PRIMARY KEY,
    sess JSON NOT NULL,
    expire TIMESTAMP(6) WITHOUT TIME ZONE NOT NULL
);

CREATE INDEX IF NOT EXISTS "IDX_session_expire" ON session (expire ASC);

CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    google_id TEXT UNIQUE NOT NULL,
    email TEXT,
    name TEXT,
    date_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

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
    suggested_hours NUMERIC DEFAULT 2.0,
    CONSTRAINT check_suggested_hours CHECK (suggested_hours >= 0)
);

CREATE TABLE IF NOT EXISTS group_events (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    creator_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    description TEXT,
    duration NUMERIC NOT NULL,
    range_start TIMESTAMPTZ NOT NULL,
    range_end TIMESTAMPTZ NOT NULL,
    finalised BOOLEAN NOT NULL DEFAULT FALSE,
    finalised_slot JSONB,
    date_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT check_valid_range CHECK (range_end > range_start),
    CONSTRAINT check_duration CHECK (duration > 0)
); 

CREATE INDEX IF NOT EXISTS idx_group_events_creator_id ON group_events (creator_id);

CREATE TABLE IF NOT EXISTS group_availability (
    id SERIAL PRIMARY KEY,
    group_event_id UUID NOT NULL REFERENCES group_events(id) ON DELETE CASCADE,
    participant_name TEXT NOT NULL,
    available_slots JSONB
);

CREATE INDEX IF NOT EXISTS idx_group_availability_group_event_id ON group_availability (group_event_id);

CREATE TABLE IF NOT EXISTS ai_usage (
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    usage_date DATE NOT NULL DEFAULT CURRENT_DATE,
    request_count INTEGER NOT NULL DEFAULT 0,
    PRIMARY KEY(user_id, usage_date),
    CONSTRAINT check_usage CHECK (request_count >= 0)
); 
