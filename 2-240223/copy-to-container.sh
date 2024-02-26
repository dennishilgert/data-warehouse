#!/bin/sh

docker cp 01_create_messung.sql postgres:/tmp/01_create_messung.sql
docker cp 02_create_staging.sql postgres:/tmp/02_create_staging.sql
docker cp 11_load_staging.sql postgres:/tmp/11_load_staging.sql
docker cp 30_create_data_vault.sql postgres:/tmp/30_create_data_vault.sql

