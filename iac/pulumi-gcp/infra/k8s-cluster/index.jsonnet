{
  Config:: {
    Project: '${project}',
    Env: '${pulumi.stack}',
    Region: '${region}',
    ShortRegion: '${shortRegion}',
    K8sVersion: 1.29,
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
    'gcp:project': {
      type: 'String',
    },
  },
  variables: {
    k8sVersion: {
      'fn::invoke': {
        'function': 'gcp:container:getEngineVersions',
        arguments: {
          location: '${region}',
          versionPrefix: $.Config.K8sVersion,
        },
      },
    },
    kubeConfig: {
      'fn::toJSON': import './template/kubeconfig.json',
    },
  },
  resources: {
    refNetwork: {
      type: 'pulumi:pulumi:StackReference',
      properties: {
        name: 'organization/init-network-k8s/${pulumi.stack}',
      },
    },
    k8sServiceAccount: (import '../../lib/iam/serviceaccount.libsonnet').ServiceAccount {
      saType: 'gke',
      Config: $.Config,
    },
    irsaSecretsSa: (import '../../lib/iam/serviceaccount.libsonnet').ServiceAccount {
      saType: 'irsa-secrets',
      Config: $.Config,
    },
    irsaSecretsBinding1: (import '../../lib/iam/serviceaccount.libsonnet').RoleBinding {
      serviceAccount: '${irsaSecretsSa.email}',
      role: 'roles/secretmanager.secretAccessor',
    },
    irsaSecretsBinding2: (import '../../lib/iam/serviceaccount.libsonnet').RoleBinding {
      serviceAccount: '${irsaSecretsSa.email}',
      role: 'roles/iam.serviceAccountTokenCreator',
    },
    irsaSecretsBinding3: (import '../../lib/iam/serviceaccount.libsonnet').RoleBinding {
      serviceAccount: '${irsaSecretsSa.email}',
      role: 'roles/secretmanager.viewer',
    },
    irsaSecretsSaBinding: (import '../../lib/iam/trust.libsonnet').AssumeMember {
      serviceAccountId: '${irsaSecretsSa.name}',
      member: 'serviceAccount:${gcp:project}.svc.id.goog[kube-system/irsa-external-secrets]',
      roleType: 'workload',
    },
    k8sMaster: (import '../../lib/k8s/cluster.libsonnet').Cluster {
      name: 'cluster',
      Config: $.Config,
      network: '${refNetwork.outputs["networkId"]}',
      privateCluster: true,
      masterIpCidr: '${ipPrefix}.64.0/28',
      subnet: '${refNetwork.outputs["subnetPrivWorkloadId"]}',
      properties+: {
        minMasterVersion: $.Config.K8sVersion,
      },
    },
    npDefault: (import '../../lib/k8s/nodepool.libsonnet').NodePool {
      name: 'default',
      Config: $.Config,
      cluster: '${k8sMaster.id}',
      serviceAccount: '${k8sServiceAccount.email}',
      machineType: 't2d-standard-2',
      minNodes: 1,
      maxNodes: 10,
      properties+: {
        version: '${k8sVersion.latestNodeVersion}',
      },
    },
    kubeProvider: {
      type: 'pulumi:providers:kubernetes',
      properties: {
        kubeconfig: '${kubeConfig}',
      },
    },
    kubeIrsaSecretsSA: {
      type: 'kubernetes:yaml/v2:ConfigGroup',
      properties: {
        objs: [
          import './template/irsa-secrets.json',
        ],
      },
      options: {
        provider: '${kubeProvider}',
      },
    },
    kubeExternalSecretsChart: {
      type: 'kubernetes:helm.sh/v4:Chart',
      properties: {
        name: 'secrets',
        chart: 'external-secrets',
        repositoryOpts: {
          repo: 'https://charts.external-secrets.io/',
        },
        version: '0.9.14',
        namespace: 'kube-system',
        values: {
          serviceAccount: {
            create: false,
            name: 'irsa-external-secrets',
          },
          podDisruptionBudget: {
            enabled: true,
            minAvailable: 1,
            priorityClassName: 'system-cluster-critical',
          },
        },
      },
      options: {
        provider: '${kubeProvider}',
      }
    },
    kubeSecretsStore: {
      type: 'kubernetes:yaml/v2:ConfigGroup',
      properties: {
        objs: [
          import './template/secret-store.json',
        ],
      },
      options: {
        provider: '${kubeProvider}',
        dependsOn: [
          '${kubeExternalSecretsChart}'
        ]
      },
    },
  },
  outputs: {
    k8sEndpoint: '${k8sMaster.endpoint}',
    kubeConfig: '${kubeConfig}',
    k8sVersion: '${k8sMaster.masterVersion}',
  },
}
