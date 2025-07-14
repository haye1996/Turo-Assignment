variable "namespace" {
  description = "The namespace to deploy into"
  type        = string
  default     = "hye"
}

variable "app_name" {
  description = "The name of the application"
  type        = string
}

variable "image" {
  description = "The docker image to deploy"
  type        = string
} 