variable "aws_region" {
  description = "The AWS region to create things in."
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR for the VPC"
  default     = "10.0.0.0/16"
}

variable "training_ami_size" {
  description = "Instance size of the running AMI"
  default     = "t2.micro"
}

#
#  Change the value below to match your own keys
#
variable "key_path" {
  description = "SSH Public Key path"
  default     = "/Users/tennis.smith/.ssh/id_rsa.pub"
}

variable "ec2_device_names" {
  default = [
    "/dev/sdd",
    "/dev/sde",
    "/dev/sdf",
  ]
}

variable "orphan_ebs_volume_count" {
  description = "Count of UN-attached EBS volumes"
  default     = 0
}

variable "ebs_volume_count" {
  description = "Count of EBS volumes per instance"
  default     = 3
}

#
#  Change the value below to create more instances
#
variable "instance_count" {
  description = "Count of our training instances"
  default     = 4
}

# SNS
variable "sns_subscription_email_address_list" {
  type        = string
  description = "List of email addresses"
  default = "tennis.n.smith@gmail.com"
}

variable "sns_subscription_protocol" {
  type        = string
  default     = "email"
  description = "SNS subscription protocol"
}

variable "sns_topic_name" {
  type        = string
  description = "SNS topic name"
  default     = "AWSAlexaDemoNotifications"
}

variable "sns_topic_display_name" {
  type        = string
  description = "SNS topic display name"
  default     = "AWSAlexaDemoNotifications"
}
