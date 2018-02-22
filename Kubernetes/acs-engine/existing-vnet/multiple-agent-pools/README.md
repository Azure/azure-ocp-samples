# ACS-Engine Kubernetes 1.8 Existing VNet with Multiple Agent Pools

This example is designed to showcase creating a Virtual Network (with 3 Subnets) and then using ACS-engine to deploy a Kubernetes 1.8 cluster into the existing Vnet and subnets

# Prerequisites

* [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
* [ACS Engine](https://github.com/Azure/acs-engine/)

## Steps

These steps showcase an example walkthrough.  Additional steps might be required.

Create the Resource Group and deploy the Network ARM template into it

_In this case, I use the RG name:_ `acs-engine-vnet-agents`

```
export RESOURCE_GROUP=acs-engine-vnet-agents
export VNET_NAME=acs-engine-vnet-agents-vnet
export LOCATION=westus
export SUBSCRIPTION_ID=<YOUR SUBSCRIPTION HERE>
export API_MODEL=kubernetes1.8.json

# Create the RG
az group create -n $RESOURCE_GROUP -l $LOCATION

az network vnet create -g $RESOURCE_GROUP -n $VNET_NAME --address-prefixes 10.0.0.0/8
az network vnet subnet create -g $RESOURCE_GROUP --vnet-name $VNET_NAME -n mgmt --address-prefix 10.1.0.0/16
az network vnet subnet create -g $RESOURCE_GROUP --vnet-name $VNET_NAME -n pool1 --address-prefix 10.2.0.0/16
az network vnet subnet create -g $RESOURCE_GROUP --vnet-name $VNET_NAME -n pool2 --address-prefix 10.3.0.0/16

# Verify the subnets exist
az network vnet subnet list -g $RESOURCE_GROUP --vnet-name $VNET_NAME -o tsv
```

* Edit the kubernetes json file to meet your requirements

```
# Edit kubernetes-hybrid.json to fill out the templates
acs-engine deploy --api-model $API_MODEL --subscription-id $SUBSCRIPTION_ID --location $LOCATION --resource-group $RESOURCE_GROUP

# Get the IP address of the K8S Master
K8S_MASTER=$(az network public-ip list -g $RESOURCE_GROUP | jq '.[0].ipAddress' -r)
echo $K8S_MASTER

# Log into the master
ssh $K8S_MASTER

# Validate the cluster is up
kubectl get nodes
kubectl cluster-info
```

## Cleanup

```
az group delete -n $RESOURCE_GROUP -y
```