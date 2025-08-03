<#
  This script builds and runs a Flutter application on a connected
  Android emulator or device. It assumes the Flutter SDK is installed
  and that an emulator is already running.
  Usage:
      .\build_and_run_flutter.ps1 -ProjectDir "C:\path\to\flutter\project"
#>

param (
    # Path to the root of the Flutter project. Defaults to the current working directory.
    [string]$ProjectDir = "."
)

# Resolve to an absolute path and verify it exists
$fullProjectPath = Resolve-Path -Path $ProjectDir -ErrorAction SilentlyContinue
if (-not $fullProjectPath) {
    Write-Host "ERROR: The specified project directory '$ProjectDir' does not exist." -ForegroundColor Red
    exit 1
}

# Ensure that the 'flutter' command is available
try {
    & flutter --version | Out-Null
} catch {
    Write-Host "ERROR: The 'flutter' command could not be found. Make sure the Flutter SDK is installed and added to your PATH." -ForegroundColor Red
    exit 1
}

# Change into the project directory
Push-Location $fullProjectPath.Path

Write-Host "Running 'flutter pub get' to fetch dependencies..." -ForegroundColor Cyan
& flutter pub get
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: 'flutter pub get' failed." -ForegroundColor Red
    Pop-Location
    exit 1
}

Write-Host "Launching the Flutter application on the connected device..." -ForegroundColor Cyan
# This builds the app and deploys it to the first available device/emulator
& flutter run
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: 'flutter run' failed." -ForegroundColor Red
    Pop-Location
    exit 1
}

Pop-Location

Write-Host "Flutter application launched successfully." -ForegroundColor Green
