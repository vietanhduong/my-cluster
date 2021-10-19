locals {
  name       = "my_cluster"
  eks_output = data.terraform_remote_state.eks.outputs
  subnets = {
    for s in data.aws_subnet.selected : s.availability_zone => s.id...
  }
}