locals {
  subnets = {
    for s in data.aws_subnet.selected : s.availability_zone => s.id...
  }
}