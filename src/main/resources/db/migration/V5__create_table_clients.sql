CREATE TABLE clients (
    id UUID PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    cpf CHAR(11) NOT NULL UNIQUE,
    birthdate DATE NOT NULL,
    balance NUMERIC(10, 2) NOT NULL
);

CREATE OR REPLACE FUNCTION validate_client_data()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.cpf !~ '^[0-9]{11}$' THEN
        RAISE EXCEPTION 'CPF inválido: %', NEW.cpf;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_validate_client_data
BEFORE INSERT OR UPDATE ON clients
FOR EACH ROW
EXECUTE FUNCTION validate_client_data();
