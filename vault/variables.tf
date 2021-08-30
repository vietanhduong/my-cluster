variable "domain" {
  type = string
}

variable "robot_access_key" {
  type      = string
  sensitive = true
}

variable "robot_secret_key" {
  type      = string
  sensitive = true
}
