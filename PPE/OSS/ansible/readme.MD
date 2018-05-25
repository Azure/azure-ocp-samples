## Ansible on Azure

Ansible is an open-source product that automates cloud provisioning, configuration management, and application deployments. Using Ansible you can provision virtual machines, containers, and network and other cloud infrastructure components. In addition, Ansible allows you to automate the deployment and configuration of resources in your environment.
Ansible is agent-less, which means that it does not require the installation of any software in the managed machines. Ansible uses SSH to manage Linux machines, and remote Powershell to manage Windows machines.

## Prerequisites

1. Azure Subscription
2. Azure CLI (Version 2.0.30 or later.)



## Steps

### Install and Configure Ansible 

One of the easiest ways to use Ansible with Azure is with the Azure Cloud Shell, a browser-based shell experience to manage and develop Azure resources. Ansible is pre-installed in the Cloud Shell.

#### Create an Ubuntu VM 

Steps:

1. Login to Azure from the terminal window
    
    az login

1. Create a resource group 

    az group create --name PPEansiblelab --location westus2

3. Create VM

az vm create \
    --name [prefix]VMAnsible \
    --resource-group PPEansiblelab \
    --image Canonical:UbuntuServer:16.04-LTS:latest \
    --admin-username azureuser \
    --generate-ssh-keys

Note: The above command creates a VM with user account 'azureuser' and generates SSH keys if they do not already exist in the default key location (~/.ssh). To use a specific SSH key use the --ssh-key-value option

1. Login to the VM and Install Ansible

ssh azureuser@<publicIpAddress>

sudo apt-get update && sudo apt-get install -y libssl-dev libffi-dev python-dev python-pip

pip install ansible[azure]


## Create Service Principal

In order for Ansible to login to Azure, we will need a service principal to be created. The outputs of the below commands provide you the credentails needed for Ansible configuration.

az ad sp create-for-rbac --query '{"client_id": appId, "secret": password, "tenant": tenant}'

Get Subscription Id:
az account show --query "{ subscription_id: id }"


## Create Ansible Credentails File

To provide credentials to Ansible, you define environment variables or create a local credentials file. Create a credentials file on the VM where you installed Ansible in a previous step:

mkdir ~/.azure
vi ~/.azure/credentials

Add the following values to the file and save it.

[default]
subscription_id=<subscriptionid>
client_id=<clientid>
secret=<secret>
tenant=<tenantid>


## Creating a CentOS Linux VM using Ansible

Now that we have configurated Ansible in host VM, we can use the ansible playbook to create a Linux VM. Create an Ansible Playbook named "LinuxVMCreate.yml". 

To Create the VM, run the playbook as follows:

ansible-playbook LinuxVMCreate.yml


## Configuring a Web Application using Ansible 

To Install Apache web server and configure a website, create the playbook  named "InstallApache.yml" and run the playbook as follows:

ansible-playbook InstallApache.yml

## References

### Create SSH Key

Generate an SSH key pair. You can find a detailed instructions on how to create an SSH key pair at the URL below. 

https://docs.microsoft.com/en-us/azure/virtual-machines/linux/create-ssh-keys-detailed

### Ansible Dynamic Inventory

Ansible can be used to pull inventory information from various sources into a dynamic inventory. 

https://docs.microsoft.com/en-us/azure/ansible/ansible-manage-azure-dynamic-inventories?toc=%2Fen-us%2Fazure%2Fansible%2Ftoc.json&bc=%2Fen-us%2Fazure%2Fbread%2Ftoc.json


