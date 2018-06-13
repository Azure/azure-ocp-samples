#Login to Azure account
Login-AzureRmAccount

#List all subscripotions
Get-AzureRmSubscription

#Set current subscrioption
Set-AzureRmContext -SubscriptionName <yourSubNameNere>
#OR
Set-AzureRmContext -SubscriptionID <yourSubIdHere>

##Create Resource Group##

#https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-template-deploy

New-AzureRmResourceGroup -Name iac-rg -Location eastus2

##DEPLOY CHALLENGE FOUR##

 New-AzureRmResourceGroupDeployment -Name Challenge4Deployment -ResourceGroupName iac-rg `
 -TemplateFile challenge-04-windows-vm.json `
 -TemplateParameterFile .\challenge-04.parameters.json

 ##DEPLOY CHALLENGE FIVE##

 New-AzureRmResourceGroupDeployment -Name Challenge5Deployment -ResourceGroupName iac-rg `
 -TemplateFile challenge-05-simple-dsc.json `
 -TemplateParameterFile .\challenge-05.parameters.json


##DEPLOY CHALLENGE SIX##

 New-AzureRmResourceGroupDeployment -Name Challenge6Deployment -ResourceGroupName iac-rg `
 -TemplateFile challenge-06-file-server-dsc.json `
 -TemplateParameterFile .\challenge-06.parameters.json


