<!-- DIHASILKAN OTOMATIS — jangan edit file ini.
     Ubah context/roadmap.yaml lalu jalankan: tool\context\ctx.bat sync -->

# MangRitel — di mana proyek ini sekarang

_Sumber: `context/roadmap.yaml` · diperbarui 2026-08-07T06:20:02Z_

## 🔄 Aplikasi Flutter — fase aktif UI-6 · Identity dan Organisasi Nyata

`8/10` task selesai (80%)

> Mengganti sesi pengembangan dengan identitas Supabase dan menuntaskan konteks business, outlet, pengguna, serta peran sebelum modul operasional bergantung kepadanya

Berikutnya:

1. `ui6-device-rbac` Buktikan login, deep link terlarang, menu berbasis izin, ganti outlet, dan logout di ponsel serta tablet Android/iOS _(UI-6)_
2. `ui6-quality-gate` [Phase Verification & Quality Gate] Jalankan automated test, manual acceptance, regression test, requirement verification, dan scope-specific integration test (auth Supabase nyata, RBAC lintas role, isolasi tenant di device Android/iOS); kumpulkan bukti sebelum fase dinyatakan DONE _(UI-6)_
3. `ui11-pos-catalog` Halaman /sales/pos responsif dengan ProductCard, pencarian/scan, filter kategori, harga-varian, stok tersedia, dan katalog outlet aktif _(UI-11)_

## ⬜ Backend Supabase — fase aktif BE-1 · Quality Gate Kontrak Inti

`0/7` task selesai (0%)

> Menutup 12 quality gate identity, product-catalog, dan CRM sebelum UI nyata mengikat kontrak auth, tenant, dan master data

Berikutnya:

1. `be1-gate-has-permission` Uji public.has_permission() untuk user global maupun user spesifik outlet, termasuk bypass Owner _(BE-1)_
2. `be1-gate-rls-tenant` Uji RLS lintas tenant: bisnis A tidak bisa membaca role, katalog, atau customer milik bisnis B _(BE-1)_
3. `be1-gate-price-trigger` Buktikan trigger histori harga menulis baris baru ke product_prices saat harga produk diubah _(BE-1)_

## Sedang dikerjakan

_Tidak ada task berstatus in_progress._

## Semua fase sekilas

**Aplikasi Flutter**

- ✅ **UI-0** Fondasi Design System — 10/10 (100%)
- ✅ **UI-1** Tema Tuntas — 7/7 (100%)
- ✅ **UI-2** Primitive Tuntas — 10/10 (100%)
- ✅ **UI-3** Mobile-First — 9/9 (100%)
- ✅ **UI-4** Rangka Sesi/RBAC + Tabel Rute Penuh — 10/10 (100%)
- ✅ **UI-5** Halaman Produk — 10/10 (100%)
- 🔄 **UI-6** Identity dan Organisasi Nyata — 8/10 (80%)
- ✅ **UI-7** Master Data Katalog — 8/8 (100%)
- ✅ **UI-8** CRM — 7/7 (100%)
- ✅ **UI-9** Inventory Core — 7/7 (100%)
- ✅ **UI-10** Pembelian — 8/8 (100%)
- ⬜ **UI-11** POS dan Penjualan — 0/10 (0%)
- ⬜ **UI-12** Keuangan — 0/8 (0%)
- ⬜ **UI-13** Dasbor dan Laporan — 0/9 (0%)
- ⬜ **UI-14** Setelan dan Perangkat — 0/7 (0%)
- ⬜ **UI-15** Release Candidate — 0/9 (0%)

**Backend Supabase**

- ✅ **BE-0** Skema, RLS, dan Trigger — 12/12 (100%)
- ⬜ **BE-1** Quality Gate Kontrak Inti — 0/7 (0%)
- ⬜ **BE-2** Hardening Skema dan Keamanan — 0/8 (0%)
- ⬜ **BE-3** Seed Operasional dan Pembuktian Trigger — 0/8 (0%)
- ⬜ **BE-4** Kontrak Sinkronisasi Offline — 0/8 (0%)
- ⬜ **BE-5** Release Backend — 0/7 (0%)

## Backlog tertunda

_Diwariskan fase sebelumnya; belum ada di fase yang sudah selesai._

- UI-0 → **UI-11**: Komponen bisnis: ProductCard, CartPanel, PaymentSummary, ReceiptPreview
- UI-0 → **UI-11**: Keyboard shortcut F2/F4/ESC/Ctrl+P
- UI-0 → **UI-11**: Slicing halaman POS
- UI-4 → **UI-6**: Hapus DevSessionRepository dan sambungkan auth Supabase sungguhan
- BE-0 → **BE-1**: 12 Quality Gate di spec 01, 02, dan 03 belum pernah dicentang — gate spec 04-11 sudah
- BE-0 → **BE-3**: Seluruh trigger baru ditinjau baris demi baris, belum pernah dijalankan dengan data nyata

## Risiko terbuka

- **high** (UI-6) Sesi offline dapat mempertahankan UI setelah token server kedaluwarsa; operasi tulis harus tetap diantrikan dan divalidasi ulang saat koneksi kembali
- **high** (UI-7) Model produk lokal masih menyimpan beberapa identifier sebagai String sementara Supabase memakai bigint/uuid; mapping wajib gagal keras, bukan mengubah identifier tidak valid menjadi null
- **high** (UI-9) Kesalahan idempotensi atau pembulatan kuantitas akan mengubah stok dua kali; semua command movement wajib memiliki identity stabil dan diuji saat retry
- **high** (UI-10) Penerimaan parsial dan retry dapat menggandakan movement bila command tidak idempotent; backend BE-3 harus lulus sebelum sinkronisasi purchase diaktifkan
- **high** (UI-11) Checkout menyalakan trigger paling berisiko; jangan aktifkan push produksi sebelum BE-2 memperbaiki schema dan BE-3 membuktikan semua trigger dengan data nyata
- _…12 lagi, lihat `project-progress.md`_

## Catatan terakhir

- `context/journal/2026-07-27-bangun-sistem-konteks-chat-ctx.md` — Bangun sistem konteks-chat ctx

---

Ubah status: `tool\context\ctx.bat task done <key>` · papan penuh ada di `project-progress.md`.
