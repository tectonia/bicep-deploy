param networkInterfaceName string
param IPConfigName string
param location string 
param virtualNetworkName string
param applicationGatewayName string
param publicIPAddressName string
param nsgName string
param vmNumber int

resource networkInterface 'Microsoft.Network/networkInterfaces@2021-05-01' = [for i in range(0, vmNumber): {
  name: '${networkInterfaceName}-${i + 1}'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: '${IPConfigName}-${i + 1}'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: resourceId('Microsoft.Network/publicIPAddresses', '${publicIPAddressName}-${i + 1}')
          }
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', virtualNetworkName, 'backendSubnet')
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
          applicationGatewayBackendAddressPools: [
            {
              id: resourceId('Microsoft.Network/applicationGateways/backendAddressPools', applicationGatewayName, 'backendPool')
            }
          ]
        }
      }
    ]
    enableAcceleratedNetworking: false
    enableIPForwarding: false
    networkSecurityGroup: {
      id: resourceId('Microsoft.Network/networkSecurityGroups', nsgName)
    }
  }
}]
