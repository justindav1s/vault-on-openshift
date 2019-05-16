# List, create, update, and delete key/value secrets
path "ola/*"
{
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}