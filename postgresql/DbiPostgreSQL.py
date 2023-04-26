import psycopg_pool
import os
import logging
from typing import Optional


logging.getLogger("psycopg.pool").setLevel(logging.DEBUG)
class DbiPostgreSQL():

    def __init__(self) -> None:
        conninfo = f'host={os.getenv("HOSTNAME")} port={os.getenv("PORT")} dbname={os.getenv("DATABASE")} user={os.getenv("USER")} password={os.getenv("PASSWORD")}'
        self.pool = psycopg_pool.ConnectionPool(conninfo=conninfo)

    def open_pool(self) -> None:
        p = self.pool.get_stats()
        self.pool.open()
        self.pool.wait()
        logging.info("Connection Pool Opened")
    
    def select_fetchall(self, query, args=None):
        with self.pool.connection() as conn:
            with conn.cursor() as cursor:
                cursor.execute(query, args)
                results = cursor.fetchall()
                return results
    
    
    def write(self, query, args=None):
        with self.pool.connection() as conn:
            with conn.cursor() as cursor:
                cursor.execute(query, args)
                if 'RETURNING' in query:
                    results = cursor.fetchone()
                    return results
                else:
                    return