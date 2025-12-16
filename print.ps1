# Set console output to UTF8 to ensure tree symbols print correctly
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$root = Get-Location

# --- CONFIGURATION ---

# 1. Folders to COMPLETELY HIDE (Garbage)
$hiddenFolders = @("build", ".dart_tool", ".git", ".idea", ".vscode", ".gradle", ".fvm", "coverage")

# 2. Folders to COLLAPSE (Show folder name, but hide contents)
$collapsedFolders = @("android", "ios", "windows", "linux", "macos", "web")

# 3. Extensions/Files to PRINT CONTENT
$allowedExtensions = @(".dart", ".yaml", ".md", ".gitignore", ".xml") # .xml included for AndroidManifest if needed, usually excluded by logic below
$allowedNames = @("pubspec.yaml", "analysis_options.yaml", ".gitignore", "README.md", "AndroidManifest.xml")

# 4. Files to IGNORE CONTENT
$ignoredFiles = @("pubspec.lock", "print.ps1")

# --- PART 1: PROJECT STRUCTURE (The Tree) ---

Write-Host "===== PROJECT STRUCTURE =====" -ForegroundColor Cyan

function Show-Tree {
    param (
        [string]$Path,
        [string]$Indent = "",
        [bool]$Last = $true
    )

    $name = Split-Path $Path -Leaf
    
    # Define tree characters compatible with older PowerShell
    $VBar   = [char]0x2502 # │
    $Tee    = [char]0x251C # ├
    $HBar   = [char]0x2500 # ─
    $Corner = [char]0x2514 # └
    
    # Build the marker
    $marker = if ($Last) { "$Corner$HBar$HBar " } else { "$Tee$HBar$HBar " }
    
    # Print the item
    if ($Indent -eq "") { 
        Write-Host "." -ForegroundColor Blue
    } else {
        Write-Host "$Indent$marker$name" -ForegroundColor Blue
    }

    # Stop if this is a collapsed folder (e.g., android, ios)
    if ($collapsedFolders -contains $name) { return }

    # Get content
    try {
        $items = Get-ChildItem -Path $Path -ErrorAction SilentlyContinue | 
            Where-Object { $hiddenFolders -notcontains $_.Name } |
            Sort-Object { $_.PSIsContainer } -Descending # Folders first, then files
            
        $count = $items.Count
        $i = 0

        foreach ($item in $items) {
            $i++
            $isLastItem = ($i -eq $count)
            $nextIndent = if ($Last) { "$Indent    " } else { "$Indent$VBar   " }
            
            if ($item.PSIsContainer) {
                Show-Tree -Path $item.FullName -Indent $nextIndent -Last $isLastItem
            } else {
                $fileMarker = if ($isLastItem) { "$Corner$HBar$HBar " } else { "$Tee$HBar$HBar " }
                Write-Host "$nextIndent$fileMarker$($item.Name)"
            }
        }
    } catch {}
}

Show-Tree -Path $root -Indent "" -Last $true


# --- PART 2: FILE CONTENTS ---

Write-Host "`n===== FILE CONTENTS =====" -ForegroundColor Cyan

# Recursive search
$allFiles = Get-ChildItem -Path $root -Recurse -File

foreach ($file in $allFiles) {
    $relPath = $file.FullName.Substring($root.Path.Length + 1)
    $parts = $relPath -split "\\"
    
    # 1. Skip files inside Hidden folders
    if ($parts | Where-Object { $hiddenFolders -contains $_ }) { continue }

    # 2. Skip files inside Collapsed folders (Don't print Android XMLs or iOS Pods)
    if ($parts | Where-Object { $collapsedFolders -contains $_ }) { continue }

    # 3. Filter for specific code files
    $isCode = ($allowedExtensions -contains $file.Extension.ToLower()) -or ($allowedNames -contains $file.Name)
    
    if ($isCode -and ($ignoredFiles -notcontains $file.Name)) {
        
        Write-Host "`n===== FILE: $relPath =====" -ForegroundColor Green
        try {
            Get-Content -Path $file.FullName -Raw
        } catch {
            Write-Host "[Binary or Unreadable]"
        }
    }
}