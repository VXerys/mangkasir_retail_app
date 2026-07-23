# constants

Konstanta **non-visual** yang dipakai lintas feature: alamat rute, kunci Hive,
nilai default bisnis, dan nama tabel remote.

File di sini tidak boleh berisi logic — hanya definisi nilai.

Contoh file: `app_routes.dart`

## Bukan di sini

Warna, ukuran font, spasi, dan ikon **tidak** tinggal di folder ini. Semuanya
ada di `lib/core/design/tokens/` dan diakses lewat `context.colors`,
`context.text`, `context.space`, serta `AppIcons`.

Alasannya: token visual butuh varian per tema dan per kerapatan, jadi bentuknya
harus `ThemeExtension` dan `InheritedWidget` — bukan konstanta statis.
