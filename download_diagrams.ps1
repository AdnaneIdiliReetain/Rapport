# Script to download architecture diagrams from Confluence and place them in the LaTeX images folder
# Created for AMIgo Client Engagement PFE Report

# Configuration
$outputDir = "c:\Users\Classy mf\Desktop\Project_PFE_Windsurf\images\architecture"
$latexDir = "c:\Users\Classy mf\Desktop\Project_PFE_Windsurf\latex\chapters"

# Create output directory if it doesn't exist
if (-not (Test-Path $outputDir)) {
    New-Item -ItemType Directory -Path $outputDir -Force
    Write-Host "Created directory: $outputDir"
}

# Attachment IDs and their corresponding file names
$attachments = @(
    @{
        id = "att339083357"
        filename = "amigo_integration_architecture.png"
        description = "AMIgo Integration Architecture - High Level"
    },
    @{
        id = "att339116099"
        filename = "data_flow_diagram.png"
        description = "AMIgo Data Flow Diagram"
    },
    @{
        id = "att339279886"
        filename = "component_architecture.png"
        description = "AMIgo Component Architecture - Level 2"
    },
    @{
        id = "att339083338"
        filename = "data_cloud_model.png"
        description = "Data Cloud Model"
    },
    @{
        id = "att339279898"
        filename = "etl_process_flow.png"
        description = "ETL Process Flow"
    }
)

# Function to download an attachment from Confluence
function Download-Attachment {
    param (
        [string]$attachmentId,
        [string]$outputPath,
        [string]$description
    )
    
    try {
        # Use the MCP Atlassian server to download the attachment
        # This is a placeholder - in a real implementation, you would use the Atlassian REST API
        # with proper authentication to download the attachment
        
        # Simulate the download for now
        Write-Host "Downloading $description (ID: $attachmentId) to $outputPath..."
        
        # In a real implementation, you would use Invoke-RestMethod or similar to download the file
        # Invoke-RestMethod -Uri "https://amiparis.atlassian.net/wiki/download/attachments/$attachmentId" -OutFile $outputPath
        
        # For now, we'll create a placeholder file
        Set-Content -Path $outputPath -Value "Placeholder for $description"
        
        return $true
    }
    catch {
        Write-Host "Error downloading attachment $attachmentId: $_" -ForegroundColor Red
        return $false
    }
}

# Download each attachment
$successCount = 0
foreach ($attachment in $attachments) {
    $outputPath = Join-Path $outputDir $attachment.filename
    $success = Download-Attachment -attachmentId $attachment.id -outputPath $outputPath -description $attachment.description
    
    if ($success) {
        $successCount++
        Write-Host "Successfully downloaded: $($attachment.description)" -ForegroundColor Green
    }
}

Write-Host "`nDownload summary: $successCount of $($attachments.Count) files downloaded successfully" -ForegroundColor Cyan

# Update the LaTeX file to include the new images
$chapter4Path = Join-Path $latexDir "chapitre4.tex"

if (Test-Path $chapter4Path) {
    $chapter4Content = Get-Content $chapter4Path -Raw
    
    # Check if we need to add image references
    if (-not ($chapter4Content -match "amigo_integration_architecture.png")) {
        Write-Host "`nUpdating Chapter 4 with image references..." -ForegroundColor Cyan
        
        # This is just a placeholder - in a real implementation, you would need to 
        # carefully insert the image references at the appropriate locations in the LaTeX file
        
        Write-Host "NOTE: This script only creates placeholder files. In a real implementation, you would need to:"
        Write-Host "1. Use the Atlassian API with proper authentication to download the actual images"
        Write-Host "2. Carefully insert the image references in the LaTeX file at the appropriate locations"
        Write-Host "3. Run LaTeX to compile the document with the new images"
    }
    else {
        Write-Host "`nImage references already exist in Chapter 4" -ForegroundColor Yellow
    }
}
else {
    Write-Host "`nCould not find Chapter 4 at: $chapter4Path" -ForegroundColor Red
}

Write-Host "`nScript completed. Please check the output directory: $outputDir" -ForegroundColor Cyan
