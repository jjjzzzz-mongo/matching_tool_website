# Kanopy Test Project

This is a test Flask application following the MongoDB Kanopy tutorial.

## Files Created

- `app.py` - Flask application with environment variable support
- `Dockerfile` - Docker configuration for containerization
- `.drone.yml` - CI/CD pipeline configuration
- `environments/staging.yaml` - Staging environment configuration
- `aws-config.txt` - Sample configuration file for secrets

## Setup Instructions

1. Replace `<APP>` and `<NAMESPACE>` placeholders in `.drone.yml` with your actual values
2. Configure Drone secrets:
   - `staging_kubernetes_token`
   - `ecr_access_key`
   - `ecr_secret_key`
3. Create Kubernetes secrets:
   ```bash
   helm ksec set my-secrets APP_SECRET=supersecretpassword
   kubectl create secret generic my-secrets --from-file=aws-config.txt
   ```

## Local Testing

```bash
docker build -t my-app .
docker run -p 8080:8080 my-app
```

Visit http://localhost:8080/ to test the application.