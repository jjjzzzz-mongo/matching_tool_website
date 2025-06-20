#!/bin/bash

# Script to get all required secrets for Drone
# Run this on a machine with MongoDB kubectl access

echo "=== Getting MongoDB Kanopy Secrets ==="
echo ""

# Set your namespace
NAMESPACE="analytics"  # Using analytics namespace
echo "Using namespace: $NAMESPACE"
echo ""

echo "1. Getting staging kubernetes token..."
kubectl config use-context api.staging.corp.mongodb.com
kubectl config set-context --current --namespace=$NAMESPACE
STAGING_TOKEN=$(kubectl get secret kanopy-cicd-token -o jsonpath="{.data.token}" | base64 --decode)
echo "✅ Staging token retrieved"

echo ""
echo "2. Getting ECR access credentials..."
ECR_ACCESS_KEY=$(kubectl get secret ecr -o jsonpath="{.data.ecr_access_key}" | base64 --decode)
ECR_SECRET_KEY=$(kubectl get secret ecr -o jsonpath="{.data.ecr_secret_key}" | base64 --decode)
echo "✅ ECR credentials retrieved"

echo ""
echo "3. Creating application secrets in Kubernetes..."
helm ksec set my-secrets APP_SECRET=supersecretpassword
echo "✅ Application secrets created"

echo ""
echo "=========================================="
echo "DRONE SECRETS TO ADD:"
echo "=========================================="
echo ""
echo "Secret Name: staging_kubernetes_token"
echo "Value: $STAGING_TOKEN"
echo ""
echo "Secret Name: ecr_access_key"  
echo "Value: $ECR_ACCESS_KEY"
echo ""
echo "Secret Name: ecr_secret_key"
echo "Value: $ECR_SECRET_KEY"
echo ""
echo "=========================================="
echo ""
echo "Add these secrets to Drone at:"
echo "https://drone.corp.mongodb.com/jjjzzzz-mongo/matching_tool_website/settings/secrets"