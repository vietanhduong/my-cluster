resource "aws_efs_file_system" "this" {
  tags = {
    Name = "${local.name}_efs"
  }
}

data "aws_subnet_ids" "selected" {
  vpc_id = local.eks_output.vpc_id
}

data "aws_subnet" "selected" {
  for_each = data.aws_subnet_ids.selected.ids
  id       = each.value
}

resource "aws_efs_mount_target" "this" {
  for_each        = local.subnets
  file_system_id  = aws_efs_file_system.this.id
  subnet_id       = each.value[0]
  security_groups = [aws_security_group.this.id]
}

