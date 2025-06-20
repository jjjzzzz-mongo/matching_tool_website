# Kanopy Deployment Steps

Since kubectl contexts aren't configured locally, follow these steps to deploy your Kanopy project:

## 1. ✅ Create GitHub Repository

**Option A: Using GitHub Web UI (Recommended)**
1. Go to https://github.com/new
2. Repository name: `my-kanopy-app` (or your preferred name)
3. Set to **Public** (required for MongoDB's Drone)
4. **DO NOT** initialize with README (we already have files)
5. Click "Create repository"

**Option B: Using Command Line (if you have GitHub CLI)**
```bash
gh repo create my-kanopy-app --public --source=. --push
```

## 2. ✅ Push Your Code

After creating the GitHub repo, run these commands:

```bash
# Add GitHub remote (replace YOUR_USERNAME)
git remote add origin https://github.com/YOUR_USERNAME/my-kanopy-app.git

# Push code to GitHub
git branch -M main
git push -u origin main
```

## 3. ✅ Configure Drone

1. **Go to Drone:** https://drone.corp.mongodb.com
2. **Sign in** with your GitHub credentials
3. **Activate your repository:**
   - Find `YOUR_USERNAME/my-kanopy-app`
   - Click the toggle to activate it
   - This creates a webhook in GitHub

## 4. ✅ Get Secrets from MongoDB Infrastructure

**You need to run these commands on a machine with MongoDB kubectl access:**

```bash
# Set your namespace
export NAMESPACE="devops"  # or your assigned namespace

# Get staging token
kubectl config use-context api.staging.corp.mongodb.com
kubectl config set-context --current --namespace=$NAMESPACE
kubectl get secret kanopy-cicd-token -o jsonpath="{.data.token}" | base64 --decode

# Get ECR keys
kubectl get secret ecr -o jsonpath="{.data.ecr_access_key}" | base64 --decode
kubectl get secret ecr -o jsonpath="{.data.ecr_secret_key}" | base64 --decode
```

## 5. ✅ Add Secrets to Drone

In Drone (https://drone.corp.mongodb.com), go to your repository settings and add:

| Secret Name | Value |
|-------------|-------|
| `staging_kubernetes_token` | Output from kubectl command above |
| `ecr_access_key` | ECR access key from kubectl |
| `ecr_secret_key` | ECR secret key from kubectl |

## 6. ✅ Create Kubernetes Secrets

**Run on machine with MongoDB kubectl access:**

```bash
# Switch to staging context
kubectl config use-context api.staging.corp.mongodb.com
kubectl config set-context --current --namespace=$NAMESPACE

# Create app secret
helm ksec set my-secrets APP_SECRET=supersecretpassword

# Create config file secret
kubectl create secret generic my-secrets --from-file=aws-config.txt
```

## 7. ✅ Deploy

Push any change to trigger deployment:

```bash
git commit --allow-empty -m "Trigger deployment"
git push origin main
```

## 8. ✅ Verify Deployment

- **Drone Build:** Check https://drone.corp.mongodb.com for build status
- **Application:** Visit https://my-kanopy-app.devops.staging.corp.mongodb.com
- **Logs:** Use `kubectl logs` to troubleshoot if needed

## 🚨 Important Notes

- Replace `devops` with your actual MongoDB namespace
- Replace `YOUR_USERNAME` with your GitHub username
- The MongoDB kubectl contexts must be configured by your infrastructure team
- All secrets are specific to your MongoDB environment

## 📞 Need Help?

If you encounter issues:
1. Check Drone build logs
2. Verify all secrets are correctly set
3. Confirm namespace access with your MongoDB team
4. Review kubectl context configuration