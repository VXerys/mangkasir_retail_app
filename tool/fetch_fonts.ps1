#requires -Version 5.1
<#
.SYNOPSIS
    Mengunduh font design system MangRitel ke assets/fonts/.

.DESCRIPTION
    Mengambil Inter dan JetBrains Mono (keduanya SIL OFL 1.1) dari release
    resmi di GitHub, lalu menyalin hanya file .ttf statis yang didaftarkan
    di pubspec.yaml. Aman dijalankan berulang kali — file yang sudah ada
    akan dilewati kecuali diberi -Force.

.EXAMPLE
    pwsh tool/fetch_fonts.ps1
    pwsh tool/fetch_fonts.ps1 -Force
#>
[CmdletBinding()]
param(
    [switch]$Force
)

$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'

$repoRoot = Split-Path -Parent $PSScriptRoot
$fontsDir = Join-Path $repoRoot 'assets/fonts'

$interVersion = '4.1'
$jetbrainsVersion = '2.304'

$expected = @(
    'Inter-Regular.ttf'
    'Inter-Medium.ttf'
    'Inter-SemiBold.ttf'
    'Inter-Bold.ttf'
    'JetBrainsMono-Regular.ttf'
    'JetBrainsMono-Bold.ttf'
)

if (-not (Test-Path $fontsDir)) {
    New-Item -ItemType Directory -Path $fontsDir | Out-Null
}

$missing = $expected | Where-Object { -not (Test-Path (Join-Path $fontsDir $_)) }
if ($missing.Count -eq 0 -and -not $Force) {
    Write-Host 'Semua font sudah ada. Pakai -Force untuk mengunduh ulang.' -ForegroundColor Green
    exit 0
}

$work = Join-Path ([System.IO.Path]::GetTempPath()) ("mangritel-fonts-" + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $work | Out-Null

function Expand-FromZip {
    param(
        [string]$Url,
        [string]$ZipName,
        [hashtable]$Map
    )

    $zip = Join-Path $work $ZipName
    $dest = Join-Path $work ([System.IO.Path]::GetFileNameWithoutExtension($ZipName))

    Write-Host "Mengunduh $ZipName ..." -ForegroundColor Cyan
    Invoke-WebRequest -Uri $Url -OutFile $zip
    Expand-Archive -Path $zip -DestinationPath $dest -Force

    foreach ($target in $Map.Keys) {
        $sourceLeaf = $Map[$target]
        $found = Get-ChildItem -Path $dest -Recurse -Filter $sourceLeaf |
            Select-Object -First 1

        if ($null -eq $found) {
            throw "Tidak menemukan '$sourceLeaf' di dalam $ZipName. Struktur release mungkin berubah — unduh manual sesuai assets/fonts/README.md."
        }

        Copy-Item -Path $found.FullName -Destination (Join-Path $fontsDir $target) -Force
        Write-Host "  -> $target" -ForegroundColor DarkGray
    }
}

try {
    Expand-FromZip `
        -Url "https://github.com/rsms/inter/releases/download/v$interVersion/Inter-$interVersion.zip" `
        -ZipName 'Inter.zip' `
        -Map @{
            'Inter-Regular.ttf'  = 'Inter-Regular.ttf'
            'Inter-Medium.ttf'   = 'Inter-Medium.ttf'
            'Inter-SemiBold.ttf' = 'Inter-SemiBold.ttf'
            'Inter-Bold.ttf'     = 'Inter-Bold.ttf'
        }

    Expand-FromZip `
        -Url "https://github.com/JetBrains/JetBrainsMono/releases/download/v$jetbrainsVersion/JetBrainsMono-$jetbrainsVersion.zip" `
        -ZipName 'JetBrainsMono.zip' `
        -Map @{
            'JetBrainsMono-Regular.ttf' = 'JetBrainsMono-Regular.ttf'
            'JetBrainsMono-Bold.ttf'    = 'JetBrainsMono-Bold.ttf'
        }

    Write-Host ''
    Write-Host 'Selesai. Jalankan: flutter pub get' -ForegroundColor Green
}
finally {
    Remove-Item -Path $work -Recurse -Force -ErrorAction SilentlyContinue
}
