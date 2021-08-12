resource "helm_release" "autoscaler" {
  name            = "autoscaler"
  namespace       = "kube-system"
  repository      = "https://kubernetes.github.io/autoscaler"
  chart           = "cluster-autoscaler"
  cleanup_on_fail = true

  values = [templatefile("${path.module}/helm/cluster-autoscaler.yml", {
    cluster_name = local.cluster_name
    region       = var.region
    arn          = aws_iam_role.cluster_autoscaler.arn
  })]

  depends_on = [
    module.cluster
  ]
}

resource "aws_iam_role" "cluster_autoscaler" {
  name               = "${local.cluster_name}_cluster_autoscaler"
  assume_role_policy = data.aws_iam_policy_document.pod_assume_role.json
}

data "aws_iam_policy_document" "cluster_autoscaler" {
  version = "2012-10-17"
  statement {
    actions = [
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeTags",
      "autoscaling:DescribeLaunchConfigurations",
      "autoscaling:SetDesiredCapacity",
      "autoscaling:TerminateInstanceInAutoScalingGroup",
      "ec2:DescribeLaunchTemplateVersions"
    ]
    resources = ["*"]
    effect    = "Allow"
  }
}
resource "aws_iam_policy" "cluster_autoscaler" {
  name   = "${local.cluster_name}_cluster_autoscaler"
  policy = data.aws_iam_policy_document.cluster_autoscaler.json
}

resource "aws_iam_role_policy_attachment" "cluster_autoscaler" {
  role       = aws_iam_role.cluster_autoscaler.name
  policy_arn = aws_iam_policy.cluster_autoscaler.arn
}
