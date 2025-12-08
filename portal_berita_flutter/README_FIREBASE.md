# 🔥 Portal Berita - Firebase Authentication Integration

Aplikasi Portal Berita dengan integrasi **Firebase Authentication** untuk fitur registrasi dan login.

## ✨ Fitur

- ✅ **Firebase Authentication** dengan Email & Password
- ✅ Registrasi user baru
- ✅ Login & Logout
- ✅ Session management otomatis
- ✅ Error handling yang informatif
- ✅ UI modern dan responsif
- ✅ Berita dari API Laravel
- ✅ Komentar artikel (memerlukan login)

---

## 🚀 Quick Start

### Prerequisites
- Flutter SDK (3.9.2 atau lebih baru)
- Dart SDK
- Android Studio / VS Code
- Akun Google (untuk Firebase Console)

### Setup Firebase (Pilih salah satu)

#### Opsi 1: Menggunakan Script Otomatis (Recommended)
```powershell
cd "c:\laragon\www\projekberita - Firebase\portal_berita_flutter"
.\setup_firebase.ps1
```

#### Opsi 2: Manual Setup
Lihat panduan lengkap di [QUICK_START.md](QUICK_START.md)

### Instalasi
```bash
# Clone atau download project

# Masuk ke folder project
cd portal_berita_flutter

# Install dependencies
flutter pub get

# Setup Firebase (jika belum)
# Lihat QUICK_START.md atau FIREBASE_SETUP.md

# Jalankan aplikasi
flutter run
```

---

## 📂 Struktur Proyek

```
lib/
├── main.dart                      # Entry point aplikasi + Firebase init
├── firebase_options.dart          # Konfigurasi Firebase (auto-generated)
├── config/
│   └── api_config.dart           # Konfigurasi API Laravel
├── models/
│   ├── article.dart              # Model artikel
│   ├── category.dart             # Model kategori
│   ├── user.dart                 # Model user
│   └── comment.dart              # Model komentar
├── screens/
│   ├── home_screen.dart          # Halaman utama
│   ├── login_screen.dart         # Halaman login (Firebase)
│   ├── register_screen.dart      # Halaman registrasi (Firebase)
│   ├── article_detail_screen.dart
│   ├── category_screen.dart
│   └── search_screen.dart
├── services/
│   ├── auth_service.dart         # Service Firebase Authentication
│   ├── api_service.dart          # Service API Laravel
│   └── comment_service.dart      # Service komentar
└── widgets/
    └── comment_section.dart      # Widget untuk menampilkan komentar

android/
├── app/
│   ├── build.gradle.kts          # Gradle config (dengan Firebase)
│   └── google-services.json      # Firebase config (dari console)
└── settings.gradle.kts           # Gradle settings (dengan Firebase plugin)
```

---

## 🔧 Konfigurasi

### 1. Firebase Configuration

File penting untuk Firebase:
- `lib/firebase_options.dart` - Konfigurasi Firebase (auto-generated oleh FlutterFire CLI)
- `android/app/google-services.json` - Konfigurasi Android (download dari Firebase Console)

### 2. API Configuration

Edit `lib/config/api_config.dart`:
```dart
class ApiConfig {
  static const String baseUrl = 'http://YOUR_IP:8000/api';
  // Contoh: 'http://192.168.1.100:8000/api'
}
```

---

## 🎯 Cara Menggunakan

### 1. Registrasi User Baru
1. Buka aplikasi
2. Tap icon profil di app bar
3. Pilih "Daftar"
4. Isi form:
   - Nama lengkap
   - Email
   - Password (minimal 6 karakter)
   - Konfirmasi password
5. Tap "Daftar"
6. User otomatis login setelah registrasi berhasil

### 2. Login
1. Tap icon profil di app bar
2. Masukkan email & password
3. Tap "Login"
4. Anda akan diarahkan kembali ke halaman sebelumnya

### 3. Logout
1. Tap icon profil di app bar
2. Pilih "Logout"

### 4. Komentar Artikel
1. Login terlebih dahulu
2. Buka artikel
3. Scroll ke bawah untuk melihat/menulis komentar

---

## 🔐 Firebase Authentication

### Metode Autentikasi
Saat ini mendukung:
- ✅ Email & Password

Bisa ditambahkan:
- ⬜ Google Sign-In
- ⬜ Facebook Login
- ⬜ Phone Number
- ⬜ Anonymous

### Auth Flow
```
Register: Input → Firebase createUser → Update DisplayName → Save to SharedPreferences → Success
Login: Input → Firebase signIn → Save to SharedPreferences → Success
Logout: Firebase signOut → Clear SharedPreferences → Success
```

---

## 🛠️ Development

### Dependencies Utama
```yaml
dependencies:
  firebase_core: ^3.8.1        # Firebase Core
  firebase_auth: ^5.3.3        # Firebase Authentication
  http: ^1.2.0                 # HTTP client
  shared_preferences: ^2.2.2   # Local storage
  provider: ^6.1.1             # State management
  cached_network_image: ^3.3.1 # Image caching
```

### Build & Run
```bash
# Development
flutter run

# Release (Android)
flutter build apk --release

# Release (iOS)
flutter build ios --release
```

---

## 📝 Error Handling

Aplikasi menangani berbagai error Firebase:

| Error Code | Message |
|------------|---------|
| `user-not-found` | Email tidak ditemukan |
| `wrong-password` | Password salah |
| `invalid-credential` | Email atau password salah |
| `email-already-in-use` | Email sudah terdaftar |
| `weak-password` | Password terlalu lemah |
| `invalid-email` | Email tidak valid |
| `user-disabled` | Akun telah dinonaktifkan |

---

## 🐛 Troubleshooting

### Firebase Errors

**Error: "No Firebase App '[DEFAULT]' has been created"**
- Pastikan `Firebase.initializeApp()` dipanggil di `main.dart`
- Cek `firebase_options.dart` sudah ada dan benar

**Error: "google-services.json is missing"**
- Download dari Firebase Console
- Letakkan di `android/app/google-services.json`

**Error: "PlatformException(error, An internal error...)"**
- Tambahkan SHA-1 certificate ke Firebase Console
- Dapatkan SHA-1: `cd android && ./gradlew signingReport`

### Build Errors

**Error: "Multidex"**
- Sudah ditangani di `build.gradle.kts`
- Coba: `flutter clean && flutter pub get`

**Error: "minSdkVersion"**
- Firebase memerlukan minSdk 21+
- Sudah diset di `build.gradle.kts`

---

## 📚 Resources

### Documentation
- [Firebase Auth Documentation](https://firebase.google.com/docs/auth)
- [FlutterFire Documentation](https://firebase.flutter.dev/)
- [Flutter Documentation](https://flutter.dev/docs)

### Tools
- [Firebase Console](https://console.firebase.google.com/)
- [FlutterFire CLI](https://firebase.flutter.dev/docs/cli/)

### Guides
- [QUICK_START.md](QUICK_START.md) - Panduan setup cepat
- [FIREBASE_SETUP.md](FIREBASE_SETUP.md) - Panduan setup detail

---

## 👥 Team

Dibuat sebagai bagian dari pembelajaran Firebase Authentication dengan Flutter.

---

## 📄 License

Project ini dibuat untuk keperluan edukasi.

---

## 🙏 Acknowledgments

- Firebase Team
- Flutter Team
- FlutterFire Contributors

---

**Happy Coding! 🚀**
