CREATE TRIGGER trg_process_payment
BEFORE UPDATE OF status ON orders
FOR EACH ROW
EXECUTE FUNCTION process_payment();
