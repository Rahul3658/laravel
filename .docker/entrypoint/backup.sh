#!/bin/sh

export VAULT_ADDR="http://vault:8200"
export VAULT_TOKEN="root"

echo "Fetching secrets..."

# ✅ CRITICAL FIX (no export issue)
vault kv get -format=json secret/laravel \
| jq -r '.data.data | to_entries[] | "\(.key)=\(.value)"' \
| while IFS='=' read -r key value; do
    printf '%s' "$value" > "/var/run/s6/container_environment/$key"
done

echo "Secrets injected"

# Wait MySQL
until nc -z mysql 3306; do
  sleep 2
done
