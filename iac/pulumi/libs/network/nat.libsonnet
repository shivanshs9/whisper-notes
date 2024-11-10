local Utils = (import '../utils/config.libsonnet');
{
  Router: {
    local this = self,
    Config:: Utils.Config,
    type: 'gcp:compute:Router',
    name:: error 'Router name is required',
    network:: error 'Router requires VPC network',
    properties: {
      name: 'router-%s-%s-%s-%s' % [this.Config.Project, this.Config.Env, this.name, this.Config.ShortRegion],
      region: this.Config.Region,
      network: this.network,
      bgp: {
        asn: 64569,
      },
    },
  },
  Nat: {
    local this = self,
    Config:: Utils.Config,
    name:: error 'NAT name is required',
    type: 'gcp:compute:RouterNat',
    router:: error 'NAT requires router',
    subnets:: [],
    properties: {
      name: 'nat-%s-%s-%s-%s' % [this.Config.Project, this.Config.Env, this.name, this.Config.ShortRegion],
      region: this.Config.Region,
      router: this.router,
      natIpAllocateOption: 'AUTO_ONLY',
      sourceSubnetworkIpRangesToNat: if std.length(this.subnets) > 0 then 'LIST_OF_SUBNETWORKS' else 'ALL_SUBNETWORKS_ALL_IP_RANGES',
      logConfig: {
        enable: true,
        filter: 'ERRORS_ONLY',
      },
      subnetworks: [
        {
          name: subnet,
          sourceIpRangesToNats: ['ALL_IP_RANGES'],
        }
        for subnet in this.subnets
      ],
    },
  },
}
