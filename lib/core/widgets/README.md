# widgets

Widget global yang **terikat state atau service**, dipakai di banyak halaman.
Contoh yang akan tinggal di sini: `SyncStatusBanner` (mendengarkan `SyncBloc`),
`OfflineIndicator` (mendengarkan `ConnectivityService`).

Widget di sini boleh membaca BLoC, tapi tidak boleh punya business logic
sendiri — keputusan bisnis tetap milik UseCase.

## Bukan di sini

Primitive visual murni (tombol, isian, panel, lencana, keadaan kosong) ada di
`lib/core/design/components/`. Primitive itu stateless dan hanya membaca token,
sehingga bisa dirender di galeri design system tanpa menyiapkan DI apa pun.

Pembagiannya: kalau sebuah widget perlu `getIt` atau `BlocBuilder` untuk
menampilkan dirinya, tempatnya di sini. Kalau cukup dengan parameter, tempatnya
di `design/components/`.
