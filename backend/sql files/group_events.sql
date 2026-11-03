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