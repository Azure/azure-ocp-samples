
## Use Terraform to create a Linux VM in Azure from a Packer Custom Image with NGINX installed

Terraform is a tool (templating language) for building, changing, and versioning infrastructure safely and efficiently. Using Terraform, you can automate the tasks of building, changing and de-provisioning(destroy)the infrastructure

## Steps

### Install Terraform and configure it to access Azure

Installation instructions can be found at the following URLs

https://docs.microsoft.com/en-us/azure/virtual-machines/linux/terraform-install-configure


### Create SSH Key

Generate an SSH key pair. You can find a detailed instructions on how to create an SSH key pair at the URL below. 

https://docs.microsoft.com/en-us/azure/virtual-machines/linux/create-ssh-keys-detailed

## Create Service Principal

`az ad sp create-for-rbac`

### Install Packer

Installation instructions can be found at the following URL

https://www.packer.io/docs/install/index.html

### Use Packer to Create an Ubuntu image with NGINX installed

In the packer template (vmNGINX_Packer.json) , update the azure service principal credentails (client_id, client_secret, and tenant_id) and azure subscription_id

Build the packer image using the following command. This will create an azure custom image in the resource group defined in the template

`packer build vmNGINX_Packer.json`

### Build and Deploy the VM using the Terraform Template

Terraform Template files:
    
    variables.tf 
    (This file contains values of the variables used in the template)
    
    linuxVM.tf  
    (This file contains the code of the infrastructure that you are deploying)

    output.tf
    (This file contains settings that needs to be displayed after the deployment)

Initialize Terraform 

`terraform init`

Validate the template 

`terraform plan`

if the validation is successful, apply the template

`terraform apply`

To clean up the environment created, use the following command

`terraform destroy`


## References

### Terraform Azure RM Provider

https://www.terraform.io/docs/providers/azurerm/


### Terraform on Azure Documentation

https://docs.microsoft.com/en-us/azure/terraform/





