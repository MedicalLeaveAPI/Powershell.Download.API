Function Get-SIVIMessageZip {

	Param(
		[Parameter(Mandatory)]
		[string] $Token,
		
		[Parameter(Mandatory)]
	    [string] $SIVIAPIUri,
		
		[Parameter(Mandatory)]
		[string] $TenantId,
		
		[Parameter(Mandatory)]
		[string] $OutputPath
	)
	
	$Headers = @{
		'Cache-Control'='no-cache'
		'Content-Type'='application/zip'
		'Accept'='application/zip'
		'Authorization'= $Token
		'X-Raet-Tenant-Id'= $TenantId
	}
	Write-Host 'Retrieving messages...' -ForegroundColor Green
	Write-Host 'Tenant ' -ForegroundColor Yellow -NoNewline
	Write-Host $TenantId -ForegroundColor White
	
	If(!(Test-Path $OutputPath))
	{
		New-Item -ItemType Directory -Force -Path $OutputPath
	}
	
	$ZipFile = Join-Path $OutputPath 'siviMessages.zip'
	
	Invoke-WebRequest -Method GET -Uri $SIVIAPIUri -Headers $Headers -OutFile $ZipFile
	
	Write-Host "Storing messages in ${OutputPath}" -ForegroundColor Green
			
	Expand-Archive -Path $ZipFile -DestinationPath $OutputPath
    <#Remove-Item $ZipFile#>
}
