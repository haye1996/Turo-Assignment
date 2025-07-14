# DevOps Interview Assignment - Web Application with CI/CD

This project demonstrates a complete CI/CD pipeline for deploying a simple web application to Kubernetes using Docker, Terraform, and automated PR creation.

## 🏗️ Project Overview

A basic web server application that serves three static files:
- `/index.html` - Main application page
- `/page1.html` - Secondary page
- `/version.json` - Build information

The application is containerized with Docker, deployed to Kubernetes using Terraform, and includes automated CI/CD processes.

## 📁 Project Structure

```
.
├── app/                          # Application static files
│   ├── index.html
│   ├── page1.html
│   └── version.json
├── terraform/                    # Terraform configuration
│   ├── modules/app/             # Reusable app module
│   ├── main.tf                  # Root configuration
│   ├── variables.tf             # Variable definitions
│   ├── outputs.tf               # Output values
│   └── provider.tf              # Provider configuration
├── scripts/                     # Automation scripts
│   ├── build-and-push.sh        # Build and push Docker image
│   ├── setup-k8s.sh             # Kubernetes cluster setup
│   └── create-deployment-pr.py  # Create PR for version updates
├── Dockerfile                   # Docker image definition
├── .gitignore                   # Git ignore rules
└── README.md                    # This file
```

## 🚀 Quick Start

### Prerequisites
- Docker installed and running
- kubectl installed
- Terraform installed
- GitHub CLI (`gh`) installed and authenticated
- Access to a Kubernetes cluster

### 1. Setup Kubernetes Access
```bash
# Set the kubeconfig for this assignment
export KUBECONFIG="$(pwd)/kubeconfig-devops-interview"

# Set up cluster access and create namespace
./scripts/setup-k8s.sh
```

### 2. Build and Push Application
```bash
# Build Docker image and push to registry
./scripts/build-and-push.sh --push
```

### 3. Deploy to Kubernetes
```bash
# Navigate to terraform directory
cd terraform

# Initialize Terraform
terraform init

# Plan deployment
terraform plan

# Apply deployment
terraform apply
```

### 4. Access Your Application
```bash
# Get external hostnames
terraform output

# Test the application
curl http://<app1_external_hostname>/index.html
curl http://<app2_external_hostname>/index.html
```

## 🔄 CI/CD Process

### Automated Deployment Workflow

1. **Build and Push** (Manual or CI trigger)
   ```bash
   ./scripts/build-and-push.sh --push
   ```
   - Builds Docker image with timestamp-based version
   - Pushes to Docker Hub registry
   - Outputs version tag for deployment

2. **Create Deployment PR** (Automated)
   ```bash
   python3 scripts/create-deployment-pr.py <version_tag>
   ```
   - Updates Terraform variables with new image version
   - Creates git branch and commits changes
   - Pushes branch and creates Pull Request
   - Example: `python3 scripts/create-deployment-pr.py 20250713-220636`

3. **Review and Merge** (Manual)
   - Review the PR on GitHub
   - Merge using "Squash and merge" to keep clean history

4. **Deploy** (Manual)
   ```bash
   cd terraform
   terraform apply
   ```
   - Applies the new image version to Kubernetes cluster

### Script Details

#### `scripts/build-and-push.sh`
- **Purpose**: Build Docker image and push to registry
- **Usage**: `./scripts/build-and-push.sh [--push]`
- **Output**: Version tag and `.version` file
- **Features**: 
  - Timestamp-based versioning
  - Optional push to registry
  - Version file generation for CI/CD

#### `scripts/setup-k8s.sh`
- **Purpose**: Setup Kubernetes cluster access
- **Usage**: `./scripts/setup-k8s.sh`
- **Features**:
  - Sets KUBECONFIG environment variable
  - Creates namespace if needed
  - Lists all namespaces

#### `scripts/create-deployment-pr.py`
- **Purpose**: Automate version updates and PR creation
- **Usage**: `python3 scripts/create-deployment-pr.py <version_tag>`
- **Features**:
  - Updates Terraform variables with new image version
  - Checks if update is needed (no duplicate PRs)
  - Creates git branch and PR automatically
  - Supports both specific tags and 'latest'

## 🏗️ Infrastructure

### Terraform Configuration
- **Modular Design**: Reusable `modules/app/` for multiple deployments
- **Multiple Instances**: Deploys two app instances with different names
- **LoadBalancer Services**: Externally accessible via HTTP
- **Namespace Management**: Uses existing namespace (no auto-creation)

### Kubernetes Resources
- **Deployment**: Runs the application pods
- **Service**: LoadBalancer type for external access
- **Namespace**: Isolated deployment environment

## 🔧 Configuration

### Environment Variables
- `KUBECONFIG`: Path to Kubernetes config file
- `DOCKER_REPO`: Docker registry repository name

### Terraform Variables
- `image1`: Docker image for first app instance
- `image2`: Docker image for second app instance

## 🧪 Testing

### Local Testing
```bash
# Test Docker image locally
docker run -p 8080:80 haitongyedocker/devops-interview-app:latest
curl http://localhost:8080/index.html
```

### Kubernetes Testing
```bash
# Set kubeconfig for kubectl commands
export KUBECONFIG="$(pwd)/kubeconfig-devops-interview"

# Check deployment status
kubectl get pods -n hye
kubectl get svc -n hye

# Test application endpoints
curl http://<external-hostname>/index.html
curl http://<external-hostname>/page1.html
curl http://<external-hostname>/version.json
```

## 📝 Notes

- **HTTP Only**: Application uses HTTP (no HTTPS/ACM certs) as per requirements
- **LoadBalancer**: Uses AWS ELB for external access
- **Modular**: Terraform module allows multiple app deployments
- **Automated**: CI/CD process reduces manual deployment steps

## 🚨 Troubleshooting

### Common Issues
1. **Docker push fails**: Ensure you're logged in with `docker login`
2. **Terraform apply fails**: Check cluster access with `kubectl cluster-info`
3. **PR creation fails**: Verify GitHub CLI authentication with `gh auth status`
4. **External IP empty**: Wait a few minutes for LoadBalancer provisioning
5. **Wrong cluster connection**: Ensure KUBECONFIG is set correctly with `export KUBECONFIG="$(pwd)/kubeconfig-devops-interview"`

### Useful Commands
```bash
# Check cluster access
kubectl cluster-info

# Check deployment status
kubectl get all -n hye

# Check Terraform state
terraform show

# Check Docker images
docker images | grep devops-interview-app
``` 