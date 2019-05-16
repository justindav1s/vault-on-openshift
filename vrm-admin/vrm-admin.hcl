# List, create, update, and delete key/value secrets
path "vrm/*"
{
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}