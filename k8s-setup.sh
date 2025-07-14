#!/bin/bash

# Set kubeconfig to the provided file in the current directory
export KUBECONFIG="$(pwd)/kubeconfig-devops-interview"

echo "Using kubeconfig: $KUBECONFIG"

# Create the namespace (ignore error if it already exists)
kubectl create namespace hye || echo "Namespace 'hye' may already exist."

# List all namespaces
kubectl get namespaces 