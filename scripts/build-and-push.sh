#!/bin/bash

# Configuration
# You can change this to your Docker Hub username or use a different registry
DOCKER_REPO="haitongyedocker/devops-interview-app"
VERSION=$(date +%Y%m%d-%H%M%S)
IMAGE_TAG="${DOCKER_REPO}:${VERSION}"
LATEST_TAG="${DOCKER_REPO}:latest"

echo "Building Docker image..."
echo "Version: ${VERSION}"
echo "Image: ${IMAGE_TAG}"

# Build the Docker image
docker build -t ${IMAGE_TAG} -t ${LATEST_TAG} .

if [ $? -eq 0 ]; then
    echo "Docker build successful!"
    
    # Check if we should push to registry
    if [ "$1" = "--push" ]; then
        echo "Pushing image to registry..."
        docker push ${IMAGE_TAG}
        docker push ${LATEST_TAG}
        
        if [ $? -eq 0 ]; then
            echo "Image pushed successfully!"
        else
            echo "Failed to push image to registry!"
            echo "Note: You may need to:"
            echo "1. Create a Docker Hub account"
            echo "2. Run 'docker login'"
            echo "3. Update DOCKER_REPO in this script to your username"
            echo "4. Or use --local flag to skip pushing"
        fi
    else
        echo "Skipping push (use --push flag to push to registry)"
        echo "For local testing, you can run:"
        echo "docker run -p 8080:80 ${IMAGE_TAG}"
    fi
    
    # Create version file
    echo "VERSION=${VERSION}" > .version
    echo "IMAGE_TAG=${IMAGE_TAG}" >> .version
    echo "LATEST_TAG=${LATEST_TAG}" >> .version
    
    echo "=== BUILD SUMMARY ==="
    echo "Version: ${VERSION}"
    echo "Image Tag: ${IMAGE_TAG}"
    echo "Latest Tag: ${LATEST_TAG}"
    echo "Version file created: .version"
    
    # Output version for CI/CD pipeline
    echo "${VERSION}"
else
    echo "Docker build failed!"
    exit 1
fi 