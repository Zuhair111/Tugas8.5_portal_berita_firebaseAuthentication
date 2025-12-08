# Script untuk setup Firebase menggunakan FlutterFire CLI

Write-Host "=== Firebase Setup untuk Portal Berita ===" -ForegroundColor Green
Write-Host ""

# Check apakah FlutterFire CLI sudah terinstall
Write-Host "Checking FlutterFire CLI..." -ForegroundColor Yellow
$flutterfireInstalled = flutter pub global list | Select-String "flutterfire_cli"

if (-not $flutterfireInstalled) {
    Write-Host "Installing FlutterFire CLI..." -ForegroundColor Yellow
    dart pub global activate flutterfire_cli
    Write-Host "FlutterFire CLI installed!" -ForegroundColor Green
    Write-Host ""
} else {
    Write-Host "FlutterFire CLI already installed!" -ForegroundColor Green
    Write-Host ""
}

# Jalankan flutterfire configure
Write-Host "Running FlutterFire Configure..." -ForegroundColor Yellow
Write-Host "Silakan pilih proyek Firebase Anda dan platform yang ingin digunakan." -ForegroundColor Cyan
Write-Host ""

flutterfire configure

Write-Host ""
Write-Host "=== Setup Complete! ===" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Pastikan file google-services.json ada di android/app/" -ForegroundColor White
Write-Host "2. Aktifkan Email/Password di Firebase Console > Authentication" -ForegroundColor White
Write-Host "3. Jalankan: flutter clean && flutter pub get" -ForegroundColor White
Write-Host "4. Jalankan: flutter run" -ForegroundColor White
Write-Host ""
