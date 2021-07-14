/*--------------------*/
/*--- Prerequisites --*/
/*--------------------*/
- Consumer Key and Consumer secret for sandbox,
- sandbox TenantId,
- powershell installed on your machine,
- url for retrieving authentication token,
- url of sandbox siviapi

/*------------------*/
/*--- BeforeStart --*/
/*------------------*/
- create credentials file with using this script "/Credentials/CreateCredentialsFile.ps1"
- open script file "SIVIClientScriptZip.ps1" and edit these values to sandbox details:
	- $IdentityAddress	(line 21)
	- $SIVIAPIUri		(line 29)
	- $TenantId		(line 33)

- in case your server has security check for scripts in place and will throw error that 
  scripts are not signed then please unblock all scripts with this command "Unblock-File NameOfScriptFile.ps1"

/*---------------------*/
/*--- HowToRunScript --*/
/*---------------------*/
- to run this scripts as incremental load use this parameter:
	- ".\SIVIClientScriptZip.ps1 incremental"

- to run this scripts as full load use this parameter (this will load all messages which api has):
	- ".\SIVIClientScriptZip.ps1 fullload"
