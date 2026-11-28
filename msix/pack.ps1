# Builds an unsigned MSIX from the Flutter Windows Release build, ready for
# upload to Partner Center (Microsoft re-signs it after certification).
param(
  [Parameter(Mandatory = $false)]
  [ValidatePattern('^\d+\.\d+\.\d+\.\d+$')]
  [string]$Version = '1.0.0.0',

  [string]$Configuration = 'Release',

  [string]$OutDir = ''
)

$ErrorActionPreference = 'Stop'
$root = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
if ([string]::IsNullOrWhiteSpace($OutDir)) { $OutDir = Join-Path $root 'build\msix\output' }
$releaseDir = Join-Path $root "build\windows\x64\runner\$Configuration"
$stagingDir = Join-Path $root 'build\msix\staging'

if (-not (Test-Path (Join-Path $releaseDir 'streamora.exe'))) {
  throw "No streamora.exe in $releaseDir. Run 'flutter build windows --release' first."
}
if (-not (Test-Path (Join-Path $PSScriptRoot 'Assets\StoreLogo.png'))) {
  throw 'MSIX assets are missing. Run msix\generate_assets.ps1 first.'
}

if (Test-Path $stagingDir) { Remove-Item $stagingDir -Recurse -Force }
New-Item -ItemType Directory -Force -Path $stagingDir | Out-Null

Copy-Item (Join-Path $releaseDir '*') $stagingDir -Recurse -Force
Copy-Item (Join-Path $PSScriptRoot 'AppxManifest.xml') (Join-Path $stagingDir 'AppxManifest.xml') -Force
Copy-Item (Join-Path $PSScriptRoot 'Assets') (Join-Path $stagingDir 'Assets') -Recurse -Force

# Keep the manifest version in sync with the requested package version.
$manifest = Join-Path $stagingDir 'AppxManifest.xml'
$content = Get-Content $manifest -Raw
$content = $content -replace '(<Identity\b[^>]*\bVersion=")[^"]+(")', "`${1}$Version`${2}"
[System.IO.File]::WriteAllText($manifest, $content, (New-Object System.Text.UTF8Encoding($false)))

$makeappx = Get-ChildItem 'C:\Program Files (x86)\Windows Kits\10\bin\*\x64\makeappx.exe' `
  -ErrorAction SilentlyContinue | Sort-Object FullName -Descending |
  Select-Object -First 1 -ExpandProperty FullName
if (-not $makeappx) {
  throw 'makeappx.exe not found. Install the Windows SDK (App Development / MSI tools).'
}

New-Item -ItemType Directory -Force -Path $OutDir | Out-Null
$package = Join-Path $OutDir "streamore-windows-$Version.msix"
if (Test-Path $package) { Remove-Item $package -Force }

Write-Host "Packaging $releaseDir -> $package"
& $makeappx pack /d $stagingDir /p $package
if ($LASTEXITCODE -ne 0) { throw "makeappx failed with exit code $LASTEXITCODE" }

Write-Host "MSIX ready: $package"
Write-Host 'This package is intentionally unsigned; Microsoft Store re-signs it after certification.'
