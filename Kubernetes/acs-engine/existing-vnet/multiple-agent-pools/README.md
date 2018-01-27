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
# Create the RG
az group create -n acs-engine-vnet-agents -l southcentralus

# Deploy the network.json ARM template.  Some customization might be necessary
az group deployment create -g acs-engine-vnet-agents --template-file network.json

# Verify the subnets exist
az network vnet subnet list -g acs-engine-vnet-agents  --vnet-name acs-engine-hybrid-vnet
```

* Deploy K8S using ACS-engine into the RG

```
# Edit kubernetes-hybrid.json to fill out the templates
acs-engine deploy --api-model kubernetes-hybrid.json --subscription-id <SUBSCRIPTION_ID> --location southcentralus --resource-group acs-engine-vnet-agents

# Get the IP address of the K8S Master
K8S_MASTER=$(az network public-ip list -g acs-engine-vnet-agents | jq '.[0].ipAddress' -r)

# Log into the master
ssh $K8S_MASTER

# Validate the cluster is up
kubectl get nodes
kubectl cluster-info
```
