local Utils = (import '../utils/config.libsonnet');
{
  Database: {
    local this = self,
    Config:: Utils.Config,
    type: 'gcp:sql:DatabaseInstance',
    privateNetwork:: '',
    tier:: 'db-g1-small',
    name:: error 'DB Instance name must be set',
    settings:: {},
    properties: {
      name: 'pgsql-%s-%s-%s-%s' % [this.Config.Project, this.Config.Env, this.name, this.Config.ShortRegion],
      region: this.Config.Region,
      databaseVersion: 'POSTGRES_15',
      deletionProtection: true,
      settings: {
        tier: this.tier,
        availabilityType: 'REGIONAL',
        diskSize: 20,
        ipConfiguration: {
          [if this.privateNetwork != '' then 'privateNetwork']: this.privateNetwork,
          [if this.privateNetwork != '' then 'enablePrivatePathForGoogleCloudServices']: true,
          [if this.privateNetwork == '' then 'ipv4Enabled']: true,
          sslMode: 'ENCRYPTED_ONLY',
        },
        backupConfiguration: {
          enabled: true,
          backupRetentionSettings: {
            retentionUnit: 'COUNT',
            retainedBackups: 7,
          },
          pointInTimeRecoveryEnabled: true,
        },
        userLabels: {
          project: this.Config.Project,
          env: this.Config.Env,
          region: this.Config.Region,
          pulumi: '${pulumi.project}${pulumi.stack}',
        },
      } + this.settings,
    },
  },
  SqlDB: {
    local this = self,
    type: 'gcp:sql:Database',
    database:: error 'Database name must be set',
    instance:: error 'DB Instance must be set',
    properties: {
      instance: this.instance,
      name: this.database,
    },
  },
  SqlUser: {
    local this = self,
    type: 'gcp:sql:User',
    name:: error 'User name must be set',
    instance:: error 'DB Instance must be set',
    password:: error 'Password must be set',
    properties: {
      instance: this.instance,
      name: this.name,
      password: this.password,
    },
  },
}
