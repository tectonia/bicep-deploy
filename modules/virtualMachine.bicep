param virtualMachineName string
param location string 
param vmSize string 
param vmNumber int
@secure()
param adminUsername string
@secure() 
param adminPassword string
param networkInterfaceName string

resource virtualMachine 'Microsoft.Compute/virtualMachines@2021-11-01' = [for i in range(0, vmNumber): {
  name: '${virtualMachineName}-${i + 1}'
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2016-Datacenter'
        version: 'latest'
      }
      osDisk: {
        osType: 'Windows'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          storageAccountType: 'StandardSSD_LRS'
        }
        diskSizeGB: 127
      }
    }
    osProfile: {
      computerName: '${virtualMachineName}-${i + 1}'
      adminUsername: adminUsername
      adminPassword: adminPassword
      windowsConfiguration: {
        provisionVMAgent: true
        enableAutomaticUpdates: true
      }
      allowExtensionOperations: true
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: resourceId('Microsoft.Network/networkInterfaces', '${networkInterfaceName}-${i + 1}')
        }
      ]
    }
  }
}]
