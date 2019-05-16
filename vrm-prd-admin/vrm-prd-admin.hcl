# List, create, update, and delete key/value secrets
path "vrm/*"
{
  capabilities = ["list"]
}

path "vrm/+/+/prd"
{
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}