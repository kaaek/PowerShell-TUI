function Show-FileOpsMenu {
    Clear-Host
    Write-Host "======================================" -ForegroundColor Cyan
    Write-Host "     File Operations Menu" -ForegroundColor Cyan
    Write-Host "======================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Choose from Menu" -ForegroundColor Yellow
    Write-Host "1- Display or change file attributes"
    Write-Host "2- Display or change current directory"
    Write-Host "3- Copy files"
    Write-Host "4- Delete files"
    Write-Host "5- List files and subdirectories"
    Write-Host "6- Create a directory"
    Write-Host "7- Move files"
    Write-Host "8- Remove a directory"
    Write-Host "9- Rename a file"
    Write-Host "10- Get file permissions"
    Write-Host "11- Set file permissions"
    Write-Host "12- Save current directory then change it"
    Write-Host "13- Remove subdirectories"
    Write-Host "14- Replace a file"
    Write-Host "15- Display directory structure"
    Write-Host "16- Copy files and directory trees"
    Write-Host "17- Back to Main Menu"
    Write-Host ""
}

function Manage-FileAttributes {
    Write-Host "`n=== File Attributes Management ===" -ForegroundColor Green
    $filePath = Read-Host "Enter file path"
    
    if (Test-Path $filePath) {
        $file = Get-Item $filePath
        Write-Host "`nCurrent Attributes: $($file.Attributes)"
        
        $change = Read-Host "`nDo you want to change attributes? (Y/N)"
        if ($change -eq 'Y' -or $change -eq 'y') {
            Write-Host "`nAvailable attributes: ReadOnly, Hidden, System, Archive"
            $attr = Read-Host "Enter attribute to set"
            Set-ItemProperty -Path $filePath -Name Attributes -Value $attr
            Write-Host "Attributes updated successfully!" -ForegroundColor Green
        }
    } else {
        Write-Host "File not found!" -ForegroundColor Red
    }
    Read-Host "`nPress Enter to continue"
}

function Manage-Directory {
    Write-Host "`n=== Current Directory Management ===" -ForegroundColor Green
    Write-Host "Current Directory: $(Get-Location)"
    
    $change = Read-Host "`nDo you want to change directory? (Y/N)"
    if ($change -eq 'Y' -or $change -eq 'y') {
        $newPath = Read-Host "Enter new directory path"
        if (Test-Path $newPath) {
            Set-Location $newPath
            Write-Host "Directory changed to: $(Get-Location)" -ForegroundColor Green
        } else {
            Write-Host "Directory not found!" -ForegroundColor Red
        }
    }
    Read-Host "`nPress Enter to continue"
}

function Copy-Files {
    Write-Host "`n=== Copy Files ===" -ForegroundColor Green
    $source = Read-Host "Enter source file path"
    $destination = Read-Host "Enter destination path"
    
    try {
        Copy-Item -Path $source -Destination $destination -Force
        Write-Host "File copied successfully!" -ForegroundColor Green
    } catch {
        Write-Host "Error copying file: $_" -ForegroundColor Red
    }
    Read-Host "`nPress Enter to continue"
}

function Delete-Files {
    Write-Host "`n=== Delete Files ===" -ForegroundColor Green
    $filePath = Read-Host "Enter file path to delete"
    
    if (Test-Path $filePath) {
        $confirm = Read-Host "Are you sure you want to delete this file? (Y/N)"
        if ($confirm -eq 'Y' -or $confirm -eq 'y') {
            Remove-Item -Path $filePath -Force
            Write-Host "File deleted successfully!" -ForegroundColor Green
        }
    } else {
        Write-Host "File not found!" -ForegroundColor Red
    }
    Read-Host "`nPress Enter to continue"
}

function List-Directory {
    Write-Host "`n=== List Directory Contents ===" -ForegroundColor Green
    $dirPath = Read-Host "Enter directory path (or press Enter for current directory)"
    
    if ($dirPath -eq "") {
        $dirPath = Get-Location
    }
    
    if (Test-Path $dirPath) {
        Get-ChildItem -Path $dirPath | Format-Table -AutoSize
    } else {
        Write-Host "Directory not found!" -ForegroundColor Red
    }
    Read-Host "`nPress Enter to continue"
}

function Create-Directory {
    Write-Host "`n=== Create Directory ===" -ForegroundColor Green
    $dirPath = Read-Host "Enter new directory path"
    
    try {
        New-Item -Path $dirPath -ItemType Directory -Force | Out-Null
        Write-Host "Directory created successfully!" -ForegroundColor Green
    } catch {
        Write-Host "Error creating directory: $_" -ForegroundColor Red
    }
    Read-Host "`nPress Enter to continue"
}

function Move-Files {
    Write-Host "`n=== Move Files ===" -ForegroundColor Green
    $source = Read-Host "Enter source file path"
    $destination = Read-Host "Enter destination path"
    
    try {
        Move-Item -Path $source -Destination $destination -Force
        Write-Host "File moved successfully!" -ForegroundColor Green
    } catch {
        Write-Host "Error moving file: $_" -ForegroundColor Red
    }
    Read-Host "`nPress Enter to continue"
}

function Remove-Directory {
    Write-Host "`n=== Remove Directory ===" -ForegroundColor Green
    $dirPath = Read-Host "Enter directory path to remove"
    
    if (Test-Path $dirPath) {
        $confirm = Read-Host "Are you sure you want to remove this directory? (Y/N)"
        if ($confirm -eq 'Y' -or $confirm -eq 'y') {
            Remove-Item -Path $dirPath -Force
            Write-Host "Directory removed successfully!" -ForegroundColor Green
        }
    } else {
        Write-Host "Directory not found!" -ForegroundColor Red
    }
    Read-Host "`nPress Enter to continue"
}

