CREATE OR REPLACE FUNCTION log_order_status_change()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.status IS DISTINCT FROM OLD.status THEN
        INSERT INTO transaction_history (order_id, transation_type)
        VALUES (NEW.id, NEW.status);
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;