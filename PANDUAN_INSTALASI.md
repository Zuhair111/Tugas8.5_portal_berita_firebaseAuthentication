# PANDUAN INSTALASI & MENJALANKAN APLIKASI
## Portal Berita Flutter dengan Firebase Authentication

---

## 📋 REQUIREMENTS

### Server (Laptop/PC)
- Windows 10/11 dengan Laragon atau XAMPP
- PHP 8.1 atau lebih tinggi
- MySQL/MariaDB
- Composer
- Git (opsional)

### Mobile Device
- Android 5.0 (API 21) atau lebih tinggi
- Minimal 50MB storage kosong
- Koneksi WiFi (harus satu jaringan dengan laptop)

### Tools Development (jika ingin build sendiri)
- Flutter SDK 3.9.2+
- Android SDK
- Windows Developer Mode (aktif)

---

## 🚀 CARA MENJALANKAN APLIKASI

### OPSI 1: Install APK yang Sudah Jadi (Termudah)

#### Langkah 1: Setup Server Laravel

1. **Copy file .env**
   ```powershell
   cd projeklaravel1
   copy .env.example .env
   ```

2. **Generate Application Key**
   ```powershell
   php artisan key:generate
   ```

3. **Konfigurasi Database (.env)**
   
   Buka file `.env` dan sesuaikan konfigurasi database:
   
   **Untuk MySQL/MariaDB:**
   ```env
   DB_CONNECTION=mysql
   DB_HOST=127.0.0.1
   DB_PORT=3306
   DB_DATABASE=portal_berita
   DB_USERNAME=root
   DB_PASSWORD=
   ```
   
   **Atau gunakan SQLite (lebih mudah untuk development):**
   ```env
   DB_CONNECTION=sqlite
   ```

