# if no default value => not mandatory 
variable "volumes_names" {
  type    = list(string)
  description = "The names of volumes to create"
}