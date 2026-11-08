CREATE TABLE IF NOT EXISTS weekly_themes (
    id SERIAL PRIMARY KEY,
    start_date DATE NOT NULL UNIQUE,
    title VARCHAR(255) NOT NULL, 
    description TEXT,
    suggested_hours NUMERIC DEFAULT 2.0
);