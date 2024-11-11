local Utils = (import '../utils/config.libsonnet');
{
  Vpc: {
    local this = self,
    Config:: Utils.Config,
    type: 'gcp:compute:Network',
    name:: error 'Vpc name is required',
    properties: {
      name: 'vpc-%s-%s-%s' % [this.Config.Project, this.Config.Env, this.name],
      autoCreateSubnetworks: false,
      description: 'VPC network for the %s' % (this.Config.Project),
    },
  },
}
