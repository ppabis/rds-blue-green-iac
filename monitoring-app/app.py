from fastapi import FastAPI
from fastapi.responses import HTMLResponse
from os import getenv
from check_mysql import get_stats as get_mysql_stats
from check_postgresql import get_stats as get_postgresql_stats
from monitor import Monitor
from contextlib import asynccontextmanager

db_host = getenv("DB_HOST", "localhost")
db_port = int(getenv("DB_PORT", 3306))
db_user = getenv("DB_USER", "root")
db_password = getenv("DB_PASSWORD", "password")
db_name = getenv("DB_NAME", "test_db")

pg_host=getenv("PG_HOST", "localhost")
pg_port=int(getenv("PG_PORT", 5432))
pg_user=getenv("PG_USER", "postgres")
pg_password=getenv("PG_PASSWORD", "password")
pg_database=getenv("PG_DB", "postgres")

mode = getenv("MONITOR_MODE", "mysql")

monitor_thread = None

@asynccontextmanager
async def lifespan(app: FastAPI):
    global monitor_thread
    if mode == "mysql":
        mysql_args = {
            "host": db_host,
            "port": db_port,
            "user": db_user,
            "password": db_password,
            "database": db_name
        }
        monitor_thread = Monitor(mode="mysql", args=mysql_args)
    elif mode == "postgresql":
        pg_args = {
        "host": pg_host,
        "port": pg_port,
        "user": pg_user,
        "password": pg_password,
        "database": pg_database
        }
        monitor_thread = Monitor(mode="postgresql", args=pg_args)
    monitor_thread.start()
    
    yield
    
    # Shutdown: Stop monitoring
    if monitor_thread:
        monitor_thread.stop()

app = FastAPI(lifespan=lifespan)

@app.get("/", response_class=HTMLResponse)
async def root():
    with open("index.html", "r") as f:
        return f.read()

@app.get("/stats")
async def stats():
    stats_json = {}
    if mode == "mysql":
        stats_json = get_mysql_stats()
    elif mode == "postgresql":
        stats_json = get_postgresql_stats()
    stats_json['dbtype'] = mode
    return stats_json
