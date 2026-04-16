#!/bin/sh

vault kv get -format=json secret/laravel \
| jq -r '.data.data | to_entries[] | "\(.key)=\(.value)"' \
> /var/www/html/.env

echo "Waiting for MySQL..."

until nc -z laravel-mysql 3306; do
  sleep 2
done
