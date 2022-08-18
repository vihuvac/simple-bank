#!/bin/sh

set -e

echo "---> Run the database migrations:"
/app/migrate -path /app/migrations -database "$DB_URI" -verbose up

echo "---> Start the API:"
exec "$@"
