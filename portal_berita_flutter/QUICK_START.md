# Quick Start - Firebase Authentication

## 🚀 Setup Cepat (Menggunakan FlutterFire CLI)

### 1. Jalankan Script Setup
```bash
cd "c:\laragon\www\projekberita - Firebase\portal_berita_flutter"
.\setup_firebase.ps1
```

Script ini akan:
- Install FlutterFire CLI (jika belum)
- Generate `firebase_options.dart` otomatis
- Download `google-services.json` otomatis

### 2. Aktifkan Email/Password Authentication
1. Buka [Firebase Console](https://console.firebase.google.com/)
2. Pilih proyek Anda
3. Klik **Authentication** > **Sign-in method**
4. Aktifkan **Email/Password**
5. Klik **Save**

### 3. Jalankan Aplikasi
```bash
flutter clean
flutter pub get
flutter run
```

---

## 📱 Manual Setup (Jika Script Gagal)

### Langkah 1: Buat Proyek Firebase
1. Buka [Firebase Console](https://console.firebase.google.com/)
2. Klik **"Add project"**
3. Beri nama proyek (contoh: `portal-berita`)
4. Ikuti langkah wizard

### Langkah 2: Tambahkan Android App
1. Di Firebase Console, klik ikon Android
2. Package name: `com.example.portal_berita_flutter`
3. Download `google-services.json`
4. Letakkan di: `android/app/google-services.json`

### Langkah 3: Aktifkan Authentication
1. Klik **Authentication** di sidebar
2. Klik **Get started**
3. Tab **Sign-in method**
4. Aktifkan **Email/Password**

### Langkah 4: Update firebase_options.dart
Buka file `lib/firebase_options.dart` dan ganti dengan credential dari Firebase Console:

```dart
static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'COPY_FROM_FIREBASE_CONSOLE',
  appId: 'COPY_FROM_FIREBASE_CONSOLE',
  messagingSenderId: 'COPY_FROM_FIREBASE_CONSOLE',
  projectId: 'YOUR_PROJECT_ID',
  storageBucket: 'YOUR_PROJECT_ID.appspot.com',
);
```

**Cara mendapatkan credential:**
1. Firebase Console > Project Settings (⚙️)
2. Scroll ke bawah ke bagian "Your apps"
3. Pilih Android app Anda
4. Lihat "SDK setup and configuration"

### Langkah 5: Run
```bash
flutter clean
flutter pub get
flutter run
```

---

## ✅ Testing

1. **Register User Baru**
   - Buka aplikasi
   - Tekan tombol profil/login
   - Pilih "Daftar"
   - Isi form registrasi
   - Klik "Daftar"

2. **Cek di Firebase Console**
   - Buka Firebase Console > Authentication > Users
   - User baru akan muncul di sini

3. **Login**
   - Logout dari aplikasi
   - Login dengan email & password yang tadi

---

## 🐛 Troubleshooting

### Error: "No Firebase App '[DEFAULT]' has been created"
**Solusi:** Pastikan `firebase_options.dart` sudah benar dan `Firebase.initializeApp()` sudah dipanggil di `main.dart`

### Error: "google-services.json is missing"
**Solusi:** Download `google-services.json` dari Firebase Console dan letakkan di `android/app/`

### Error: "Multidex error"
**Solusi:** Sudah ditambahkan di `build.gradle.kts`, coba:
```bash
flutter clean
flutter pub get
cd android
./gradlew clean
cd ..
flutter run
```

### Error: "PlatformException(error, An internal error has occurred...)"
**Solusi:** 
1. Pastikan SHA-1 certificate sudah ditambahkan di Firebase Console
2. Untuk debug, dapatkan SHA-1:
```bash
cd android
./gradlew signingReport
```
3. Copy SHA-1 dan tambahkan di Firebase Console > Project Settings > Your apps > Android app

---

## 📝 Fitur yang Tersedia

✅ **Registrasi** - Daftar dengan email & password  
✅ **Login** - Masuk dengan kredensial  
✅ **Logout** - Keluar dari akun  
✅ **Session** - Tetap login otomatis  
✅ **Error Handling** - Pesan error yang jelas

---

## 💡 Tips

- **Development**: Gunakan email dummy (test@example.com) untuk testing
- **Production**: Aktifkan email verification di Firebase Console
- **Security**: Tambahkan password reset functionality
- **UI**: Screen login/register sudah ada dan siap pakai

---

## 📚 Resources

- [Firebase Documentation](https://firebase.google.com/docs)
- [FlutterFire Documentation](https://firebase.flutter.dev/)
- [Firebase Console](https://console.firebase.google.com/)
