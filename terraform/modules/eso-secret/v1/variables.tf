variable "name" {
  type = string
}

variable "namespace" {
  type = string
}

variable "secret_store_name" {
  type = string
}

variable "data" {
  type = list(object({
    secretKey = string
    remoteRef = object({
      key      = string
      property = string
    })
  }))
}
