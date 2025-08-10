CREATE TABLE transaction_history (
    id SERIAL PRIMARY KEY,
    order_id INTEGER NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
	transation_type TEXT NOT NULL,
	transation_date TIMESTAMP DEFAULT now()
);