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
  name: 'webAppAppServicetttt'
  location: resourceGroup().location
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly:true
    clientAffinityEnabled: false
    siteConfig: {
      appSettings: [
        {
          name: 'DOCKER_REGISTRY_SERVER_URL'
          value: 'https://demoacridu6abteg7mnu.azurecr.io'
        }
        {
          name: 'DOCKER_REGISTRY_SERVER_USERNAME'
          value: 'todo'
        }
        {
          name: 'DOCKER_REGISTRY_SERVER_PASSWORD'
          value: 'todo'
        }
        {
          name: 'WEBSITES_ENABLE_APP_SERVICE_STORAGE'
          value: 'false'
        }
      ]
      linuxFxVersion: 'DOCKER|demoacridu6abteg7mnu.azurecr.io/tripview-web:v1'
    }
  }
}
