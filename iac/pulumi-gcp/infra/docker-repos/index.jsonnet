local artifactRegistry = (import '../../lib/registry/index.libsonnet');
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
  resources: artifactRegistry.CreateDockerRepo('services', $.Config) + {
    saGithubActions: (import '../../lib/iam/serviceaccount.libsonnet').ServiceAccount {
      saType: 'github-ci-repo',
      Config: $.Config,
    },
    saGithubActionsPush: (import '../../lib/iam/serviceaccount.libsonnet').RoleBinding {
      serviceAccount: '${saGithubActions.email}',
      role: 'roles/artifactregistry.repoAdmin',
    },
  },
  outputs: {
    saGithubActionsEmail: '${saGithubActions.email}',
  },
}
