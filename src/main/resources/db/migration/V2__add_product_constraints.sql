-- Impede preço negativo
ALTER TABLE products
ADD CONSTRAINT chk_price_positive CHECK (price >= 0);

-- Cria função para validar nome vazio ou em branco
CREATE OR REPLACE FUNCTION validate_product_name()
RETURNS TRIGGER AS $$
BEGIN
    IF TRIM(NEW.name) IS NULL OR LENGTH(TRIM(NEW.name)) = 0 THEN
        RAISE EXCEPTION 'Nome do produto não pode ser vazio';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Cria trigger que executa a função antes de INSERT ou UPDATE
CREATE TRIGGER trg_validate_product_name
BEFORE INSERT OR UPDATE ON products
FOR EACH ROW
EXECUTE FUNCTION validate_product_name();
