#!/bin/bash
#echo "Password is password"
PGPASSWORD=password psql -h localhost -p 5432 -d app_db -U app_user < world.psql

