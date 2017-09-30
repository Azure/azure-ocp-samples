# Azure Container Instance
Before we can push an instance of this app to Azure Container Instance we will have to build the docker image that will be used by ACI service.
## Prerequisites
*   Docker
*   Docker Public Repository
*   Azure CLI
## The following steps are going to be taken to create create the docker image and ACI deployment
* Copy source code folder to local environment
* Modify your specific environment variables in main.py (**DB_URL**,**dBName**,**dbCollection**)
* Build the Docker Image
* Push the Docker Image to public Repository
* Create Azure Container Instance referencing the Docker image pushed

### Copy Source Code into Local Environment
This is going to be done by cloning the public Repository
```
git clone https://github.com/AzureCAT-GSI/azure-serverless-workshop.git
cd azure-serverless-workshop/05_cosmosdb-to-aci/ACI/flaskDockerFile/build/src
```
The output your going to get is going to look like:
```
Cloning into 'azure-serverless-workshop'...
remote: Counting objects: 107, done.
remote: Compressing objects: 100% (70/70), done.
remote: Total 107 (delta 39), reused 90 (delta 22), pack-reused 0
Receiving objects: 100% (107/107), 546.50 KiB | 0 bytes/s, done.
Resolving deltas: 100% (39/39), done.
Checking connectivity... done.
```
### Modify your specific environment variables
Lets modify the three variables
  *  **YourURL**
  *  **YourDBName**
  *  **YourCollectionName**
```
url = "<YourURL>"
db = client.<YourDBName>.<YourCollectionName>
```
Once done it should look something like:
```
url = "mongodb://iotdbaccount***:cOl25CnJVEonhsGShaSJZqCNYWPIR9j8mfcQLaloJwvy4oG5oZVF9aenWdUchYXHuRrLf2JZqwKOk********==@iotdbaccount***.documents.azure.com:10255/?ssl=true&replicaSet=globaldb"
db = client.cosmosdb.mongodbcollection
```



Now lets build the docker image. To do so you will need a docker account and a public repository.
Lets cd into the location of the docker file
```
cd /azure-serverless-workshop/05_cosmosdb-to-aci/ACI/flaskDockerFile/build
```
Run the following command to insure the Docker file is there
```
ls -alh
```
Output will look as follows:
```
[jenkins@jenkins build]$ ls -alh
total 16K
drwxrwxr-x. 3 jenkins jenkins 4.0K Sep 28 06:48 .
drwxrwxr-x. 3 jenkins jenkins 4.0K Sep 28 06:48 ..
-rw-rw-r--. 1 jenkins jenkins  163 Sep 28 06:48 Dockerfile
drwxrwxr-x. 4 jenkins jenkins 4.0K Sep 28 06:49 src
```
Now lets build the docker image by running the following command.
```
docker build -t <YourDockerAccountName>/<YourDockerPublicRepo>:CosmosDBACI .
```

Sample of how it should look like is:
```
docker build -t alihhussain/azurepublic:CosmosDBACI .
```

Once build insure the image is listed by running the following command:
```
docker images
```

Output should look like:
```
[jenkins@jenkins build]$ docker images
REPOSITORY                      TAG                 IMAGE ID            CREATED             SIZE
alihhussain/azurepublic         CosmosDBACI         18798f955b75        5 minutes ago       103MB
```
Now lets push this image up to Docker Hub so that ACI can fetch it
To do so you will have to login within your docker environment, to do so run the following command:
```
docker login
```
Specify the username
```
Login with your Docker ID to push and pull images from Docker Hub. If you don't have a Docker ID, head over to https://hub.docker.com to create one.
Username:
```
Specify the password:
```
Password:
```
Ensure the login has succeeded:
```
Login Succeeded
```
Lets now push the image up to DockerHub
```
docker push <YourDockerAccountName>/<YourDockerPublicRepo>:CosmosDBACI 
```
It will look something like this:
```
docker push alihhussain/azurepublic:CosmosDBACI
```
# Create Azure Container Instance
To run the Azure CLI commands ensure you are logged in and have the resource name which was created in the earlier section.

To create the ACI instance run the following command substituting for your **ResourceGroup**, **ACI-Name**, **YourDockerAccountName**, and **YourDockerPublicRepo**,
```
az container create -g <YourResourceGroup> --name <ACI-Name> --image <YourDockerAccountName>/<YourDockerPublicRepo>:CosmosDBACI --cpu 1 --memory 1 --ip-address public
```
It should look something like:
```
az container create -g CosmosDB --name azurevote --image alihhussain/azurepublic:CosmosDBACI --cpu 1 --memory 1 --ip-address public
```
The output will look something like:
```
{
  "containers": [
    {
      "command": null,
      "environmentVariables": [],
      "image": "alihhussain/azurepublic:CosmosDBACI",
      "instanceView": null,
      "name": "azurevote",
      "ports": [
        {
          "port": 80
        }
      ],
      "resources": {
        "limits": null,
        "requests": {
          "cpu": 1.0,
          "memoryInGb": 1.0
        }
      },
      "volumeMounts": null
    }
  ],
  "id": "/subscriptions/e729c299-db43-40ce-991a-7e4572a69d50/resourceGroups/iotdbrg/providers/Microsoft.ContainerInstance/containerGroups/azurevote",
  "imageRegistryCredentials": null,
  "ipAddress": {
    "ip": "52.168.142.183",
    "ports": [
      {
        "port": 80,
        "protocol": "TCP"
      }
    ]
  },
  "location": "eastus",
  "name": "azurevote",
  "osType": "Linux",
  "provisioningState": "Creating",
  "resourceGroup": "iotdbrg",
  "restartPolicy": null,
  "state": null,
  "tags": null,
  "type": "Microsoft.ContainerInstance/containerGroups",
  "volumes": null
}
```
Now lets get the public IP of the ACI that was created by running the following command:
```
az container show --name <ACI-Name> --resource-group <YourResourceGroup>| jq .ipAddress.ip
```

A sample is shown below:
```
az container show --name azurevote --resource-group CosmosDB | jq .ipAddress.ip
"52.168.142.183"
```
