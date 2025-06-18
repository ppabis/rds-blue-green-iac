from fastapi import FastAPI
from fastapi.responses import HTMLResponse
from os import getenv
import mysql.connector
import psycopg2

db_host = getenv("DB_HOST", "localhost")
db_port = int(getenv("DB_PORT", 3306))
db_user = getenv("DB_USER", "root")
db_password = getenv("DB_PASSWORD", "password")
db_name = getenv("DB_NAME", "test_db")

app = FastAPI()

@app.get("/", response_class=HTMLResponse)
async def root():
    with open("index.html", "r") as f:
        return f.read()

@app.get("/info")
async def info():
    mysql_version = ""
    try:
        connection = mysql.connector.connect(
            host=db_host,
            port=db_port,
            user=db_user,
            password=db_password,
            database=db_name
        )
        if connection.is_connected():
            cursor = connection.cursor()
            cursor.execute("SELECT VERSION()")
            version = cursor.fetchone()
            cursor.close()
            connection.close()
            mysql_version = version[0]
    except mysql.connector.Error as err:
        pass
    pg_version = ""
    try:
        connection = psycopg2.connect(
            host=getenv("PG_HOST", "localhost"),
            port=int(getenv("PG_PORT", 5432)),
            user=getenv("PG_USER", "postgres"),
            password=getenv("PG_PASSWORD", "password"),
            database=getenv("PG_DB", "postgres")
        )
        if connection:
            cursor = connection.cursor()
            cursor.execute("SELECT version()")
            version = cursor.fetchone()
            cursor.close()
            connection.close()
            pg_version = version[0]
    except psycopg2.Error as err:
        pass

    return {"mysql": mysql_version, "pg": pg_version}
