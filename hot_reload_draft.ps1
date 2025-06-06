# Hot Reload LaTeX Compilation Script (Draft Mode)
# This script watches for changes in .tex files and automatically compiles in draft mode
# with optimized error reporting for image sizing and overflow issues

$texDir = ".\latex"
$mainFile = "main.tex"
$fullPath = Join-Path $texDir $mainFile
$lastCompileTime = Get-Date

# Create temp file to hold draft version
$draftFile = Join-Path $texDir "main_draft.tex"

# Store files we've already seen modified to avoid recompiling the same files
$alreadyCompiled = @{}

# Function to extract warnings and errors related to images and boxes
function Extract-ImageAndBoxIssues {
    param (
        [string]$logFile
    )
    
    $content = Get-Content $logFile -Raw
    
    # Extract various types of warnings we care about
    $overFullBoxes = Select-String -Pattern "Overfull \\(h|v)box" -InputObject $content -AllMatches
    $underFullBoxes = Select-String -Pattern "Underfull \\(h|v)box" -InputObject $content -AllMatches
    $floatWarnings = Select-String -Pattern "Float too large for page" -InputObject $content -AllMatches
    $imageErrors = Select-String -Pattern "(! LaTeX Error: Cannot determine size of graphic|No BoundingBox)" -InputObject $content -AllMatches
    
    Write-Host "`n--- IMAGE & BOX ISSUES ---" -ForegroundColor Yellow
    
    if ($overFullBoxes.Matches.Count -gt 0) {
        Write-Host "`nOverfull boxes (content too wide/tall):" -ForegroundColor Red
        # Limit to showing just the first 10 to avoid overwhelming output
        for ($i = 0; $i -lt [Math]::Min(10, $overFullBoxes.Matches.Count); $i++) {
            Write-Host "  $($overFullBoxes.Matches[$i].Value)" -ForegroundColor Red
        }
        if ($overFullBoxes.Matches.Count -gt 10) {
            Write-Host "  ... and $($overFullBoxes.Matches.Count - 10) more" -ForegroundColor Red
        }
    }
    
    if ($underFullBoxes.Matches.Count -gt 0) {
        Write-Host "`nUnderfull boxes (content too small/sparse):" -ForegroundColor Yellow
        # Limit to showing just the first 10
        for ($i = 0; $i -lt [Math]::Min(10, $underFullBoxes.Matches.Count); $i++) {
            Write-Host "  $($underFullBoxes.Matches[$i].Value)" -ForegroundColor Yellow
        }
        if ($underFullBoxes.Matches.Count -gt 10) {
            Write-Host "  ... and $($underFullBoxes.Matches.Count - 10) more" -ForegroundColor Yellow
        }
    }
    
    if ($floatWarnings.Matches.Count -gt 0) {
        Write-Host "`nFloat sizing issues:" -ForegroundColor Red
        foreach ($match in $floatWarnings.Matches) {
            Write-Host "  $($match.Value)" -ForegroundColor Red
        }
    }
    
    if ($imageErrors.Matches.Count -gt 0) {
        Write-Host "`nImage errors:" -ForegroundColor Red
        foreach ($match in $imageErrors.Matches) {
            Write-Host "  $($match.Value)" -ForegroundColor Red
        }
    }
    
    Write-Host "`n----------------------" -ForegroundColor Yellow
}

# Create a draft version of the main file with draft option
function Create-DraftVersion {
    $content = Get-Content $fullPath -Raw
    
    # Replace documentclass line to add draft option
    $draftContent = $content -replace "\\documentclass\[(.*?)\]", "\documentclass[`$1,draft]"
    
    # Optional: Turn off some features that slow down compilation
    $draftContent = $draftContent -replace "\\tableofcontents", "% \tableofcontents (disabled in draft mode)"
    $draftContent = $draftContent -replace "\\listoffigures", "% \listoffigures (disabled in draft mode)"
    $draftContent = $draftContent -replace "\\listoftables", "% \listoftables (disabled in draft mode)"
    
    # Write the draft content to the draft file
    $draftContent | Set-Content $draftFile
    
    return $draftFile
}

# Compile the document
function Compile-Document {
    $draftFilePath = Create-DraftVersion
    
    Write-Host "Compiling draft version..." -ForegroundColor Cyan
    
    # Change to the latex directory and compile
    Push-Location $texDir
    
    # Run pdflatex with options to continue despite errors
    $process = Start-Process -FilePath "pdflatex" -ArgumentList "-interaction=nonstopmode", "-file-line-error", "main_draft.tex" -NoNewWindow -Wait -PassThru
    
    # Check for the log file
    $logFile = "main_draft.log"
    if (Test-Path $logFile) {
        Extract-ImageAndBoxIssues -logFile $logFile
    }
    
    # Return to the original directory
    Pop-Location
    
    return $process.ExitCode
}

# Wait for user to press Enter to start monitoring
Write-Host "Press Enter to start monitoring for file changes..." -ForegroundColor Green
$null = Read-Host

# Initial compilation
Write-Host "Starting hot reload LaTeX compiler in draft mode" -ForegroundColor Green
Write-Host "Focus: Image size optimization and box warnings" -ForegroundColor Green
Write-Host "Press Ctrl+C to stop" -ForegroundColor Green
$exitCode = Compile-Document

# Clear the already compiled hash after the initial compilation
$alreadyCompiled = @{}

# Watch for changes and recompile
try {
    while ($true) {
        Start-Sleep -Seconds 2

        # Get all modified .tex files since last compile time except main_draft.tex
        $changedFiles = Get-ChildItem -Path $texDir -Include "*.tex" -Exclude "main_draft.tex" -Recurse | 
                        Where-Object { $_.LastWriteTime -gt $lastCompileTime }
                        
        # Skip compilation if no files have changed or if only system-generated files changed
        if ($changedFiles.Count -gt 0) {
            # Check if any actual user files changed (not just auto-generated ones)
            $userFilesChanged = $false
            $changedUserFiles = @()
            
            foreach ($file in $changedFiles) {
                # Skip already compiled files in this cycle
                if ($alreadyCompiled.ContainsKey($file.FullName)) {
                    continue
                }
                
                # Skip temporary files and auto-generated files
                if ($file.Name -notmatch "_draft\.tex$" -and 
                    $file.Name -notmatch "\.(aux|log|out|toc|lof|lot)$") {
                    $userFilesChanged = $true
                    $changedUserFiles += $file
                    $alreadyCompiled[$file.FullName] = $true
                }
            }
            
            if ($userFilesChanged) {
                Write-Host "`nDetected changes in the following files:" -ForegroundColor Cyan
                $changedUserFiles | ForEach-Object { Write-Host "  $($_.Name)" }
                
                $lastCompileTime = Get-Date
                $exitCode = Compile-Document
                
                if ($exitCode -eq 0) {
                    Write-Host "Compilation successful!" -ForegroundColor Green
                } else {
                    Write-Host "Compilation completed with issues. Check the log for details." -ForegroundColor Yellow
                }
                
                # Clear the already compiled hash after each compilation cycle
                $alreadyCompiled = @{}
            }
        }
    }
} finally {
    # Clean up the draft file when the script is terminated
    if (Test-Path $draftFile) {
        Remove-Item $draftFile
    }
} 