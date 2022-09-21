
    param location string
    param principalId string = ''
    param resourceToken string
    param tags object
    param AZURE_KEY_VAULT_ENDPOINT string
param APPINSIGHTS_INSTRUMENTATIONKEY string
    
      module getFnEnv './getFnEnv.bicep' = {
        name: 'getFnEnv'
        params: {
          resourceToken: resourceToken
        }
      }
      
      resource fnConfig 'Microsoft.Web/sites/config@2020-12-01' = {
        name: 'app-api-${resourceToken}/appsettings'
        properties: union(getFnEnv.outputs.fnAppSettings, {
            AZURE_KEY_VAULT_ENDPOINT: AZURE_KEY_VAULT_ENDPOINT
APPINSIGHTS_INSTRUMENTATIONKEY: APPINSIGHTS_INSTRUMENTATIONKEY
          })
      }    
    
  