variable "aws_principals" {
  type        = list(string)
  description = "The principals who will have access to the bucket"
}

variable "kms_deletion_window_in_days" {
  type    = number
  default = 14
}

variable "bucket_name" {
  type    = string
  default = null
}
variable "bucket_name_prefix" {
  type    = string
  default = null
}
