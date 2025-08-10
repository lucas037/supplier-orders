CREATE OR REPLACE FUNCTION has_sufficient_balance(user_id UUID, amount NUMERIC)
RETURNS BOOLEAN AS $$
DECLARE
    saldo NUMERIC;
BEGIN
    SELECT balance INTO saldo
    FROM clients
    WHERE id = user_id;

    RETURN saldo >= amount;
END;
$$ LANGUAGE plpgsql;
