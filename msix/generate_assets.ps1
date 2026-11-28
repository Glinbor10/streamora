# Generates the MSIX tile/logo assets from the existing brand icon.
Add-Type -AssemblyName System.Drawing

$ErrorActionPreference = 'Stop'
$root = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$source = Join-Path $root 'assets\brand\icon-1024.png'
$outDir = Join-Path $PSScriptRoot 'Assets'

if (-not (Test-Path $source)) { throw "Brand icon not found: $source" }
New-Item -ItemType Directory -Force -Path $outDir | Out-Null

$image = [System.Drawing.Image]::FromFile($source)

function Save-Square {
  param([int]$Size, [string]$Name)
  $bitmap = New-Object System.Drawing.Bitmap($Size, $Size)
  $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
  $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
  $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
  $graphics.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
  $graphics.Clear([System.Drawing.Color]::Transparent)
  $graphics.DrawImage($image, 0, 0, $Size, $Size)
  $graphics.Dispose()
  $bitmap.Save((Join-Path $outDir $Name), [System.Drawing.Imaging.ImageFormat]::Png)
  $bitmap.Dispose()
}

function Save-Wide {
  param([int]$Width, [int]$Height, [int]$IconSize, [string]$Name)
  $bitmap = New-Object System.Drawing.Bitmap($Width, $Height)
  $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
  $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
  $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
  $graphics.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
  # Matches the app background (#0A1128) used by flutter_launcher_icons.
  $graphics.Clear([System.Drawing.Color]::FromArgb(255, 10, 17, 40))
  $x = [int](($Width - $IconSize) / 2)
  $y = [int](($Height - $IconSize) / 2)
  $graphics.DrawImage($image, $x, $y, $IconSize, $IconSize)
  $graphics.Dispose()
  $bitmap.Save((Join-Path $outDir $Name), [System.Drawing.Imaging.ImageFormat]::Png)
  $bitmap.Dispose()
}

Save-Square -Size 50 -Name 'StoreLogo.png'
Save-Square -Size 44 -Name 'Square44x44Logo.png'
Save-Square -Size 150 -Name 'Square150x150Logo.png'
Save-Square -Size 310 -Name 'Square310x310Logo.png'
Save-Wide -Width 310 -Height 150 -IconSize 110 -Name 'Wide310x150Logo.png'
Save-Wide -Width 620 -Height 300 -IconSize 180 -Name 'SplashScreen.png'

$image.Dispose()
Get-ChildItem $outDir -Filter *.png | Select-Object Name, Length | Format-Table -AutoSize
