<!-- DIHASILKAN OTOMATIS — jangan edit file ini.
     Ubah context/roadmap.yaml lalu jalankan: tool\context\ctx.bat sync -->

# Progres MangRitel

_Sumber: `context/roadmap.yaml` · diperbarui 2026-07-27T10:16:37Z_

**Total: 52/85 task selesai (61%) di 12 fase.**

# Track Aplikasi Flutter — 41/56 (73%)

## ✅ UI-0 — Fondasi Design System (9/9 · 100%)

_mulai 2026-07-23 · selesai 2026-07-23 · commit `7c0616e`_

> Token, tema, primitive, dan shell dituntaskan sebelum satu halaman pun di-slice

- ✅ `ui0-tokens` Token: palette, warna semantik, tipografi, density adaptif, radius, shadow, motion, breakpoint, ikon domain
- ✅ `ui0-theme-light` LightScheme lengkap + pemetaan token ke ColorScheme Material agar Dialog/SnackBar/Switch ikut sistem
- ✅ `ui0-primitives` Delapan primitive stateless: button, text field, panel, badge, divider, empty state, error view, skeleton
- ✅ `ui0-shell` AppShell 4 slot (sidebar/workspace/inspector/bottom-panel), memasang DensityScope untuk seluruh subtree
- ✅ `ui0-router` GoRouter dengan transisi 220 ms, shell layout, dan galeri /dev/design
- ✅ `ui0-format` Formatter currency (Rp id_ID), number (qty, persen), date (id_ID + relatif)
- ✅ `ui0-fonts` Inter + JetBrains Mono di-bundle lokal, varian 18pt, angka tabular dijamin di tiap style numerik
- ✅ `ui0-fix-imports` Perbaiki import 5 model yang menunjuk file *table tak tersedia — proyek tidak bisa dikompilasi sebelumnya
- ✅ `ui0-tests` Tes invarian token (breakpoint, density, motion), ColorScheme memakai token, galeri terbangun

**Keputusan**

- Tipografi disusun per peran, bukan per hierarki — Layar POS padat; ukuran teks ditentukan tugasnya (harga, label, angka tabel), bukan kedalaman heading
- Garis lebih diutamakan daripada bayangan — Tampilan industrial/dense; bayangan menumpuk jadi kotor di layar yang penuh panel
- Semua motion dibatasi 220 ms — Kasir mengetuk cepat dan berulang; animasi lebih panjang terasa menghalangi
- Font di-bundle lokal, bukan diunduh saat runtime — Aplikasi offline-first; teks tidak boleh menunggu jaringan

**Sengaja ditunda**

- → **UI-1**: Isi nilai dark_scheme.dart (saat ini masih kerangka berisi TODO)
- → **UI-2**: AppDataTable (25-50 baris)
- → **UI-5**: Komponen bisnis: ProductCard, CartPanel, PaymentSummary, ReceiptPreview
- → **UI-6**: Keyboard shortcut F2/F4/ESC/Ctrl+P
- → **UI-6**: Slicing halaman POS

**Verifikasi:** Analyzer bersih; galeri /dev/design terbangun di desktop dan ponsel

## ✅ UI-1 — Tema Tuntas (6/6 · 100%)

_mulai 2026-07-23 · selesai 2026-07-23 · commit `280ba1b`_

> Menuntaskan tema gelap dan tiga sistem tersimpan: preferensi, cubit, penyimpanan

- ✅ `ui1-dark-ramp` Ramp gelap d0..d900 di AppPalette: selisih antar lapisan rapat, trio semantik diturunkan saturasinya
- ✅ `ui1-dark-scheme` DarkScheme terisi lengkap, tidak lagi alias LightScheme
- ✅ `ui1-elevation` AppElevation sebagai ThemeExtension ketiga
- ✅ `ui1-preferences` AppPreferences (Hive settings_box) + ThemeCubit untuk menyimpan ThemeMode antar sesi
- ✅ `ui1-contrast-test` Uji kontras WCAG kedua tema; dua perbaikan ditemukan di tema terang (n500 digelapkan)
- ✅ `ui1-theme-switch` Sakelar tema di galeri design system (Sistem/Terang/Gelap)

