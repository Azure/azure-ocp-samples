##SETUP##

#Install Azure CLI
#https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest

#Login and set Azure Subscription

az login

az account set --subscription "<SUBSCRIPTION_NAME>" 

#Create a resource group
az group create --name iac-rg --location eastus2

#Deploy templates to a resource group via Azure CLI
#https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-template-deploy-cli

##DEPLOY CHALLENGE FOUR##
az group deployment create --name Challenge4Deployment --resource-group iac-rg --template-file challenge-04-windows-vm.json --parameters @challenge-04.parameters.json

##DEPLOY CHALLENGE FIVE#
az group deployment create --name Challenge5Deployment --resource-group iac-rg --template-file challenge-05-simple-dsc.json --parameters @challenge-05.parameters.json

##DEPLOY CHALLENGE SIX##
az group deployment create --name Challenge6Deployment --resource-group iac-rg --template-file challenge-06-file-server-dsc.json --parameters @challenge-06.parameters.json

