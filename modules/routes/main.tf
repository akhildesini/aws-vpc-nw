resource "aws_route_table" "private" {
  count  = length(var.private_subnet_ids)
  vpc_id = var.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    vpc_endpoint_id = try(var.firewall_endpoint_ids[count.index], null)
  }

  tags = {
    Name        = "${var.env}-rt-private-${count.index}"
    Environment = var.env
  }
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnet_ids)
  subnet_id      = var.private_subnet_ids[count.index]
  route_table_id = aws_route_table.private[count.index].id
}

