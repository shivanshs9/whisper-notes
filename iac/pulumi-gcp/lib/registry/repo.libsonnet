local Utils = (import '../utils/config.libsonnet');
{
  DockerRepository: {
    local this = self,
    Config:: Utils.Config,
    type: 'gcp:artifactregistry:Repository',
    name:: error 'Repo name is required',
    properties: {
      location: this.Config.Region,
      repositoryId: this.name,
      description: 'Docker repo for %s' % this.name,
      format: 'DOCKER',
      dockerConfig: {
        immutableTags: true,
      },
      labels: {
        name: this.name,
        env: this.Config.Env,
        project: this.Config.Project,
        region: this.Config.Region,
        pulumi: '${pulumi.project}',
      },
      cleanupPolicyDryRun: false,
      cleanupPolicies: [
        {
          id: 'keep-last-50',
          action: 'KEEP',
          mostRecentVersions: {
            keepCount: 50,
          },
        },
      ],
    },
  },
}
