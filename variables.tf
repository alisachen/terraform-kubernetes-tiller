variable "name" {
  description = "Generic name"
  type        = string
  default     = "tiller"
}

variable "component" {
  description = "Component name"
  type        = string
  default     = "helm"
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

variable "service_namespaces" {
  description = "The ServiceAccounts to grant permissions to. Example ['helm']"
  type        = list(string)
}

variable "tiller_version" {
  description = "Tiller version"
  type        = string
  default     = "v2.14.2"
}

variable "tiller_replicas" {
  description = "Amound of replicas to deploy"
  type        = string
  default     = 1
}

variable "tiller_max_history" {
  description = "Tiller history to contain"
  type        = string
  default     = 200
}

variable "tiller_image" {
  type        = string
  description = "Tiller Docker image"
  default     = "gcr.io/kubernetes-helm/tiller:v2.14.2"
}

variable "tiller_service_type" {
  description = "Type of Tiller's Kubernetes service object."
  type        = string
  default     = "ClusterIP"
}

locals {
  app = var.namespace
}
