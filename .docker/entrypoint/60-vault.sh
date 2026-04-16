#!/bin/sh

export VAULT_ADDR="http://vault:8200"
export VAULT_TOKEN="root"

vault kv get -format=json secret/laravel \
| jq -r '.data.data | to_entries[] | "\(.key)=\(.value)"' \
> /var/www/html/.env

until nc -z mysql 3306; do
  sleep 2
done
