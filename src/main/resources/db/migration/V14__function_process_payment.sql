CREATE OR REPLACE FUNCTION process_payment()
RETURNS TRIGGER AS $$
DECLARE
    total NUMERIC;
BEGIN
    -- Só processar se o novo status for 'PAGO'
    IF NEW.status = 'PAGO' AND OLD.status <> 'PAGO' THEN
        total := get_order_total(NEW.id);

        -- Verifica saldo
        IF NOT has_sufficient_balance(NEW.user_id, total) THEN
            RAISE EXCEPTION 'Saldo insuficiente para concluir o pagamento.';
        END IF;

        -- Debita saldo
        PERFORM debit_user_balance(NEW.user_id, total);
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
