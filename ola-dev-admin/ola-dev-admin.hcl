# List, create, update, and delete key/value secrets
path "ola/*"
{
  capabilities = ["list"]
}

path "ola/+/+/dev"
{
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}