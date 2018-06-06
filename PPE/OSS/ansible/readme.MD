## Ansible on Azure

Ansible is an open-source product that automates cloud provisioning, configuration management, and application deployments. Using Ansible you can provision virtual machines, containers, and network and other cloud infrastructure components. In addition, Ansible allows you to automate the deployment and configuration of resources in your environment.
Ansible is agent-less, which means that it does not require the installation of any software in the managed machines. Ansible uses SSH to manage Linux machines, and remote Powershell to manage Windows machines.

## Prerequisites

1. Azure Subscription
2. Azure CLI (Version 2.0.30 or later.)

## Steps

### Install and Configure Ansible 

One of the easiest ways to use Ansible with Azure is with the Azure Cloud Shell, a browser-based shell experience to manage and develop Azure resources. Ansible is pre-installed in the Cloud Shell.

The other option is to create a provisioning server and install and configure Ansible on that server.

#### Create an Ubuntu VM to use as Provisioning Server

Steps:

1. Login to Azure from the terminal window
    
    ``` 
    az login
    ```

1. Create a resource group 

```
    az group create --name PPEansiblelab --location westus2
```
3. Create VM

```
az vm create \
    --name [prefix]VMAnsible \
    --resource-group PPEansiblelab \
    --image Canonical:UbuntuServer:16.04-LTS:latest \
    --admin-username azureuser \
    --generate-ssh-keys
```
Note: The above command creates a VM with user account 'azureuser' and generates SSH keys if they do not already exist in the default key location (~/.ssh). To use a specific SSH key use the --ssh-key-value option

1. Login to the VM and Install Ansible

```
ssh azureuser@< public ip address>
```

```
sudo apt-get update && sudo apt-get install -y libssl-dev libffi-dev python-dev python-pip

pip install ansible[azure]

```
## Create Service Principal

In order for Ansible to login to Azure, we will need a service principal to be created. The outputs of the below commands provide you the credentails needed for Ansible configuration.

```
az ad sp create-for-rbac --query '{"client_id": appId, "secret": password, "tenant": tenant}'

#Get Subscription Id:
az account show --query "{ subscription_id: id }"
```

## Create Ansible Credentails File

To provide credentials to Ansible, you define environment variables or create a local credentials file. Create a credentials file on the VM where you installed Ansible in a previous step:

```
mkdir ~/.azure
vi ~/.azure/credentials

```
Add the following values to the file and save it.

```
[default]
subscription_id=<subscriptionid>
client_id=<clientid>
secret=<secret>
tenant=<tenantid>

```
## Creating a CentOS Linux VM using Ansible

Now that we have configurated Ansible in host VM, we can use the ansible playbook to create a Linux VM. Create an Ansible Playbook named "LinuxVMCreate.yml". 

To Create the VM, run the playbook as follows:

```
ansible-playbook LinuxVMCreate.yml
```

## Ansible Dynamic Inventory on Azure

 Dynamic inventories help discover the machines that fulfill certain requirements such as existing in Azure, or belonging to a certain resource group, and makes Ansible execute operations on them.


Clone the Ansible repository. The azure_rm.py script is located in this repository

```
    git clone git://github.com/ansible/ansible.git --recursive

```
 
 Install jq ('jq' is a command-line JSON interpreter, that you can use here to make the JSON output readable)

```
    sudo apt-get install jq

```

 First, we will test that the dynamic inventory script is running, executing it with the parameter “--list”. This should show JSON text containing information about all the VMs in your resource group.

```
 python ./ansible/contrib/inventory/azure_rm.py --list | jq

```
 Now, we test the reachability using ansible function called "ping"

```
 ansible -i ./ansible/contrib/inventory/azure_rm.py all -m ping

```
Note: The first time you run the command you will have to acknowledge the host's authenticity, after that it should run automatically

Now, let's run a command inside all VMs in the resource group. In order to test this, create another VM in the resource group.

The command below "uname -a" returns some information about the machine where it is executed, such as the Kernel version, the date and time and the CPU architecture. You can see that it is executed on all the machines in the resource group.

```
 ansible -i ~/ansible/contrib/inventory/azure_rm.py all -m shell -a "/bin/uname -a"

```
 Use the inventory script below to print instance specific information

```
 ./ansible/contrib/inventory/azure_rm.py --host my_instance_host_name --resource-groups=Testing --pretty

```
 You can also run a playbook using the inventory script. 

Save the following playbook script to a file named "AzureInventory.yml"


``` 
  - name: Test the inventory script
  hosts: azure
  connection: local
  gather_facts: no
  tasks:
    - debug: msg="{{ inventory_hostname }} has powerstate {{ powerstate }}"
```

Execute the playbook using the following command

``` 

ansible-playbook -i ./ansible/contrib/inventory/azure_rm.py AzureInventory.yml

``` 
## Configuring a Web Application using Ansible 

To Install Apache web server and configure a website, create the playbook  named "InstallApache.yml" and run the playbook as follows:

```
ansible-playbook InstallApache.yml

```
## References

### Create SSH Key

Generate an SSH key pair. You can find a detailed instructions on how to create an SSH key pair at the URL below. 

https://docs.microsoft.com/en-us/azure/virtual-machines/linux/create-ssh-keys-detailed

### Install Azure CLI 2.0

https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest


### Use Ansible from Azure Cloud Shell

https://docs.microsoft.com/en-us/azure/ansible/ansible-run-playbook-in-cloudshell

### Ansible Dynamic Inventory example using Azure Cloud Shell

Ansible can be used to pull inventory information from various sources into a dynamic inventory. 

https://docs.microsoft.com/en-us/azure/ansible/ansible-manage-azure-dynamic-inventories?toc=%2Fen-us%2Fazure%2Fansible%2Ftoc.json&bc=%2Fen-us%2Fazure%2Fbread%2Ftoc.json

