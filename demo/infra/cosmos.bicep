
  param location string
  param principalId string = ''
  param resourceToken string
  param tags object
  resource cosmos 'Microsoft.DocumentDB/databaseAccounts@2021-04-15' = {
    name: 'cosmos-${resourceToken}'
    kind: 'GlobalDocumentDB'
    location: location
    tags: tags
    properties: {
      consistencyPolicy: {
        defaultConsistencyLevel: 'Session'
      }
      locations: [
        {
          locationName: location
          failoverPriority: 0
          isZoneRedundant: false
        }
      ]
      databaseAccountOfferType: 'Standard'
      enableAutomaticFailover: false
      enableMultipleWriteLocations: false
      capabilities: [
        {
          name: 'EnableServerless'
        }
      ]
    }
  }

  output cosmosConnectionStringValue string = cosmos.listConnectionStrings().connectionStrings[0].connectionString
