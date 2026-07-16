# error

Folder ini menyimpan definisi error dan failure yang dipakai di seluruh aplikasi. `Failure` adalah class untuk error yang dikembalikan ke BLoC (lewat `Either<Failure, T>`), sedangkan `Exception` untuk error teknis di layer data. Semua Repository wajib mengembalikan `Either<Failure, T>`, bukan melempar exception langsung ke UI.

Contoh file: `failures.dart`
