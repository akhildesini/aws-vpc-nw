resource "aws_eip" "nat" {
  count = length(var.public_subnets)

  tags = {
    Name = "${var.env}-nat-eip-${count.index}"
  }
}

resource "aws_nat_gateway" "this" {
  count         = length(var.public_subnets)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = var.public_subnets[count.index]

  tags = {
    Name = "${var.env}-nat-${count.index}"
  }

  depends_on = [aws_eip.nat]
}

output "nat_gateway_ids" {
  value = aws_nat_gateway.this[*].id
}

