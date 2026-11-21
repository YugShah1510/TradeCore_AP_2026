-- Representative TradeCore workload queries. Bind values are shown as SQL literals
-- so the statements can be run directly with psql against dbms/03_schema.sql.

-- Q1: Best-priced open buy orders for one instrument (price-time priority).
SELECT o.order_id, u.display_name, o.limit_price, o.original_quantity, o.created_at
FROM orders AS o
JOIN instruments AS i ON i.instrument_id = o.instrument_id
JOIN users AS u ON u.user_id = o.user_id
WHERE i.symbol = 'TRC'
  AND o.side = 'buy'
  AND o.status = 'open'
ORDER BY o.limit_price DESC, o.created_at ASC
LIMIT 20;

-- Q2: Recent orders for one user.
SELECT o.order_id, i.symbol, o.side, o.limit_price, o.original_quantity,
       o.status, o.created_at
FROM orders AS o
JOIN users AS u ON u.user_id = o.user_id
JOIN instruments AS i ON i.instrument_id = o.instrument_id
WHERE u.email = 'trader-0042@example.com'
ORDER BY o.created_at DESC
LIMIT 50;

-- Q3: Recent executions for one instrument.
SELECT t.trade_id, t.execution_price, t.quantity, t.executed_at,
       bu.display_name AS buyer, su.display_name AS seller
FROM trades AS t
JOIN orders AS bo ON bo.order_id = t.buy_order_id
JOIN users AS bu ON bu.user_id = bo.user_id
JOIN orders AS so ON so.order_id = t.sell_order_id
JOIN users AS su ON su.user_id = so.user_id
JOIN instruments AS i ON i.instrument_id = bo.instrument_id
WHERE i.symbol = 'TRC'
  AND t.executed_at >= TIMESTAMPTZ '2026-01-01 00:00:00+00'
ORDER BY t.executed_at DESC
LIMIT 100;

-- Q4: Current portfolio for one user.
SELECT i.symbol, i.display_name, p.quantity, p.average_cost,
       p.quantity * p.average_cost AS cost_basis
FROM positions AS p
JOIN users AS u ON u.user_id = p.user_id
JOIN instruments AS i ON i.instrument_id = p.instrument_id
WHERE u.email = 'trader-0042@example.com'
ORDER BY i.symbol;

-- Q5: Daily volume and average execution price by instrument.
SELECT i.symbol, date_trunc('day', t.executed_at) AS trading_day,
       count(*) AS trade_count, sum(t.quantity) AS volume,
       avg(t.execution_price) AS average_price
FROM trades AS t
JOIN orders AS o ON o.order_id = t.buy_order_id
JOIN instruments AS i ON i.instrument_id = o.instrument_id
WHERE t.executed_at >= TIMESTAMPTZ '2026-11-01 00:00:00+00'
GROUP BY i.symbol, date_trunc('day', t.executed_at)
ORDER BY trading_day DESC, i.symbol;

-- Q6: Filled quantity and notional value by user.
SELECT u.email, sum(t.quantity) AS filled_quantity,
       sum(t.quantity * t.execution_price) AS notional_value
FROM users AS u
JOIN orders AS o ON o.user_id = u.user_id
JOIN trades AS t ON t.buy_order_id = o.order_id OR t.sell_order_id = o.order_id
WHERE u.email = 'trader-0042@example.com'
GROUP BY u.email;
