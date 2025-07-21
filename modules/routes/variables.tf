variable "vpc_id" {}
variable "private_subnet_ids" {
  type = list(string)
}
variable "firewall_endpoint_ids" {
  type = list(string)
}
variable "nat_gateway_ids" {
  type = list(string)
}
variable "azs" {
  type = list(string)
}
variable "env" {}

