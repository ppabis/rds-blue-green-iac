import mysql.connector
from datetime import datetime

MYSQL_CONNECTION_STATS = []
MYSQL_WRITE_STATS = []
MYSQL_READ_STATS = []

def limit_arrays(max_size=2048):
    global MYSQL_CONNECTION_STATS, MYSQL_WRITE_STATS, MYSQL_READ_STATS
    if len(MYSQL_CONNECTION_STATS) > max_size:
        MYSQL_CONNECTION_STATS[:] = MYSQL_CONNECTION_STATS[-max_size:]
    if len(MYSQL_WRITE_STATS) > max_size:
        MYSQL_WRITE_STATS[:] = MYSQL_WRITE_STATS[-max_size:]
    if len(MYSQL_READ_STATS) > max_size:
        MYSQL_READ_STATS[:] = MYSQL_READ_STATS[-max_size:]

def check_read_write(timestamp, cursor):
    read_result = 0
    write_result = 0
    try:
        cursor.execute("SELECT * FROM test_table ORDER BY timestamp DESC LIMIT 5")
        result = cursor.fetchone()
        read_result = 1 if result else 0
    except mysql.connector.Error as err:
        read_result = 0
    try:
        cursor.execute("INSERT INTO test_table (timestamp) VALUES (%s)", (timestamp,))
        cursor.connection.commit()
        cursor.execute("SELECT * FROM test_table WHERE timestamp = %s", (timestamp,))
        result = cursor.fetchone()
        write_result = 1 if result else 0
    except mysql.connector.Error as err:
        write_result = 0
    return read_result, write_result


def check_mysql(host, port, user, password, database):
    timestamp = datetime.now().timestamp()
    read_result = 0
    write_result = 0
    connection_result = 0
    try:
        connection = mysql.connector.connect(host=host, port=port, user=user, password=password, database=database)
        if connection and connection.is_connected():
            connection_result = 1
            with connection.cursor() as cursor:
                read_result, write_result = check_read_write(timestamp, cursor)
    except mysql.connector.Error as err:
        pass
    except Exception as e:
        print(f"Error checking MySQL: {e}")
        import traceback
        traceback.print_exc()
    finally:
        if 'connection' in locals() and connection and connection.is_connected():
            connection.close()
    MYSQL_CONNECTION_STATS.append( (timestamp, connection_result) )
    MYSQL_WRITE_STATS.append( (timestamp, write_result) )
    MYSQL_READ_STATS.append( (timestamp, read_result) )
    limit_arrays()

def get_stats():
    global MYSQL_CONNECTION_STATS, MYSQL_WRITE_STATS, MYSQL_READ_STATS
    return {
        "connection_stats": MYSQL_CONNECTION_STATS,
        "write_stats": MYSQL_WRITE_STATS,
        "read_stats": MYSQL_READ_STATS
    }