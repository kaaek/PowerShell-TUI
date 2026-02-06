function Show-AccountMgmtMenu {
    Clear-Host
    Write-Host "======================================" -ForegroundColor Cyan
    Write-Host "    Account Management Menu" -ForegroundColor Cyan
    Write-Host "======================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Choose from Menu" -ForegroundColor Yellow
    Write-Host "1- View list of all user accounts"
    Write-Host "2- View account details for specific user"
    Write-Host "3- View account expiration dates"
    Write-Host "4- Create a local user account"
    Write-Host "5- Create a local administrator account"
    Write-Host "6- Change a user's password"
    Write-Host "7- Lock or unlock a user account"
    Write-Host "8- Set or modify account expiration dates"
    Write-Host "9- Delete a local user account"
    Write-Host "10- Delete account and remove user data"
    Write-Host "11- Add user to local administrator group"
    Write-Host "12- Back to Main Menu"
    Write-Host ""
}

function Get-AllUserAccounts {
    Write-Host "`n=== All User Accounts ===" -ForegroundColor Green
    
    try {
        Get-LocalUser | Select-Object Name, Enabled, Description, LastLogon, PasswordLastSet | Format-Table -AutoSize
    } catch {
        Write-Host "Error retrieving user accounts: $_" -ForegroundColor Red
    }
    
    Read-Host "`nPress Enter to continue"
}

function Get-UserAccountDetails {
    Write-Host "`n=== User Account Details ===" -ForegroundColor Green
    
    $username = Read-Host "Enter username"
    
    try {
        $user = Get-LocalUser -Name $username -ErrorAction Stop
        Write-Host "`nAccount Details:" -ForegroundColor Yellow
        Write-Host "Name: $($user.Name)"
        Write-Host "Full Name: $($user.FullName)"
        Write-Host "Description: $($user.Description)"
        Write-Host "Enabled: $($user.Enabled)"
        Write-Host "Last Logon: $($user.LastLogon)"
        Write-Host "Password Last Set: $($user.PasswordLastSet)"
        Write-Host "Password Expires: $($user.PasswordExpires)"
        Write-Host "Account Expires: $($user.AccountExpires)"
        Write-Host "Password Changeable Date: $($user.PasswordChangeableDate)"
        Write-Host "Password Required: $($user.PasswordRequired)"
        Write-Host "User May Change Password: $($user.UserMayChangePassword)"
        Write-Host "`nGroup Memberships:" -ForegroundColor Yellow
        Get-LocalGroup | ForEach-Object {
            $group = $_
            $members = Get-LocalGroupMember -Group $group.Name -ErrorAction SilentlyContinue
            if ($members.Name -contains "$env:COMPUTERNAME\$username") {
                Write-Host "  - $($group.Name)"
            }
        }
    } catch {
        Write-Host "Error: User not found or access denied." -ForegroundColor Red
    }
    
    Read-Host "`nPress Enter to continue"
}

function Get-AccountExpirations {
    Write-Host "`n=== Account Expiration Dates ===" -ForegroundColor Green
    
    try {
        Get-LocalUser | Where-Object {$_.AccountExpires -ne $null} | 
            Select-Object Name, AccountExpires, Enabled | 
            Format-Table -AutoSize
    } catch {
        Write-Host "Error retrieving expiration dates: $_" -ForegroundColor Red
    }
    
    Read-Host "`nPress Enter to continue"
}

function New-LocalUserAccount {
    Write-Host "`n=== Create Local User Account ===" -ForegroundColor Green
    
    $username = Read-Host "Enter username"
    $fullName = Read-Host "Enter full name (optional)"
    $description = Read-Host "Enter description (optional)"
    
    $password = Read-Host "Enter password" -AsSecureString
    $confirmPassword = Read-Host "Confirm password" -AsSecureString
    
    # Compare passwords
    $pwd1 = [System.Net.NetworkCredential]::new('', $password).Password
    $pwd2 = [System.Net.NetworkCredential]::new('', $confirmPassword).Password
    
    if ($pwd1 -ne $pwd2) {
        Write-Host "Passwords do not match!" -ForegroundColor Red
        Read-Host "`nPress Enter to continue"
        return
    }
    
    try {
        $params = @{
            Name = $username
            Password = $password
            PasswordNeverExpires = $false
            UserMayNotChangePassword = $false
        }
        
        if ($fullName) { $params.FullName = $fullName }
        if ($description) { $params.Description = $description }
        
        New-LocalUser @params
        Write-Host "User account created successfully!" -ForegroundColor Green
    } catch {
        Write-Host "Error creating user account: $_" -ForegroundColor Red
    }
    
    Read-Host "`nPress Enter to continue"
}

