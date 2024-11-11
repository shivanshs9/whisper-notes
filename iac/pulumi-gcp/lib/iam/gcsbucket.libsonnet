local Utils = (import '../utils/config.libsonnet');
{
  BucketRoleBinding: {
    local this = self,
    Config:: Utils.Config,
    type: 'gcp:storage:BucketIAMMember',
    bucket:: error 'Bucket name must be set',
    role:: error 'Role must be set',
    serviceAccount:: error 'ServiceAccount must be set',
    properties: {
      bucket: this.bucket,
      role: this.role,
      member: 'serviceAccount:%s' % this.serviceAccount,
    },
  },
}
