# call domain modules which handle users
module "users" {
  source = "./modules/iam_users"
  user_names = var.users
}