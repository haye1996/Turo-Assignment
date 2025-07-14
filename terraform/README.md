# Terraform Kubernetes Deployment

This directory contains Terraform configuration to deploy the DevOps Interview App to a Kubernetes cluster.

## Prerequisites
- Terraform installed
- Access to the Kubernetes cluster (kubeconfig in project root)
- Docker image published to Docker Hub

## Usage

1. Initialize Terraform:
   ```bash
   terraform init
   ```
2. Plan the deployment:
   ```bash
   terraform plan -var="image1=haitongyedocker/devops-interview-app:<tag1>" -var="image2=haitongyedocker/devops-interview-app:<tag2>"
   ```
3. Apply the deployment:
   ```bash
   terraform apply -var="image1=haitongyedocker/devops-interview-app:<tag1>" -var="image2=haitongyedocker/devops-interview-app:<tag2>"
   ```

## Module Usage

The `modules/app` module can be used to deploy multiple instances of the application. See `main.tf` for example usage deploying two instances with different names and namespaces.

## Variables
- `image1`: Docker image for app1 (default: `haitongyedocker/devops-interview-app:latest`)
- `image2`: Docker image for app2 (default: `haitongyedocker/devops-interview-app:latest`)

## Outputs
- `app1_service_external_ip`: The external IP of the LoadBalancer service for app1
- `app2_service_external_ip`: The external IP of the LoadBalancer service for app2
- `app1_deployment_name`: The name of the deployment for app1
- `app2_deployment_name`: The name of the deployment for app2 