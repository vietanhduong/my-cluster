variable "region" {
  type        = string
  description = "AWS Region. Default is 'ap-southeast-1'"
  default     = "ap-southeast-1"
}

variable "cluster_name" {
  type        = string
  description = "EKS cluster name. Default is empty. Make sure cluster name does not exist."
  default     = ""
}

variable "default_owner" {
  type        = string
  description = "AWS Onwer tag. If this variabe is empty. Owner tag will be 'robot'. Default is empty."
  default     = ""
}

variable "cluster_version" {
  type        = string
  description = "Kubernetes version. Default is '1.20'."
  default     = "1.20"
}

variable "allowed_cidrs" {
  type        = list(string)
  description = "Allowed IP CIRD can access to the Cluster. Default is ['0.0.0.0/0']"
  default     = ["0.0.0.0/0"]
}

variable "volume_type" {
  type        = string
  description = "AWS EBS Volume type. Default is 'gp2'"
  default     = "gp2"
}

variable "volume_size" {
  type        = number
  description = "AWS EBS disk size. Default is 100"
  default     = 100
}

variable "worker_tier" {
  type        = string
  description = "AWS EC2 machine type. Default is 't2.medium'"
  default     = "t2.medium"
}

variable "min_worker" {
  type        = number
  description = "Minimum number of workers. Default is 2"
  default     = 2
}

variable "max_worker" {
  type        = number
  description = "Maximum number of workers. Default is 100"
  default     = 100
}

variable "private_subnets" {
  type        = list(string)
  description = "VPC private subnets (required)"
}

variable "public_subnets" {
  type        = list(string)
  description = "VPC public subnets. Default is []"
  default     = []
}

variable "availability_zones" {
  type        = list(string)
  description = "AWS AZ. Default is ['ap-southeast-1a', 'ap-southeast-1b', 'ap-southeast-1c']"
  default     = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]
}

variable "cidr_range" {
  type        = string
  description = "VPC IP CIDR (required)"
}
