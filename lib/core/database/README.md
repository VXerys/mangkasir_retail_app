# database

Folder ini menyimpan konfigurasi utama database lokal berbasis Drift (SQLite). Di sini ada definisi `AppDatabase` — satu class yang mendaftarkan semua tabel dan DAO yang dipakai aplikasi. Hanya boleh ada satu instance (singleton) sepanjang app berjalan.

Contoh file: `app_database.dart`
