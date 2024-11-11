# IAC modules for GCP (Pulumi)

I am using [Pulumi](https://www.pulumi.com/) to manage IAC configs for Google Cloud resources, so please [setup pulumi first](https://www.pulumi.com/docs/install/). Make sure gcloud CLI is installed too.

## Project Structure

### Library modules ([lib](./lib/))

Contains the reusable library modules (written in Jsonnet) to provision resources to GCP.

### Infra Projects ([infra](./infra/))

Contains different Pulumi Programs, grouping co-dependent resources in one program. Pulumi Program is the executable code that Pulumi can deploy in different envs, called **stacks**. In subsequent steps, all provisioning simply uses a stack called `prod` (environment name).

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
3. A GCP Bucket to store Pulumi state files. Refer to [this doc](https://cloud.google.com/storage/docs/discover-object-storage-console) on how-to create. The bucket **should not be public**.

## Provisioning Steps

### Preparation

1. Once Pulumi is installed, setup GCP with pulumi:

```bash
gcloud auth application-default login
gcloud config set project $GCP_PROJECT
pulumi login gs://$BUCKET_NAME
```

2. Update the GCP metadata in all Pulumi programs. Open up `Pulumi.prod.yaml` file in all the projects under ./infra subfolder in your code editor. It'll roughly look like below (and update the CHANGEME values):

```yaml
config:
  gcp:project: "" # CHANGEME: GCP Project ID
  project: whisper
  env: "prod"
  region: "" # CHANGEME: GCP Region <--- region where you want to provision, like 'europe-north1'
  shortRegion: "" # CHANGEME: GCP Short Region <--- eurn1 for 'europe-north1' region
```

### High-level Infra

1. Provision the Network resources (subnets) with [init-network-k8s](./infra/init-network-k8s/):

```bash
cd infra/init-network-k8s
pulumi up -s prod --diff
```

2. Provision the K8s cluster, node pool and External Secret with [k8s-cluster](./infra/k8s-cluster/):

```bash
cd infra/k8s-cluster
pulumi up -s prod --diff
```

3. Provision the Artifact Registry repository with [docker-repos](./infra/docker-repos/):

```bash
cd infra/docker-repos
pulumi up -s prod --diff
```

4. Provision the Postgres DB for Whisper notes app (and an encrypted secret in Secret Manager to store the database credentials) with [whisper-notes-db](./infra/whisper-notes-db/):

```bash
cd infra/whisper-notes-db
pulumi up -s prod --diff
```

### Kubernetes Infra setup

1. Install necessary tools like:
    - Export k8s-related metrics, like Kube state/node/pods, to [GCP Managed-Prometheus](https://cloud.google.com/stackdriver/docs/managed-prometheus) ([code](./infra/k8s-tools/monitoring/))
    - Create Self-signed certificate issuer using [cert-manager](https://cert-manager.io/) ([code](./infra/k8s-tools/certs/))
    - Enable HTTPS listener on the ALB using [Gateway](https://cloud.google.com/kubernetes-engine/docs/concepts/gateway-api) and a self-signed certificate for your domain ([code](./infra/k8s-tools/ingress))
    - Support GitOps to auto-deploy services using [ArgoCD](https://argo-cd.readthedocs.io/en/stable/) ([code](./infra/k8s-tools/argocd/))
1. Update the desired domain in configs for [ingress](./infra/k8s-tools/ingress/) and [argocd](./infra/k8s-tools/argocd/) tools. Search for string `CHANGEME` using your code editor and replace as-per the instructions.
1. Provision all the above tools with [k8s-tools](./infra/k8s-tools/) pulumi program:

```bash
cd infra/k8s-tools
pulumi up -s prod --diff
```

## Next steps

Once all the provisioning steps are successful, refer to [k8s services](../services/).
