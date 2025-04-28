# Optimizely Alloy on Docker

```sh
docker compose up --build 
```
Browse to http://localhost:4747 , set up an admin account and you are off to the races!

# script.sh
Controls the cms application creation process
You can modify the SQL Server wait (in seconds) on Line 7 with 10 seconds being the default

# docker-compose.yml

- SQL Server
- CMS Application

# Add API's

## Install Packages
dotnet add package EPiServer.CMS
dotnet add package EPiServer.ContentDeliveryApi.Cms
dotnet add package EPiServer.ContentManagementApi
dotnet add package EPiServer.ContentDefinitionsApi

dotnet add package EPiServer.OpenIDConnect
dotnet add package EPiServer.OpenIDConnect.UI

## Startup.cs - Import Namespaces
```csharp
using EPiServer.ContentApi.Cms;
using EPiServer.ContentApi.Cms.Internal;
using EPiServer.ContentDefinitionsApi;
using EPiServer.ContentManagementApi;
using EPiServer.OpenIDConnect;
```

## Startup.cs - Append Code to ConfigureServices()
```csharp

// Content Delivery API
services.AddContentDeliveryApi(OpenIDConnectOptionsDefaults.AuthenticationScheme, options =>
        {
            options.SiteDefinitionApiEnabled = true;
        })
               .WithFriendlyUrl()
               .WithSiteBasedCors();

// Content Definitions API
services.AddContentDefinitionsApi(options =>
{
    // Accept anonymous calls
    options.DisableScopeValidation = true;
});

// Content Management
services.AddContentManagementApi(OpenIDConnectOptionsDefaults.AuthenticationScheme, options =>
{
    // Accept anonymous calls
    options.DisableScopeValidation = true;
});

// OpenID Connect
services.AddOpenIDConnect<ApplicationUser>(
        useDevelopmentCertificate: true,
        signingCertificate: null,
        encryptionCertificate: null,
        createSchema: true,
        options =>
    {
        //options.RequireHttps = !_webHostingEnvironment.IsDevelopment();
        var application = new OpenIDConnectApplication()
        {
            ClientId = "postman-client",
            ClientSecret = "postman",
            Scopes =
            {
                ContentDeliveryApiOptionsDefaults.Scope,
                ContentManagementApiOptionsDefaults.Scope,
                ContentDefinitionsApiOptionsDefaults.Scope,
            }
        };

        // Using Postman for testing purpose.
        // The authorization code is sent to postman after successful authentication.
        application.RedirectUris.Add(new Uri("https://oauth.pstmn.io/v1/callback"));
        options.Applications.Add(application);
        options.AllowResourceOwnerPasswordFlow = true;
        options.AllowAnonymousFlow = true;
    });

services.AddOpenIDConnectUI();
```