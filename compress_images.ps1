# Image Compression and Rasterization Script for LaTeX
# This script compresses and rasterizes images to improve LaTeX compilation speed

$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
Write-Host "[$timestamp] Starting image optimization..." -ForegroundColor Cyan

# Check if ImageMagick is installed
$imagemagickInstalled = $false
try {
    $magickVersion = magick -version
    $imagemagickInstalled = $true
    Write-Host "ImageMagick is installed: $magickVersion" -ForegroundColor Green
} catch {
    Write-Host "ImageMagick is not installed. Please install it to use this script." -ForegroundColor Red
    Write-Host "You can download it from: https://imagemagick.org/script/download.php" -ForegroundColor Yellow
    exit 1
}

# Create optimized images directory if it doesn't exist
$imagesDir = ".\latex\images"
$optimizedDir = ".\latex\images_optimized"

if (-not (Test-Path $optimizedDir)) {
    New-Item -Path $optimizedDir -ItemType Directory | Out-Null
    Write-Host "Created optimized images directory: $optimizedDir" -ForegroundColor Green
}

# Get all images in the images directory
$imageFiles = Get-ChildItem -Path $imagesDir -Include "*.png","*.jpg","*.jpeg","*.pdf" -Recurse

$totalImages = $imageFiles.Count
$processedImages = 0

Write-Host "Found $totalImages images to process" -ForegroundColor Yellow

foreach ($image in $imageFiles) {
    $processedImages++
    $outputFile = Join-Path -Path $optimizedDir -ChildPath $image.Name
    
    # Skip if optimized file exists and is newer than source
    if ((Test-Path $outputFile) -and ((Get-Item $outputFile).LastWriteTime -gt $image.LastWriteTime)) {
        Write-Host "[$processedImages/$totalImages] Skipping $($image.Name) (already optimized)" -ForegroundColor Gray
        continue
    }
    
    Write-Host "[$processedImages/$totalImages] Processing $($image.Name)..." -ForegroundColor Yellow
    
    # Compress and rasterize the image
    # Parameters:
    # -density 300: Set resolution to 300 DPI (higher quality for better readability)
    # -quality 95: JPEG quality at 95% (prioritizing quality over compression)
    # -resize 2000x2000>: Resize if larger than 2000x2000, maintaining aspect ratio
    # -strip: Remove metadata
    # -alpha remove: Remove alpha channel for better PDF compatibility
    
    try {
        if ($image.Extension -eq ".pdf") {
            # For PDF files, convert to PNG first
            magick convert -density 300 "$($image.FullName)" -quality 95 -resize "2000x2000>" -strip "$outputFile.png"
            Write-Host "  Converted PDF to PNG: $($outputFile).png" -ForegroundColor Green
        } else {
            # For other image formats
            magick convert "$($image.FullName)" -density 300 -quality 95 -resize "2000x2000>" -strip -alpha remove "$outputFile"
            Write-Host "  Optimized: $outputFile" -ForegroundColor Green
        }
    } catch {
        Write-Host "  Error processing $($image.Name): $_" -ForegroundColor Red
    }
}

Write-Host "Image optimization complete. Processed $processedImages images." -ForegroundColor Cyan
Write-Host "Optimized images are in: $optimizedDir" -ForegroundColor Green
Write-Host "To use these images in your LaTeX document, update the graphicspath in your main.tex file." -ForegroundColor Yellow
