# IAC modules for GCP (Pulumi)

## Library modules ([lib](./lib/))

## Infra Projects ([infra](./infra/))

### Prerequisites

1. Have a GCP account.
2. Enable following services on GCP:
    - serviceusage.googleapis.com
    - storage-component.googleapis.com
    - compute.googleapis.com
    - container.googleapis.com
    - logging.googleapis.com
    - monitoring.googleapis.com
    - sqladmin.googleapis.com
    - networkconnectivity.googleapis.com
    - secretmanager.googleapis.com
    - artifactregistry.googleapis.com
3. Give following roles to the [default GCP's Compute Service Account](https://cloud.google.com/compute/docs/access/service-accounts#default_service_account):
    - Artifact Registry Reader
    - Logs Writer
    - Monitoring Metric Writer
    - Service Account Token Creator
