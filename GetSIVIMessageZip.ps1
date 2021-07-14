Function Get-SIVIMessageZip {

	Param(
		[Parameter(Mandatory)]
		[string] $Token,

		[Parameter(Mandatory)]
		[string] $ConsumerKey,
		
		[Parameter(Mandatory)]
	    [string] $SIVIAPIUri,

		[Parameter(Mandatory)]
	    [string] $Endpoint,	

		[Parameter(Mandatory)]
		[AllowEmptyString()]
	    [string] $UriFilter = $null,
		
		[Parameter(Mandatory)]
		[string] $TenantId,
		
		[Parameter(Mandatory)]
		[string] $OutputPath
	)
	
	$Headers = @{
		'Cache-Control'='no-cache'
		'Content-Type'='application/xml'
		'Accept'='application/xml'
		'Authorization'= $Token
		'X-Client-Id'= $ConsumerKey
		'X-Raet-Tenant-Id'= $TenantId
	}
	
	If(!(Test-Path $OutputPath))
	{
		New-Item -ItemType Directory -Force -Path $OutputPath
	}
	
	$Uri = $SIVIAPIUri + "/" + $Endpoint

	if ($UriFilter)
	{
		$Uri = $SIVIAPIUri + "/" + $Endpoint + $UriFilter
	}
	

	Write-Host 'Retrieving messages...' -ForegroundColor Green
	Write-Host 'Tenant ' -ForegroundColor Yellow -NoNewline
	Write-Host $TenantId -ForegroundColor White
	Write-Host $Uri -ForegroundColor White

	$Response = Invoke-WebRequest -Method GET -Uri $Uri -Headers $Headers -UseBasicParsing
	$Content = Select-Xml -Content $Response.Content -XPath '/Messages/Value'
	$nextPage = Select-Xml -Content $Response.Content -XPath '/Messages/NextLink'

	$pathXMLFile = Join-Path $OutputPath 'siviMessages.xml'
	$Stream = [System.IO.StreamWriter]::new($pathXMLFile , $false)
	


	try {
		$Stream.Write('<?xml version="1.0" encoding="utf-8"?>')
		$Stream.Write($Content)
	}
	finally {
    	$Stream.Dispose()
	}	

	if ($nextPage.Length -gt 0)
	{
		DO
		{
			$NextUri = $SIVIAPIUri + $nextPage
			Write-Host 'Retrieving messages from next page...' -ForegroundColor Green
			Write-Host $NextUri
			
			$nextResponse = Invoke-WebRequest -Method GET -Uri $NextUri -Headers $Headers -UseBasicParsing
			$nextContent = Select-Xml -Content $nextResponse.Content -XPath '/Messages/Value'
			$nextPage = Select-Xml -Content $nextResponse.Content -XPath '/Messages/NextLink'
			
			$Stream = [System.IO.StreamWriter]::new($pathXMLFile , $true)
			
			try {
				$Stream.Write($nextContent)
			}
			finally {
				$Stream.Dispose()
			}	

		} While ($nextPage.Length -gt 0)
	}

	Write-Host 'Creating zip archive with messages' -ForegroundColor Green
	$zipOutPutPath = Join-Path $OutputPath "siviMessages_$(get-date -f yyyyMMddTHHmmss).zip"
	Compress-Archive -Path $pathXMLFile -DestinationPath $zipOutPutPath

	Write-Host 'Script successfully finished' -ForegroundColor Green
}