4. **Buat Database** (jika pakai MySQL)
   - Buka phpMyAdmin (http://localhost/phpmyadmin)
   - Buat database baru bernama `portal_berita`

5. **Jalankan Migration & Seeder**
   ```powershell
   php artisan migrate
   php artisan db:seed
   ```
   
   Atau jika database sudah ada dan ingin reset:
   ```powershell
   php artisan migrate:fresh --seed
   ```

6. **Jalankan Laravel Server**
   
   **Pilihan A - Menggunakan Laragon Apache:**
   - Pastikan Laragon sudah running (start Apache & MySQL)
   - Server otomatis aktif di: `http://localhost/projekberita%20-%20Firebase/projeklaravel1/public`
   
   **Pilihan B - Menggunakan PHP Artisan:**
   ```powershell
   php artisan serve
   ```
   - Server akan berjalan di: `http://127.0.0.1:8000`

7. **Test API** (Opsional)
   
   Buka browser dan akses salah satu endpoint berikut:
   - `http://localhost/projekberita%20-%20Firebase/projeklaravel1/public/api/v1/categories`
   - Atau `http://127.0.0.1:8000/api/v1/categories` (jika pakai artisan serve)
   
   Jika API berjalan dengan baik, akan muncul data JSON kategori berita.

## B. Setup Flutter Application

1. **Install Dependencies**
   - Pastikan Laragon Apache sudah jalan
   - URL API: `http://localhost/projekberita%20-%20Firebase/projeklaravel1/public/api/v1`
   
   **Pilihan B - Menggunakan PHP artisan serve:**
   ```powershell
   cd projeklaravel1
   php artisan serve --host=0.0.0.0
   ```
   - URL API: `http://192.168.X.X:8000/api/v1`

#### Langkah 2: Dapatkan IP Address Laptop

1. **Buka PowerShell/CMD**
2. **Jalankan command:**
   ```powershell
   ipconfig
   ```
3. **Catat IPv4 Address** dari adapter WiFi Anda
   - Contoh: `192.168.100.203`
   - Biasanya dimulai dengan `192.168.` atau `10.`

#### Langkah 3: Install APK di Android

1. **Copy file APK** dari laptop ke HP
   - File lokasi: `portal_berita_flutter/build/app/outputs/flutter-apk/app-release.apk`
   - Transfer via USB, Bluetooth, Google Drive, atau WhatsApp

2. **Install APK di HP**
   - Buka file APK di HP
   - Jika muncul "Install from Unknown Sources", aktifkan
   - Klik Install dan tunggu selesai

3. **PENTING: Pastikan HP dan Laptop terhubung ke WiFi yang sama!**

#### Langkah 4: Test Aplikasi

1. **Buka aplikasi "Portal Berita"**
2. **Jika muncul error "Connection Refused":**
   - Berarti APK perlu di-rebuild dengan IP laptop Anda
   - Lanjut ke OPSI 2

---

### OPSI 2: Build APK dengan IP Address Anda

#### Langkah 1: Update Konfigurasi API

1. **Buka file:** `portal_berita_flutter/lib/config/api_config.dart`

2. **Edit IP address** sesuai IP laptop Anda:
   ```dart
   // Ganti dengan IP laptop Anda yang didapat dari ipconfig
   static const String physicalDevice = 'http://192.168.100.203/projekberita%20-%20Firebase/projeklaravel1/public/api/v1';
   
   // Gunakan physicalDevice untuk baseUrl
   static const String baseUrl = physicalDevice;
   ```

3. **Jika menggunakan php artisan serve:**
   ```dart
   static const String physicalDevice = 'http://192.168.100.203:8000/api/v1';
   ```

#### Langkah 2: Build APK

1. **Buka PowerShell di folder project**
   ```powershell
   cd "C:\laragon\www\projekberita - Firebase\portal_berita_flutter"
   ```

2. **Clean build cache** (opsional tapi direkomendasikan)
   ```powershell
   flutter clean
   ```

3. **Build APK Release**
   ```powershell
   flutter build apk --release
   ```

4. **Tunggu proses build selesai** (±2-3 menit)

5. **File APK akan tersimpan di:**
   ```
   build/app/outputs/flutter-apk/app-release.apk
   ```

#### Langkah 3: Install dan Test

- Ikuti Langkah 3-4 dari OPSI 1

---

## 🔧 TROUBLESHOOTING

### 1. Error "Connection Refused" atau "Failed to Fetch"

**Penyebab:**
- HP tidak terhubung ke WiFi yang sama dengan laptop
- IP address salah
- Laravel server tidak berjalan

**Solusi:**
1. Pastikan HP dan laptop di WiFi yang sama
2. Cek IP laptop dengan `ipconfig`
3. Rebuild APK dengan IP yang benar
4. Pastikan Laravel server berjalan:
   - Buka browser: `http://192.168.X.X/projekberita%20-%20Firebase/projeklaravel1/public/api/v1/news`
   - Harus menampilkan JSON data berita

### 2. Error "Building requires Developer Mode"

**Penyebab:**
- Windows Developer Mode belum aktif

**Solusi:**
1. Buka Windows Settings
   ```powershell
   start ms-settings:developers
   ```
2. Toggle "Developer Mode" ON
3. Tunggu instalasi selesai
4. Build ulang APK

### 3. APK Tidak Bisa di Install

**Penyebab:**
- Unknown Sources tidak diaktifkan

**Solusi:**
1. Settings → Security → Unknown Sources → ON
2. Atau klik "Install Anyway" saat muncul warning

### 4. Firebase Authentication Error

**Penyebab:**
- Firebase configuration tidak sesuai

**Solusi:**
1. Pastikan file `android/app/google-services.json` ada
2. Package name harus sama: `com.example.portal_berita_flutter`
3. Di Firebase Console, pastikan Email/Password authentication enabled

### 5. Gambar Tidak Muncul

**Penyebab:**
- URL gambar di database menggunakan localhost

**Solusi:**
1. Update URL gambar di database Laravel
2. Atau gunakan Laragon's virtual host untuk akses stabil

---

## 📱 FITUR APLIKASI

### Authentication (Firebase)
- ✅ Register dengan email & password
- ✅ Login dengan validasi Firebase
- ✅ Logout
- ✅ Auto-login jika sudah pernah login

### Manajemen Profil (CRUD)
- ✅ **Read**: Lihat informasi profil
- ✅ **Update**: Edit nama profil
- ✅ **Update**: Ganti password (dengan re-authentication)
- ✅ **Delete**: Hapus akun dengan konfirmasi

### Berita
- ✅ Lihat daftar berita (Featured, Trending, Latest)
- ✅ Baca detail artikel lengkap
- ✅ Filter by kategori
- ✅ Search berita
- ✅ View counter

### Komentar
- ✅ Lihat komentar artikel
- ✅ Post komentar (requires login)
- ✅ Delete komentar sendiri
- ✅ Integrasi Firebase user dengan Laravel

---

## 🔐 AKUN DEMO

### Admin Laravel (phpMyAdmin)
- Email: admin@portalberita.com
- Password: (sesuai seeder Anda)

### User Firebase (Aplikasi Mobile)
- Registrasi akun baru langsung di aplikasi
- Atau gunakan akun yang sudah terdaftar

---

## 🌐 TESTING DI BROWSER (Alternative)

Jika tidak punya Android device atau ingin test cepat:

1. **Update api_config.dart:**
   ```dart
   static const String baseUrl = laragonApache;
   ```

2. **Jalankan di Chrome:**
   ```powershell
   cd portal_berita_flutter
   flutter run -d chrome
   ```

3. **Akses via browser:**
   - Otomatis terbuka di Chrome
   - Gunakan localhost untuk API

---

## 📝 CATATAN PENTING

### Untuk Production/Deploy:
1. **Gunakan domain/IP static** bukan localhost
2. **Setup SSL/HTTPS** untuk keamanan
3. **Enable Firebase security rules**
4. **Aktifkan email verification**
5. **Setup proper CORS** di Laravel
6. **Optimize APK** dengan:
   ```powershell
   flutter build apk --split-per-abi --release
   ```

### IP Address Berubah?
Jika laptop ganti WiFi atau IP berubah:
1. Cek IP baru dengan `ipconfig`
2. Update `api_config.dart`
3. Rebuild APK
4. Install ulang di HP

### Alternatif: Gunakan Ngrok/LocalTunnel
Untuk testing tanpa batasan WiFi:
1. Install ngrok: https://ngrok.com/
2. Jalankan:
   ```bash
   ngrok http 80
   ```
3. Gunakan ngrok URL di `api_config.dart`

---

## 📞 KONTAK SUPPORT

Jika ada masalah atau pertanyaan:
- Email: [email Anda]
- GitHub: [link repository]
- WhatsApp: [nomor Anda]

---

**Dibuat:** 11 Desember 2025  
**Versi:** 1.0  
**Platform:** Flutter + Laravel + Firebase
