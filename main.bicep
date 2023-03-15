@description('Admin username for the backend servers')
param adminUsername string
@description('Password for the admin account on the backend servers')
@secure()
param adminPassword string

@description('Location for all resources.')
param location string = resourceGroup().location

@description('The environment to deploy to')
@allowed([
  'dev'
  'test'
  'prod'
])
param environmentType string

@description('The resource prefixes shared in the organization')
var sharedNamePrefixes = loadJsonContent('./shared-prefixes.json')

// Network security group
@description('The common set of security rules that must be applied to each NSG')
var sharedRules = loadJsonContent('./shared-rules.json', 'securityRules')
@description('The application-specific set of security rules to be added to the NSG')
param customRules array 
@description('The name for the network security groups to be created')
var nsgName = '${sharedNamePrefixes.networkSecurityGroupPrefix}-${environmentType}-${uniqueString(resourceGroup().id)}'

// Public IP addresses
@description('The name for the public IP addresses to be created')
var publicIPAddressName = '${sharedNamePrefixes.publicIPAddressPrefix}-${environmentType}-${uniqueString(resourceGroup().id)}'
@description('The number of public IP addresses to be created')
param publicIPAddressNumber int

// Virtual network
@description('The name for the virtual network to be created')
var virtualNetworkName = '${sharedNamePrefixes.virtualNetworkPrefix}-${environmentType}-${uniqueString(resourceGroup().id)}'
@description('The virtual network address prefix')
param virtualNetworkAddressPrefix string 
@description('The subnet address prefix')
param subnetAddressPrefix string 
@description('The backend subnet address prefix')
param backendSubnetAddressPrefix string 

// Virtual machines
@description('The name for the virtual machines to be created')
var virtualMachineName = take('${sharedNamePrefixes.virtualMachinePrefix}-${environmentType}-${uniqueString(resourceGroup().id)}', 12)
@description('The number of virtual machines to be deployed')
param vmNumber int

// Application gateway
@description('The name for the application gateway to be created')
var applicationGatewayName = '${sharedNamePrefixes.applicationGatewayPrefix}-${environmentType}-${uniqueString(resourceGroup().id)}'

// Network interfaces
@description('The name for the network interface to be created')
var networkInterfaceName = '${sharedNamePrefixes.networkInterfacePrefix}-${environmentType}-${uniqueString(resourceGroup().id)}'
@description('The IP config for the network interface')
param IPConfigName string = 'IPConfig'

var environmentConfigurationMap = {
  dev: {
    virtualMachine: {
      vmSize: 'Standard_B2ms'
    }
  }
  prod: {
    virtualMachine: {
      vmSize: 'Standard_B4ms'
    }
  }
  test: {
    virtualMachine: {
      vmSize: 'Standard_B4ms'
    }
  }
}

module networkSecurityGroup 'modules/networkSecurityGroup.bicep' = {
  name: 'networkSecurityGroupDeploy'
  params:{
    nsgName: nsgName
    location: location
    sharedRules: sharedRules
    customRules: customRules
  }
}

module publicIPAddress 'modules/publicIPAddress.bicep' = {
  name: 'publicIPDeploy'
  params:{
    publicIPAddressName: publicIPAddressName
    location: location
    publicIPAddressNumber: publicIPAddressNumber
  }
}

module virtualNetwork 'modules/virtualNetwork.bicep' = {
  name: 'virtualNetworkDeploy'
  params:{
    virtualNetworkName: virtualNetworkName
    virtualNetworkPrefix: virtualNetworkAddressPrefix
    subnetPrefix: subnetAddressPrefix
    backendSubnetPrefix: backendSubnetAddressPrefix
    location: location
  }
}


module virtualMachine 'modules/virtualMachine.bicep' = {
  name: 'virtualMachineDeploy'
  params: {
    virtualMachineName: virtualMachineName
    location: location
    vmSize: environmentConfigurationMap[environmentType].virtualMachine.vmSize
    vmNumber: vmNumber
    networkInterfaceName: networkInterfaceName
    adminPassword: adminPassword
    adminUsername: adminUsername
  }
  dependsOn: [
    networkInterface
  ]
}

module applicationGateway 'modules/applicationGateway.bicep' = {
  name: 'appGatewayDeploy'
  params: {
    applicationGatewayName: applicationGatewayName
    location: location
    virtualNetworkName: virtualNetworkName
    publicIPAddressName: publicIPAddressName
  }
  dependsOn: [
    virtualNetwork
    publicIPAddress
  ]
}

module networkInterface 'modules/networkInterface.bicep' = {
  name: 'networkInterfaceDeploy'
  params:{
    networkInterfaceName: networkInterfaceName
    location: location
    applicationGatewayName: applicationGatewayName
    nsgName: nsgName
    publicIPAddressName: publicIPAddressName
    virtualNetworkName: virtualNetworkName
    IPConfigName: IPConfigName
    vmNumber: vmNumber
  }
  dependsOn: [
    publicIPAddress
    applicationGateway
    networkSecurityGroup
  ]
}

module storageAccount 'modules/storageAccountInsecure.bicep' = {
  name: 'storageAccountInsecureDeploy'
  params: {
    storageAccountName: 'storageaccountinsecure2324${environmentType}'
    location: location
  }
}
