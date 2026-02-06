function Show-DataAnalysisMenu {
    Clear-Host
    Write-Host "======================================" -ForegroundColor Cyan
    Write-Host "       Data Analysis Menu" -ForegroundColor Cyan
    Write-Host "======================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Choose from Menu" -ForegroundColor Yellow
    Write-Host "1- Search for a string within a file"
    Write-Host "2- Search for a string within a directory"
    Write-Host "3- Sort the contents of a text file"
    Write-Host "4- Search for a specific string in a text file"
    Write-Host "5- Compare two files and display differences"
    Write-Host "6- Display the contents of a text file"
    Write-Host "7- Display message 'Hello, World!'"
    Write-Host "8- Back to Main Menu"
    Write-Host ""
}

function Search-StringInFile {
    Write-Host "`n=== Search String in File ===" -ForegroundColor Green
    
    $filePath = Read-Host "Enter file path"
    $searchString = Read-Host "Enter string to search"
    
    if (Test-Path $filePath) {
        Write-Host "`nSearch Results:" -ForegroundColor Yellow
        $results = Select-String -Path $filePath -Pattern $searchString -AllMatches
        
        if ($results) {
            $results | ForEach-Object {
                Write-Host "Line $($_.LineNumber): $($_.Line)" -ForegroundColor Cyan
            }
            Write-Host "`nTotal matches found: $($results.Count)" -ForegroundColor Green
        } else {
            Write-Host "No matches found." -ForegroundColor Yellow
        }
    } else {
        Write-Host "File not found!" -ForegroundColor Red
    }
    
    Read-Host "`nPress Enter to continue"
}

function Search-StringInDirectory {
    Write-Host "`n=== Search String in Directory ===" -ForegroundColor Green
    
    $dirPath = Read-Host "Enter directory path"
    $searchString = Read-Host "Enter string to search"
    $filePattern = Read-Host "Enter file pattern (e.g., *.txt, *.*, or press Enter for all files)"
    
    if ($filePattern -eq "") { $filePattern = "*.*" }
    
    if (Test-Path $dirPath) {
        Write-Host "`nSearching..." -ForegroundColor Yellow
        $results = Get-ChildItem -Path $dirPath -Filter $filePattern -Recurse -File -ErrorAction SilentlyContinue | 
                   Select-String -Pattern $searchString -ErrorAction SilentlyContinue
        
        if ($results) {
            $results | ForEach-Object {
                Write-Host "`nFile: $($_.Path)" -ForegroundColor Cyan
                Write-Host "Line $($_.LineNumber): $($_.Line)"
            }
            Write-Host "`nTotal matches found: $($results.Count)" -ForegroundColor Green
        } else {
            Write-Host "No matches found." -ForegroundColor Yellow
        }
    } else {
        Write-Host "Directory not found!" -ForegroundColor Red
    }
    
    Read-Host "`nPress Enter to continue"
}

function Sort-FileContents {
    Write-Host "`n=== Sort File Contents ===" -ForegroundColor Green
    
    $filePath = Read-Host "Enter file path"
    
    if (Test-Path $filePath) {
        Write-Host "`nOptions:"
        Write-Host "1- Sort ascending"
        Write-Host "2- Sort descending"
        Write-Host "3- Sort unique lines only"
        
        $sortOption = Read-Host "Choose sort option"
        
        $saveOption = Read-Host "`nSave sorted output to new file? (Y/N)"
        
        switch ($sortOption) {
            '1' { 
                $sorted = Get-Content $filePath | Sort-Object 
            }
            '2' { 
                $sorted = Get-Content $filePath | Sort-Object -Descending 
            }
            '3' { 
                $sorted = Get-Content $filePath | Sort-Object -Unique 
            }
            default { 
                Write-Host "Invalid option!" -ForegroundColor Red
                Read-Host "`nPress Enter to continue"
                return
            }
        }
        
        if ($saveOption -eq 'Y' -or $saveOption -eq 'y') {
            $outputPath = Read-Host "Enter output file path"
            $sorted | Out-File -FilePath $outputPath
            Write-Host "Sorted content saved to: $outputPath" -ForegroundColor Green
        } else {
            Write-Host "`nSorted Content:" -ForegroundColor Yellow
            $sorted | ForEach-Object { Write-Host $_ }
        }
    } else {
        Write-Host "File not found!" -ForegroundColor Red
    }
    
    Read-Host "`nPress Enter to continue"
}

