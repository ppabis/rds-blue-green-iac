CREATE SCHEMA IF NOT EXISTS app_db;
SET search_path TO app_db;

CREATE TABLE IF NOT EXISTS test_table (timestamp TIMESTAMP);

INSERT INTO test_table (timestamp)
SELECT NOW()
WHERE NOT EXISTS (SELECT 1 FROM test_table);
