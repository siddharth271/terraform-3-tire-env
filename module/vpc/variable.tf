variable "enabled" {
  type = bool
  description = "it control if vpc needs to be created"
  default = ""
}

variable "use_existing_vpc" {
  type = string
  description = "if existing vpc to be used"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_cidr" {
  default = "10.0.1.0/24"
}

variable "private_cidr" {
  default = "10.0.2.0/24"
}

