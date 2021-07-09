RESOURCE_GROUP="terry"
LOCATION="westeurope"
az group create --name $RESOURCE_GROUP --location $LOCATION

az deployment group create --resource-group $RESOURCE_GROUP --template-file './bicep/platform.bicep'


