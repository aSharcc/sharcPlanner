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