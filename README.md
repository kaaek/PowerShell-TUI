# PowerShell Utility

A menu-driven PowerShell utility for system administration, file management, network operations, and data analysis tasks on Windows systems. Assignment submission for EECE 503J at MSFEA in AUB.

## Table of Contents

- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [Modules](#modules)
- [Security Notes](#security-notes)

## Features

### System Information
- View detailed system configuration
- Display computer, processor, and memory information
- Monitor disk drives and storage space
- View network configuration
- Display hostname, date, and time

### File Operations
- Manage file attributes (ReadOnly, Hidden, System, Archive)
- Navigate and manage directories
- Copy, move, rename, and delete files
- List directory contents
- Create and remove directories
- Get and set file permissions
- Display directory tree structure
- Copy entire directory trees

### Network Tools
- View password and logon restrictions
- Display server/workgroup settings
- View user account details
- Start, stop, and restart services
- Display network statistics
- Manage shared resource connections

### Process Management
- View all running processes
- Monitor CPU and memory usage
- Terminate processes by name or ID
- Start new processes
- Display top CPU-consuming processes
- Display top memory-consuming processes

### Data Analysis
- Search for strings within files
- Search for strings within directories
- Sort file contents (ascending, descending, unique)
- Compare two files and display differences
- Display file contents
- Advanced pattern matching with filtering

### Account Management
- View all user accounts
- Display detailed account information
- View account expiration dates
- Create local user accounts
- Create local administrator accounts
- Change user passwords
- Lock and unlock user accounts
- Set or modify account expiration dates
- Delete user accounts
- Add users to administrator group

## Installation

1. **Clone or download** the repository to your local machine:
   ```powershell
   git clone <repository-url>
   ```

2. **Navigate** to the project directory:
   ```powershell
   cd PowerShell-Utility
   ```

3. **Set execution policy** (if needed):
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```

## Usage

### Starting the Application

Launch the main menu by executing:
```powershell
.\MainMenu.ps1
```

### Navigation

1. The main menu displays numbered options (1-7)
2. Enter the number corresponding to your desired module
3. Each module has its own submenu with specific functions
4. Follow the on-screen prompts for each operation
5. Use option `12` or similar in submenus to return to the main menu
6. Select option `7` from the main menu to exit

### Example Workflow

```powershell
# 1. Launch the application
.\MainMenu.ps1

# 2. Select System Information (option 1)
Enter your choice (1-7): 1

# 3. View computer basic information (option 2)
Enter your choice (1-10): 2

# 4. Press Enter to return to the submenu
# 5. Return to main menu (option 10)
# 6. Exit (option 7)
```

## Modules

### MainMenu.ps1
The entry point of the application. Displays the main menu and routes user selections to appropriate module scripts.

**Key Functions:**
- `Show-MainMenu` - Displays the main interface
- `Main` - Controls program flow and navigation

---

### SystemInfo.ps1
Provides comprehensive system information and configuration details.

**Available Operations:**
1. Display detailed configuration information
2. Get computer basic information
3. Get processor information
4. Get installed memory information
5. Get disk drives information
6. Display host name
7. Display TCP/IP network configuration
8. Display current date
9. Display current time

**Key Functions:**
- `Get-DetailedConfiguration` - System-wide configuration
- `Get-ComputerBasicInfo` - Computer, BIOS, and OS information
- `Get-ProcessorInfo` - CPU details and specifications
- `Get-MemoryInfo` - RAM usage and physical memory details
- `Get-DiskInfo` - Disk drive information and storage capacity

---

### FileOps.ps1
Comprehensive file and directory management operations.

**Available Operations:**
1. Display or change file attributes
2. Display or change current directory
3. Copy files
4. Delete files
5. List files and subdirectories
6. Create a directory
7. Move files
8. Remove a directory
9. Rename a file
10. Get file permissions
11. Set file permissions
12. Save current directory then change it
13. Remove subdirectories
14. Replace a file
15. Display directory structure
16. Copy files and directory trees

**Key Functions:**
- `Manage-FileAttributes` - View and modify file attributes
- `Copy-Files` - File copying with error handling
- `Delete-Files` - Safe file deletion with confirmation
- `List-Directory` - Enhanced directory listing
- `Get-FilePermissions` - Display NTFS permissions
- `Set-FilePermissions` - Modify file access control

---

### NetworkTools.ps1
Network configuration and service management utilities.

**Available Operations:**
1. View password & logon restrictions
2. Display server or workgroup settings
3. View user account details
4. Stop and start a service
5. Display network statistics
6. Manage shared resource connections

**Key Functions:**
- `Get-PasswordRestrictions` - Display password policies
- `Get-ServerSettings` - Domain and workgroup information
- `Manage-Service` - Start, stop, and restart Windows services
- `Get-NetworkStatistics` - Network connection statistics
- `Manage-SharedConnections` - View and manage network shares

---

### ProcessMgmt.ps1
Process monitoring and management capabilities.

**Available Operations:**
1. View list of running processes
2. Kill a particular process
3. Start a new process
4. View processes consuming most CPU
5. View processes consuming most memory

**Key Functions:**
- `Get-RunningProcesses` - List all active processes with details
- `Stop-TargetProcess` - Terminate processes by name or ID
- `Start-NewProcess` - Launch new applications
- `Get-TopCPUProcesses` - Display CPU-intensive processes
- `Get-TopMemoryProcesses` - Display memory-intensive processes

---

### DataAnalysis.ps1
Text processing and data analysis utilities.

**Available Operations:**
1. Search for a string within a file
2. Search for a string within a directory
3. Sort the contents of a text file
4. Search for a specific string in a text file
5. Compare two files and display differences
6. Display the contents of a text file
7. Display message 'Hello, World!'

**Key Functions:**
- `Search-StringInFile` - Pattern matching within files
- `Search-StringInDirectory` - Recursive directory search
- `Sort-FileContents` - Sort and filter file contents
- `Compare-Files` - File comparison and diff display
- `Display-FileContents` - Read and display text files

---

### AccountMgmt.ps1
User account creation, modification, and management.

**Available Operations:**
1. View list of all user accounts
2. View account details for specific user
3. View account expiration dates
4. Create a local user account
5. Create a local administrator account
6. Change a user's password
7. Lock or unlock a user account
8. Set or modify account expiration dates
9. Delete a local user account
10. Delete account and remove user data
11. Add user to local administrator group

**Key Functions:**
- `Get-AllUserAccounts` - List all local user accounts
- `Get-UserAccountDetails` - Detailed account information
- `New-LocalUserAccount` - Create standard user accounts
- `New-LocalAdminAccount` - Create administrator accounts
- `Set-UserPassword` - Password management
- `Lock-UnlockAccount` - Account status management
- `Set-AccountExpiration` - Configure account expiry
- `Remove-UserAccount` - Delete user accounts

## Security Notes

### Administrator Privileges
Many operations require elevated permissions. Run PowerShell as Administrator for full functionality:
- Right-click PowerShell
- Select "Run as Administrator"

### Execution Policy
The script execution policy must allow running local scripts:
```powershell
# Check current policy
Get-ExecutionPolicy

# Set policy if needed (RemoteSigned or Unrestricted)
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```