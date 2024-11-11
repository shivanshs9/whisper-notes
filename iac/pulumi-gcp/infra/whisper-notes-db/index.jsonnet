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
    'gcp:project': {
      type: 'String',
    },
  },
  variables: {
    secDataWhisperDbCreds: {
      'fn::toJSON': {
        POSTGRES_USER: '${DbRWUser.name}',
        POSTGRES_PASSWORD: '${DbUserPassword.result}',
        POSTGRES_NAME: 'whisper',
        POSTGRES_HOST: '${DbInstance.privateIpAddress}',
        POSTGRES_PORT: '5432',
      },
    },
  },
  resources: {
    refNetwork: {
      type: 'pulumi:pulumi:StackReference',
      properties: {
        name: 'organization/init-network-k8s/${pulumi.stack}',
      },
    },
    # Needed for CloudSQL Private connection
    # https://cloud.google.com/sql/docs/mysql/private-ip#network_requirements
    DbPrivateIpRange: (import '../../lib/network/ip.libsonnet').GlobalAddress {
      Config: $.Config,
      name: 'whisper-db',
      network: '${refNetwork.outputs["networkId"]}',
      purpose: 'VPC_PEERING',
      addressType: 'INTERNAL',
      prefixLength: 20,
    },
    DbPrivateVpcConnection: (import '../../lib/network/peering.libsonnet').Connection {
      Config: $.Config,
      network: '${refNetwork.outputs["networkId"]}',
      reservedPeeringRanges: [
        '${DbPrivateIpRange.name}',
      ],
    },
    DbInstance: (import '../../lib/sql/postgres.libsonnet').Database {
      Config: $.Config,
      privateNetwork: '${refNetwork.outputs["networkId"]}',
      name: 'whisper-notes',
      options: {
        dependsOn: [
          '${DbPrivateVpcConnection}',
        ],
      },
    },
    PgDbWhisper: (import '../../lib/sql/postgres.libsonnet').SqlDB {
      database: 'whisper',
      instance: '${DbInstance.name}',
    },
    DbUserPassword: {
      type: 'random:RandomPassword',
      properties: {
        length: 16,
        special: true,
        overrideSpecial: '!#$%&*()-_=+[]{}<>:?',
      },
    },
    DbRWUser: (import '../../lib/sql/postgres.libsonnet').SqlUser {
      name: 'whisper',
      instance: '${DbInstance.name}',
      password: '${DbUserPassword.result}',
    },
  } + (import '../../lib/secrets/index.libsonnet').CreateSecretData('service-whisper-notes-db', '${secDataWhisperDbCreds}', $.Config),
  outputs: {
    dbEndpoint: '${DbInstance.privateIpAddress}',
    dbConnectionString: '${DbInstance.connectionName}',
    dbUser: '${DbRWUser.name}',
    dbPassword: '${DbUserPassword.result}',
  },
}
