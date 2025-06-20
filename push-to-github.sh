#!/bin/bash

# GitHub Push Script
# Run this after creating your GitHub repository

echo "=== Push to GitHub ==="
echo ""

# Check if we have a GitHub URL as parameter
if [ -z "$1" ]; then
    echo "Usage: $0 <github-repo-url>"
    echo ""
    echo "Example:"
    echo "$0 https://github.com/yourusername/my-kanopy-app.git"
    echo ""
    echo "Get your repo URL from GitHub after creating the repository"
    exit 1
fi

REPO_URL=$1

echo "Repository URL: $REPO_URL"
echo ""

# Add remote if it doesn't exist
if git remote | grep -q "origin"; then
    echo "Remote origin already exists, updating..."
    git remote set-url origin $REPO_URL
else
    echo "Adding remote origin..."
    git remote add origin $REPO_URL
fi

# Push to GitHub
echo "Pushing to GitHub..."
git branch -M main
git push -u origin main

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ SUCCESS! Code pushed to GitHub"
    echo ""
    echo "Next steps:"
    echo "1. Go to https://drone.corp.mongodb.com"
    echo "2. Sign in with GitHub"
    echo "3. Activate your repository: $(basename $REPO_URL .git)"
    echo "4. Configure secrets (see DEPLOYMENT_STEPS.md)"
    echo ""
    echo "Your app will deploy to:"
    echo "https://my-kanopy-app.devops.staging.corp.mongodb.com"
else
    echo ""
    echo "❌ Push failed. Check your GitHub credentials and repository access."
fi