function Rename-File {
    Write-Host "`n=== Rename File ===" -ForegroundColor Green
    $oldName = Read-Host "Enter current file path"
    $newName = Read-Host "Enter new file name"
    
    try {
        Rename-Item -Path $oldName -NewName $newName
        Write-Host "File renamed successfully!" -ForegroundColor Green
    } catch {
        Write-Host "Error renaming file: $_" -ForegroundColor Red
    }
    Read-Host "`nPress Enter to continue"
}

function Get-FilePermissions {
    Write-Host "`n=== Get File Permissions ===" -ForegroundColor Green
    $filePath = Read-Host "Enter file path"
    
    if (Test-Path $filePath) {
        $acl = Get-Acl -Path $filePath
        Write-Host "`nOwner: $($acl.Owner)"
        Write-Host "`nAccess Rules:"
        $acl.Access | Format-Table -AutoSize
    } else {
        Write-Host "File not found!" -ForegroundColor Red
    }
    Read-Host "`nPress Enter to continue"
}

function Set-FilePermissions {
    Write-Host "`n=== Set File Permissions ===" -ForegroundColor Green
    $filePath = Read-Host "Enter file path"
    
    if (Test-Path $filePath) {
        $username = Read-Host "Enter username to grant permissions"
        $permission = Read-Host "Enter permission (Read, Write, Modify, FullControl)"
        
        try {
            $acl = Get-Acl -Path $filePath
            $AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule($username, $permission, "Allow")
            $acl.SetAccessRule($AccessRule)
            Set-Acl -Path $filePath -AclObject $acl
            Write-Host "Permissions set successfully!" -ForegroundColor Green
        } catch {
            Write-Host "Error setting permissions: $_" -ForegroundColor Red
        }
    } else {
        Write-Host "File not found!" -ForegroundColor Red
    }
    Read-Host "`nPress Enter to continue"
}

function Save-AndChangeDirectory {
    Write-Host "`n=== Save and Change Directory ===" -ForegroundColor Green
    Write-Host "Current Directory: $(Get-Location)"
    Push-Location
    Write-Host "Directory saved to stack!"
    
    $newPath = Read-Host "Enter new directory path"
    if (Test-Path $newPath) {
        Set-Location $newPath
        Write-Host "Directory changed to: $(Get-Location)" -ForegroundColor Green
        Write-Host "Use Pop-Location to return to saved directory"
    } else {
        Write-Host "Directory not found!" -ForegroundColor Red
        Pop-Location
    }
    Read-Host "`nPress Enter to continue"
}

function Remove-Subdirectories {
    Write-Host "`n=== Remove Subdirectories ===" -ForegroundColor Green
    $dirPath = Read-Host "Enter parent directory path"
    
    if (Test-Path $dirPath) {
        $confirm = Read-Host "Are you sure you want to remove all subdirectories? (Y/N)"
        if ($confirm -eq 'Y' -or $confirm -eq 'y') {
            Remove-Item -Path "$dirPath\*" -Recurse -Force
            Write-Host "Subdirectories removed successfully!" -ForegroundColor Green
        }
    } else {
        Write-Host "Directory not found!" -ForegroundColor Red
    }
    Read-Host "`nPress Enter to continue"
}

function Replace-File {
    Write-Host "`n=== Replace File ===" -ForegroundColor Green
    $source = Read-Host "Enter source file path"
    $destination = Read-Host "Enter destination file path to replace"
    
    try {
        Copy-Item -Path $source -Destination $destination -Force
        Write-Host "File replaced successfully!" -ForegroundColor Green
    } catch {
        Write-Host "Error replacing file: $_" -ForegroundColor Red
    }
    Read-Host "`nPress Enter to continue"
}

function Show-DirectoryTree {
    Write-Host "`n=== Directory Structure ===" -ForegroundColor Green
    $dirPath = Read-Host "Enter directory path (or press Enter for current directory)"
    
    if ($dirPath -eq "") {
        $dirPath = Get-Location
    }
    
    if (Test-Path $dirPath) {
        tree $dirPath /F
    } else {
        Write-Host "Directory not found!" -ForegroundColor Red
    }
    Read-Host "`nPress Enter to continue"
}

function Copy-DirectoryTree {
    Write-Host "`n=== Copy Directory Tree ===" -ForegroundColor Green
    $source = Read-Host "Enter source directory path"
    $destination = Read-Host "Enter destination directory path"
    
    try {
        Copy-Item -Path $source -Destination $destination -Recurse -Force
        Write-Host "Directory tree copied successfully!" -ForegroundColor Green
    } catch {
        Write-Host "Error copying directory tree: $_" -ForegroundColor Red
    }
    Read-Host "`nPress Enter to continue"
}

function Main {
    do {
        Show-FileOpsMenu
        $choice = Read-Host "Enter your choice (1-17)"
        
        switch ($choice) {
            '1' { Manage-FileAttributes }
            '2' { Manage-Directory }
            '3' { Copy-Files }
            '4' { Delete-Files }
            '5' { List-Directory }
            '6' { Create-Directory }
            '7' { Move-Files }
            '8' { Remove-Directory }
            '9' { Rename-File }
            '10' { Get-FilePermissions }
            '11' { Set-FilePermissions }
            '12' { Save-AndChangeDirectory }
            '13' { Remove-Subdirectories }
            '14' { Replace-File }
            '15' { Show-DirectoryTree }
            '16' { Copy-DirectoryTree }
            '17' { return }
            default {
                Write-Host "`nInvalid choice! Please select 1-17." -ForegroundColor Red
                Start-Sleep -Seconds 2
            }
        }
    } while ($choice -ne '17')
}

Main
