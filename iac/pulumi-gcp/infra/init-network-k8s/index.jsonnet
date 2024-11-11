{
  Config:: {
    Project: '${project}',
    Env: '${pulumi.stack}',
    Region: '${region}',
    ShortRegion: '${shortRegion}',
  },
  configuration: {
    project: {
      type: 'String',
    },
    region: {
      type: 'String',
    },
    shortRegion: {
      type: 'String',
    },
    ipPrefix: {
      type: 'String',
    },
  },
  resources: {
    vpc: (import '../../lib/network/vpc.libsonnet').Vpc {
      name: 'main',
      Config: $.Config,
    },
    subnetPrivWorkload: (import '../../lib/network/subnet.libsonnet').Subnet {
      name: 'priv-workload',
      network: '${vpc.id}',
      ipCidrRange: '${ipPrefix}.0.0/18',
      Config: $.Config,
    },
    subnetPrivK8sMaster: (import '../../lib/network/subnet.libsonnet').Subnet {
      name: 'priv-k8s-master',
      network: '${vpc.id}',
      ipCidrRange: '${ipPrefix}.64.0/28',
      Config: $.Config,
    },
    router: (import '../../lib/network/nat.libsonnet').Router {
      name: 'main',
      network: '${vpc.id}',
      Config: $.Config,
    },
    nat: (import '../../lib/network/nat.libsonnet').Nat {
      name: 'main',
      router: '${router.name}',
      Config: $.Config,
    },
  },
  outputs: {
    networkId: '${vpc.id}',
    subnetPrivWorkloadId: '${subnetPrivWorkload.id}',
    routerId: '${router.id}',
    natId: '${nat.id}',
  },
}