**Keputusan**

- Bayangan tidak boleh sama di dua tema — Bertinta biru di tema terang, hitam murni di tema gelap; bayangan biru di atas gelap terlihat berkabut
- settings_box dibuka sinkron di main.dart sebelum runApp — Kalau dibuka asinkron, aplikasi sempat menggambar tema salah lalu berkedip saat preferensi tiba

**Risiko**

- **low** Tema gelap belum pernah dilihat di perangkat asli; flutter build windows butuh Developer Mode

**Verifikasi:** 38 tes lolos, analyzer bersih

## ✅ UI-2 — Primitive Tuntas (9/9 · 100%)

_mulai 2026-07-24 · selesai 2026-07-24 · commit `06cb976`_

> Melengkapi Component Inventory 15_Screen_Spesification.md dan memasang penegak aturannya selagi lib/features/ masih bersih

- ✅ `ui2-overlay` AppDialog + showAppDialog + showAppConfirm; di layar compact masuk sebagai lembar dari tepi bawah
- ✅ `ui2-drawer-toast` showAppDrawer, AppToast (Overlay, bukan ScaffoldMessenger), AppTooltip, AppIconButton
- ✅ `ui2-form-toggle` AppCheckbox (tristate), AppRadio/AppRadioGroup, AppSwitch, fokus dan area sentuh dikumpulkan di ToggleShell
- ✅ `ui2-select` AppSelect: popover menempel pada isian, membalik ke atas bila ruang sempit, bisa dicari dan dijelajahi panah
- ✅ `ui2-number-date` AppNumberInput, AppCurrencyInput, AppDateField/AppDateRangeField
- ✅ `ui2-table` AppColumn dengan ColumnPriority + AppDataTable; di bawah 600 px berubah jadi daftar kartu
- ✅ `ui2-pagination` AppPagination 25/50/100 baris
- ✅ `ui2-search-filter-tabs` AppSearchField (jeda 300 ms, Enter melapor seketika untuk barcode), AppFilterChip/AppFilterBar, AppTabs beridentitas id
- ✅ `ui2-style-enforcer` no_hardcoded_style_test.dart memindai lib/features/ untuk warna, gaya teks, spasi, radius, ikon, durasi mentah

**Keputusan**

- showGeneralDialog, bukan showDialog — Supaya tirai memakai colors.overlay dan durasinya tunduk pada plafon 220 ms
- Enter di dialog ditangani lewat FocusScope, bukan CallbackShortcuts di dalam panel — Peristiwa papan ketik merambat ke leluhur, dan scope milik rute berada di atas isi dialog
- Checkbox/Radio/Switch digambar sendiri — Versi Material mengambil warna dari ColorScheme, sehingga lepas dari token
- AppDataTable memakai ListView.builder ber-itemExtent — DataTable Material membangun seluruh baris sekaligus; tabel produk bisa ribuan baris
- Pengurutan dilaporkan ke pemanggil, tidak dikerjakan tabel sendiri — Sumber data ada di bloc/DAO; tabel yang mengurut sendiri akan berbeda hasil dari yang di database
- Ukuran halaman 10 baris ditolak, minimum 25 — Sesuai penolakan eksplisit di 16_Design_System.md §16.3
- Enforcer dipasang justru selagi lib/features/ masih kosong dari widget — Kalau menunggu ada widget, daftar pengecualian akan tumbuh lebih dulu dan aturannya jadi tumpul

**Verifikasi:** Analyzer bersih; enforcer menguji polanya sendiri terhadap contoh positif dan negatif

## ✅ UI-3 — Mobile-First (8/8 · 100%)

