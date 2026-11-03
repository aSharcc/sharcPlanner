CREATE TABLE IF NOT EXISTS group_availability (
    id SERIAL PRIMARY KEY,
    group_event_id INTEGER REFERENCES group_events(id) ON DELETE CASCADE,
    participant_name TEXT NOT NULL,
    available_slots JSONB
);