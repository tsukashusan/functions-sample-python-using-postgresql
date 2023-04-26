import azure.functions as func
import sys
import logging
import json
import asyncio
import postgresql.DbiPostgreSQL as Dbi
import logging

app = func.FunctionApp()
dbi = Dbi.DbiPostgreSQL()


@app.function_name(name="EventHubTrigger1")
@app.event_hub_message_trigger(arg_name="myhub",
                               event_hub_name="",
                               connection="connectionString")
def test_function(myhub: func.EventHubEvent):
    event = json.loads(myhub.get_body().decode('utf-8'))
    dbi.open_pool()
    ret = dbi.select_fetchall("SELECT 1");
    sql = f'INSERT INTO public.event(sensor_id, sensor_temp, sensor_humidity, sensor_status, sensor_sentdatetime) VALUES (%s, %s, %s, %s, %s)'
    param = (event['sensor_id'], event['sensor_temp'], event['sensor_temp'], f"{event['sensor_status']}", f"{event['sensor_sentdatetime']}")
    ret = dbi.write(sql, param)
    logging.info(ret)
    logging.info('Python EventHub trigger processed an event: %s',
                myhub.get_body().decode('utf-8'))