# List, create, update, and delete key/value secrets
path "ola/*"
{
  capabilities = ["list"]
}

path "ola/+/+/prd"
{
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}