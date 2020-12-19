ALTER TABLE product_barcodes
ADD note TEXT;

CREATE VIEW uihelper_shopping_list
AS
SELECT
	sl.*,
	p.name AS product_name,
	plp.price * IFNULL(qucr.factor, 1.0) AS last_price_unit,
	plp.price * IFNULL(qucr.factor, 1.0) * sl.amount AS last_price_total
FROM shopping_list sl
LEFT JOIN products p
	ON sl.product_id = p.id
LEFT JOIN quantity_unit_conversions_resolved qucr
	ON sl.product_id = qucr.product_id
	AND p.qu_id_stock = qucr.from_qu_id
	AND sl.qu_id = qucr.to_qu_id
LEFT JOIN products_last_purchased plp
	ON sl.product_id = plp.product_id;
