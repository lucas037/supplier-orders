CREATE OR REPLACE FUNCTION get_order_total(order_id INTEGER)
RETURNS NUMERIC AS $$
DECLARE
    total NUMERIC;
BEGIN
    SELECT o.quant * p.price
    INTO total
    FROM orders o
    JOIN products p ON p.id = o.product_id
    WHERE o.id = order_id;

    RETURN total;
END;
$$ LANGUAGE plpgsql;
