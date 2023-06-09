-- CREATE DATABASE "sampledb1" ENCODING='UTF8' LC_COLLATE='ja_JP.utf8' LC_CTYPE='ja_JP.utf8' TEMPLATE='template0';
-- Table: public.event

-- DROP TABLE IF EXISTS public.<userid>_event;

CREATE TABLE IF NOT EXISTS public.<userid>_event
(
    sensor_id integer,
    sensor_temp double precision,
    sensor_humidity double precision,
    sensor_status character(2),
    sensor_sentdatetime timestamp without time zone
);