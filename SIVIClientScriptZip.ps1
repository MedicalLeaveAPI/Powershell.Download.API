. ./GetAuthenticationToken.ps1
. ./GetSIVIMessageZip.ps1
. ./SIVIRunSettings.ps1

$ErrorActionPreference = "Stop"
$CurrentFolder = Get-Location


# -----Token Related settings -------
$IdentityAddress = 'https://api-test.raet.com/authentication/token'
$ClientId = 'ReplaceWithClientId'
$ClientSecret = 'ReplaceWithClientSecret'
#---------------------------------------------------------

# API URI
$SIVIAPIUri = 'https://we-demo-app-siviapi.azurewebsites.net/api/sivi/zip'

#Tenant Id of the customer
$TenantId = '12345'

# Path to the folder where message should be donwloaded and saved. Currently set to the folder where files are kept.
$SIVIMessagesPath = Join-Path $CurrentFolder 'SIVIMessages'


$AccessToken =
Get-AuthenticationToken -IdentityAddress $IdentityAddress  -ClientId $ClientId  -ClientSecret $ClientSecret

$RunSetting = Get-SIVIRunSetting
$ChangedAfter = $RunSetting.FetchedUntil
$ChangedUntil = (Get-Date).ToUniversalTime()
$ChangedAfterQueryString = Get-Date -Date $ChangedAfter -Format 'yyyy-MM-ddThh:mm:ss'
$ChangedUntilQueryString = Get-Date -Date $ChangedUntil -Format 'yyyy-MM-ddThh:mm:ss'
$SIVIAPIUri = $SIVIAPIUri + "?changedAfter=${ChangedAfterQueryString}&changedUntil=${ChangedUntilQueryString}"


Write-Host 'Executing Get: ' -ForegroundClors Yellow -NoNewline
Write-Host $SIVIAPIUri -ForegroundColor White

Get-SIVIMessageZip -Token $AccessToken -SIVIAPIUri $SIVIAPIUri -TenantId $TenantId -OutputPath $SIVIMessagesPath

$RunSetting.FetchedUntil = $ChangedUntil
Edit-SIVIRunSetting -RunSetting $RunSetting
