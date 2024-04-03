resource "local_file" "env" {
  content  = var.config_content
  filename = "${path.module}/${terraform.workspace}/.env"
}