_mulai 2026-07-24 · selesai 2026-07-24 · commit `52cc009`_

> Membereskan kontradiksi perangkat sasaran antar dokumen, lalu merancang ulang navigasi dan barcode di atas keputusan itu

- ✅ `ui3-target-devices` Tambah §16.0 Perangkat Sasaran (ponsel Tingkat 1, tablet Tingkat 2, tablet + pemindai HID Tingkat 3, tanpa PC)
- ✅ `ui3-nav-item` AppSidebarItem jadi AppNavItem: model tujuan dipakai bersama sidebar dan bilah bawah supaya tidak menyimpang
- ✅ `ui3-bottom-nav` AppBottomNav menggantikan Drawer di layar sempit; menghilang saat papan ketik layar terbuka
- ✅ `ui3-barcode-scope` AppBarcodeScope sebagai titik masuk tunggal; kamera, wedge, dan ketik manual bermuara ke sana
- ✅ `ui3-barcode-listener` AppBarcodeListener membedakan pemindai dari manusia lewat jeda antar tombol
- ✅ `ui3-mobile-scanner` mobile_scanner 7.4.0 + izin CAMERA + NSCameraUsageDescription, format dibatasi ke barcode ritel
- ✅ `ui3-gesture` AppSwipeAction, AppRefreshView, AppBackGuard, AppKeyboardInset (juga dipasang di AppDialog dan AppDrawer sempit)
- ✅ `ui3-physical-keyboard` PhysicalKeyboard menyimpulkan papan ketik fisik dari tombol yang mustahil ada di papan ketik layar; AppShortcutHint

**Keputusan**

- 01_Product_Vision_And_Scope.md menang atas 16_Design_System.md §16.1 soal perangkat sasaran — Vision menetapkan Android/iOS/Web Admin; §16.1 menulis Desktop POS dengan layout ala VS Code. Tidak bisa dua-duanya
- Heuristik pemindai memakai satu Timer, bukan DateTime.now() — Jam dinding tidak ikut dipercepat FakeAsync, jadi versi pertama mustahil diuji
- AppSwipeAction tidak memakai Dismissible — Dismissible menghapus widgetnya sendiri sebelum bloc sempat memutuskan apakah aksinya jadi
- PopScope, bukan WillPopScope — WillPopScope sudah usang
- Digit dan Enter tidak dihitung sebagai bukti papan ketik fisik — Justru itu yang dikirim pemindai HID, dan pemindai bukan papan ketik
- BarcodeFormat.all ditolak — Dibatasi ke format barcode ritel supaya pendeteksian tidak melambat dan salah baca

## ✅ UI-4 — Rangka Sesi/RBAC + Tabel Rute Penuh (9/9 · 100%)

_mulai 2026-07-24 · selesai 2026-07-24 · commit `4bc6111`_

> Aplikasi tahu siapa yang masuk, di outlet mana, boleh membuka apa, dan punya alamat untuk seluruh 45 layar IA

- ✅ `ui4-permissions` AppPermissions: 26 kode persis seperti di server, plus peta sinonim dikumpulkan di satu tempat
- ✅ `ui4-session` AppSession.can() dengan bypass Owner; SessionState tiga keadaan, unknown bukan signedOut
- ✅ `ui4-session-repo` SessionRepository sebagai seam, DevSessionRepository sebagai satu-satunya implementasi hari ini
- ✅ `ui4-nav-tree` app_nav_tree.dart jadi sumber tunggal sidebar, bilah bawah, breadcrumb, tabel rute, dan penjaga izin
- ✅ `ui4-routes` AppRoutes tumbuh dari 5 ke sekitar 45 konstanta, bersarang mengikuti area IA
- ✅ `ui4-route-guard` app_route_guard.dart: tujuan awal ditentukan izin, bukan nama peran
- ✅ `ui4-breadcrumb-topbar` Komponen baru AppBreadcrumb, AppTopBar, AppNavSection (sidebar bergrup)
- ✅ `ui4-doc-fix` Perbaiki matriks izin dan kamus izin di 15_Screen_Spesification.md serta area per peran di 13_Information_Architecture.md
- ✅ `ui4-scaffold-fix` Ganti Scaffold.of(context) yang dipanggil dari konteks di atas Scaffold-nya dengan GlobalKey

