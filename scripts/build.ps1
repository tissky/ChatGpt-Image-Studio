Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$webDir = Join-Path $repoRoot "web"
$backendDir = Join-Path $repoRoot "backend"
$distDir = Join-Path $repoRoot "dist"

function Assert-LastExitCode {
  param(
    [string]$CommandName
  )

  if ($LASTEXITCODE -ne 0) {
    throw "$CommandName failed with exit code $LASTEXITCODE"
  }
}

Write-Host "[1/2] Building frontend..."
Push-Location $webDir
npm ci
Assert-LastExitCode "npm ci"
npm run build
Assert-LastExitCode "npm run build"
Pop-Location

Write-Host "[2/2] Building backend..."
New-Item -ItemType Directory -Path $distDir -Force | Out-Null
Push-Location $backendDir
go build -o (Join-Path $distDir "chatgpt2api-studio.exe") .
Assert-LastExitCode "go build"
Pop-Location

Write-Host "Build complete: $distDir"
