# Setup Firebase untuk Portal Berita Flutter

## Langkah-langkah Setup Firebase

### 1. Buat Proyek Firebase
1. Buka [Firebase Console](https://console.firebase.google.com/)
2. Klik **"Add project"** atau **"Create a project"**
3. Masukkan nama proyek (contoh: `portal-berita`)
4. Ikuti langkah-langkah sampai proyek dibuat

### 2. Aktifkan Firebase Authentication
1. Di Firebase Console, pilih proyek Anda
2. Klik **"Authentication"** di menu sidebar
3. Klik **"Get started"**
4. Di tab **"Sign-in method"**, aktifkan **"Email/Password"**
5. Klik **"Save"**

### 3. Setup untuk Android

#### A. Download google-services.json
1. Di Firebase Console, klik ikon Android atau **"Add app"**
2. Masukkan package name: `com.example.portal_berita_flutter`
   (Lihat di `android/app/build.gradle` pada `applicationId`)
3. Download file **`google-services.json`**
4. Letakkan file tersebut di folder: `android/app/google-services.json`

#### B. Update build.gradle Files

**File: `android/build.gradle.kts`**
Tambahkan di bagian `dependencies` (dalam block `buildscript`):
```kotlin
buildscript {
    dependencies {
        classpath("com.google.gms:google-services:4.4.0")
    }
}
```

**File: `android/app/build.gradle.kts`**
Tambahkan di bagian paling atas (setelah plugins):
```kotlin
plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")  // Tambahkan baris ini
}
```

Dan di bagian `defaultConfig`, pastikan minSdkVersion minimal 21:
```kotlin
defaultConfig {
    minSdk = 21  // Minimal 21 untuk Firebase
    targetSdk = flutter.targetSdkVersion
    // ...
}
```

### 4. Setup Firebase Options (PENTING!)

Setelah setup Android selesai, jalankan FlutterFire CLI untuk generate konfigurasi:

```bash
# Install FlutterFire CLI (jika belum)
dart pub global activate flutterfire_cli

# Generate firebase_options.dart
flutterfire configure
```

Pilih proyek Firebase Anda dan platform yang ingin digunakan (Android, iOS, Web, dll).

Atau update manual file `lib/firebase_options.dart` dengan credential dari Firebase Console:
- Android: Project Settings > Your apps > Android app
- Web: Project Settings > Your apps > Web app
- iOS: Project Settings > Your apps > iOS app

### 5. Verifikasi Setup

Setelah semua setup selesai:

```bash
flutter clean
flutter pub get
flutter run
```

### 6. Testing

1. Jalankan aplikasi
2. Buka halaman Register
3. Daftar dengan email dan password
4. Coba login dengan kredensial yang sama
5. Periksa Firebase Console > Authentication > Users untuk melihat user yang terdaftar

## Troubleshooting

### Error: Multidex
Jika muncul error multidex, tambahkan di `android/app/build.gradle.kts`:
```kotlin
defaultConfig {
    multiDexEnabled = true
}

dependencies {
    implementation("androidx.multidex:multidex:2.0.1")
}
```

### Error: MinSdkVersion
Pastikan `minSdk = 21` di `android/app/build.gradle.kts`

### Error: google-services.json not found
Pastikan file `google-services.json` ada di `android/app/`

## Fitur yang Tersedia

✅ **Registrasi** dengan email & password
✅ **Login** dengan email & password  
✅ **Logout** dari akun
✅ **Session management** otomatis
✅ **Error handling** yang informatif

## Catatan

- Firebase Authentication tidak memerlukan Laravel backend untuk autentikasi
- Data user disimpan di Firebase, bukan di database lokal
- Token Firebase digunakan untuk autentikasi
- Untuk fitur comment, Anda mungkin perlu menyesuaikan dengan user ID dari Firebase
