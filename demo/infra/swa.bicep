
  param location string
  param principalId string = ''
  param resourceToken string
  param tags object
  param APPINSIGHTS_INSTRUMENTATIONKEY string = ''
  param AZURE_KEY_VAULT_ENDPOINT string = ''
  
  resource web 'Microsoft.Web/staticSites@2021-03-01' = {
    name: 'stapp-${resourceToken}'
    location: location
    tags: union(tags, {
        'azd-service-name': 'web'
      })
    sku: {
      name: 'Free'
      tier: 'Free'
    }
    properties: {
      provider: 'Custom'
    }
  }
  
  output WEB_URI string = 'https://${web.properties.defaultHostname}'
  