variable "vpc_id" {
description = "The ID of the VPC where the firewall will be deployed"
type = string
}


variable "firewall_subnet_ids" {
description = "List of firewall subnet IDs"
type = list(string)
}

variable "env" {
type = string
description = "Environment name (e.g. dev, staging)"
}
