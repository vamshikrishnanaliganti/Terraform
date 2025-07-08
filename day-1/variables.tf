variable "amiid" {
    type = string
    default = ""
}

variable "key" {
    type    = string
    default = ""
}

variable "instance_type" {
    type    = string
    default = ""
}

# variable "db_instance_username" {
#   type        = string
#   description = "Username for RDS"
# }

# variable "db_instance_password" {
#   type        = string
#   description = "Password for RDS"
#   sensitive   = true
# }