function New-LocalAdminAccount {
    Write-Host "`n=== Create Local Administrator Account ===" -ForegroundColor Green
    
    $username = Read-Host "Enter username"
    $fullName = Read-Host "Enter full name (optional)"
    $description = Read-Host "Enter description (optional, default: Administrator Account)"
    
    if ($description -eq "") { $description = "Administrator Account" }
    
    $password = Read-Host "Enter password" -AsSecureString
    $confirmPassword = Read-Host "Confirm password" -AsSecureString
    
    $pwd1 = [System.Net.NetworkCredential]::new('', $password).Password
    $pwd2 = [System.Net.NetworkCredential]::new('', $confirmPassword).Password
    
    if ($pwd1 -ne $pwd2) {
        Write-Host "Passwords do not match!" -ForegroundColor Red
        Read-Host "`nPress Enter to continue"
        return
    }
    
    try {
        $params = @{
            Name = $username
            Password = $password
            Description = $description
            PasswordNeverExpires = $false
            UserMayNotChangePassword = $false
        }
        
        if ($fullName) { $params.FullName = $fullName }
        
        New-LocalUser @params
        
        Add-LocalGroupMember -Group "Administrators" -Member $username
        
        Write-Host "Administrator account created successfully!" -ForegroundColor Green
    } catch {
        Write-Host "Error creating administrator account: $_" -ForegroundColor Red
    }
    
    Read-Host "`nPress Enter to continue"
}

function Set-UserPassword {
    Write-Host "`n=== Change User Password ===" -ForegroundColor Green
    
    $username = Read-Host "Enter username"
    
    try {
        $user = Get-LocalUser -Name $username -ErrorAction Stop
        
        $newPassword = Read-Host "Enter new password" -AsSecureString
        $confirmPassword = Read-Host "Confirm new password" -AsSecureString
        
        $pwd1 = [System.Net.NetworkCredential]::new('', $newPassword).Password
        $pwd2 = [System.Net.NetworkCredential]::new('', $confirmPassword).Password
        
        if ($pwd1 -ne $pwd2) {
            Write-Host "Passwords do not match!" -ForegroundColor Red
            Read-Host "`nPress Enter to continue"
            return
        }
        
        Set-LocalUser -Name $username -Password $newPassword
        Write-Host "Password changed successfully!" -ForegroundColor Green
    } catch {
        Write-Host "Error changing password: $_" -ForegroundColor Red
    }
    
    Read-Host "`nPress Enter to continue"
}

function Toggle-UserAccountLock {
    Write-Host "`n=== Lock/Unlock User Account ===" -ForegroundColor Green
    
    $username = Read-Host "Enter username"
    
    try {
        $user = Get-LocalUser -Name $username -ErrorAction Stop
        
        Write-Host "`nCurrent Status: $(if ($user.Enabled) {'Unlocked (Enabled)'} else {'Locked (Disabled)'})"
        
        Write-Host "`nOptions:"
        Write-Host "1- Lock account (Disable)"
        Write-Host "2- Unlock account (Enable)"
        
        $choice = Read-Host "Choose option"
        
        switch ($choice) {
            '1' {
                Disable-LocalUser -Name $username
                Write-Host "Account locked successfully!" -ForegroundColor Green
            }
            '2' {
                Enable-LocalUser -Name $username
                Write-Host "Account unlocked successfully!" -ForegroundColor Green
            }
            default {
                Write-Host "Invalid option!" -ForegroundColor Red
            }
        }
    } catch {
        Write-Host "Error managing account lock status: $_" -ForegroundColor Red
    }
    
    Read-Host "`nPress Enter to continue"
}

function Set-AccountExpiration {
    Write-Host "`n=== Set Account Expiration Date ===" -ForegroundColor Green
    
    $username = Read-Host "Enter username"
    
    try {
        $user = Get-LocalUser -Name $username -ErrorAction Stop
        
        Write-Host "`nCurrent Expiration: $($user.AccountExpires)"
        
        Write-Host "`nOptions:"
        Write-Host "1- Set expiration date"
        Write-Host "2- Remove expiration (never expires)"
        
        $choice = Read-Host "Choose option"
        
        switch ($choice) {
            '1' {
                $expirationDate = Read-Host "Enter expiration date (MM/DD/YYYY)"
                try {
                    $date = [DateTime]::Parse($expirationDate)
                    Set-LocalUser -Name $username -AccountExpires $date
                    Write-Host "Expiration date set successfully!" -ForegroundColor Green
                } catch {
                    Write-Host "Invalid date format!" -ForegroundColor Red
                }
            }
            '2' {
                Set-LocalUser -Name $username -AccountNeverExpires
                Write-Host "Account set to never expire!" -ForegroundColor Green
            }
            default {
                Write-Host "Invalid option!" -ForegroundColor Red
            }
        }
    } catch {
        Write-Host "Error setting expiration date: $_" -ForegroundColor Red
    }
    
    Read-Host "`nPress Enter to continue"
}

