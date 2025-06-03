# Fast LaTeX Preview Script with Image Optimization
# This script provides a quick preview of the LaTeX document with optional image optimization

param (
    [switch]$OptimizeImages,
    [switch]$Draft = $true,
    [switch]$Clean = $false
)

$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
Write-Host "[$timestamp] Starting quick LaTeX preview..." -ForegroundColor Cyan

# Run image optimization if requested
if ($OptimizeImages) {
    Write-Host "Optimizing images for faster compilation..." -ForegroundColor Yellow
    try {
        # Return to project root if we're in the latex directory
        if ((Get-Location).Path -like "*\latex") {
            Set-Location ..
        }
        
        # Run the image optimization script
        & .\compress_images.ps1
        
        Write-Host "Image optimization completed." -ForegroundColor Green
    } catch {
        Write-Host "Error during image optimization: $_" -ForegroundColor Red
    }
}

# Clean auxiliary files if requested
if ($Clean) {
    Write-Host "Cleaning auxiliary files..." -ForegroundColor Yellow
    # Change to LaTeX directory if not already there
    if (-not ((Get-Location).Path -like "*\latex")) {
        Set-Location -Path "latex"
    }
    
    # Remove auxiliary files
    Remove-Item -Path "*.aux", "*.log", "*.out", "*.toc", "*.lof", "*.lot", "*.bbl", "*.blg", "*.synctex.gz" -ErrorAction SilentlyContinue
    Write-Host "Auxiliary files removed." -ForegroundColor Green
}

# Change to LaTeX directory if not already there
if (-not ((Get-Location).Path -like "*\latex")) {
    Set-Location -Path "latex"
}

# Run quick compilation
Write-Host "Running quick draft compilation..." -ForegroundColor Yellow

# Set draft mode options if enabled
if ($Draft) {
    # Draft mode uses faster settings
    pdflatex -interaction=nonstopmode -draftmode main.tex
} else {
    # Full mode for final output
    pdflatex -interaction=nonstopmode main.tex
}

# Check if compilation was successful
if (Test-Path "main.pdf") {
    Write-Host "Preview PDF generated successfully!" -ForegroundColor Green
    
    # Open the PDF file
    try {
        Start-Process "main.pdf"
        Write-Host "PDF opened for preview." -ForegroundColor Green
    } catch {
        Write-Host "Could not open PDF automatically. Please open manually." -ForegroundColor Red
    }
} else {
    Write-Host "Error: PDF generation failed. Check the log file for errors." -ForegroundColor Red
}

Write-Host "Quick preview process completed." -ForegroundColor Cyan