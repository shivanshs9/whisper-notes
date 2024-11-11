local Utils = (import '../utils/config.libsonnet');
{
  local secName = 'top+%s' % self.name,
  CreateSecretData(name, data, config):
    local secName = 'sec_%s' % name;
    local secVersionName = 'secVersion_%s' % name;
    {
      [secName]: (import './secret.libsonnet').Secret {
        Config: config,
        name: name,
      },
      [secVersionName]: (import './secret.libsonnet').SecretVersion {
        Config: config,
        secret: '${%s.id}' % secName,
        data: data,
      },
    },
}
