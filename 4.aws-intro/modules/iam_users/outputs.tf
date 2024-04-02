# Output access keys and secret keys for each user
output "access_keys" {
  value = {
    for user_name, access_key in aws_iam_access_key.access_keys :
    user_name => {
      access_key_id = access_key.id,
      secret_key    = access_key.secret
    }
  }
  sensitive = true
}