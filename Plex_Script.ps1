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

 
function Show-Menu
{
    param (
        [string]$Title = 'Plex Server Menu'
    )
    Clear-Host
    Write-Host "================ $Title ================"
    
    Write-Host "1: Press '1' to take a full backup of your Plex server. Location: $PlexBackupFolderPath"
    Write-Host "2: Press '2' to take REG database backup of your Plex server. Location: $PlexBackupFolderPath"
    Write-Host "3: Press '3' for this option."
    Write-Host "Q: Press 'Q' to quit."
}


# Function to full Plex backup
function FullPlexBackup
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

# Function to Reg database Plex backup
function RegPlexBackup
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


}




# Logic runs here
Show-Menu –Title 'Plex Server Menu'
 $selection = Read-Host "Please make a selection"
 switch ($selection)
 {
     '1' {
         'Creating full backup of Plex server'
         PlexBackup
     } '2' {
         'Creating REG backup of Plex server'
         RegPlexBackup
     } '3' {
         'You chose option #3'
     } 'q' {
         return
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