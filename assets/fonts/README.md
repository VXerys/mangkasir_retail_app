# assets/fonts

Design system MangRitel memakai dua font, keduanya berlisensi
[SIL Open Font License 1.1](https://openfontlicense.org) sehingga boleh
di-bundle langsung ke dalam aplikasi.

| Family | Peran | Kenapa |
|---|---|---|
| **Inter** | Seluruh teks UI | Tinggi x besar → terbaca di layar padat dan jarak pandang tablet kasir |
| **JetBrainsMono** | Angka, harga, KPI, struk | Lebar karakter tetap → kolom harga sejajar sempurna di tabel |

## File yang wajib ada

```
Inter-Regular.ttf        (400)
Inter-Medium.ttf         (500)
Inter-SemiBold.ttf       (600)
Inter-Bold.ttf           (700)
JetBrainsMono-Regular.ttf (400)
JetBrainsMono-Bold.ttf    (700)
```

Nama file harus **persis** seperti di atas — sudah didaftarkan di `pubspec.yaml`.
Build akan gagal dengan `unable to locate asset entry` kalau ada yang hilang.

## Cara mengambilnya

Jalankan sekali dari root repo:

```bash
pwsh tool/fetch_fonts.ps1
```

Atau unduh manual:

- Inter — <https://github.com/rsms/inter/releases> (ambil folder
  `extras/ttf/`, salin 4 file statis di atas — **bukan** file variable
  `InterVariable.ttf`)
- JetBrains Mono — <https://github.com/JetBrains/JetBrainsMono/releases>
  (folder `fonts/ttf/`)

## Kenapa di-bundle, bukan `google_fonts`

Aplikasi ini offline-first. Package `google_fonts` mengunduh font saat runtime,
jadi pemakaian pertama tanpa internet akan jatuh ke font fallback sistem —
angka jadi tidak tabular dan seluruh tabel POS bergeser. Bundle lokal
menghilangkan kelas bug itu sepenuhnya.

## Catatan versi kontrol

File `.ttf` sengaja **ikut di-commit**. Ukurannya kecil (~1,5 MB total) dan ini
menjamin setiap developer serta pipeline CI mendapat rendering yang identik
tanpa langkah unduh tambahan.
