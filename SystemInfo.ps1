function Show-SystemInfoMenu {
    Clear-Host
    Write-Host "======================================" -ForegroundColor Cyan
    Write-Host "     System Information Menu" -ForegroundColor Cyan
    Write-Host "======================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Choose from Menu" -ForegroundColor Yellow
    Write-Host "1- Display detailed configuration information"
    Write-Host "2- Get computer basic information"
    Write-Host "3- Get processor information"
    Write-Host "4- Get installed memory information"
    Write-Host "5- Get disk drives information"
    Write-Host "6- Display host name"
    Write-Host "7- Display TCP/IP network configuration"
    Write-Host "8- Display current date"
    Write-Host "9- Display current time"
    Write-Host "10- Back to Main Menu"
    Write-Host ""
}

function Get-DetailedConfiguration {
    Write-Host "`n=== Detailed System Configuration ===" -ForegroundColor Green
    systeminfo
    Read-Host "`nPress Enter to continue"
}

function Get-ComputerBasicInfo {
    Write-Host "`n=== Computer Basic Information ===" -ForegroundColor Green
    Get-CimInstance Win32_ComputerSystem | Select-Object Name, Manufacturer, Model, SystemType, TotalPhysicalMemory | Format-List
    Get-CimInstance Win32_BIOS | Select-Object SerialNumber, Manufacturer, Version | Format-List
    Get-CimInstance Win32_OperatingSystem | Select-Object Caption, BuildNumber, OSArchitecture, Version, CodeSet | Format-List
    Read-Host "`nPress Enter to continue"
}

function Get-ProcessorInfo {
    Write-Host "`n=== Processor Information ===" -ForegroundColor Green
    Get-CimInstance Win32_Processor | Select-Object Name, Manufacturer, NumberOfCores, NumberOfLogicalProcessors, MaxClockSpeed, CurrentClockSpeed | Format-List
    Read-Host "`nPress Enter to continue"
}

function Get-MemoryInfo {
    Write-Host "`n=== Memory Information ===" -ForegroundColor Green
    $TotalRAM = (Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory
    $FreeRAM = (Get-CimInstance Win32_OperatingSystem).FreePhysicalMemory * 1KB
    $UsedRAM = $TotalRAM - $FreeRAM
    
    Write-Host "Total Physical Memory: $($TotalRAM/1GB) GB"
    Write-Host "Used Memory: $($UsedRAM/1GB) GB"
    Write-Host "Free Memory: $($FreeRAM/1GB) GB"
    Write-Host ""
    Get-CimInstance Win32_PhysicalMemory | Select-Object Manufacturer, Capacity, Speed, DeviceLocator | Format-Table -AutoSize
    Read-Host "`nPress Enter to continue"
}

function Get-DiskInfo {
    Write-Host "`n=== Disk Drives Information ===" -ForegroundColor Green
    Get-CimInstance Win32_LogicalDisk | Where-Object {$_.DriveType -eq 3} | 
        Select-Object DeviceID, VolumeName, 
            @{Name="Size(GB)";Expression={$_.Size/1GB}},
            @{Name="FreeSpace(GB)";Expression={$_.FreeSpace/1GB}},
            @{Name="UsedSpace(GB)";Expression={($_.Size - $_.FreeSpace)/1GB}} | 
        Format-Table -AutoSize
    Read-Host "`nPress Enter to continue"
}

function Get-HostNameInfo {
    Write-Host "`n=== Host Name Information ===" -ForegroundColor Green
    $hostname = hostname
    Write-Host "Computer Name: $hostname"
    Read-Host "`nPress Enter to continue"
}

function Get-NetworkConfig {
    Write-Host "`n=== TCP/IP Network Configuration ===" -ForegroundColor Green
    ipconfig /all
    Read-Host "`nPress Enter to continue"
}

function Get-CurrentDate {
    Write-Host "`n=== Current Date ===" -ForegroundColor Green
    $date = Get-Date -Format "dddd, MMMM dd, yyyy"
    Write-Host "Current Date: $date"
    Read-Host "`nPress Enter to continue"
}

function Get-CurrentTime {
    Write-Host "`n=== Current Time ===" -ForegroundColor Green
    $time = Get-Date -Format "HH:mm:ss tt"
    Write-Host "Current Time: $time"
    Read-Host "`nPress Enter to continue"
}

function Main {
    do {
        Show-SystemInfoMenu
        $choice = Read-Host "Enter your choice (1-10)"
        
        switch ($choice) {
            '1' { Get-DetailedConfiguration }
            '2' { Get-ComputerBasicInfo }
            '3' { Get-ProcessorInfo }
            '4' { Get-MemoryInfo }
            '5' { Get-DiskInfo }
            '6' { Get-HostNameInfo }
            '7' { Get-NetworkConfig }
            '8' { Get-CurrentDate }
            '9' { Get-CurrentTime }
            '10' { return }
            default {
                Write-Host "`nInvalid choice! Please select 1-10." -ForegroundColor Red
                Start-Sleep -Seconds 2
            }
        }
    } while ($choice -ne '10')
}

Main
