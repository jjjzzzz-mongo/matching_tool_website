# Matching Tool Website

This repository contains both the main matching tool website and a MongoDB Kanopy tutorial project.

## Kanopy Test Project (in my-app directory)

This is a complete Flask application following the MongoDB Kanopy tutorial with full CI/CD pipeline setup.

### Project Structure

- `app.py` - Flask application with environment variables and secrets
- `Dockerfile` - Docker configuration for containerization  
- `.drone.yml` - CI/CD pipeline configuration (configured for devops namespace)
- `environments/staging.yaml` - Complete staging environment configuration
- `aws-config.txt` - Sample configuration file for volume secrets
- `setup-secrets.sh` - Automated setup script
- `manual-commands.md` - Step-by-step manual setup instructions

### Quick Setup (Recommended)

1. **Run the automated setup script:**
   ```bash
   cd my-app
   ./setup-secrets.sh
   ```

2. **Configure Drone:**
   - Go to https://drone.corp.mongodb.com
   - Sign in with GitHub and activate your repository
   - Add the secrets displayed by the setup script

3. **Deploy:**
   Your app will be available at: https://my-kanopy-app.devops.staging.corp.mongodb.com

### Manual Setup

If you prefer manual setup, see `my-app/manual-commands.md` for detailed instructions.

### Configuration Details

#### Environment Variables
- `APP_MESSAGE` - Custom message (set to "Hello, MongoDB!")
- `APP_SECRET` - Secret value from Kubernetes secret

#### Features Included
- ✅ Environment variable configuration
- ✅ Kubernetes secrets integration
- ✅ Volume-mounted configuration files
- ✅ Health checks and probes
- ✅ Service account with RBAC
- ✅ Ingress configuration
- ✅ Service mesh integration

#### Architecture
- **Namespace:** devops
- **App Name:** my-kanopy-app
- **Architecture:** arm64
- **Port:** 8080

### Local Testing

```bash
cd my-app
docker build -t my-kanopy-app .
docker run -p 8080:8080 -e APP_MESSAGE="Hello Local!" my-kanopy-app
```

Visit http://localhost:8080/ to test the application.

### Customization

To customize for your project:
1. Update namespace and app name in `.drone.yml`
2. Modify `environments/staging.yaml` for your requirements
3. Update the setup script with your values
4. Change configuration files as needed
