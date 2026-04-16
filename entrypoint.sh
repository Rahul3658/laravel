#!/bin/sh

export VAULT_ADDR="http://vault:8200"
export VAULT_TOKEN="root"
eval "$(
  vault kv get -format=json secret/laravel \
  | jq -r '.data.data | to_entries[] | @sh "export \(.key)=\(.value)"'
)"
env | grep APP_KEY

until nc -z mysql 3306; do
  sleep 2
done
php artisan config:clear
php artisan cache:clear
exec "$@"
