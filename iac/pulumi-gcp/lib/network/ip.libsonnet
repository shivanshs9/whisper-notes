local Utils = (import '../utils/config.libsonnet');
{
  GlobalAddress: {
    local this = self,
    Config:: Utils.Config,
    type: 'gcp:compute:GlobalAddress',
    name:: error 'GlobalAddress requires name',
    network:: error 'GlobalAddress requires VPC network',
    purpose:: error 'GlobalAddress requires purpose',
    addressType:: error 'GlobalAddress requires addressType',
    prefixLength:: error 'GlobalAddress requires prefixLength',
    properties: {
      name: 'ip-%s-%s-%s-%s' % [this.Config.Project, this.Config.Env, this.name, this.Config.ShortRegion],
      network: this.network,
      purpose: this.purpose,
      addressType: this.addressType,
      prefixLength: this.prefixLength,
    },
  },
}
