# Prerequisite for Hackathon

This section lays out all the tools that are required for this hackathon.
* **Terminal**
* **Azure Subscription**
* **Azure CLI**
* [**VS Code**](https://code.visualstudio.com/)

## Note for Windows Users

While majority of the documentation should work fine locally on Windows, I would recommend using [Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/install-win10) for interacting with the Azure CLI.

Alternatively, you can use the [Azure Cloud Shell](https://shell.azure.com/bash). This is discussed shortly in the next section.

## Azure Sign Up

[Sign Up for Azure](https://azure.microsoft.com/en-us/free/)

Our goal is limit the cost of using Azure services. 

If you've never used Azure, you will get:
- $200 free credits for use for up to 30 days
- 12 months of popular free services  (includes storage, Linux VMs)
- Then there are services that are free up to a certain quota

Details can be found here on [free services](https://azure.microsoft.com/en-us/free/).

If you have used Azure before, we will still try to limit cost of services by suspending, shutting down services, or destroy services before end of the hackathon. You will still be able to use the free services (up to their quotas) like App Service, or Functions.

## Managing Cloud Resources

We can manage cloud resources via three separate ways:
- Web Interface/Dashboard
  - [Azure Portal](https://portal.azure.com/)
- CLI within Web Interface
  - [Azure Cloud Shell](https://shell.azure.com/bash)
- CLI
  - [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)

The CLI will be the preferred (and supported) approach for this event, so please install the Azure CLI locally or use the Azure Cloud Shell from the Azure Portal.

### Azure Portal

Build, manage, and monitor everything from simple web apps to complex cloud applications in a single, unified console.

Manage your resources via a web interface (i.e. GUI) at [https://portal.azure.com/](https://portal.azure.com/)

### Azure Cloud Shell

The Azure Cloud Shell is a free interactive shell that you can use to run the steps in this article. It has common Azure tools preinstalled and configured to use with your account. Just click the **Copy** button to copy the code, paste it into the Cloud Shell, and then press enter to run it.  There are a few ways to launch the Cloud Shell:

|  |   |
|-----------------------------------------------|---|
| Click **Try It** in the upper right corner of a code block. | ![Cloud Shell in this article](https://github.com/MicrosoftDocs/azure-docs/raw/master/includes/media/cloud-shell-try-it/cli-try-it.png) |
| Open Cloud Shell in your browser. | [![https://shell.azure.com/bash](https://github.com/MicrosoftDocs/azure-docs/raw/master/includes/media/cloud-shell-try-it/launchcloudshell.png)](https://shell.azure.com/bash) |
| Click the **Cloud Shell** button on the menu in the upper right of the [Azure portal](https://portal.azure.com). |	![Cloud Shell in the portal](https://github.com/MicrosoftDocs/azure-docs/raw/master/includes/media/cloud-shell-try-it/cloud-shell-menu.png) |
|  |  |

### Azure CLI

The Azure CLI 2.0 is a command-line tool providing a great experience for managing Azure resources. The CLI is designed to make scripting easy, flexibly query data, support long-running operations as non-blocking processes, and more. Try it today and find out what the CLI has to offer!

- [Install on Windows](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-windows?view=azure-cli-latest)
- [Install on macOS](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-macos?view=azure-cli-latest)
- Install on Linux or Windows Subsystem for Linux (WSL)
  - [Install with apt on Debian or Ubuntu](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-apt?view=azure-cli-latest)
  - [Install with yum on RHEL, Fedora, or CentOS](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-yum?view=azure-cli-latest)
  - [Install from script](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-linux?view=azure-cli-latest)
- [Run in Docker container](https://docs.microsoft.com/en-us/cli/azure/run-azure-cli-docker?view=azure-cli-latest)

### MobaXterm
Download [MobaXterm](https://mobaxterm.mobatek.net/download.html) 