local Utils = (import '../utils/config.libsonnet');
{
  Cluster: {
    local this = self,
    Config:: Utils.Config,
    type: 'gcp:container:Cluster',
    name:: error 'Cluster name is required',
    network:: error 'Network is required',
    privateCluster:: false,
    masterIpCidr:: error 'Set masterIpCidr for private clusters',
    subnet:: error 'Set subnet for clusters',
    properties: {
      name: 'gke-%s-%s-%s-%s' % [this.Config.Project, this.Config.Env, this.name, this.Config.ShortRegion],
      location: this.Config.Region,
      removeDefaultNodePool: true,
      network: this.network,
      subnetwork: this.subnet,
      description: 'GKE Cluster for %s in %s' % [this.Config.Project, this.Config.Env],
      initialNodeCount: 1,
      monitoringConfig: {
        enableComponents: ['SYSTEM_COMPONENTS', 'APISERVER'],
        managedPrometheus: {
          enabled: true,
        },
      },
      deletionProtection: false,
      [if this.privateCluster then 'privateClusterConfig']: {
        enablePrivateNodes: true,
        masterIpv4CidrBlock: this.masterIpCidr,
        // enablePrivateEndpoint: true,
      },
      gatewayApiConfig: {
        channel: 'CHANNEL_STANDARD',
      },
      workloadIdentityConfig: {
        workloadPool: '${gcp:project}.svc.id.goog',
      },
      resourceLabels: {
        project: this.Config.Project,
        env: this.Config.Env,
        region: this.Config.Region,
        pulumi: '${pulumi.project}',
      },
    },
  },
}
