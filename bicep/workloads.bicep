param azureContainerRegistryName string

@secure()
param azureContainerRegistryPassword string

param imageName string

resource appServicePlan 'Microsoft.Web/serverfarms@2021-01-01' = {
  name:  'demoAppServicePlan'
  location: resourceGroup().location
  kind: 'linux'
  sku: {
    name:'F1'
    tier: 'Free'
  }
  properties: {
    reserved:true
  }
}

resource webApp  'Microsoft.Web/sites@2021-01-01' = {
  name: 'webappdemo${uniqueString(resourceGroup().id)}'
  location: resourceGroup().location
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly:true
    clientAffinityEnabled: false
    siteConfig: {
      appSettings: [
        {
          name: 'DOCKER_REGISTRY_SERVER_URL'
          value: 'https://${azureContainerRegistryName}.azurecr.io'
        }
        {
          name: 'DOCKER_REGISTRY_SERVER_USERNAME'
          value: azureContainerRegistryName
        }
        {
          name: 'DOCKER_REGISTRY_SERVER_PASSWORD'
          value: azureContainerRegistryPassword
        }
        {
          name: 'WEBSITES_ENABLE_APP_SERVICE_STORAGE'
          value: 'false'
        }
      ]
      linuxFxVersion: 'DOCKER|${azureContainerRegistryName}.azurecr.io/${imageName}'
    }
  }
}

resource aci 'Microsoft.ContainerInstance/containerGroups@2021-03-01' = {
 name: 'acidemo'
 location: resourceGroup().location
 
 properties: {
   restartPolicy: 'OnFailure'
   osType: 'Linux'
   imageRegistryCredentials: [
     {
        server: '${azureContainerRegistryName}.azurecr.io'
        username:azureContainerRegistryName
        password: azureContainerRegistryPassword
      }
   ]
   ipAddress: {
     type: 'Public'
     ports: [
       {
         port:80
         protocol:'TCP'
       }
     ]
     dnsNameLabel: 'acitest-${uniqueString(resourceGroup().id)}'

   }
   containers: [
     {
       name:'testaci'
       properties: {
          image: '${azureContainerRegistryName}.azurecr.io/${imageName}'
          ports: [
            {
              protocol:'TCP'
              port: 80
            }
          ]
          
          resources: {
            requests: {
              cpu:1
              memoryInGB: 2
            }
          }
       
        }
      
      }
   ]
 }
}