**Keputusan**

- Daftar izin dibaca langsung dari Supabase, tidak dikarang — 26 permission dan 7 peran disalin apa adanya dari tabel role_permissions
- AppSession.can() memegang bypass Owner — public.has_permission di database mem-bypass Owner lebih dulu; klien yang tidak ikut akan menyembunyikan menu yang justru diizinkan server
- DevSessionRepository akan dihapus, bukan dikembangkan, saat fase auth tiba — Ia sengaja dibuat sebagai sekat sementara; mengembangkannya berarti menumpuk logika yang harus dibongkar lagi
- Permission Matrix di 15_Screen_Spesification.md salah di empat sel; database yang benar — Kasir dinyatakan tidak boleh membuka Product/Inventory/Finance padahal memegang PRODUCT_READ, INVENTORY_VIEW, CASH_VIEW; Manager dinyatakan tidak boleh Settings padahal memegang SETTING_MANAGE
- DASHBOARD_VIEW yang dirujuk dokumen tidak pernah ada di tabel permissions

**Sengaja ditunda**

- → **UI-7**: Hapus DevSessionRepository dan sambungkan auth Supabase sungguhan

**Risiko**

- **medium** Guard, ganti outlet, dan laci tablet potret hanya terbukti lewat widget test; belum pernah dijalankan di Android atau iOS sungguhan

**Verifikasi:** 193 tes lulus, flutter analyze bersih

## ⬜ UI-5 — Komponen Bisnis (0/5 · 0%)

> Menutup sisa Component Inventory yang tertunda sejak UI-0, sebelum halaman pertama di-slice

- ⬜ `ui5-product-card` ProductCard: kartu produk untuk grid kasir dan daftar katalog
- ⬜ `ui5-cart-panel` CartPanel: daftar item keranjang, ubah qty, diskon per item, ringkasan
- ⬜ `ui5-payment-summary` PaymentSummary: subtotal, diskon, pajak, bayar, kembalian
- ⬜ `ui5-receipt-preview` ReceiptPreview: pratinjau struk sebelum cetak, mengikuti lebar kertas 58/80 mm
- ⬜ `ui5-features-tokens` Loloskan widget pertama di lib/features/ terhadap no_hardcoded_style_test tanpa menambah pengecualian

**Risiko**

- **low** no_hardcoded_style_test.dart memindai lib/features/ dan gagal keras tanpa daftar pengecualian; komponen bisnis pertama yang masuk ke sana langsung diuji olehnya

## ⬜ UI-6 — Layar Kasir (0/5 · 0%)

> Layar fitur nyata pertama: slicing halaman POS di atas primitive dan komponen bisnis yang sudah tuntas

- ⬜ `ui6-pos-layout` Susunan halaman kasir: pencarian produk, grid, panel keranjang, aksi bawah
- ⬜ `ui6-cart-wiring` Sambungkan halaman ke CartBloc multi-tab yang sudah ada sejak commit d198cb0
- ⬜ `ui6-scanner-wiring` Sambungkan AppBarcodeScope ke pencarian produk di halaman kasir
- ⬜ `ui6-checkout-flow` Alur checkout dan pembayaran sampai struk, memakai PaymentSummary dan ReceiptPreview
- ⬜ `ui6-shortcuts` Keyboard shortcut F2/F4/ESC/Ctrl+P, tertunda sejak UI-0, hanya aktif saat papan ketik fisik terdeteksi

**Risiko**

