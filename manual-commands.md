# Manual Setup Commands

If you prefer to run commands manually instead of using the setup script:

## 1. Set Your Namespace
```bash
export NAMESPACE="analytics"  # Using analytics namespace
```

## 2. Get Drone Secrets

### Staging Kubernetes Token
```bash
kubectl config use-context api.staging.corp.mongodb.com
kubectl config set-context --current --namespace=$NAMESPACE
kubectl get secret kanopy-cicd-token -o jsonpath="{.data.token}" | base64 --decode && echo
```

### Production Kubernetes Token
```bash
kubectl config use-context api.prod.corp.mongodb.com
kubectl config set-context --current --namespace=$NAMESPACE
kubectl get secret kanopy-cicd-token -o jsonpath="{.data.token}" | base64 --decode && echo
```

### ECR Access Key
```bash
kubectl get secret ecr -o jsonpath="{.data.ecr_access_key}" | base64 --decode && echo
```

### ECR Secret Key
```bash
kubectl get secret ecr -o jsonpath="{.data.ecr_secret_key}" | base64 --decode && echo
```

## 3. Create Kubernetes Secrets

### Application Secret (Environment Variables)
```bash
kubectl config use-context api.staging.corp.mongodb.com
kubectl config set-context --current --namespace=$NAMESPACE
helm ksec set my-secrets APP_SECRET=supersecretpassword
```

### Volume Secret (Configuration Files)
```bash
kubectl create secret generic my-config-files --from-file=aws-config.txt
```

## 4. Configure Drone

1. Go to https://drone.corp.mongodb.com
2. Sign in with GitHub credentials
3. Activate your repository
4. Add the following secrets:
   - `staging_kubernetes_token` (from step 2)
   - `prod_kubernetes_token` (from step 2)
   - `ecr_access_key` (from step 2)
   - `ecr_secret_key` (from step 2)

## 5. Deploy

Push your code to GitHub to trigger the pipeline:
```bash
git add .
git commit -m "Ready for deployment"
git push origin main
```

Your app will be available at:
https://my-kanopy-app.analytics.staging.corp.mongodb.com