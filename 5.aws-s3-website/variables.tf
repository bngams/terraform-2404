variable "users" {
  type = list(string)
  description = "List of users to create"
}

variable "aws_access_key" {
  type = string
  description = "My aws access key"
}

variable "aws_secret_key" {
  type = string
  description = "My aws secret key"
}