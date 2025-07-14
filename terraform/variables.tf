variable "namespace" {
  description = "The namespace to deploy into"
  type        = string
  default     = "hye"
}

variable "app_name" {
  description = "The name of the application"
  type        = string
  default     = "devops-interview-app"
}

variable "image" {
  description = "The docker image to deploy"
  type        = string
  default     = "haitongyedocker/devops-interview-app:latest"
}

variable "image1" {
  description = "The docker image to deploy for app1"
  type        = string
  default     = "haitongyedocker/devops-interview-app:20250713-220636"
}

variable "image2" {
  description = "The docker image to deploy for app2"
  type        = string
  default     = "haitongyedocker/devops-interview-app:latest"
} 