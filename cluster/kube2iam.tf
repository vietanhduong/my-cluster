resource "helm_release" "kube2iam" {
  name       = "kube2iam"
  repository = "https://charts.helm.sh/stable"
  chart      = "kube2iam"
  namespace  = "kube-system"

  values = [file("${path.module}/helm/kube2iam.yml")]
}

data "aws_iam_policy_document" "eks-extra" {
  version = "2012-10-17"

  statement {
    actions = [
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["*"]
    effect    = "Allow"
  }

  statement {
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetRepositoryPolicy",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:BatchGetImage",
    ]

    resources = ["*"]
    effect    = "Allow"
  }

}

resource "aws_iam_policy" "eks_policy_default" {
  name   = "${local.cluster_name}_default"
  path   = "/"
  policy = data.aws_iam_policy_document.eks-extra.json
}

resource "aws_iam_role_policy_attachment" "eks_attach_default" {
  role       = module.cluster.worker_iam_role_name
  policy_arn = aws_iam_policy.eks_policy_default.arn
}

data "aws_iam_policy_document" "worker_assume_role" {
  statement {
    effect    = "Allow"
    actions   = ["sts:AssumeRole"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "worker_assume_role_policy" {
  name   = "${local.cluster_name}_worker_assume_role_policy"
  path   = "/"
  policy = data.aws_iam_policy_document.worker_assume_role.json
}

resource "aws_iam_role_policy_attachment" "worker_assume_role_policy" {
  role       = module.cluster.worker_iam_role_name
  policy_arn = aws_iam_policy.worker_assume_role_policy.arn
}

data "aws_iam_policy_document" "pod_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }

  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      type        = "AWS"
      identifiers = [module.cluster.worker_iam_role_arn]
    }
  }
}
