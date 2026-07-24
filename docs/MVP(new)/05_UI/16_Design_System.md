---
id: ui-design-system
title: Design System
type: ui
parent: ui-screen-spec
tags: ui, design system
version: 1.0
---

# Tahap 16.0 — Perangkat Sasaran

Ditambahkan 24 Juli 2026, mendahului seluruh aturan di bawahnya.

Dokumen ini semula ditulis dengan **desktop POS** di kepala — terlihat pada
§16.1 poin 4 dan §16.4. Itu bertentangan dengan
[01_Product_Vision_And_Scope.md](../00_Project/01_Product_Vision_And_Scope.md)
yang menetapkan platform **Android, iOS, Web Admin** tanpa desktop sama sekali.
Vision doc yang menang. Seluruh aturan di bawah dibaca dengan tingkatan ini:

```
Tingkat 1 — Ponsel Android        (< 600 px)
Tingkat 2 — Tablet Android/iOS    (600–1439 px)
Tingkat 3 — Tablet + papan ketik & pemindai HID   (600–1439 px + perangkat luar)
```

Tidak ada tingkat PC/laptop. Ukuran jendela ≥ 1440 px hanya muncul di galeri
design system saat pengembangan, bukan di tangan kasir.

Konsekuensi yang mengikat:

- **Mobile-first, bukan desktop yang dikecilkan.** Navigasi utama di layar
  sempit berada di **bawah**, dalam jangkauan ibu jari — bukan di laci samping.
  Kasir memegang ponsel dengan satu tangan sambil tangan lain memegang barang.
- **Pindai barcode memakai kamera sebagai jalur utama.** Pemindai HID
  keyboard-wedge tetap didukung, tetapi sebagai Tingkat 3.
- **Pintasan papan ketik adalah lapisan opsional**, bukan syarat. Lihat §16.1
  poin 4 yang sudah diperbaiki.
- **Gestur adalah warga kelas satu**: geser-untuk-hapus, tarik-untuk-muat-ulang,
  tombol Back Android, dan menghindari papan ketik layar yang menutupi isian.

---

# Tahap 16.1 — UX Principle

Menurut saya ini harus ditulis dulu.

Misalnya.

## 1. Speed First

Kasir tidak boleh lebih dari

```
3 tap

untuk transaksi normal
```

---

## 2. Information First

Yang paling penting selalu muncul.

Contoh Product.

```
Nama

Harga

Stok

SKU
```

Bukan

```
Deskripsi panjang

Tag

Metadata
```

---

## 3. Large Touch Area

Button

minimal

```
44x44
```

agar nyaman digunakan di tablet.

---

## 4. Keyboard Friendly — *lapisan opsional, Tingkat 3*

Diperbaiki 24 Juli 2026. Bunyi lama "Desktop POS harus bisa dipakai tanpa
mouse" dicabut: tidak ada desktop di produk ini (§16.0).

Yang tetap berlaku: **bila** ada papan ketik fisik tersambung ke tablet, POS
harus bisa dijalankan tanpa menyentuh layar.

```
F2

↓

Cari Produk

F4

↓

Bayar

ESC

↓

Batal

CTRL + P

↓

Print
```

Dua syarat yang mengikat penerapannya:

- **Tidak ada aksi yang hanya bisa dicapai lewat pintasan.** Setiap pintasan
  adalah jalan pintas menuju tombol yang tetap terlihat di layar. Ponsel tidak
  punya tombol F2, dan tidak boleh kehilangan satu pun kemampuan karenanya.
- **Petunjuk pintasan hanya muncul saat papan ketik fisik terdeteksi.**
  Menuliskan "Tekan F2" pada layar sentuh murni adalah kebohongan kecil yang
  membuat pengguna mencari tombol yang tidak ada.

Pintasan yang melekat pada komponen — ESC menutup dialog, panah menjelajah
tabel dan daftar pilihan — tidak termasuk aturan ini. Keduanya tidak merugikan
di layar sentuh karena memang tidak terlihat.

---

## 5. Scan Friendly

Dua jalur, dengan urutan yang jelas.

**Jalur utama — kamera** (Tingkat 1 & 2). Kasir menekan tombol pindai, kamera
terbuka, hasilnya langsung masuk keranjang. Inilah yang dipakai mayoritas
pengguna, karena ponsel dan tablet selalu punya kamera dan jarang punya
pemindai.

**Jalur kedua — pemindai HID keyboard-wedge** (Tingkat 3). Pemindai mengetik
karakter lalu menekan Enter.

```
Barcode Scanner

↓

langsung fokus ke field.

Tidak perlu klik textbox.
```

Keduanya bermuara ke satu titik masuk yang sama di kode, supaya alur setelah
barcode terbaca — cari produk, tambahkan ke keranjang, tangani barcode tak
dikenal — tidak ditulis dua kali dan tidak menyimpang satu sama lain.

---

# Tahap 16.2 — Visual Language

Di sinilah identitas produk dibuat.

Bukan

```
Blue

Purple

Gradient
```

Tetapi menentukan karakter.

Contoh.

