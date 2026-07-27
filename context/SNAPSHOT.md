<!-- DIHASILKAN OTOMATIS — jangan edit file ini.
     Ubah context/roadmap.yaml lalu jalankan: tool\context\ctx.bat sync -->

# MangRitel — di mana proyek ini sekarang

_Sumber: `context/roadmap.yaml` · diperbarui 2026-07-27T10:14:19Z_

## ⬜ Aplikasi Flutter — fase aktif UI-5 · Komponen Bisnis

`0/5` task selesai (0%)

> Menutup sisa Component Inventory yang tertunda sejak UI-0, sebelum halaman pertama di-slice

Berikutnya:

1. `ui5-product-card` ProductCard: kartu produk untuk grid kasir dan daftar katalog _(UI-5)_
2. `ui5-cart-panel` CartPanel: daftar item keranjang, ubah qty, diskon per item, ringkasan _(UI-5)_
3. `ui5-payment-summary` PaymentSummary: subtotal, diskon, pajak, bayar, kembalian _(UI-5)_

## ⬜ Backend Supabase — fase aktif BE-1 · Quality Gate Terbuka

`0/6` task selesai (0%)

> Menutup 12 quality gate yang masih kosong di spec 01 identity-rbac, 02 product-catalog, dan 03 crm

Berikutnya:

1. `be1-gate-has-permission` Uji public.has_permission() untuk user global maupun user spesifik outlet, termasuk bypass Owner _(BE-1)_
2. `be1-gate-rls-tenant` Uji RLS lintas tenant: bisnis A tidak bisa membaca role, katalog, atau customer milik bisnis B _(BE-1)_
3. `be1-gate-price-trigger` Buktikan trigger histori harga menulis baris baru ke product_prices saat harga produk diubah _(BE-1)_

## Sedang dikerjakan

_Tidak ada task berstatus in_progress._

## Semua fase sekilas

**Aplikasi Flutter**

- ✅ **UI-0** Fondasi Design System — 9/9 (100%)
- ✅ **UI-1** Tema Tuntas — 6/6 (100%)
- ✅ **UI-2** Primitive Tuntas — 9/9 (100%)
- ✅ **UI-3** Mobile-First — 8/8 (100%)
- ✅ **UI-4** Rangka Sesi/RBAC + Tabel Rute Penuh — 9/9 (100%)
- ⬜ **UI-5** Komponen Bisnis — 0/5 (0%)
- ⬜ **UI-6** Layar Kasir — 0/5 (0%)
- ⬜ **UI-7** Auth Asli — 0/5 (0%)

**Backend Supabase**

- ✅ **BE-0** Skema, RLS, dan Trigger — 11/11 (100%)
- ⬜ **BE-1** Quality Gate Terbuka — 0/6 (0%)
- ⬜ **BE-2** Data Nyata dan Pembuktian Trigger — 0/5 (0%)
- ⬜ **BE-3** Temuan Terbuka — 0/7 (0%)

## Backlog tertunda

_Diwariskan fase sebelumnya; belum ada di fase yang sudah selesai._

- UI-0 → **UI-5**: Komponen bisnis: ProductCard, CartPanel, PaymentSummary, ReceiptPreview
- UI-0 → **UI-6**: Keyboard shortcut F2/F4/ESC/Ctrl+P
- UI-0 → **UI-6**: Slicing halaman POS
- UI-4 → **UI-7**: Hapus DevSessionRepository dan sambungkan auth Supabase sungguhan
- BE-0 → **BE-1**: 12 Quality Gate di spec 01, 02, dan 03 belum pernah dicentang — gate spec 04-11 sudah
- BE-0 → **BE-2**: Seluruh trigger baru ditinjau baris demi baris, belum pernah dijalankan dengan data nyata

## Risiko terbuka

- **high** (UI-6) Layar kasir adalah yang pertama akan memicu 8 trigger Supabase yang belum pernah dijalankan dengan data nyata. Sebaiknya BE-2 selesai lebih dulu, atau bug trigger akan muncul sebagai bug UI
- **high** (BE-2) T-01 Kritis: 8 trigger hanya ditinjau baris demi baris, belum sekalipun dijalankan dengan data nyata. Bug NULL handling, urutan trigger, atau RAISE EXCEPTION yang terlalu agresif belum ketahuan
- **high** (BE-3) T-02: trigger void bergantung persis pada nilai 'done' dan 'void'. Nilai 'VOID' atau 'voided' membuat trigger diam-diam tidak jalan dan stok tidak dikembalikan, tanpa error apa pun
- **medium** (UI-4) Guard, ganti outlet, dan laci tablet potret hanya terbukti lewat widget test; belum pernah dijalankan di Android atau iOS sungguhan
- **medium** (BE-3) T-04: window-nya sedang terbuka. Selama belum ada data varian nyata, mencabut products.parent_id murah; setelah ada, mahal
- _…2 lagi, lihat `project-progress.md`_

## Catatan terakhir

- `context/journal/2026-07-27-bangun-sistem-konteks-chat-ctx.md` — Bangun sistem konteks-chat ctx

---

Ubah status: `tool\context\ctx.bat task done <key>` · papan penuh ada di `project-progress.md`.
