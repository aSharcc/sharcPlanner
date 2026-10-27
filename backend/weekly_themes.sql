CREATE TABLE IF NOT EXISTS weekly_themes (
    id SERIAL PRIMARY KEY,
    start_date DATE UNIQUE NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    suggested_hours NUMERIC DEFAULT 2.0
);