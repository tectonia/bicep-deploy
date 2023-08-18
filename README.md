# Bicep infrastructure deployment using GitHub Actions
This repository contains an Azure Bicep file (main.bicep) that deploys the following resources:

- Network Security Group: A common set of security rules that must be applied to each NSG.
- Public IP Addresses: A set of public IP addresses to be created.
- Virtual Network: A virtual network to be created with a specified address prefix and subnet address prefix.
- Virtual Machines: A set of virtual machines to be deployed.
- Application Gateway: An application gateway to be created.
- Network Interfaces: A network interface to be created with an IP config.

The deployment is parameterized to allow for customization of the environment type, admin credentials, and other settings. The resources are deployed in a modular fashion using separate Bicep modules for each resource type.

![image](https://github.com/tectonia/bicep-deploy/assets/61530975/f3b22f86-838a-4b4e-aa77-f40ce9e9e95e)

### Prerequisites
To deploy:
- An Azure Subscription: [Free Account](https://azure.microsoft.com/en-gb/free/search/)

To edit code locally:
- Visual Studio Code: [Download](https://code.visualstudio.com/download)
- Azure CLI: [Download](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-windows?tabs=azure-cli#install-or-update)
- The Bicep extension for Visual Studio Code: [Download](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-bicep)
