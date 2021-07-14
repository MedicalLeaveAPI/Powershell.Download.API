	Param(
		[Parameter()]
		[string] $Run = 'incremental'
	)

. ./GetAuthenticationToken.ps1
. ./GetSIVIMessageZip.ps1
. ./SIVIRunSettings.ps1

$ErrorActionPreference = "Stop"
$CurrentFolder = Get-Location


if(-not(Test-Path -Path ./Credentials/Credentials.xml -PathType Leaf))
{
    Write-host 'Credentials.xml file does not exist. Please run CreateCredentialsFile.ps1 to create this file.' -ForegroundColor red
    Write-host 'This script will not run without this file.' -ForegroundColor red
    exit
} else {
    # -----Token Related settings -------
    $IdentityAddress = 'https://apidemo.raet.com/authentication/token'
    $Credential = Import-CliXml -Path  ./Credentials/Credentials.xml
    $ClientId = $Credential.GetNetworkCredential().UserName
    $ClientSecret = $Credential.GetNetworkCredential().Password
    #---------------------------------------------------------
}

# API URI
$SIVIAPIUri = 'https://apidemo.raet.com/sivi'
$SIVIEndpoint = 'verzuimmeldingen'

#Tenant Id of the customer
$TenantId = '123456'

# Path to the folder where message should be donwloaded and saved. Currently set to the folder where files are kept.
$SIVIMessagesPath = Join-Path $CurrentFolder 'SIVIMessages'

if ($Run -eq "incremental")
{

    $AccessToken =
    Get-AuthenticationToken -IdentityAddress $IdentityAddress  -ClientId $ClientId  -ClientSecret $ClientSecret

    $RunSetting = Get-SIVIRunSetting
    $ChangedAfter = $RunSetting.FetchedUntil
    $ChangedUntil = (Get-Date).ToUniversalTime()
    $ChangedAfterQueryString = Get-Date -Date $ChangedAfter -Format 'yyyy-MM-dd' # 'yyyy-MM-ddTHH:mm:ss'
    $ChangedUntilQueryString = Get-Date -Date $ChangedUntil -Format 'yyyy-MM-dd' # 'yyyy-MM-ddTHH:mm:ss'
    $UriFilter = "?changedAfter=${ChangedAfterQueryString}&changedUntil=${ChangedUntilQueryString}"

    Get-SIVIMessageZip -Token $AccessToken -ConsumerKey $ClientId -SIVIAPIUri $SIVIAPIUri -Endpoint $SIVIEndpoint -UriFilter $UriFilter -TenantId $TenantId -OutputPath $SIVIMessagesPath

    $RunSetting.FetchedUntil = $ChangedUntil
    Edit-SIVIRunSetting -RunSetting $RunSetting

} ElseIf ($Run -eq "fullload") {
    
    $AccessToken =
    Get-AuthenticationToken -IdentityAddress $IdentityAddress  -ClientId $ClientId  -ClientSecret $ClientSecret
    Get-SIVIMessageZip -Token $AccessToken -ConsumerKey $ClientId -SIVIAPIUri $SIVIAPIUri -Endpoint $SIVIEndpoint -UriFilter $null -TenantId $TenantId -OutputPath $SIVIMessagesPath

} else {
    Write-Host 'You used wrong RUN parameter.'
    Write-Host 'Only "incremental" or "fullload" are supported.'
}