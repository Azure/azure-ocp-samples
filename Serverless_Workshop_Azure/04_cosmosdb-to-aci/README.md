# CosmosDB
The very first thing we need to do is setup CosmosDB.
## Prerequisites
*   Azure Subscription
*   Azure CLI
*   jq ([json Query](https://stedolan.github.io/jq/download/))
## The following steps are going to be taken to create a MongoDB within a CosmosDB Account
* Authenticate in AzureCLI 2.0
* Create Resource Group
* Create CosmosDB Account
* Create CosmosDB Database
* Create CosmosDB Collection
* Put together the python connection string

### Authenticate in AzureCLI 2.0
Login to the Azure CLI 2.0 by running the following command:
```
az login
```
The output your going to get is going to look like:
```
To sign in, use a web browser to open the page https://aka.ms/devicelogin and enter the code <YourCodeHere> to authenticate.
```
Go to the [Login Page](https://aka.ms/devicelogin) and authenticate using the code specified in the output of Login command **YourCodeHere**

Once successfully logged in you will see the following output:
```
[
  {
    "cloudName": "AzureCloud",
    "id": "<YourSubscriptionID>",
    "isDefault": false,
    "name": "Visual Studio Enterprise",
    "state": "Enabled",
    "tenantId": "<YourTenantID>",
    "user": {
      "name": "<YourUserName>",
      "type": "user"
    }
  }
]
```
### Create Resource Group
Before you execute the command lets set some environment variables:
```
location="eastus"
resourcegroup="CosmosDB"
```
Now that the environment variables have been set lets execute the resource group creation command:
```
az group create -l $location -n $resourcegroup
```
Your output will look like:
```
{
  "id": "/subscriptions/e729c299-db43-40ce-****-******/resourceGroups/CosmosDB",
  "location": "eastus",
  "managedBy": null,
  "name": "CosmosDB",
  "properties": {
    "provisioningState": "Succeeded"
  },
  "tags": null
}

```
### Create CosmosDB Account
Before you execute the command lets set some environment variables:
Make sure to replace the <RandomDigit> to a numarical value. As a sample **"Mongodbcosmos678343"**
```
resourcegroup="CosmosDB"
dbkind="MongoDB"
dbaccountname="mongodbcosmos<RandomDigit>"
```
Lets now create the CosmosDB account by executing the following command:
```
az cosmosdb create -n $dbaccountname -g $resourcegroup --kind $dbkind
```
Your output will look like:
```
{
  "consistencyPolicy": {
    "defaultConsistencyLevel": "Session",
    "maxIntervalInSeconds": 5,
    "maxStalenessPrefix": 100
  },
  "databaseAccountOfferType": "Standard",
  "documentEndpoint": "https://****.documents.azure.com:443/",
  "enableAutomaticFailover": false,
  "failoverPolicies": [
    {
      "failoverPriority": 0,
      "id": "{
  "consistencyPolicy": {
    "defaultConsistencyLevel": "Session",
    "maxIntervalInSeconds": 5,
    "maxStalenessPrefix": 100
  },
  "databaseAccountOfferType": "Standard",
  "documentEndpoint": "https://***.documents.azure.com:443/",
  "enableAutomaticFailover": false,
  "failoverPolicies": [
    {
      "failoverPriority": 0,
      "id": "***-eastus",
      "locationName": "East US"
    }
  ],
  "id": "/subscriptions/e729c299-db43-40ce-991a-7e4572a69d50/resourceGroups/CosmosDB/providers/Microsoft.DocumentDB/databaseAccounts/****",
  "ipRangeFilter": "",
  "kind": "MongoDB",
  "location": "East US",
  "name": "*****",
  "provisioningState": "Succeeded",
  "readLocations": [
    {
      "documentEndpoint": "https://****-eastus.documents.azure.com:443/",
      "failoverPriority": 0,
      "id": "*****-eastus",
      "locationName": "East US",
      "provisioningState": "Succeeded"
    }
  ],
  "resourceGroup": "CosmosDB",
  "tags": {},
  "type": "Microsoft.DocumentDB/databaseAccounts",
  "writeLocations": [
    {
      "documentEndpoint": "https://*****-eastus.documents.azure.com:443/",
      "failoverPriority": 0,
      "id": "*****-eastus",
      "locationName": "East US",
      "provisioningState": "Succeeded"
    }
  ]
}
-eastus",
      "locationName": "East US"
    }
  ],
  "id": "/subscriptions/e729c299-db43-40ce-991a-***********/resourceGroups/CosmosDB/providers/Microsoft.DocumentDB/databaseAccounts/****",
  "ipRangeFilter": "",
  "kind": "MongoDB",
  "location": "East US",
  "name": "**************",
  "provisioningState": "Succeeded",
  "readLocations": [
    {
      "documentEndpoint": "https://****-eastus.documents.azure.com:443/",
      "failoverPriority": 0,
      "id": "****-eastus",
      "locationName": "East US",
      "provisioningState": "Succeeded"
    }
  ],
  "resourceGroup": "CosmosDB",
  "tags": {},
  "type": "Microsoft.DocumentDB/databaseAccounts",
  "writeLocations": [
    {
      "documentEndpoint": "https://****-eastus.documents.azure.com:443/",
      "failoverPriority": 0,
      "id": "****-eastus",
      "locationName": "East US",
      "provisioningState": "Succeeded"
    }
  ]
}
```
Lets get the db endpoint by running the following command:
```
cosmosdb_endpoint=$(az cosmosdb show -n $dbaccountname -g $resourcegroup | jq .writeLocations[0].documentEndpoint | awk -F '"' '{print $2}')
echo $cosmosdb_endpoint
```
Lets also get the key for the account created:
```
cosmosdbkey=$(az cosmosdb list-keys -n $dbaccountname -g $resourcegroup | jq .primaryMasterKey | awk -F '"' '{print $2}')
echo $cosmosdbkey
```
### Create the CosmosDB instance
Before you execute the command lets set some environment variables:
```
dbname="cosmosdb"
```
Ensure the **cosmosdb_endpoint** and **cosmosdbkey** environment variables are set from the previous section:
```
echo $cosmosdb_endpoint
echo $cosmosdbkey
```
Lets now run the CLI command to create the Database:
```
az cosmosdb database create --db-name $dbname --key $cosmosdbkey --name $dbname -g $resourcegroup --url-connection $cosmosdb_endpoint
```

The output will be:
```
{
  "_colls": "colls/",
  "_etag": "\"00007301-0000-0000-0000-59cb69350000\"",
  "_rid": "WXUcAA==",
  "_self": "dbs/WXUcAA==/",
  "_ts": 1506502965,
  "_users": "users/",
  "id": "cosmosdb"
}
```

### Create CosmosDB Collection
Before you execute the command lets set some environment variables:
```
dbcollection="mongodbcollection"
```
lets now run the CLI command to create the collection:
```
az cosmosdb collection create --collection-name $dbcollection --db-name $dbname --key $cosmosdbkey --name $dbname -g $resourcegroup --url-connection $cosmosdb_endpoint
```

The output will be something like:
```
{
  "collection": {
    "_conflicts": "conflicts/",
    "_docs": "docs/",
    "_etag": "\"00007401-0000-0000-0000-59cb6a110000\"",
    "_rid": "WXUcAMfIAgA=",
    "_self": "dbs/WXUcAA==/colls/WXUcAMfIAgA=/",
    "_sprocs": "sprocs/",
    "_triggers": "triggers/",
    "_ts": 1506503185,
    "_udfs": "udfs/",
    "id": "mongodbcollection",
    "indexingPolicy": {
      "automatic": true,
      "excludedPaths": [],
      "includedPaths": [
        {
          "indexes": [
            {
              "dataType": "String",
              "kind": "Range",
              "precision": -1
            },
            {
              "dataType": "Number",
              "kind": "Range",
              "precision": -1
            }
          ],
          "path": "/*"
        }
      ],
      "indexingMode": "consistent"
    }
  },
  "offer": {
    "_etag": "\"00007501-0000-0000-0000-59cb6a110000\"",
    "_rid": "BN1W",
    "_self": "offers/BN1W/",
    "_ts": 1506503185,
    "content": {
      "offerIsRUPerMinuteThroughputEnabled": false,
      "offerThroughput": 400
    },
    "id": "BN1W",
    "offerResourceId": "WXUcAMfIAgA=",
    "offerType": "Invalid",
    "offerVersion": "V2",
    "resource": "dbs/WXUcAA==/colls/WXUcAMfIAgA=/"
  }
}
```
###  Put together the python connection string

The connection string for mongoDB will have the following struction:

* mongodb://**YourDBAccountName**:**YourKey**@**YourDBAccountName**.documents.azure.com:10255/?ssl=true&replicaSet=globaldb"

Lets get the values we need by recalling the environment variables set:
```
echo $dbaccountname
echo $cosmosdbkey
```
Sample connection string will be:
```
"mongodb://iotdbaccount***:cOl25CnJVEonhsGShaSJZqCNYWPIR9j8mfcQLaloJwvy4oG5oZVF9aenWdUchYXHuRrLf2JZqwKOk********==@iotdbaccount***.documents.azure.com:10255/?ssl=true&replicaSet=globaldb"
```

# Demo App
Copy the entire [folder](https://github.com/AzureCAT-GSI/azure-serverless-workshop/tree/master/04_cosmosdb-to-aci/ACI/flaskDockerFile/build/src) in a local folder

Modify the following values in the **[main.py](https://raw.githubusercontent.com/alihhussain/AzureTemplates/master/CosmosDB/azure-vote/main.py)** file

```
url = <Put the connection string created in the previous section>
db = client.<YourDBName>.<YourCollectionName> 
```
Before running the python app locally insure pymongo binaries are install.
To do so run the following command.
```
pip install pymongo
pip install flask
```

Once pymongo module is install run the following command to start the flask app
```
sudo python main.py
for box
```


