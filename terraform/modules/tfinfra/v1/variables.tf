variable "aws_principals" {
  type        = list(string)
  description = "The principals that will have access to common infrastructure"
}

variable "state_principals" {
  type        = list(string)
  description = "The principals that will have read/write access to the bucket to store a state"
}

variable "kms_deletion_window_in_days" {
  type    = number
  default = 14
}

variable "bucket_name" {
  type = string
}
