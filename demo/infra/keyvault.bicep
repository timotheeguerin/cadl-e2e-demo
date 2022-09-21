
  param location string
  param principalId string = ''
  param resourceToken string
  param tags object
  param API_PRINCIPAL string
  param cosmosConnectionStringValue string

  resource keyVault 'Microsoft.KeyVault/vaults@2019-09-01' = {
    name: 'keyvault${resourceToken}'
    location: location
    tags: tags
    properties: {
      tenantId: subscription().tenantId
      sku: {
        family: 'A'
        name: 'standard'
      }
      accessPolicies: concat([
          {
            objectId: API_PRINCIPAL
            permissions: {
              secrets: [
                'get'
                'list'
              ]
            }
            tenantId: subscription().tenantId
          }
        ], !empty(principalId) ? [
          {
            objectId: principalId
            permissions: {
              secrets: [
                'get'
                'list'
              ]
            }
            tenantId: subscription().tenantId
          }
        ] : [])
    }
  
    
      resource cosmosConnectionString 'secrets' = {
        name: 'cosmosConnectionString'
        properties: {
          value: cosmosConnectionStringValue
        }
      }
    
  }

  output AZURE_KEY_VAULT_ENDPOINT string = keyVault.properties.vaultUri
  