# Use outputs from the users_iam module
output "access_keys_from_module" {
  value = module.users.access_keys
  sensitive = true
}