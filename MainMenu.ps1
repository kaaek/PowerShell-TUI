function Show-MainMenu {
    Clear-Host
    Write-Host "======================================" -ForegroundColor Cyan
    Write-Host "     PowerShell Utility System" -ForegroundColor Cyan
    Write-Host "======================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Choose from Menu" -ForegroundColor Yellow
    Write-Host "1- System information"
    Write-Host "2- File operations"
    Write-Host "3- Network Tools"
    Write-Host "4- Process Management"
    Write-Host "5- Data Analysis"
    Write-Host "6- Account Management"
    Write-Host "7- Exit"
    Write-Host ""
}

function Main {
    do {
        Show-MainMenu
        $choice = Read-Host "Enter your choice (1-7)"
        
        switch ($choice) {
            '1' {
                & "$PSScriptRoot\SystemInfo.ps1"
            }
            '2' {
                & "$PSScriptRoot\FileOps.ps1"
            }
            '3' {
                & "$PSScriptRoot\NetworkTools.ps1"
            }
            '4' {
                & "$PSScriptRoot\ProcessMgmt.ps1"
            }
            '5' {
                & "$PSScriptRoot\DataAnalysis.ps1"
            }
            '6' {
                & "$PSScriptRoot\AccountMgmt.ps1"
            }
            '7' {
                Write-Host "`nExiting... Goodbye!" -ForegroundColor Green
                Start-Sleep -Seconds 1
                exit
            }
            default {
                Write-Host "`nInvalid choice! Please select 1-7." -ForegroundColor Red
                Start-Sleep -Seconds 2
            }
        }
    } while ($choice -ne '7')
}

Main