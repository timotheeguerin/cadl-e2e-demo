
    param resourceToken string
    output fnAppSettings object = list('Microsoft.Web/sites/app-api-${resourceToken}/config/appsettings', '2020-12-01').properties    
    