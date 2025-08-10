CREATE OR REPLACE FUNCTION debit_user_balance(user_id UUID, amount NUMERIC)
RETURNS VOID AS $$
BEGIN
    UPDATE clients
    SET balance = balance - amount
    WHERE id = user_id;
END;
$$ LANGUAGE plpgsql;
