# ACS-Engine Kubernetes 1.8 Existing VNet with Multiple Agent Pools

This example is designed to showcase creating a Virtual Network (with 3 Subnets) and then using ACS-engine to deploy a Kubernetes 1.8 cluster into the existing Vnet and subnets

# Prerequisites

* [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
* [ACS Engine](https://github.com/Azure/acs-engine/)

## Steps

These steps showcase an example walkthrough.  Additional steps might be required.

Create the Resource Group and deploy the Network ARM template into it

_In this case, I use the RG name:_ `acs-engine-vnet-agents`

```shell
export SUBSCRIPTION_ID=
export CLIENT_ID=
export CLIENT_SECRET=

export BASE_NAME=${BASE_NAME:=acs-engine-multi-pool}
export RESOURCE_GROUP=${RESOURCE_GROUP:=$BASE_NAME-rg}
export VNET_NAME=${VNET_NAME:=$BASE_NAME-vnet}
export VNET_CIDR=${VNET_CIDR:=10.0.0.0/8}
export NETWORK_RESOURCE_GROUP=${NETWORK_RESOURCE_GROUP:=$RESOURCE_GROUP}
export LOCATION=${LOCATION:=westus}
export SRC_API_MODEL=${SRC_API_MODEL:=kubernetes1.8.json}
export DEST_API_MODEL=${DEST_API_MODEL:=kubernetes.json}
export DNS_PREFIX=${DNS_PREFIX:=$RESOURCE_GROUP-master}
export MGMT_SUBNET_NAME=${MGMT_SUBNET_NAME:=mgmt}
export POOL1_SUBNET_NAME=${POOL1_SUBNET_NAME:=pool1}
export POOL2_SUBNET_NAME=${POOL2_SUBNET_NAME:=pool2}
export SSH_PUBLIC_KEY=${SSH_PUBLIC_KEY:=$(cat ~/.ssh/id_rsa.pub)}
export FIRST_CONSECUTIVE_STATIC_IP=${FIRST_CONSECUTIVE_STATIC_IP:=10.1.0.8}

# Create the RG
az group create -n $RESOURCE_GROUP -l $LOCATION

az network vnet create -g $NETWORK_RESOURCE_GROUP -n $VNET_NAME --address-prefixes $VNET_CIDR
az network vnet subnet create -g $NETWORK_RESOURCE_GROUP --vnet-name $VNET_NAME -n mgmt --address-prefix 10.1.0.0/16
az network vnet subnet create -g $NETWORK_RESOURCE_GROUP --vnet-name $VNET_NAME -n pool1 --address-prefix 10.2.0.0/16
az network vnet subnet create -g $NETWORK_RESOURCE_GROUP --vnet-name $VNET_NAME -n pool2 --address-prefix 10.3.0.0/16

# Verify the subnets exist
az network vnet subnet list -g $NETWORK_RESOURCE_GROUP --vnet-name $VNET_NAME -o tsv
```

* Edit the kubernetes json file to meet your requirements

```shell
cp $SRC_API_MODEL $DEST_API_MODEL
sed -i '' "s/DNS_PREFIX/$DNS_PREFIX/g" $DEST_API_MODEL
sed -i '' "s/SUBSCRIPTION_ID/$SUBSCRIPTION_ID/g" $DEST_API_MODEL
sed -i '' "s/NETWORK_RESOURCE_GROUP/$NETWORK_RESOURCE_GROUP/g" $DEST_API_MODEL
sed -i '' "s/VNET_NAME/$VNET_NAME/g" $DEST_API_MODEL
# Need to change up due to special characters in ssh keys
sed -i '' "s:VNET_CIDR:$VNET_CIDR:g" $DEST_API_MODEL
sed -i '' "s/MGMT_SUBNET_NAME/$MGMT_SUBNET_NAME/g" $DEST_API_MODEL
sed -i '' "s/POOL1_SUBNET_NAME/$POOL1_SUBNET_NAME/g" $DEST_API_MODEL
sed -i '' "s/POOL2_SUBNET_NAME/$POOL2_SUBNET_NAME/g" $DEST_API_MODEL
# Need to change up due to special characters in ssh keys
sed -i '' "s:SSH_PUBLIC_KEY:$SSH_PUBLIC_KEY:g" $DEST_API_MODEL
sed -i '' "s/CLIENT_ID/$CLIENT_ID/g" $DEST_API_MODEL
sed -i '' "s/CLIENT_SECRET/$CLIENT_SECRET/g" $DEST_API_MODEL
sed -i '' "s/ADMIN_USERNAME/$USER/g" $DEST_API_MODEL
sed -i '' "s/FIRST_CONSECUTIVE_STATIC_IP/$FIRST_CONSECUTIVE_STATIC_IP/g" $DEST_API_MODEL

# Edit kubernetes-hybrid.json to fill out the templates
acs-engine deploy --api-model $DEST_API_MODEL --subscription-id $SUBSCRIPTION_ID --location $LOCATION --resource-group $RESOURCE_GROUP

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