function Search-SpecificString {
    Write-Host "`n=== Search Specific String ===" -ForegroundColor Green
    
    $filePath = Read-Host "Enter file path"
    $searchString = Read-Host "Enter string to search"
    
    if (Test-Path $filePath) {
        Write-Host "`nOptions:"
        Write-Host "1- Case-sensitive search"
        Write-Host "2- Case-insensitive search"
        Write-Host "3- Exact match only"
        
        $searchOption = Read-Host "Choose search option"
        
        switch ($searchOption) {
            '1' { 
                $results = Select-String -Path $filePath -Pattern $searchString -CaseSensitive 
            }
            '2' { 
                $results = Select-String -Path $filePath -Pattern $searchString 
            }
            '3' { 
                $results = Select-String -Path $filePath -Pattern "^$searchString$" 
            }
            default { 
                Write-Host "Invalid option!" -ForegroundColor Red
                Read-Host "`nPress Enter to continue"
                return
            }
        }
        
        if ($results) {
            Write-Host "`nMatches found:" -ForegroundColor Yellow
            $results | ForEach-Object {
                Write-Host "Line $($_.LineNumber): $($_.Line)" -ForegroundColor Cyan
            }
            Write-Host "`nTotal matches: $($results.Count)" -ForegroundColor Green
        } else {
            Write-Host "No matches found." -ForegroundColor Yellow
        }
    } else {
        Write-Host "File not found!" -ForegroundColor Red
    }
    
    Read-Host "`nPress Enter to continue"
}

function Compare-Files {
    Write-Host "`n=== Compare Files ===" -ForegroundColor Green
    
    $file1 = Read-Host "Enter first file path"
    $file2 = Read-Host "Enter second file path"
    
    if ((Test-Path $file1) -and (Test-Path $file2)) {
        Write-Host "`nComparing files..." -ForegroundColor Yellow
        
        $diff = Compare-Object -ReferenceObject (Get-Content $file1) -DifferenceObject (Get-Content $file2)
        
        if ($diff) {
            Write-Host "`nDifferences found:" -ForegroundColor Yellow
            $diff | ForEach-Object {
                if ($_.SideIndicator -eq '<=') {
                    Write-Host "< $($_.InputObject)" -ForegroundColor Red
                } else {
                    Write-Host "> $($_.InputObject)" -ForegroundColor Green
                }
            }
        } else {
            Write-Host "`nFiles are identical!" -ForegroundColor Green
        }
    } else {
        Write-Host "One or both files not found!" -ForegroundColor Red
    }
    
    Read-Host "`nPress Enter to continue"
}

function Display-FileContents {
    Write-Host "`n=== Display File Contents ===" -ForegroundColor Green
    
    $filePath = Read-Host "Enter file path"
    
    if (Test-Path $filePath) {
        Write-Host "`nFile: $filePath" -ForegroundColor Yellow
        Write-Host "----------------------------------------"
        Get-Content $filePath | ForEach-Object { Write-Host $_ }
        Write-Host "----------------------------------------"
    } else {
        Write-Host "File not found!" -ForegroundColor Red
    }
    
    Read-Host "`nPress Enter to continue"
}

function Display-HelloWorld {
    Write-Host "`n=== Message Display ===" -ForegroundColor Green
    Write-Host "`nHello, World!" -ForegroundColor Cyan
    Read-Host "`nPress Enter to continue"
}

function Main {
    do {
        Show-DataAnalysisMenu
        $choice = Read-Host "Enter your choice (1-8)"
        
        switch ($choice) {
            '1' { Search-StringInFile }
            '2' { Search-StringInDirectory }
            '3' { Sort-FileContents }
            '4' { Search-SpecificString }
            '5' { Compare-Files }
            '6' { Display-FileContents }
            '7' { Display-HelloWorld }
            '8' { return }
            default {
                Write-Host "`nInvalid choice! Please select 1-8." -ForegroundColor Red
                Start-Sleep -Seconds 2
            }
        }
    } while ($choice -ne '8')
}

Main
