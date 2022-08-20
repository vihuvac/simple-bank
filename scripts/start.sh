#!/bin/sh

set -e

echo "---> Refresh environment variables before running database migrations:"
source /app/app.env

echo "---> Run the database migrations:"
/app/migrate -path /app/migrations -database "$DB_URI" -verbose up

echo "---> Start the API:"
exec "$@"
