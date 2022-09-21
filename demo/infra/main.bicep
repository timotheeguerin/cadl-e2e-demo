
    targetScope = 'subscription'

    @minLength(1)
    @maxLength(64)
    @description('Name of the the environment which is used to generate a short unqiue hash used in all resources.')
    param name string

    @minLength(1)
    @description('Primary location for all resources')
    param location string

    @description('Id of the user or app to assign application roles')
    param principalId string = ''

    resource resourceGroup 'Microsoft.Resources/resourceGroups@2020-06-01' = {
      name: '${name}-rg'
      location: location
      tags: tags
    }

    var resourceToken = toLower(uniqueString(subscription().id, name, location))
    var tags = {
      'azd-env-name': name
    }

    
      module cosmos './cosmos.bicep' = {
        name: 'cosmos-${resourceToken}'
        scope: resourceGroup
        params: {
          location: location
          principalId: principalId
          resourceToken: resourceToken
          tags: tags
          
        }
      }
      
      module swa './swa.bicep' = {
        name: 'swa-${resourceToken}'
        scope: resourceGroup
        params: {
          location: location
          principalId: principalId
          resourceToken: resourceToken
          tags: tags
          
        }
      }
      
      module functions './functions.bicep' = {
        name: 'functions-${resourceToken}'
        scope: resourceGroup
        params: {
          location: location
          principalId: principalId
          resourceToken: resourceToken
          tags: tags
          WEB_URI: swa.outputs.WEB_URI
        }
      }
      
      module keyvault './keyvault.bicep' = {
        name: 'keyvault-${resourceToken}'
        scope: resourceGroup
        params: {
          location: location
          principalId: principalId
          resourceToken: resourceToken
          tags: tags
          cosmosConnectionStringValue: cosmos.outputs.cosmosConnectionStringValue
API_PRINCIPAL: functions.outputs.API_PRINCIPAL
        }
      }
      
      module appInsights './appInsights.bicep' = {
        name: 'appInsights-${resourceToken}'
        scope: resourceGroup
        params: {
          location: location
          principalId: principalId
          resourceToken: resourceToken
          tags: tags
          
        }
      }
      
    module env './env.bicep' = {
    name: 'env-${resourceToken}'
    scope: resourceGroup
    params: {
      location: location
      principalId: principalId
      resourceToken: resourceToken
      tags: tags
      AZURE_KEY_VAULT_ENDPOINT: keyvault.outputs.AZURE_KEY_VAULT_ENDPOINT
APPINSIGHTS_INSTRUMENTATIONKEY: appInsights.outputs.APPINSIGHTS_INSTRUMENTATIONKEY
    }
  }
    output API_ENDPOINT string = functions.outputs.FUNCTION_ENDPOINT
output AZURE_KEY_VAULT_ENDPOINT string = keyvault.outputs.AZURE_KEY_VAULT_ENDPOINT
output APPINSIGHTS_INSTRUMENTATIONKEY string = appInsights.outputs.APPINSIGHTS_INSTRUMENTATIONKEY