```
Industrial

Professional

Dense

Fast

Minimal Distraction
```

atau

```
Modern Retail

Friendly

Clean

Simple
```

Ini menentukan seluruh desain.

---

# Tahap 16.3 — Information Density

Ini sangat penting untuk POS.

Saya justru menyarankan.

```
High Density
```

karena kasir ingin melihat banyak data.

Misalnya tabel.

AI biasanya membuat.

```
10 row
```

Saya lebih suka

```
25–50 row
```

per halaman.

Catatan 24 Juli 2026: angka ini soal **ukuran halaman**, bukan jumlah baris yang
terlihat sekaligus. Di ponsel, baris setinggi 48 px berarti sekitar 12 baris
yang terlihat — dan itu benar, karena area sentuh tidak boleh dikorbankan demi
kepadatan (§16.1 poin 3). Yang tetap berlaku: jangan memotong daftar tiap 10
baris dan memaksa pengguna menghitung halaman. Kepadatan visual mengikuti
tingkat perangkat di §16.0, bukan satu angka untuk semua.

---

# Tahap 16.4 — Layout System

Saya tidak suka

```
Container

↓

1280px
```

Seperti dashboard SaaS.

Saya lebih suka.

```
Sidebar

+

Workspace

+

Inspector

+

Bottom Panel
```

Seperti software profesional.

Contoh:

```
VS Code

Photoshop

Excel

Figma
```

Karena POS adalah aplikasi kerja.

---

## Batas berlakunya

Diperbaiki 24 Juli 2026. Susunan empat panel di atas adalah bentuk **tablet
lanskap**, bukan bentuk universal. Menyempilkan sidebar, inspector, dan bottom
panel sekaligus ke layar 400 px menghasilkan aplikasi yang tidak bisa dipakai.

Yang berlaku per tingkat perangkat (§16.0):

| Ruang | Ponsel (< 600) | Tablet potret (600–1023) | Tablet lanskap (≥ 1024) |
| --- | --- | --- | --- |
| Navigasi utama | **Bilah bawah** | Rail ikon di kiri | Sidebar berlabel di kiri |
| Workspace | Seluruh layar | Sisa ruang | Sisa ruang |
| Inspector | Lembar bawah, dibuka manual | Laci kanan | Panel kanan tetap |
| Bottom panel | Menyatu ke workspace | Menyatu ke workspace | Panel bawah tetap |

Navigasi utama di ponsel memakai bilah bawah, **bukan laci samping**. Laci
samping adalah pola desktop yang dikecilkan: ia menyembunyikan tujuan navigasi
di balik satu ketukan tambahan, dan menaruhnya di pojok kiri atas — sudut
terjauh dari ibu jari.

Isi laci samping tetap berguna untuk hal yang jarang disentuh: ganti outlet,
setelan, keluar. Itu bukan navigasi utama.

---

# Tahap 16.5 — Component System

Saya tidak ingin membuat

```
Button

Input

Card
```

Saya ingin membuat

```
Business Component
```

Misalnya.

```
Product Card

Cart Panel

Payment Summary

Cash Drawer

Receipt Preview

Stock Badge

Price Badge

Purchase Timeline

Inventory Timeline
```

Ini jauh lebih bernilai.

---

# Tahap 16.6 — Design Token

Baru sekarang.

Tetapi token dibuat berdasarkan UX.

Misalnya.

Spacing.

Bukan

```
4

8

16

32
```

Tetapi.

```
Compact

Normal

Comfortable
```

Karena POS membutuhkan density berbeda.

---

Typography.

Bukan.

```
H1

H2

Body
```

Tetapi.

```
Receipt

Table

Form

Dashboard KPI

Dialog

Toolbar
```

---

# Color

Saya bahkan tidak ingin menentukan

```
Primary Blue
```

di awal.

Saya ingin menentukan semantic.

```
Success

Danger

Warning

Information

Neutral

Inventory

Finance

Sales
```

Nanti baru dipilih warnanya.

---

# Icon

Saya juga tidak ingin.

```
Box

Dollar

User
```

Saya ingin.

```
Stock Adjustment

Receiving

Purchase

Cash Session

Stock Opname
```

Icon berdasarkan domain.

---

# Motion

Tidak banyak animasi.

Saya ingin.

```
Instant

100 ms

150 ms
```

Bukan

```
400 ms

fade

scale

bounce
```

Karena POS harus cepat.

---

## Summary

This document defines the Design System and UX principles for the MVP Retail application, focusing on speed, information density, keyboard friendliness, and domain-specific semantic design.

## Related Domains

- [Business Domain Analysis](../01_Business/02_Business_Domain_Analysis.md) (influences the semantic colors and domain-specific icons)

## Related Processes

- N/A

## Related Entities

- N/A

## Related Database

- N/A

## Related API

- N/A

## Business Rules

- [Functional Specification](../01_Business/05_Functional_Spesification.md) (requirements for fast data entry and keyboard shortcuts in POS)

## References

- [Frontend Architecture](../02_Architecture/12_Frontend_Architecture.md)
- [Screen Specification](./15_Screen_Spesification.md)
