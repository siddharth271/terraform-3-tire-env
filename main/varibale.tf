variable "region" {
  type        = string
  default     = "us-west-2"
}

variable "vpc_name" {
  type =string
}

variable "vpc-cidr" {
  type = string
}

variable "namespace" {
  type = string
}

variable "use_existing_vpc" {
  type = bool
}

variable "public_cidr" {
  type = string
}

variable "private_cidr" {
  type = string
}

variable "vpc-location" {
  type = string
  default = ""
}

variable "map_public_ip_on_launch" {
  type = bool
}

variable "instance_type" {
  type = string
  default = ""
}

variable "ami" {
  default = ""
}