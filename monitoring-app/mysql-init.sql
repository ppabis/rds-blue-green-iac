USE my_database;

CREATE TABLE IF NOT EXISTS test_table (id INT PRIMARY KEY AUTO_INCREMENT, timestamp TIMESTAMP);

INSERT INTO test_table (timestamp)
SELECT NOW()
WHERE NOT EXISTS (SELECT 1 FROM test_table);
