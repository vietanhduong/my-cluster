data "aws_iam_policy_document" "istio" {
  version = "2012-10-17"
  statement {
    actions = [
      "ec2:DescribeVpcs",
      "elasticloadbalancing:AddTags",
      "elasticloadbalancing:CreateListener",
      "elasticloadbalancing:CreateTargetGroup",
      "elasticloadbalancing:DeleteListener",
      "elasticloadbalancing:DeleteTargetGroup",
      "elasticloadbalancing:DescribeListeners",
      "elasticloadbalancing:DescribeLoadBalancerPolicies",
      "elasticloadbalancing:DescribeTargetGroups",
      "elasticloadbalancing:DescribeTargetHealth",
      "elasticloadbalancing:ModifyListener",
      "elasticloadbalancing:ModifyTargetGroup",
      "elasticloadbalancing:RegisterTargets",
      "elasticloadbalancing:SetLoadBalancerPoliciesOfListener"
    ]
    resources = ["*"]
    effect    = "Allow"
  }

  statement {
    actions = [
      "ec2:DescribeVpcs",
      "ec2:DescribeRegions"
    ]
    resources = ["*"]
    effect    = "Allow"
  }
}

resource "aws_iam_policy" "istio" {
  name   = "${data.terraform_remote_state.eks.outputs.cluster_id}_istio"
  policy = data.aws_iam_policy_document.istio.json
}

resource "aws_iam_role_policy_attachment" "istio" {
  role       = data.terraform_remote_state.eks.outputs.cluster_role_name
  policy_arn = aws_iam_policy.istio.arn
}
