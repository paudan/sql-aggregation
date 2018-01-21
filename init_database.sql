-- Initialize test database in PostgreSQL

DROP TABLE IF EXISTS public.testing_data;

CREATE TABLE public.testing_data(
   id serial, 
   "group" integer, 
   value integer,
   constraint pk_testing_data primary key (id)
) WITH ( OIDS = FALSE);

COPY public.testing_data("group", value) FROM '/mnt/DATA/Darbas/projects/sql-aggregation/data.csv' DELIMITER ';' CSV HEADER;
