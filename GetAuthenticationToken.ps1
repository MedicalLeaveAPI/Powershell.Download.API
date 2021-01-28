Function Get-AuthenticationToken {
	[CmdletBinding()]
    param(
	[Parameter(Mandatory)]
	[string]$ClientId,
	[Parameter(Mandatory)]
	[string]$ClientSecret,
	[Parameter(Mandatory)]
	[string]$IdentityAddress
	) 
		
	Write-Host 'Retrieving token...' -ForegroundColor Green
	Write-Host 'Client ' -ForegroundColor Yellow -NoNewline
	Write-Host $ClientId -ForegroundColor White
	Write-Host 'Retrieving Token'
	Write-Host ''

	$Headers = @{
		'Cache-Control'='no-cache'
		'Content-Type'='application/x-www-form-urlencoded'
	}
	
	$Body = @{
		grant_type='client_credentials'
		client_id=$clientId
		client_secret=$clientSecret
	}
	
	$Response =
	Invoke-WebRequest -Method POST -Uri $IdentityAddress -Headers $Headers -Body $Body -UseBasicParsing

	$Content = $Response.Content | ConvertFrom-Json
	$Token = $Content.token_type + ' ' + $Content.access_token
	
	return $Token
}
