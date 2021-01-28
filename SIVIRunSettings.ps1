Function Get-SIVIRunSetting {

	[CmdletBinding()]
	Param(
	)
		
	$LocalStoragePath = Get-RunSettingStoragePath
	$RunSettingsFile = Join-Path $LocalStoragePath 'RunSettings';
     
    If (Test-Path $RunSettingsFile) 
	{
		$RunSetting = Import-CliXml -Path $RunSettingsFile
	}
	else {
		$FetchedUntil = (Get-Date).ToUniversalTime().Date
		$RunSetting = [psCustomObject]@{ FetchedUntil =  $FetchedUntil}
	}

	return $RunSetting
}

Function Edit-SIVIRunSetting {

	[CmdletBinding()]
	Param(
		[Parameter(Mandatory)]
		[psCustomObject]$RunSetting
	)
	
	$LocalStoragePath = Get-RunSettingStoragePath
	$RunSettingsFile = Join-Path $LocalStoragePath 'RunSettings';
	$RunSetting | Export-CliXml -Path $RunSettingsFile
}

Function Get-RunSettingStoragePath {
	$CurrentFolder = Get-Location

	$LocalStoragePath = Join-Path $CurrentFolder 'LocalStorage'
  
	If(!(Test-Path $LocalStoragePath))
	{
		New-Item -ItemType Directory -Force -Path $LocalStoragePath
	}
	
	return $LocalStoragePath;
}


