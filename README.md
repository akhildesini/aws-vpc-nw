# aws-vpc-nw-project

AWS VPC with AWS Network Firewall (Modular Terraform)
This project provisions a secure AWS Virtual Private Cloud (VPC) architecture across 3 Availability Zones (AZs), including:

Public, Private, and Firewall subnets

NAT Gateways for egress from private subnets

AWS Network Firewall for traffic inspection and control

Modularized Terraform structure for reusability and clarity

✅ Built with a modular approach using Terraform v1.5+ and AWS provider

📁 Project Structure

.
├── main.tf # Root Terraform config (calls modules)
├── variables.tf # Input variables
├── outputs.tf # Output values
├── terraform.tfvars # Variable values
├── README.md # Project overview
└── modules/
├── vpc/
│ ├── main.tf # VPC, subnets, route tables
│ ├── variables.tf
│ └── outputs.tf
├── nat_gateway/
│ ├── main.tf # NAT Gateways, Elastic IPs
│ ├── variables.tf
│ └── outputs.tf
└── firewall/
├── main.tf # AWS Network Firewall, rules, endpoints
├── variables.tf
└── outputs.tf

🚀 Features

Multi-AZ VPC (3 Availability Zones)

Public subnets with Internet Gateway

Private subnets with NAT Gateways

Firewall subnets hosting AWS Network Firewall endpoints

Stateless & stateful firewall rules

Full Terraform modularization

Tags and environment-aware naming

📦 Modules

All modules accept env and az_count for flexibility.

VPC Module (modules/vpc)

Creates VPC, public/private/firewall subnets

Public route table with IGW

Outputs subnet and AZ info

NAT Gateway Module (modules/nat_gateway)

Creates NAT Gateways in public subnets

Associates private route tables for internet access

Firewall Module (modules/firewall)

Deploys AWS Network Firewall

Configures stateless & stateful rules

Outputs firewall endpoints per AZ

📘 Sample Firewall Rules

Stateless rule: allow egress HTTP/HTTPS

Stateful rule: drop traffic to IP 198.51.100.1
