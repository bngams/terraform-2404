# Define a variable for user names
variable "user_names" {
  type    = list(string)
}


variable "users" {
  description = "Tableau d'utilisateurs avec leur policies, quotas ...."
  type    = list(object({
    name = string
    policies = list(string)
  }))
  default = [
    { 
      name = "User1"
      policies = [ "policyid1", "policyid2" ]
    } 
  ] 
}
