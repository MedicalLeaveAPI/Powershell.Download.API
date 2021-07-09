
Write-host 'Via this wizard you will create encrypted file which will safely store credentials needed for connection to siviapi of Visma Reat.' -ForegroundColor Green
Write-host 'Please Read carefully all messages and try to aviod mistakes during entering inputs.' -ForegroundColor Green
Write-host 'Please prepare these credentials:' -ForegroundColor Green
Write-host '- Consumer Key' -ForegroundColor Green
Write-host '- Consumer secret' -ForegroundColor Green
$startWizard = Read-Host -Prompt 'Are you ready to proceed? Y or N'

if($startWizard -eq 'Y' -or $startWizard -eq 'y')
{

    if(-not(Test-Path -Path ./Credentials.xml -PathType Leaf))
    {
        clear
        $clientId = Read-Host -Prompt 'Please write your Consumer Key'
        $clientSecret = Read-Host -Prompt 'Please write your Consumer secret'
        $securedClientSecret = $clientSecret | ConvertTo-SecureString -AsPlainText -Force
        
        $Credentials = New-Object System.Management.Automation.PSCredential `
        -ArgumentList $clientId, $securedClientSecret | Export-CliXml  -Path ./Credentials.xml

        if(-not(Test-Path -Path ./Credentials.xml -PathType Leaf))
        {

            Write-host 'Error file with creadentials was not created.' -ForegroundColor red  

        } else {

            Write-host 'Credentails successfully saved in file for future use.' -ForegroundColor Green

        }

    } else {

        Write-host 'Error file with creadentials already exists.' -ForegroundColor red
        Write-host 'If you will continue data from credentials file will be lost.' -ForegroundColor red
        Write-host 'Please remove Credentials.xml file or rename it and start script again.' -ForegroundColor red

    }

}