- **high** Layar kasir adalah yang pertama akan memicu 8 trigger Supabase yang belum pernah dijalankan dengan data nyata. Sebaiknya BE-2 selesai lebih dulu, atau bug trigger akan muncul sebagai bug UI

## ⬜ UI-7 — Auth Asli (0/5 · 0%)

> Ganti sesi dev dengan auth Supabase sungguhan, lalu buktikan RBAC dan navigasi di perangkat asli

- ⬜ `ui7-supabase-auth` Sambungkan SessionRepository ke supabase_flutter auth, isi AppSession dari users + role_permissions
- ⬜ `ui7-login-page` Halaman login sungguhan menggantikan login_page placeholder
- ⬜ `ui7-session-persist` Sesi bertahan antar peluncuran aplikasi, termasuk saat offline
- ⬜ `ui7-remove-dev-repo` Hapus DevSessionRepository sepenuhnya, sesuai keputusan UI-4
- ⬜ `ui7-device-verify` Verifikasi guard, ganti outlet, dan laci tablet potret di Android/iOS sungguhan

# Track Backend Supabase — 11/29 (37%)

## ✅ BE-0 — Skema, RLS, dan Trigger (11/11 · 100%)

_selesai 2026-07-15_

> Seluruh tahap implementasi di 11 spec Kiro: struktur tabel, RLS, RBAC, dan trigger otomatis

- ✅ `be0-identity-rbac` Spec 01 identity-rbac: permissions, roles, role_permissions, user_roles, has_permission(), hapus users.role legacy
- ✅ `be0-product-catalog` Spec 02 product-catalog: categories, brands, units, products, product_variants, product_prices + trigger histori harga
- ✅ `be0-crm` Spec 03 crm: customers (DECIMAL + audit snake_case) dan suppliers dengan RLS
- ✅ `be0-inventory-core` Spec 04 inventory-core: warehouses, stock_movements, kuantitas desimal, trigger sinkronisasi stok
- ✅ `be0-purchase` Spec 05 purchase: purchase order dan penerimaan barang
- ✅ `be0-sales-pos` Spec 06 sales-pos: transactions dan transaction_details + 2 trigger
- ✅ `be0-finance` Spec 07 finance: kas, jurnal, dan mutasi keuangan
- ✅ `be0-reporting` Spec 08 reporting: view dan agregasi laporan
- ✅ `be0-settings-misc` Spec 09 settings-misc: tabel referensi dan pengaturan
- ✅ `be0-db-optimization` Spec 10 database-optimization: index dan penyetelan kueri
- ✅ `be0-product-variants` Spec 11 product-variants: model varian baru lewat tabel product_variants

**Keputusan**

- Database dipakai sebagai backend langsung, tanpa lapisan API sendiri — Keamanan ditegakkan RLS di 51/51 tabel plus 26 permission, bukan oleh kode server yang harus ditulis dan dirawat terpisah. 0 Edge Function
- Model varian baru (tabel product_variants) yang dipakai, bukan products.parent_id warisan Mangkasir — Keduanya masih hidup berdampingan hari ini; yang lama harus dicabut sebelum ada data varian nyata

**Sengaja ditunda**

- → **BE-1**: 12 Quality Gate di spec 01, 02, dan 03 belum pernah dicentang — gate spec 04-11 sudah
- → **BE-2**: Seluruh trigger baru ditinjau baris demi baris, belum pernah dijalankan dengan data nyata

**Verifikasi:** Diverifikasi langsung ke Supabase 2026-07-15 (ref emovquokperyixwnpqaa, PostgreSQL 17.6): 51 tabel, 6 view, 10 function, 8 trigger, 24 migrasi, RLS aktif di 51/51 tabel, 7 peran, 26 permission, 106 pemetaan role_permission

## ⬜ BE-1 — Quality Gate Terbuka (0/6 · 0%)

> Menutup 12 quality gate yang masih kosong di spec 01 identity-rbac, 02 product-catalog, dan 03 crm

