local Utils = (import '../utils/config.libsonnet');
{
  Subnet: {
    local this = self,
    Config:: Utils.Config,
    type: 'gcp:compute:Subnetwork',
    name:: error 'Subnet name is required',
    network:: error 'Subnet requires VPC network',
    ipCidrRange:: error 'Subnet requires IP CIDR range',
    properties: {
      name: 'subnet-%s-%s-%s-%s' % [this.Config.Project, this.Config.Env, this.name, this.Config.ShortRegion],
      network: this.network,
      ipCidrRange: this.ipCidrRange,
      secondaryIpRanges: [],
      region: this.Config.Region,
      description: 'Subnet for the %s' % (this.Config.Project),
      privateIpGoogleAccess: true,
      purpose: 'PRIVATE',
    },
  },
}
