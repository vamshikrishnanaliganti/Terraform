
variable "vpc_cidr" {
  type = string

}

variable "amiid" {
  type    = string
  default = ""
}

variable "key" {
  default = ""
  type    = string
}

variable "instance_type" {
  default = ""
  type    = string

}


variable "public_subnet-1_cidr" {

  default = ""
  type    = string
}



variable "public_subnet-2_cidr" {
  default = ""
  type    = string
}



variable "frontnend_subnet1_cidr" {
  default = ""
  type    = string
}

variable "frontnend_subnet2_cidr" {
  default = ""
  type    = string
}


variable "backend_subnet1_cidr" {
  default = ""
  type    = string
}

variable "backend_subnet2_cidr" {
  default = ""
  type    = string
}

variable "rds_subnet1_cidr" {
  default = ""
  type    = string

}


variable "rds_subnet2_cidr" {
  default = ""
  type    = string

}

variable "db_username" {
  default   = ""
  type      = string
  sensitive = true

}

variable "db_password" {
  default   = ""
  type      = string
  sensitive = true

}