function Remove-LocalUserAccount {
    Write-Host "`n=== Delete Local User Account ===" -ForegroundColor Green
    
    $username = Read-Host "Enter username to delete"
    
    try {
        $user = Get-LocalUser -Name $username -ErrorAction Stop
        
        Write-Host "`nUser Details:"
        Write-Host "Name: $($user.Name)"
        Write-Host "Full Name: $($user.FullName)"
        Write-Host "Description: $($user.Description)"
        
        $confirm = Read-Host "`nAre you sure you want to delete this account? (Y/N)"
        
        if ($confirm -eq 'Y' -or $confirm -eq 'y') {
            Remove-LocalUser -Name $username
            Write-Host "User account deleted successfully!" -ForegroundColor Green
        } else {
            Write-Host "Operation cancelled." -ForegroundColor Yellow
        }
    } catch {
        Write-Host "Error deleting user account: $_" -ForegroundColor Red
    }
    
    Read-Host "`nPress Enter to continue"
}

function Remove-UserAccountAndData {
    Write-Host "`n=== Delete Account and Remove User Data ===" -ForegroundColor Green
    
    $username = Read-Host "Enter username to delete"
    
    try {
        $user = Get-LocalUser -Name $username -ErrorAction Stop
        
        Write-Host "`nWARNING: This will delete the account AND all user data!" -ForegroundColor Red
        Write-Host "User: $($user.Name)"
        
        $confirm = Read-Host "`nType 'DELETE' to confirm"
        
        if ($confirm -eq 'DELETE') {
            # Delete user account
            Remove-LocalUser -Name $username
            
            # Try to remove user profile
            $userProfile = "C:\Users\$username"
            if (Test-Path $userProfile) {
                Remove-Item -Path $userProfile -Recurse -Force -ErrorAction SilentlyContinue
                Write-Host "User profile deleted." -ForegroundColor Green
            }
            
            Write-Host "User account and data deleted successfully!" -ForegroundColor Green
        } else {
            Write-Host "Operation cancelled." -ForegroundColor Yellow
        }
    } catch {
        Write-Host "Error deleting user account and data: $_" -ForegroundColor Red
    }
    
    Read-Host "`nPress Enter to continue"
}

function Add-UserToAdministrators {
    Write-Host "`n=== Add User to Administrators Group ===" -ForegroundColor Green
    
    $username = Read-Host "Enter username"
    
    try {
        $user = Get-LocalUser -Name $username -ErrorAction Stop
        
        # Check if already an administrator
        $adminMembers = Get-LocalGroupMember -Group "Administrators" -ErrorAction SilentlyContinue
        if ($adminMembers.Name -contains "$env:COMPUTERNAME\$username") {
            Write-Host "User is already a member of Administrators group!" -ForegroundColor Yellow
        } else {
            $confirm = Read-Host "`nAre you sure you want to add $username to Administrators? (Y/N)"
            
            if ($confirm -eq 'Y' -or $confirm -eq 'y') {
                Add-LocalGroupMember -Group "Administrators" -Member $username
                Write-Host "User added to Administrators group successfully!" -ForegroundColor Green
            } else {
                Write-Host "Operation cancelled." -ForegroundColor Yellow
            }
        }
    } catch {
        Write-Host "Error adding user to Administrators group: $_" -ForegroundColor Red
    }
    
    Read-Host "`nPress Enter to continue"
}

function Main {
    do {
        Show-AccountMgmtMenu
        $choice = Read-Host "Enter your choice (1-12)"
        
        switch ($choice) {
            '1' { Get-AllUserAccounts }
            '2' { Get-UserAccountDetails }
            '3' { Get-AccountExpirations }
            '4' { New-LocalUserAccount }
            '5' { New-LocalAdminAccount }
            '6' { Set-UserPassword }
            '7' { Toggle-UserAccountLock }
            '8' { Set-AccountExpiration }
            '9' { Remove-LocalUserAccount }
            '10' { Remove-UserAccountAndData }
            '11' { Add-UserToAdministrators }
            '12' { return }
            default {
                Write-Host "`nInvalid choice! Please select 1-12." -ForegroundColor Red
                Start-Sleep -Seconds 2
            }
        }
    } while ($choice -ne '12')
}

Main
