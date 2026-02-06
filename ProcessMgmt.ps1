function Show-ProcessMgmtMenu {
    Clear-Host
    Write-Host "======================================" -ForegroundColor Cyan
    Write-Host "    Process Management Menu" -ForegroundColor Cyan
    Write-Host "======================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Choose from Menu" -ForegroundColor Yellow
    Write-Host "1- View list of running processes"
    Write-Host "2- Kill a particular process"
    Write-Host "3- Start a new process"
    Write-Host "4- View processes consuming most CPU"
    Write-Host "5- View processes consuming most memory"
    Write-Host "6- Back to Main Menu"
    Write-Host ""
}

function Get-RunningProcesses {
    Write-Host "`n=== Running Processes ===" -ForegroundColor Green
    Get-Process | Select-Object Id, ProcessName, CPU, 
        @{Name="Memory(MB)";Expression={$_.WorkingSet/1MB}},
        StartTime | Sort-Object Memory -Descending | Format-Table -AutoSize
    Read-Host "`nPress Enter to continue"
}

function Stop-TargetProcess {
    Write-Host "`n=== Kill Process ===" -ForegroundColor Green
    
    $identifier = Read-Host "Enter process name or ID"
    
    try {
        if ($identifier -match '^\d+$') {
            $process = Get-Process -Id $identifier -ErrorAction Stop
        } else {
            $process = Get-Process -Name $identifier -ErrorAction Stop
        }
        
        Write-Host "`nProcess Details:"
        Write-Host "ID: $($process.Id)"
        Write-Host "Name: $($process.ProcessName)"
        Write-Host "Memory: $($process.WorkingSet/1MB) MB"
        
        $confirm = Read-Host "`nAre you sure you want to kill this process? (Y/N)"
        
        if ($confirm -eq 'Y' -or $confirm -eq 'y') {
            Stop-Process -Id $process.Id -Force
            Write-Host "Process killed successfully!" -ForegroundColor Green
        } else {
            Write-Host "Operation cancelled." -ForegroundColor Yellow
        }
    } catch {
        Write-Host "Error: Process not found or cannot be terminated." -ForegroundColor Red
    }
    
    Read-Host "`nPress Enter to continue"
}

function Start-NewProcess {
    Write-Host "`n=== Start New Process ===" -ForegroundColor Green
    
    $processName = Read-Host "Enter process/application name (e.g., notepad, calc)"
    
    try {
        Start-Process $processName
        Write-Host "Process started successfully!" -ForegroundColor Green
    } catch {
        Write-Host "Error starting process: $_" -ForegroundColor Red
    }
    
    Read-Host "`nPress Enter to continue"
}

function Get-TopCPUProcesses {
    Write-Host "`n=== Top CPU Consuming Processes ===" -ForegroundColor Green
    
    $count = Read-Host "Enter number of processes to display (default: 10)"
    if ($count -eq "") { $count = 10 }
    
    Get-Process | Where-Object {$_.CPU -ne $null} | 
        Sort-Object CPU -Descending | 
        Select-Object -First $count Id, ProcessName, 
            @{Name="CPU(s)";Expression={$_.CPU}},
            @{Name="Memory(MB)";Expression={$_.WorkingSet/1MB}},
            StartTime | 
        Format-Table -AutoSize
    
    Read-Host "`nPress Enter to continue"
}

function Get-TopMemoryProcesses {
    Write-Host "`n=== Top Memory Consuming Processes ===" -ForegroundColor Green
    
    $count = Read-Host "Enter number of processes to display (default: 10)"
    if ($count -eq "") { $count = 10 }
    
    Get-Process | Sort-Object WorkingSet -Descending | 
        Select-Object -First $count Id, ProcessName, 
            @{Name="Memory(MB)";Expression={$_.WorkingSet/1MB}},
            @{Name="CPU(s)";Expression={$_.CPU}},
            StartTime | 
        Format-Table -AutoSize
    
    Read-Host "`nPress Enter to continue"
}

function Main {
    do {
        Show-ProcessMgmtMenu
        $choice = Read-Host "Enter your choice (1-6)"
        
        switch ($choice) {
            '1' { Get-RunningProcesses }
            '2' { Stop-TargetProcess }
            '3' { Start-NewProcess }
            '4' { Get-TopCPUProcesses }
            '5' { Get-TopMemoryProcesses }
            '6' { return }
            default {
                Write-Host "`nInvalid choice! Please select 1-6." -ForegroundColor Red
                Start-Sleep -Seconds 2
            }
        }
    } while ($choice -ne '6')
}

Main
