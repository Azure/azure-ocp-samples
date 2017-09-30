#!/bin/bash
#Define the Variables
location="eastus"
resourcegroup="iotdbrg"
dbname="iotdb"
dbkind="MongoDB"
dbaccountname="iotdbaccount$(shuf -i1-1000 -n1)"
dbcollection="iotdbcollection"

samplejsonobject="{'joystick': {}, 'environmental': {'pressure': {'unit': 'mbar', 'value': 1012.033935546875}, 'temperature': {'unit': 'C', 'value': 32.19939422607422}, 'humidity': {'unit': '%RH', 'value': 41.28971862792969}}, 'inertial': {'orientation': {'yaw': 130.16238225817773, 'pitch': 0.5666904434304971, 'roll': 2.1385155805448903, 'unit': 'degrees', 'compass': 130.1553061821976}, 'accelerometer': {'y': 0.0369044728577137, 'x': -0.007158233784139156, 'z': 1.02303946018219, 'unit': 'g'}}, 'host': 'iot7643', 'name': 'sense-hat'}"

#Craete the Resource Group
echo "Creating the resource Group"
az group create -l $location -n $resourcegroup

#Create the CosmosDB Account
echo "Creating the CosmoDB Account"
az cosmosdb create -n $dbaccountname -g $resourcegroup --kind $dbkind
az cosmosdb show -n $dbaccountname -g $resourcegroup | jq .writeLocations[0].documentEndpoint | awk -F '"' '{print $2}' > iotdb_endpoint.txt
az cosmosdb list-keys -n $dbaccountname -g $resourcegroup | jq .primaryMasterKey | awk -F '"' '{print $2}' > iotdbkey.txt

#Create the CosmosDB instance
echo "Creating a CosmosDB database Instance"
az cosmosdb database create --db-name $dbname --key $(cat iotdbkey.txt) --name $dbname -g $resourcegroup --url-connection $(cat iotdb_endpoint.txt)

#Create the CosmosDB Collection
echo "Creating a Cosmosdb Collection"
az cosmosdb collection create --collection-name $dbcollection --db-name $dbname --key $(cat iotdbkey.txt) --name $dbname -g $resourcegroup --url-connection $(cat iotdb_endpoint.txt)

echo "###This is a python script that cannot be run on cloudshell"
#Make the python string
pythonurl="mongodb://$dbaccountname:$(cat iotdbkey.txt)@$dbaccountname.documents.azure.com:10255/?ssl=true&replicaSet=globaldb"
echo $pythonurl > pythonurl.txt
echo "The URL is: $pythonurl"

#Download the sample script
curl -O https://raw.githubusercontent.com/alihhussain/AzureTemplates/master/CosmosDB/python.py

#Modify the python script
sed -i "s,pythonmongodburl,$(cat pythonurl.txt),g" python.py
sed -i "s#jsonobject#$samplejsonobject#g" python.py

cat python.py