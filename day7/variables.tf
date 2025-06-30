variable "vpc_cidr" {
type = string

}

variable "public1" {
    type =string
default = ""
}


variable "public2" {
    type =string
default = ""
}

variable "private1" {
    type =string
    default = ""
}

variable "private2" {
    type =string
default = ""
}


variable "amiid" {
  type = string
  default = ""
}

variable "key" {
  default = ""
  type = string
}

variable "instance_type" {
    default = ""
    type = string
  
}