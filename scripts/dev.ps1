Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$webDir = Join-Path $repoRoot "web"
$backendDir = Join-Path $repoRoot "backend"

function Assert-LastExitCode {
  param(
    [string]$CommandName
  )

  if ($LASTEXITCODE -ne 0) {
    throw "$CommandName failed with exit code $LASTEXITCODE"
  }
}

Write-Host "[1/2] Building frontend static assets..."
Push-Location $webDir
npm ci
Assert-LastExitCode "npm ci"
npm run build
Assert-LastExitCode "npm run build"
Pop-Location

Write-Host "[2/2] Starting backend on configured port..."
Push-Location $backendDir
go run .
Assert-LastExitCode "go run ."
Pop-Location
