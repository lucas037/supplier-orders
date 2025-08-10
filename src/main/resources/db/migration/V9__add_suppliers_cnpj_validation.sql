ALTER TABLE suppliers
ADD CONSTRAINT chk_cnpj_format
CHECK (cnpj ~ '^[0-9]{14}$');

CREATE OR REPLACE FUNCTION normalize_cnpj()
RETURNS trigger AS $$
BEGIN
    NEW.cnpj := regexp_replace(NEW.cnpj, '[^0-9]', '', 'g');
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_normalize_cnpj
BEFORE INSERT OR UPDATE ON suppliers
FOR EACH ROW
EXECUTE FUNCTION normalize_cnpj();