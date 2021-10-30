<#
    .NOTES
    ===========================================================================
     Modified on:   30-10-2021
     Created on:   	30-10-2021
	 Created by:   	Daniel Jean Schmidt
	 Organization: 	Dajs
     Filename:     	Plex_Script.ps1
	===========================================================================
    ===========================================================================
     Requirements: 
     - Can be run on Windows 10, Server 2019, Server 2022
    ===========================================================================
    .DESCRIPTION
    This script gives different possibilities to manipulate Plex running on Windows
#>

 
do
 {
Show-Menu
$selection = Read-Host "Please make a selection"
switch ($selection)
{
'1' {
PlexBackup
} '2' {
'You chose option #2'
} '3' {
'You chose option #3'
}
}
pause
}
until ($selection -eq 'q')

function PlexBackup
{

# Specifies Path for the backup
$PlexBackupFolderPath = "C:\PlexBackup"

# Grabs the current date and time
$BackupTime = ((Get-Date).ToString('dd-MM-yyyy_hh.mm.ss'))

# Creates default Plex backup folder
$FolderPathTest = Test-Path $PlexBackupFolderPath
If ($FolderPathTest -eq $false)
{    
mkdir $PlexBackupFolderPath   
}

mkdir $PlexBackupFolderPath\$BackupTime


# Backs up the Plex Registry
Reg Export "HKCU\SOFTWARE\Plex, Inc." $PlexBackupFolderPath\$BackupTime\PlexReg.reg

# Plex Media Server
if(get-process | ?{$_.path -eq "C:\Program Files (x86)\Plex\Plex Media Server\Plex Media Server.exe"})

{
Write-host 'Plex Media Server is running, stopping server' -ForegroundColor Green
Stop-Process -Name "Plex Media Server" -Force
Stop-Process -Name "Plex Tuner Service" -Force
Stop-Process -Name "Plex Update Service" -Force
Stop-Process -Name "PlexScriptHost" -Force
}

# Backs up the Plex datafolder
Compress-Archive -Path "$env:userprofile\appdata\Local\Plex Media Server" -DestinationPath $PlexBackupFolderPath\$BackupTime\PlexDatabase.zip

# Plex Media Server
if(get-process | ?{$_.path -eq "C:\Program Files (x86)\Plex\Plex Media Server\Plex Media Server.exe"})

{
Write-Host 'Plex Media Server is running' -ForegroundColor Green
}
else
{
Write-host 'Plex Media Server is not running, starting server.' -ForegroundColor Red
Start-Process -FilePath "C:\Program Files (x86)\Plex\Plex Media Server\Plex Media Server.exe" -WindowStyle Minimized
}

}








    <#


    NOT IMPLEMENTED FEATURES

    function PlexRegistryRestore
    {
    # Restores Plex registry
    reg import D:\PlexBackup\PlexBackup.reg
    
    }
    
    
    #>