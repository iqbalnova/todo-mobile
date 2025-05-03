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

```
lib/
├── core/
│ ├── common/ # Helper global (DatabaseHelper, ThemeHelper, dll)
│ ├── router/ # Konfigurasi routing
│ ├── splash/ # Splash screen
│ └── main_screen/ # Shell & layout utama
│
├── feature/
│ ├── auth/ # Fitur otentikasi (Firebase Auth)
│ │ ├── data/ # Data layer (repository, data sources)
│ │ ├── domain/ # Domain layer (use cases, entities)
│ │ └── presentation/bloc/ # Presentation layer (BLoC, UI state management)
│
│ └── home/ # Fitur utama (task & profile)
│ ├── data/ # Data layer (repository, data sources)
│ ├── domain/ # Domain layer (use cases, entities)
│ └── presentation/ # Presentation layer (BLoC, UI)
│ ├── bloc/ # BLoC logic for state management
│ └── pages/ # UI pages/screens
│
└── main.dart # Entry point aplikasi
```

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

# 📸 Screenshots

Here are the screenshots of the app:

<p float="left">
  <img src="https://github.com/iqbalnova/todo-mobile/blob/main/public/todo%20(1).png" alt="Screenshot 1" width="250" />
  <img src="https://github.com/iqbalnova/todo-mobile/blob/main/public/todo%20(2).png" alt="Screenshot 2" width="250" /> 
  <img src="https://github.com/iqbalnova/todo-mobile/blob/main/public/todo%20(3).png" alt="Screenshot 3" width="250" />
</p>

<p float="left">
  <img src="https://github.com/iqbalnova/todo-mobile/blob/main/public/todo%20(4).png" alt="Screenshot 4" width="250" />
  <img src="https://github.com/iqbalnova/todo-mobile/blob/main/public/todo%20(5).png" alt="Screenshot 5" width="250" />
  <img src="https://github.com/iqbalnova/todo-mobile/blob/main/public/todo%20(6).png" alt="Screenshot 6" width="250" />
</p>

<p float="left">
  <img src="https://github.com/iqbalnova/todo-mobile/blob/main/public/todo%20(7).png" alt="Screenshot 7" width="250" />
  <img src="https://github.com/iqbalnova/todo-mobile/blob/main/public/todo%20(8).png" alt="Screenshot 8" width="250" />
  <img src="https://github.com/iqbalnova/todo-mobile/blob/main/public/todo%20(9).png" alt="Screenshot 9" width="250" />
</p>
