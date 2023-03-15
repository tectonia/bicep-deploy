param publicIPAddressName string 
param location string
param publicIPAddressNumber int

resource publicIPAddress 'Microsoft.Network/publicIPAddresses@2021-05-01' = [for i in range(0, publicIPAddressNumber): {
  name: '${publicIPAddressName}-${i}'
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
  }
}]
