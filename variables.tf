variable "name" {
  description = "Component name"
  type        = string
  default     = "tiller"
}

variable "namespace" {
  description = "Namespace to where deploy tiller"
  type        = string
}

variable "automount_service_account_token" {
  description = "Enable automatin mounting of the service account token"
  type        = bool
  default     = true
}
