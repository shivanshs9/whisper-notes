# Workflows

## CD Workflow

This workflow builds and pushes the docker image for both frontend and backend.

### Required Repo Secrets

1. **GCLOUD_PROJECT -** GCP Project name.
2. **GCLOUD_SECRET_KEY -** Base64 value of Service Account JSON key file.

### Optional Repo Variables

1. **BUILD_ARGS -** Build Args to pass during Docker build.

### GCP Artifact Registry Access

The service account should have the `roles/artifactregistry.repoAdmin` IAM role attached to it.
If using the Pulumi modules to create, then the service account is created automatically.

1. Navigate to the GCP IAM console and simply download a new Service account key for the role.
2. Convert it to base64 and use as the secret value of `GCLOUD_SECRET_KEY`

### Frontend build requires Backend URL

In the [frontend build job](./build-push-gcloud.yaml), you might need to change the URL at which backend service is deployed. This is used as a build arg in [frontend dockerfile](../../frontend.Dockerfile).

### Auto-Deployment

To avoid unnecessary bot commits, this feature is disabled by default. If you want to enable CD and deploy the build on every commit, then just enable the [deploy job](./cd-build.yaml).
