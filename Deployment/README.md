# Deployment
This folder contains all the scripts I used for deployment.

### deploy-asp-net-core.ps1
This script is used to set up IIS on a server and it will deploy a ASP .NET Core website from a GitHub releases page. It will not attempt to re-setup IIS if it has already been setup.

### deploy-asp-net-core-from-azure-blob.ps1
This script is used to set up IIS on a server and it will deploy a ASP .NET Core website from an Azure blob account. It will not attempt to re-setup IIS if it has already been setup and moreover, it will deploy the most recent artifact that has been uploaded to the blob account.