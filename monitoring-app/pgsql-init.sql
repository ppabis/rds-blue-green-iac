CREATE TABLE IF NOT EXISTS test_table (timestamp TIMESTAMP);

INSERT INTO test_table (timestamp)
SELECT NOW()
WHERE NOT EXISTS (SELECT 1 FROM test_table);
