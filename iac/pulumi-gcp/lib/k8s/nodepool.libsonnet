local Utils = (import '../utils/config.libsonnet');
{
  NodePool: {
    local this = self,
    Config:: Utils.Config,
    type: 'gcp:container:NodePool',
    name:: error 'Node pool name is required',
    cluster:: error 'Cluster name for node pool is required',
    serviceAccount:: error 'Service account is required',
    machineType:: error 'Machine type is required',
    minNodes:: error 'Minimum number of nodes is required',
    maxNodes:: error 'Maximum number of nodes is required',
    taints:: [],
    labels:: {},
    properties: {
      name: 'gke-%s-%s-%s-%s' % [this.Config.Project, this.Config.Env, this.name, this.Config.ShortRegion],
      location: this.Config.Region,
      cluster: this.cluster,
      autoscaling: {
        minNodeCount: this.minNodes,
        maxNodeCount: this.maxNodes,
      },
      nodeConfig: {
        machineType: this.machineType,
        diskType: 'pd-balanced',
        diskSizeGb: 20,
        taints: this.taints,
        // preemptible: true,
        serviceAccount: this.serviceAccount,
        oauthScopes: [
          'https://www.googleapis.com/auth/cloud-platform',
        ],
        labels: {
          name: this.name,
          env: this.Config.Env,
          project: this.Config.Project,
          region: this.Config.Region,
          pulumi: '${pulumi.project}',
        } + this.labels,
      },
      networkConfig: {
        enablePrivateNodes: true,
      },
    },
  },
}
