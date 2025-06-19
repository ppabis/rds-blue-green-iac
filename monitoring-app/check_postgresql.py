import psycopg2
from datetime import datetime
import logging

POSTGRESQL_CONNECTION_STATS = []
POSTGRESQL_WRITE_STATS = []
POSTGRESQL_READ_STATS = []

def limit_arrays(max_size=2048):
    global POSTGRESQL_CONNECTION_STATS, POSTGRESQL_WRITE_STATS, POSTGRESQL_READ_STATS
    if len(POSTGRESQL_CONNECTION_STATS) > max_size:
        POSTGRESQL_CONNECTION_STATS[:] = POSTGRESQL_CONNECTION_STATS[-max_size:]
    if len(POSTGRESQL_WRITE_STATS) > max_size:
        POSTGRESQL_WRITE_STATS[:] = POSTGRESQL_WRITE_STATS[-max_size:]
    if len(POSTGRESQL_READ_STATS) > max_size:
        POSTGRESQL_READ_STATS[:] = POSTGRESQL_READ_STATS[-max_size:]

def check_read_write(timestamp, cursor, connection):
    read_result = 0
    write_result = 0
    try:
        cursor.execute("SELECT * FROM test_table ORDER BY timestamp DESC LIMIT 5")
        result = cursor.fetchone()
        read_result = 1 if result else 0
        cursor.fetchall()
    except psycopg2.Error as err:
        read_result = 0
    try:
        cursor.execute("INSERT INTO test_table (timestamp) VALUES (%s)", (timestamp.replace(microsecond=0),))
        connection.commit()
        cursor.execute("SELECT timestamp FROM test_table ORDER BY timestamp DESC LIMIT 1")
        result = cursor.fetchone()
        write_result = 1 if result and result[0] == timestamp.replace(microsecond=0) else 0
        cursor.fetchall()
    except psycopg2.Error as err:
        write_result = 0
    return read_result, write_result



def check_postgresql(host, port, user, password, database):
    timestamp = datetime.now()
    read_result = 0
    write_result = 0
    connection_result = 0
    try:
        connection = psycopg2.connect(host=host, port=port, user=user, password=password, database=database)
        if connection:
            connection_result = 1
            with connection.cursor() as cursor:
                read_result, write_result = check_read_write(timestamp, cursor, connection)
    except psycopg2.Error as err:
        logging.error(f"Error checking PostgreSQL: {err}")
    finally:
        if 'connection' in locals() and connection:
            connection.close()
    POSTGRESQL_CONNECTION_STATS.append( (datetime.now().timestamp(), connection_result) )
    POSTGRESQL_WRITE_STATS.append( (datetime.now().timestamp(), write_result) )
    POSTGRESQL_READ_STATS.append( (datetime.now().timestamp(), read_result) )
    limit_arrays()

def get_stats():
    global POSTGRESQL_CONNECTION_STATS, POSTGRESQL_WRITE_STATS, POSTGRESQL_READ_STATS
    return {
        "connection_stats": POSTGRESQL_CONNECTION_STATS,
        "write_stats": POSTGRESQL_WRITE_STATS,
        "read_stats": POSTGRESQL_READ_STATS
    }