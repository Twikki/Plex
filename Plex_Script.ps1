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

function Show-Title() {


    Write-Host "                                                      " -ForegroundColor Green
    Write-Host "  _____  _      ________   __   _____  _____ _____  _____ _____ _______ " -ForegroundColor Green
    Write-Host " |  __ \| |    |  ____\ \ / /  / ____|/ ____|  __ \|_   _|  __ \__   __|" -ForegroundColor Green
    Write-Host " | |__) | |    | |__   \ V /  | (___ | |    | |__) | | | | |__) | | |   " -ForegroundColor Green
    Write-Host " |  ___/| |    |  __|   > <    \___ \| |    |  _  /  | | |  ___/  | |   " -ForegroundColor Green
    Write-Host " | |    | |____| |____ / . \   ____) | |____| | \ \ _| |_| |      | |   " -ForegroundColor Green
    Write-Host " |_|    |______|______/_/ \_\ |_____/ \_____|_|  \_\_____|_|      |_|   " -ForegroundColor Green
    
    
    }
    
    # Specifies Path for the backup
    $PlexBackupFolderPath = "C:\PlexBackup"
    
    # Grabs the current date and time
    $BackupTime = Get-Date -Format "yyyy/dd/MM_hh.mm.ss"
    
    
    # Creates default Plex backup folder
    $FolderPathTest = Test-Path $PlexBackupFolderPath
    If ($FolderPathTest -eq $false)
    {    
    mkdir $PlexBackupFolderPath   
    }
    
    
    mkdir $PlexBackupFolderPath_$BackupTime
    
    
    # Function finds Plex registry keys and backs them up
    function PlexRegistryBackup
    {
    # Backs up the Plex Registry
    Reg Export "HKCU\SOFTWARE\Plex, Inc." D:\PlexBackup\PlexBackup.reg
    }
    
    function PlexRegistryRestore
    {
    # Restores Plex registry
    reg import D:\PlexBackup\PlexBackup.reg
    
    }
    
    function PlexDataBaseBackup
    {
    
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
    Compress-Archive -Path "$env:userprofile\appdata\Local\Plex Media Server" -DestinationPath D:\PlexBackup.zip
    
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
    