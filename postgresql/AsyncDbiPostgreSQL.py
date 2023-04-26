import psycopg_pool
import os
import logging
import asyncio
import sys

class AsyncDbiPostgreSQL():
    def __init__(self):
        conninfo = f'host={os.getenv("HOSTNAME")} port={os.getenv("PORT")} dbname={os.getenv("DATABASE")} user={os.getenv("USER")} password={os.getenv("PASSWORD")} client_encoding={"UTF8"} sslrootcert=Prefer'
        self.pool = psycopg_pool.AsyncConnectionPool(conninfo=conninfo, open=False)
    
    async def open_pool(self):
        await self.pool.open()
        await self.pool.wait()
        logging.info("Connection Pool Opened")

    async def select_fetchall(self, query, args):
        async with self.pool.connection() as conn:
            async with conn.cursor() as cursor:
                await cursor.execute(query, args)
                results = await cursor.fetchall()
                return results
    
    
    async def write(self, query, args):
        async with self.pool.connection() as conn:
            async with conn.cursor() as cursor:
                await cursor.execute(query, args)
                if 'RETURNING' in query:
                    results = await cursor.fetchone()
                    return results
                else:
                    return