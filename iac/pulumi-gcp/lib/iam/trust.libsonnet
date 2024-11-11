local Utils = (import '../utils/config.libsonnet');
{
  AssumeMember: {
    local this = self,
    Config:: Utils.Config,
    type: 'gcp:serviceaccount:IAMMember',
    serviceAccountId:: error 'ServiceAccount ID must be set',
    member:: error 'Member must be set that will assume the service account',
    roleType:: error 'Role type must be "serviceAccount" or "workload"',
    properties: {
      serviceAccountId: this.serviceAccountId,
      role: if (this.roleType == 'serviceAccount') then 'roles/iam.serviceAccountUser'
      else if (this.roleType == 'workload') then 'roles/iam.workloadIdentityUser'
      else error 'Role type must be "serviceAccount" or "workload"',
      member: this.member,
    },
  },
}
