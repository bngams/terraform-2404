##
# Create IAM users 
# resource "aws_iam_user" "demo" {
#   count = var.number_of_users
#   name = "aelion2310.0${count.index}"
# }

##
# Create IAM users and access keys dynamically with a list
resource "aws_iam_user" "iam_users" {
  for_each = toset(var.user_names)
  name = each.value
}

##
# Policy
##

resource "aws_iam_user_policy" "policy" {
  for_each = aws_iam_user.iam_users
  name = "${aws_iam_user.iam_users[each.key].name}_policy" 
  user = aws_iam_user.iam_users[each.key].name

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
      "Version": "2012-10-17",
      "Statement": [
          {
              "Effect": "Allow",
              "Action": "*",
              "Resource": "*"
          }
      ]
  })
}

resource "aws_iam_access_key" "access_keys" {
  for_each = aws_iam_user.iam_users
  user = aws_iam_user.iam_users[each.key].name
}
