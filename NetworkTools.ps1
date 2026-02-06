function Show-NetworkToolsMenu {
    Clear-Host
    Write-Host "======================================" -ForegroundColor Cyan
    Write-Host "       Network Tools Menu" -ForegroundColor Cyan
    Write-Host "======================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Choose from Menu" -ForegroundColor Yellow
    Write-Host "1- View password & logon restrictions"
    Write-Host "2- Display server or workgroup settings"
    Write-Host "3- View user account details"
    Write-Host "4- Stop and start a service"
    Write-Host "5- Display network statistics"
    Write-Host "6- Manage shared resource connections"
    Write-Host "7- Back to Main Menu"
    Write-Host ""
}

function Get-PasswordRestrictions {
    Write-Host "`n=== Password & Logon Restrictions ===" -ForegroundColor Green
    net accounts
    Read-Host "`nPress Enter to continue"
}

function Get-ServerSettings {
    Write-Host "`n=== Server/Workgroup Settings ===" -ForegroundColor Green
    
    $computerSystem = Get-CimInstance Win32_ComputerSystem
    Write-Host "`nComputer Name: $($computerSystem.Name)"
    Write-Host "Domain: $($computerSystem.Domain)"
    Write-Host "Workgroup: $($computerSystem.Workgroup)"
    Write-Host "Part of Domain: $($computerSystem.PartOfDomain)"
    
    Write-Host "`n--- Network Configuration ---"
    net config workstation
    
    Read-Host "`nPress Enter to continue"
}

function Get-UserAccountDetails {
    Write-Host "`n=== User Account Details ===" -ForegroundColor Green
    $username = Read-Host "Enter username to view details"
    
    try {
        net user $username
    } catch {
        Write-Host "Error retrieving user information: $_" -ForegroundColor Red
    }
    
    Read-Host "`nPress Enter to continue"
}

function Manage-Service {
    Write-Host "`n=== Service Management ===" -ForegroundColor Green
    
    Write-Host "`nCurrent Services:"
    Get-Service | Select-Object -First 20 | Format-Table -AutoSize
    
    $serviceName = Read-Host "`nEnter service name"
    $service = Get-Service -Name $serviceName -ErrorAction SilentlyContinue
    
    if ($service) {
        Write-Host "`nService: $($service.Name)"
        Write-Host "Status: $($service.Status)"
        Write-Host "Display Name: $($service.DisplayName)"
        
        Write-Host "`nActions:"
        Write-Host "1- Start Service"
        Write-Host "2- Stop Service"
        Write-Host "3- Restart Service"
        Write-Host "4- Cancel"
        
        $action = Read-Host "Choose action"
        
        try {
            switch ($action) {
                '1' { 
                    Start-Service -Name $serviceName
                    Write-Host "Service started successfully!" -ForegroundColor Green
                }
                '2' { 
                    Stop-Service -Name $serviceName -Force
                    Write-Host "Service stopped successfully!" -ForegroundColor Green
                }
                '3' { 
                    Restart-Service -Name $serviceName -Force
                    Write-Host "Service restarted successfully!" -ForegroundColor Green
                }
                '4' { Write-Host "Cancelled." }
                default { Write-Host "Invalid action!" -ForegroundColor Red }
            }
        } catch {
            Write-Host "Error managing service: $_" -ForegroundColor Red
        }
    } else {
        Write-Host "Service not found!" -ForegroundColor Red
    }
    
    Read-Host "`nPress Enter to continue"
}

function Get-NetworkStatistics {
    Write-Host "`n=== Network Statistics ===" -ForegroundColor Green
    
    Write-Host "`n1- Show all connections and listening ports"
    Write-Host "2- Show Ethernet statistics"
    Write-Host "3- Show active connections"
    Write-Host "4- Show routing table"
    Write-Host "5- Show protocol statistics"
    
    $choice = Read-Host "`nChoose statistics type"
    
    switch ($choice) {
        '1' { netstat -a }
        '2' { netstat -e }
        '3' { netstat -n }
        '4' { netstat -r }
        '5' { netstat -s }
        default { Write-Host "Invalid choice!" -ForegroundColor Red }
    }
    
    Read-Host "`nPress Enter to continue"
}

function Manage-SharedResources {
    Write-Host "`n=== Shared Resource Connections ===" -ForegroundColor Green
    
    Write-Host "`n1- View current connections"
    Write-Host "2- Connect to shared resource"
    Write-Host "3- Disconnect from shared resource"
    
    $choice = Read-Host "Choose option"
    
    switch ($choice) {
        '1' {
            Write-Host "`n--- Current Network Connections ---"
            net use
        }
        '2' {
            $drive = Read-Host "Enter drive letter (e.g., Z:)"
            $path = Read-Host "Enter network path (e.g., \\server\share)"
            try {
                net use $drive $path
                Write-Host "Connected successfully!" -ForegroundColor Green
            } catch {
                Write-Host "Error connecting: $_" -ForegroundColor Red
            }
        }
        '3' {
            $drive = Read-Host "Enter drive letter to disconnect (e.g., Z:)"
            try {
                net use $drive /delete
                Write-Host "Disconnected successfully!" -ForegroundColor Green
            } catch {
                Write-Host "Error disconnecting: $_" -ForegroundColor Red
            }
        }
        default {
            Write-Host "Invalid choice!" -ForegroundColor Red
        }
    }
    
    Read-Host "`nPress Enter to continue"
}

function Main {
    do {
        Show-NetworkToolsMenu
        $choice = Read-Host "Enter your choice (1-7)"
        
        switch ($choice) {
            '1' { Get-PasswordRestrictions }
            '2' { Get-ServerSettings }
            '3' { Get-UserAccountDetails }
            '4' { Manage-Service }
            '5' { Get-NetworkStatistics }
            '6' { Manage-SharedResources }
            '7' { return }
            default {
                Write-Host "`nInvalid choice! Please select 1-7." -ForegroundColor Red
                Start-Sleep -Seconds 2
            }
        }
    } while ($choice -ne '7')
}

Main
