#!/bin/sh

export PATH=$HOME/.dotnet/tools:$PATH
APP_SETTINGS=/app/src/appsettings.json

echo "Waiting 10 seconds for SQL Server to become available at $DB_SERVER..."
sleep 10

if [ -f "$APP_SETTINGS" ]; then
    echo "$APP_SETTINGS already exists. Skipping creation and starting app"
    cd src
else 
    echo "$APP_SETTINGS does not exist. Starting app creation process"
    echo "Running: EPiServer.Templates::1.7.2"

    dotnet tool update EPiServer.Net.Cli --global --add-source https://nuget.optimizely.com/feed/packages.svc/
    dotnet new install EPiServer.Templates::1.7.2

    echo Creating project: $PROJECT

    mkdir -p src publish

    cd src

    dotnet new epi-alloy-mvc --name $PROJECT

    timestamp=$(date +%s)

    echo "Creating database: $PROJECT-$timestamp"
    dotnet-episerver create-cms-database $PROJECT.csproj \
        -S $DB_SERVER \
        -U $DB_USER \
        -P $DB_PASS \
        -dn $PROJECT-$timestamp
    
    echo "Cleaning up old connection strings"
    yq -i 'del(.ConnectionStrings)' appsettings.Development.json

fi

dotnet watch run --urls=http://*:5000 # use watch 