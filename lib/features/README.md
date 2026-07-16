# features

Folder ini adalah tempat semua fitur aplikasi diletakkan, masing-masing dalam subfolder tersendiri. Setiap fitur mengikuti struktur Clean Architecture: `data/` (datasource + repository impl), `domain/` (entity + usecase + abstract repository), dan `presentation/` (BLoC + halaman + widget). Contoh fitur: `cashier/`, `products/`, `transactions/`.

Contoh subfolder: `cashier/`
