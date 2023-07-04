variable "ami_id" {
  type = string
  default = "ami-0c55b159cbfafe1f0"
}

variable "instance_type" {
  type = string
  default = "t2.micro"
}

variable "connection_user" {
  type = string
  default = "ec2-user"
}