# Whisper Notes

Demo URL: https://whisper-notes.shivanshs9.me/

It's a journal app to write notes on-the-go. Using the latest Whisper models for speech-recognition, right there in your browser, no audio date is sent to any server.
Supports WebGPU if your browser provides!

## Project Structure

1. [CI/CD with Github Workflows](.github/workflows/)
2. [Backend gRPC API](./backend/)
3. [React Frontend](./frontend/)
4. [IAC with Pulumi](./iac/pulumi-gcp/)
5. [Service K8s manifests](./iac/services/)
6. [Notes ProtoBuf contract used in API](./protos/)

## Tech Stack Considerations

1. Using gRPC as the underlying protocol between frontend and backend, for low latency and faster development with guaranteed service contracts.
1. Using Pulumi as Infra-as-Code provider, it supports all GCP resources like Terraform along with Kube providers like Helm, Kustomize and custom manifests. Plus the YAML language support is really powerful when combined with JsonNet like I did!
1. Create a [K8s cluster](iac/pulumi-gcp/lib/k8s/cluster.libsonnet) with
    - GCP Managed Prometheus enabled to store the metrics on the cloud. Saves the hassle of managing on-prem prometheus, plus can setup alerts or create dashboards using the metrics to ensure a reliable monitoring data source.
    - Gateway API for Ingress enabled, allows using HttpRoute resource to define Ingress routes. It feels more natural and mature than the ever-changing Ingress or Service resources.
    - Sending Logs to [GCP Logging Stack](https://cloud.google.com/logging/docs/view/logs-explorer-interface) (managed service).
1. Using GCP's Secret Manager for storing Postgres creds.
1. Cluster is using private subnet, all workloads are in private network and the communication between backend and postgres is TLS encrypted using private network.
1. Envoy proxy is used to expose gRPC-Web interface to the backend API, it also forwards the real client IP by detecting the Cloudflare headers.
1. GCP's Ingress ALB is configured to only listen to HTTPS, by using self-signed TLS certifcate, ensuring end-to-end traffic encryption.
