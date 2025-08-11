CREATE OR REPLACE FUNCTION get_order_total(order_id INTEGER)
RETURNS NUMERIC AS $$
DECLARE
    total NUMERIC := 0;
    price NUMERIC;
    discount NUMERIC;
    qty INTEGER;
BEGIN
    SELECT p.price, COALESCE(p.discount, 0), o.quant
    INTO price, discount, qty
    FROM orders o
    JOIN products p ON p.id = o.product_id
    WHERE o.id = order_id
    LIMIT 1;

    IF price IS NULL THEN
        RETURN 0;
    END IF;

    IF discount > 1 THEN
        discount := discount / 100;
    END IF;

    total := (1 - discount) * price * qty;

    RETURN total;
END;
$$ LANGUAGE plpgsql;
