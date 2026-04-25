# migrate.ps1
# Run from the repo root:
#   powershell -ExecutionPolicy Bypass -File .\migrate.ps1

$ErrorActionPreference = "Stop"
$root = $PSScriptRoot

Write-Host ""
Write-Host "=== NetworkSwitchLab repo migration ===" -ForegroundColor Cyan

# ---------------------------------------------------------------------------
# SESSION 2 - flatten docs/session2/docs/* -> docs/session2/*
# ---------------------------------------------------------------------------

$s2src  = Join-Path $root "docs\session2\docs"
$s2dest = Join-Path $root "docs\session2"

if (Test-Path $s2src) {
    Write-Host ""
    Write-Host "[Session 2] Flattening nested docs folder..."

    foreach ($d in @("tasks", "reference")) {
        $srcDir  = Join-Path $s2src $d
        $destDir = Join-Path $s2dest $d
        if (Test-Path $srcDir) {
            if (-not (Test-Path $destDir)) { New-Item -ItemType Directory -Path $destDir | Out-Null }
            Get-ChildItem $srcDir -File | ForEach-Object {
                $destFile = Join-Path $destDir $_.Name
                Write-Host "  Moving $($_.Name) -> session2\$d\$($_.Name)"
                Move-Item $_.FullName $destFile -Force
            }
        }
    }

    # Move index.md from nested docs to session2 root
    $srcIndex  = Join-Path $s2src "index.md"
    $destIndex = Join-Path $s2dest "index.md"
    if (Test-Path $srcIndex) {
        Write-Host "  Moving index.md -> session2\index.md"
        Move-Item $srcIndex $destIndex -Force
    }

    # Promote overview/ files up to session2/ root
    $s2overview = Join-Path $s2src "overview"
    if (Test-Path $s2overview) {
        Get-ChildItem $s2overview -File | ForEach-Object {
            $destFile = Join-Path $s2dest $_.Name
            Write-Host "  Moving overview\$($_.Name) -> session2\$($_.Name)"
            Move-Item $_.FullName $destFile -Force
        }
        Remove-Item $s2overview -Force
    }

    # Remove now-empty nested docs folder
    Write-Host "  Removing empty nested folder: $s2src"
    Remove-Item $s2src -Recurse -Force

    Write-Host "[Session 2] Done." -ForegroundColor Green
} else {
    Write-Host "[Session 2] Nested docs folder not found - skipping." -ForegroundColor Yellow
}

# ---------------------------------------------------------------------------
# SESSION 3 - create folder structure with stub files
# ---------------------------------------------------------------------------

$s3base = Join-Path $root "docs\session3"

Write-Host ""
Write-Host "[Session 3] Creating folder structure..."

foreach ($d in @("tasks", "reference")) {
    $path = Join-Path $s3base $d
    if (-not (Test-Path $path)) {
        New-Item -ItemType Directory -Path $path | Out-Null
        Write-Host "  Created docs\session3\$d\"
    }
}

$stubs = @{
    "index.md"                     = "# Session 3: Spanning Tree Protocol`n`nSee tasks for lab content."
    "topology.md"                  = "# Topology`n`n<!-- Add topology diagram and link table here -->"
    "addressing.md"                = "# Addressing`n`n<!-- Add VLAN 10 and VLAN 11 address tables here -->"
    "tasks\part0.md"               = "# Part 0 - Base Configuration`n`n<!-- Add base config tasks here -->"
    "tasks\part1.md"               = "# Part 1 - Observe Natural Root Bridge Election`n`n<!-- Add Part 1 tasks here -->"
    "tasks\part2.md"               = "# Part 2 - Control Root Bridge Placement`n`n<!-- Add Part 2 tasks here -->"
    "tasks\part3.md"               = "# Part 3 - PVST+ Load Balancing`n`n<!-- Add Part 3 tasks here -->"
    "tasks\part4.md"               = "# Part 4 - PortFast and BPDU Guard`n`n<!-- Add Part 4 tasks here -->"
    "tasks\verify.md"              = "# Verification Summary`n`n<!-- Add verification commands here -->"
    "reference\commands.md"        = "# Command Reference`n`n<!-- Add command reference table here -->"
    "reference\troubleshooting.md" = "# Troubleshooting`n`n<!-- Add troubleshooting table here -->"
}

foreach ($file in $stubs.Keys) {
    $fullPath = Join-Path $s3base $file
    if (-not (Test-Path $fullPath)) {
        Set-Content -Path $fullPath -Value $stubs[$file] -Encoding UTF8
        Write-Host "  Created stub: session3\$file"
    } else {
        Write-Host "  Skipped (already exists): session3\$file" -ForegroundColor Yellow
    }
}

Write-Host "[Session 3] Done." -ForegroundColor Green

# ---------------------------------------------------------------------------
# Done
# ---------------------------------------------------------------------------

Write-Host ""
Write-Host "=== Migration complete ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:"
Write-Host "  1. Copy session3 lab content into docs\session3\tasks\ files"
Write-Host "  2. Copy topology and addressing into docs\session3\topology.md and addressing.md"
Write-Host "  3. Replace mkdocs.yml with the new version"
Write-Host "  4. Replace .github\workflows\deploy.yml with the new workflow"
Write-Host "  5. git add ."
Write-Host "  6. git commit -m 'Restructure to multi-session layout'"
Write-Host "  7. git push"
Write-Host ""
