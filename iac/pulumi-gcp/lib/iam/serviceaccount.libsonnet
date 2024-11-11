local Utils = (import '../utils/config.libsonnet');
{
  ServiceAccount: {
    local this = self,
    Config:: Utils.Config,
    type: 'gcp:serviceaccount:Account',
    saType:: error 'ServiceAccount type must be set',
    properties: {
      accountId: '%s-%s-%s' % [this.saType, this.Config.Project, this.Config.Env],
      createIgnoreAlreadyExists: true,
      displayName: '%s Service Account for %s in %s' % [this.saType, this.Config.Project, this.Config.Env],
    },
  },
  RoleBinding: {
    local this = self,
    Config:: Utils.Config,
    type: 'gcp:projects:IAMMember',
    role:: error 'Role must be set',
    serviceAccount:: error 'ServiceAccount must be set',
    properties: {
      project: '${gcp:project}',
      role: this.role,
      member: 'serviceAccount:%s' % this.serviceAccount,
    },
  },
}
