#!/bin/bash

# Kanopy Setup Script
# Run this script to configure all necessary secrets and contexts

echo "Setting up Kanopy project secrets..."

# Set your namespace (change this to your actual namespace)
NAMESPACE="analytics"

echo "Using namespace: $NAMESPACE"

# 1. Configure kubectl contexts and get secrets
echo "1. Setting up kubectl contexts and retrieving secrets..."

echo "   Setting staging context..."
kubectl config use-context api.staging.corp.mongodb.com
kubectl config set-context --current --namespace=$NAMESPACE

echo "   Getting staging kubernetes token..."
STAGING_TOKEN=$(kubectl get secret kanopy-cicd-token -o jsonpath="{.data.token}" | base64 --decode)
echo "   Staging token retrieved: ${STAGING_TOKEN:0:20}..."

echo "   Setting prod context..."
kubectl config use-context api.prod.corp.mongodb.com
kubectl config set-context --current --namespace=$NAMESPACE

echo "   Getting prod kubernetes token..."
PROD_TOKEN=$(kubectl get secret kanopy-cicd-token -o jsonpath="{.data.token}" | base64 --decode)
echo "   Prod token retrieved: ${PROD_TOKEN:0:20}..."

echo "   Getting ECR access key..."
ECR_ACCESS_KEY=$(kubectl get secret ecr -o jsonpath="{.data.ecr_access_key}" | base64 --decode)
echo "   ECR access key retrieved: ${ECR_ACCESS_KEY:0:20}..."

echo "   Getting ECR secret key..."
ECR_SECRET_KEY=$(kubectl get secret ecr -o jsonpath="{.data.ecr_secret_key}" | base64 --decode)
echo "   ECR secret key retrieved: ${ECR_SECRET_KEY:0:20}..."

# 2. Create Kubernetes application secrets
echo "2. Creating Kubernetes application secrets..."

echo "   Switching back to staging context..."
kubectl config use-context api.staging.corp.mongodb.com
kubectl config set-context --current --namespace=$NAMESPACE

echo "   Creating application secret with helm ksec..."
helm ksec set my-secrets APP_SECRET=supersecretpassword

echo "   Creating volume secret with config files..."
kubectl create secret generic my-secrets --from-file=aws-config.txt --dry-run=client -o yaml | kubectl apply -f -

echo ""
echo "3. Drone Secrets Configuration"
echo "Add these secrets to your Drone repository at https://drone.corp.mongodb.com"
echo ""
echo "Secret Name: staging_kubernetes_token"
echo "Value: $STAGING_TOKEN"
echo ""
echo "Secret Name: prod_kubernetes_token" 
echo "Value: $PROD_TOKEN"
echo ""
echo "Secret Name: ecr_access_key"
echo "Value: $ECR_ACCESS_KEY"
echo ""
echo "Secret Name: ecr_secret_key"
echo "Value: $ECR_SECRET_KEY"
echo ""
echo "Setup complete! Now push your code to GitHub to trigger the pipeline."