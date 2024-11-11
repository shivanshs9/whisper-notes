local Utils = (import '../utils/config.libsonnet');
{
  Secret: {
    local this = self,
    Config:: Utils.Config,
    type: 'gcp:secretmanager:Secret',
    name:: error 'Secret name must be set',
    properties: {
      secretId: '%s-%s-%s' % [this.Config.Project, this.Config.Env, this.name],
      replication: {
        auto: {},
      },
      labels: {
        project: this.Config.Project,
        env: this.Config.Env,
        pulumi: '${pulumi.project}',
      },
    },
  },
  SecretVersion: {
    local this = self,
    Config:: Utils.Config,
    type: 'gcp:secretmanager:SecretVersion',
    secret:: error 'Secret must be set',
    data:: error 'Secret data must be set',
    properties: {
      secret: this.secret,
      secretData: this.data,
    },
  },
}
