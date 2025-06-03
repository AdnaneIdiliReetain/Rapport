# Fast LaTeX Compilation Script
# This script optimizes LaTeX compilation for faster performance

# Configuration
$latexDir = "latex"
$outputDir = "output"
$mainFile = "main"
$fullCompile = $true # Set to $false for quick compilation (only one pdflatex run)

# Create timestamp for logging
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
Write-Host "[$timestamp] Starting optimized LaTeX compilation..." -ForegroundColor Cyan

# Change to LaTeX directory
Set-Location -Path $latexDir

# Create output directory if it doesn't exist
if (-not (Test-Path $outputDir)) {
    New-Item -ItemType Directory -Path $outputDir | Out-Null
    Write-Host "Created output directory: $outputDir" -ForegroundColor Green
}

# Function to measure execution time
function Measure-CommandWithOutput {
    param([scriptblock]$ScriptBlock, [string]$Description)
    
    Write-Host "Starting $Description..." -ForegroundColor Yellow
    $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
    
    & $ScriptBlock
    
    $stopwatch.Stop()
    Write-Host "$Description completed in $($stopwatch.Elapsed.TotalSeconds) seconds" -ForegroundColor Green
}

# Quick compile (just one pdflatex run)
if (-not $fullCompile) {
    Measure-CommandWithOutput -Description "Quick pdflatex compilation" -ScriptBlock {
        & pdflatex -synctex=1 -interaction=nonstopmode -output-directory=$outputDir $mainFile
    }
    
    # Copy the PDF to parent directory
    Copy-Item -Path "$outputDir\$mainFile.pdf" -Destination ".." -Force
    
    Write-Host "Quick compilation complete. PDF available at: ..\$mainFile.pdf" -ForegroundColor Green
    exit
}

# Full compilation (pdflatex, bibtex, pdflatex, pdflatex)
# First pdflatex run
Measure-CommandWithOutput -Description "First pdflatex run" -ScriptBlock {
    & pdflatex -synctex=1 -interaction=nonstopmode -output-directory=$outputDir $mainFile
}

# Bibtex run
Measure-CommandWithOutput -Description "BibTeX run" -ScriptBlock {
    Set-Location -Path $outputDir
    & bibtex $mainFile
    Set-Location -Path ".."
}

# Second pdflatex run
Measure-CommandWithOutput -Description "Second pdflatex run" -ScriptBlock {
    & pdflatex -synctex=1 -interaction=nonstopmode -output-directory=$outputDir $mainFile
}

# Third pdflatex run
Measure-CommandWithOutput -Description "Final pdflatex run" -ScriptBlock {
    & pdflatex -synctex=1 -interaction=nonstopmode -output-directory=$outputDir $mainFile
}

# Copy the PDF to parent directory
Copy-Item -Path "$outputDir\$mainFile.pdf" -Destination ".." -Force

# Final timestamp
$endTimestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
Write-Host "[$endTimestamp] LaTeX compilation complete!" -ForegroundColor Cyan
Write-Host "PDF available at: ..\$mainFile.pdf" -ForegroundColor Green

# Return to original directory
Set-Location -Path ".."
