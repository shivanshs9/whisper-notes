local Utils = (import '../utils/config.libsonnet');
{
  CreateDockerRepo(name, config):
    local repoName = 'repo_%s' % name;
    {
      [repoName]: (import './repo.libsonnet').DockerRepository {
        Config: config,
        name: name,
      },
    },
}
