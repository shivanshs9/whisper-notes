local Utils = (import '../utils/config.libsonnet');
{
  Connection: {
    local this = self,
    Config:: Utils.Config,
    type: 'gcp:servicenetworking:Connection',
    network:: error 'Connection requires VPC network',
    service:: 'servicenetworking.googleapis.com',
    reservedPeeringRanges:: error 'Connection requires reservedPeeringRanges',
    properties: {
      network: this.network,
      service: this.service,
      reservedPeeringRanges: this.reservedPeeringRanges,
    },
  },
}
