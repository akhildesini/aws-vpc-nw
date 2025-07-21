resource "aws_networkfirewall_rule_group" "stateless" {
name = "${var.env}-stateless"
capacity = 100
type = "STATELESS"

rule_group {
rules_source {
stateless_rules_and_custom_actions {
stateless_rule {
priority = 1
rule_definition {
actions = ["aws:pass"]
match_attributes {
protocols = [6] # TCP
destination {
address_definition = "0.0.0.0/0"
}
destination_port {
from_port = 80
to_port = 80
}
source {
address_definition = "0.0.0.0/0"
}
source_port {
from_port = 0
to_port = 65535
}
}
}
}
}
}
}

tags = {
Name = "${var.env}-stateless"
Environment = var.env
}
}

resource "aws_networkfirewall_rule_group" "stateful" {
name = "${var.env}-stateful"
capacity = 100
type = "STATEFUL"

rule_group {
rules_source {
rules_string = <<-EOT
pass tcp any any -> any 80 (sid:1;)
pass tcp any any -> any 443 (sid:2;)
drop ip any any -> 198.51.100.1/32 any (sid:3;)
EOT
}
}

tags = {
Name = "${var.env}-stateful"
Environment = var.env
}
}

resource "aws_networkfirewall_firewall_policy" "this" {
name = "${var.env}-policy"

firewall_policy {
stateless_rule_group_reference {
priority = 10
resource_arn = aws_networkfirewall_rule_group.stateless.arn
}

stateful_rule_group_reference {
  resource_arn = aws_networkfirewall_rule_group.stateful.arn
}

stateless_default_actions          = ["aws:forward_to_sfe"]
stateless_fragment_default_actions = ["aws:forward_to_sfe"]
}

tags = {
Name = "${var.env}-policy"
Environment = var.env
}
}

resource "aws_networkfirewall_firewall" "this" {
name = "${var.env}-firewall"
vpc_id = var.vpc_id
firewall_policy_arn = aws_networkfirewall_firewall_policy.this.arn

dynamic "subnet_mapping" {
for_each = var.firewall_subnet_ids
content {
subnet_id = subnet_mapping.value
}
}

tags = {
Name = "${var.env}-firewall"
Environment = var.env
}
}

output "endpoint_ids" {
description = "List of AWS Network Firewall endpoint IDs per AZ"
value = [
for s in aws_networkfirewall_firewall.this.firewall_status[0].sync_states :
s.attachment[0].endpoint_id
]
}
