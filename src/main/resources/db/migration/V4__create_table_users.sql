CREATE TABLE users (
    id UUID PRIMARY KEY default uuid_generate_v4(),
    name TEXT NOT NULL,
    username TEXT NOT NULL UNIQUE,
    password TEXT NOT NULL
);