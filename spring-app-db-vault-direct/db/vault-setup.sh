#!/usr/bin/env bash


export VAULT_ADDR=https://$(oc get route -n vault | grep -m1 vault | awk '{print $2}')
export VAULT_TOKEN=$(cat ../../admin/admin_token.txt| head -1)
echo VAULT_ADDR = $VAULT_ADDR
echo VAULT_TOKEN = $VAULT_TOKEN

vault secrets disable database
vault secrets enable database

cat <<EOF > vault.sql
CREATE ROLE "{{name}}" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}';
GRANT SELECT ON ALL TABLES IN SCHEMA public TO "{{name}}";
EOF

vault write database/config/demo-postgresql \
    plugin_name=postgresql-database-plugin \
    allowed_roles="ola-dev-admin" \
    connection_url="postgresql://{{username}}:{{password}}@postgresql.ola-dev.svc.cluster.local:5432/postgres?sslmode=disable" \
    username="demouser" \
    password="changeme"

vault write database/roles/ola-dev-admin \
    db_name=demo-postgresql \
    creation_statements=@vault.sql \
    default_ttl="1h" \
    max_ttl="24h"

vault read database/creds/ola-dev-admin

rm -rf vault.sql