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
  resources: {
    refCluster: {
      type: 'pulumi:pulumi:StackReference',
      properties: {
        name: 'organization/k8s-cluster/${pulumi.stack}',
      },
    },
    kubeProvider: {
      type: 'pulumi:providers:kubernetes',
      properties: {
        kubeconfig: '${refCluster.outputs["kubeConfig"]}',
      },
    },
    toolCertManager: {
      type: 'kubernetes:kustomize/v2:Directory',
      properties: {
        directory: './certs',
      },
      options: {
        provider: '${kubeProvider}',
      }
    },
    toolMonitoring: {
      type: 'kubernetes:kustomize/v2:Directory',
      properties: {
        directory: './monitoring',
      },
      options: {
        provider: '${kubeProvider}',
      }
    },
    toolIngress: {
      type: 'kubernetes:kustomize/v2:Directory',
      properties: {
        directory: './ingress',
      },
      options: {
        provider: '${kubeProvider}',
      }
    },
  },
}
