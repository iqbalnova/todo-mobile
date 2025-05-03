# 📝 Todo App - Task Management

Todo App adalah aplikasi manajemen tugas sederhana berbasis Flutter yang dibangun dengan pendekatan **Clean Architecture** dan menggunakan **BLoC** sebagai state management. Aplikasi ini mendukung autentikasi pengguna, CRUD tugas, enkripsi lokal, serta fitur **backup dan restore otomatis** ke Firebase Firestore.

---

## 🚀 Fitur Utama

- 🔐 **User Authentication**

  - Login & Register menggunakan Firebase Authentication (Email & Password).

- 📋 **Task Management (CRUD)**

  - Tambah, edit, hapus, dan tandai tugas sebagai selesai/belum selesai.
  - Setiap tugas memiliki deskripsi dan tanggal tenggat.

- 🔒 **Penyimpanan Lokal Terenkripsi**

  - Menggunakan `sqflite_sqlcipher` untuk SQLite dengan enkripsi AES dari package `encrypt`.

- 🔐 **Secure Storage**

  - Menyimpan token dan informasi penting dengan aman menggunakan `flutter_secure_storage`.

- ⚡ **Performa Optimal**
  - Menggunakan `ListView.builder` untuk efisiensi dalam menampilkan banyak data.

## 🚀 Fitur Tambahan

- ☁️ **Backup & Restore Otomatis**

  - **Backup** otomatis ke Firebase Firestore saat pengguna sign out.
  - **Restore** otomatis dari Firebase Firestore saat login pertama kali.

- 🌗 **Dark Mode**
  - Mendukung tema terang dan gelap dengan `ThemeData`. Sesuai dengan system device.

---

## 🏗️ Struktur Folder (Clean Architecture)

lib/
├── core/
│ ├── common/ # Helper global (DatabaseHelper, ThemeHelper, dll)
│ ├── router/ # Konfigurasi routing
│ ├── splash/ # Splash screen
│ └── main_screen/ # Shell & layout utama
│
├── feature/
│ ├── auth/ # Fitur otentikasi (Firebase Auth)
│ │ ├── data/
│ │ ├── domain/
│ │ └── presentation/bloc/
│
│ └── home/ # Fitur utama (task & profile)
│ ├── data/
│ ├── domain/
│ └── presentation/
│ ├── bloc/
│ └── pages/
│
└── main.dart # Entry point aplikasi

---

## 🧪 Teknologi & Library

| Teknologi              | Keterangan                          |
| ---------------------- | ----------------------------------- |
| Flutter                | Framework utama                     |
| Firebase Auth          | Login & Register via email/password |
| Firestore              | Backup & Restore tugas              |
| BLoC                   | State management                    |
| sqflite_sqlcipher      | SQLite terenkripsi                  |
| encrypt                | Enkripsi data lokal (AES)           |
| flutter_secure_storage | Penyimpanan aman                    |
| get_it                 | Dependency Injection                |
| equatable              | Perbandingan objek lebih mudah      |
| intl                   | Format tanggal                      |

---

## 🔧 Cara Menjalankan Aplikasi

### 1. Clone Repository

```bash
git clone https://github.com/username/todo_app.git
cd todo_app
flutter pub get
flutter run
```
