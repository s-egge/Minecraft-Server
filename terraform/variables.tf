variable "instance_region" {
  description = "AWS region for the server"
  type        = string
  default     = "us-west-2"
}

variable "instance_name" {
  description = "Value of the Name tag for the EC2 instance"
  type        = string
  default     = "Minecraft Server"
}

variable "instance_ami" {
  description = "AMI ID for the instance"
  type        = string
  default     = "ami-05a6dba9ac2da60cb"
}

variable "instance_type" {
  description = "Type of EC2 instance"
  type        = string
  default     = "t4g.small"
}

variable "ssh_region" {
  description = "Region that server allows SSH from"
  type        = string
  default     = "18.237.140.160/29"
}