- ⬜ `be1-gate-has-permission` Uji public.has_permission() untuk user global maupun user spesifik outlet, termasuk bypass Owner
- ⬜ `be1-gate-rls-tenant` Uji RLS lintas tenant: bisnis A tidak bisa membaca role, katalog, atau customer milik bisnis B
- ⬜ `be1-gate-price-trigger` Buktikan trigger histori harga menulis baris baru ke product_prices saat harga produk diubah
- ⬜ `be1-gate-unit-migrasi` Verifikasi migrasi teks unit produk lama ke foreign key unit_id tanpa produk yang hilang
- ⬜ `be1-gate-crud-crm` Jalankan CRUD customer dan supplier di schema terbaru sampai bersih dari error
- ⬜ `be1-gate-centang` Centang gate yang sudah terbukti di tasks.md spec 01-03, samakan dengan gaya spec 04-11

## ⬜ BE-2 — Data Nyata dan Pembuktian Trigger (0/5 · 0%)

> Mengisi data operasional pertama dan menjalankan 8 trigger dengan data sungguhan — hari ini keduanya masih 0%

- ⬜ `be2-seed-master` Seed outlet, gudang, kategori, unit, dan produk pertama — businesses punya 1 baris tapi 0 outlet, jadi yatim
- ⬜ `be2-seed-wilayah` Impor dataset wilayah Indonesia (T-05): provinces, cities, districts, villages semuanya 0 baris sehingga form alamat mati
- ⬜ `be2-e2e-penjualan` Skenario end-to-end penjualan: transaksi jadi, stock_movements terisi, stocks dan products ikut tersinkron
- ⬜ `be2-e2e-void` Uji void transaksi: trg_sync_void_transaction_stock benar-benar mengembalikan stok
- ⬜ `be2-e2e-pembelian` Skenario end-to-end pembelian: purchase order sampai penerimaan barang menambah stok

**Risiko**

- **high** T-01 Kritis: 8 trigger hanya ditinjau baris demi baris, belum sekalipun dijalankan dengan data nyata. Bug NULL handling, urutan trigger, atau RAISE EXCEPTION yang terlalu agresif belum ketahuan

## ⬜ BE-3 — Temuan Terbuka (0/7 · 0%)

> Menutup temuan T-02 sampai T-09 dari audit database 15 Juli 2026, dari kritis sampai rapi-rapi

- ⬜ `be3-t02-flag-check` T-02 Kritis: tambah CHECK constraint pada transactions.flag — semua kolom status lain sudah punya
- ⬜ `be3-t03-rpc-anon` T-03 Tinggi: cabut EXECUTE 8 trigger function SECURITY DEFINER dari role anon dan authenticated; uji di branch dulu
- ⬜ `be3-t04-parent-id` T-04: hapus products.parent_id agar model varian tunggal — sekitar 30 menit sekarang, berhari-hari nanti
- ⬜ `be3-t06-audit-kolom` T-06: samakan kolom audit legacy createdat/createdby/updatedat/updatedby dan users.isemailverified ke snake_case
- ⬜ `be3-t07-users-password` T-07: hapus sisa kolom users.password, sekitar 5 menit
- ⬜ `be3-t08-guid-uuid` T-08: ubah transactions.guid dari VARCHAR ke UUID — berisiko, perlu drop dan recreate FK
- ⬜ `be3-t09-otp-policy` T-09: otp_verifications punya RLS aktif tapi 0 policy, artinya tertutup total

**Risiko**

- **high** T-02: trigger void bergantung persis pada nilai 'done' dan 'void'. Nilai 'VOID' atau 'voided' membuat trigger diam-diam tidak jalan dan stok tidak dikembalikan, tanpa error apa pun
- **medium** T-04: window-nya sedang terbuka. Selama belum ada data varian nyata, mencabut products.parent_id murah; setelah ada, mahal

