param nsgName string
param location string 
param sharedRules array
param customRules array

resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2021-05-01' = {
  name: nsgName
  location: location
  properties: {
    securityRules: concat(sharedRules, customRules)
  }
}
