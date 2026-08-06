<!-- DIHASILKAN OTOMATIS — jangan edit file ini.
     Ubah context/roadmap.yaml lalu jalankan: tool\context\ctx.bat sync -->

# Progres MangRitel

_Sumber: `context/roadmap.yaml` · diperbarui 2026-08-06T03:08:52Z_

**Total: 67/167 task selesai (40%) di 22 fase.**

# Track Aplikasi Flutter — 56/123 (45%)

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
- → **UI-11**: Komponen bisnis: ProductCard, CartPanel, PaymentSummary, ReceiptPreview
- → **UI-11**: Keyboard shortcut F2/F4/ESC/Ctrl+P
- → **UI-11**: Slicing halaman POS

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

- → **UI-6**: Hapus DevSessionRepository dan sambungkan auth Supabase sungguhan

**Risiko**

- **medium** Guard, ganti outlet, dan laci tablet potret hanya terbukti lewat widget test; belum pernah dijalankan di Android atau iOS sungguhan

**Verifikasi:** 193 tes lulus, flutter analyze bersih

## 🔄 UI-5 — Halaman Produk (7/9 · 77%)

_mulai 2026-07-27_

> Halaman fitur nyata pertama, sekaligus memasang seluruh perkakas slicing — registry halaman, penyediaan bloc, dan uji asap aplikasi — di layar yang paling murah risikonya

- ✅ `ui5-drop-gallery-route` Cabut /dev/design dari tabel rute dan tombol galeri dari setiap penanda tempat; galeri tetap hidup lewat entrypoint lib/design_gallery_main.dart, karena nilainya ada pada uji asapnya, bukan pada pintunya di dalam aplikasi
- ✅ `ui5-test-harness` Pindahkan uji galeri ke test/core/design/, lalu isi test/widget_test.dart dengan uji asap aplikasi sungguhan di atas AppRoot dan getIt berisi ganda — tanpa .env, Supabase, maupun Hive. Dipasang sekali, dipakai setiap halaman berikutnya
- ✅ `ui5-page-registry` Registry pembangun halaman berkunci konstanta AppRoutes; _navRoute memakainya dan jatuh ke RoutePlaceholderPage bila kosong, sehingga tabel rute tetap diturunkan dari AppNavTree dan sebuah halaman bisa lahir tanpa menyentuh tabel rute sama sekali
- ✅ `ui5-store-id` Alirkan storeId dari AppSession.activeOutlet ke DAO, usecase, dan bloc produk. Hari ini ProductDao tidak menyaring outlet sama sekali, jadi ganti outlet hanya mengganti label di pojok layar sementara katalog kedua outlet tetap tercampur
- ✅ `ui5-product-list` Halaman /inventory/products di atas AppDataTable, AppSearchField, dan AppPagination; keadaan kosong, memuat, dan galat dibangun sungguhan karena ketiganya yang akan terlihat lebih dulu di database yang masih kosong
- ✅ `ui5-product-form` Satu formulir untuk /inventory/products/new dan /inventory/products/:id; izin PRODUCT_CREATE dan PRODUCT_READ sudah ditetapkan pohon navigasi, formulir tidak memeriksanya lagi sendiri
- ✅ `ui5-category-inline` Kategori bisa dibuat dari dalam formulir produk. Tanpa ini produk pertama tidak punya kategori untuk dipilih, dan category_id yang kosong akan menghalanginya didorong ke server nanti
- ⬜ `ui5-offline-only` Tegaskan fase ini offline: baris tetap di syncStatus 'pending' dan kegagalan push tampil sebagai toast, bukan diam. SyncWorker berurutan ketat dan berhenti di langkah pertama yang gagal — satu produk yang FK-nya belum ada di server ikut menahan transaksi dan pembayaran, dan satu-satunya gejalanya adalah sinkronisasi yang tidak pernah selesai
- ⬜ `ui5-features-tokens` Loloskan widget pertama di lib/features/ terhadap no_hardcoded_style_test tanpa menambah pengecualian

**Keputusan**

- Komponen bisnis tidak lagi dibangun sebagai fase tersendiri — ProductCard menerima entitas Product, jadi ia tidak boleh tinggal di lib/core/design/ yang tidak mengenal domain — dan begitu ia tinggal di lib/features/, ia tidak bisa dipamerkan di galeri. Tidak ada tempat berdiri sendiri untuk keempatnya
- Sebuah widget naik ke lib/core/design/ hanya setelah fitur kedua memerlukannya dan ia tidak menerima satu pun tipe domain — Aturan tunggal ini menjawab "di mana widget ini tinggal" sekali untuk selamanya, tanpa perdebatan per komponen
- Produk didahulukan atas kasir — SyncWorker hanya mendorong, tidak pernah menarik. Basis data lokal lahir kosong dan satu-satunya jalan produk ada adalah dibuat di dalam aplikasi — layar kasir yang dibangun lebih dulu tidak punya apa pun untuk dijual
- Tabel rute tidak digandakan; halaman nyata dipasang lewat registry berkunci konstanta AppRoutes — Menaruh builder di AppNavDestination memaksa app_nav_tree.dart mengimpor 45 halaman fitur, dan pohon itu sengaja dibuat data murni supaya bisa diuji tanpa membangun widget tree

**Risiko**

- **low** no_hardcoded_style_test.dart memindai lib/features/ dan gagal keras tanpa daftar pengecualian; widget pertama yang masuk ke sana langsung diuji olehnya, dan formulir produk kemungkinan memerlukan ikon yang belum punya token di AppIcons
- **medium** storeId disimpan sebagai String di entitas tetapi int di sesi dan bigint di server; toSupabaseJson memakai int.tryParse yang diam-diam menghasilkan null bila nilainya bukan angka

**Verifikasi:** Daftar/tambah/edit produk terbuka dari AppRoot, terikat outlet aktif, menyimpan pending secara offline, menampilkan kegagalan sync, lolos style enforcer, widget test, dan flutter analyze

## 🔄 UI-6 — Identity dan Organisasi Nyata (8/9 · 88%)

_mulai 2026-08-06_

> Mengganti sesi pengembangan dengan identitas Supabase dan menuntaskan konteks business, outlet, pengguna, serta peran sebelum modul operasional bergantung kepadanya

- ✅ `ui6-auth-contract` Bekukan kontrak SessionRepository setelah BE-1 membuktikan has_permission dan isolasi tenant; petakan auth user, users, user_roles, role_permissions, business, dan outlet tanpa logika izin ganda di klien
- ✅ `ui6-login` Halaman /login sungguhan: validasi, loading, kredensial salah, koneksi terputus, dan pemulihan password; tidak ada rute gallery atau sesi dev sebagai jalan pintas
- ✅ `ui6-session-persist` Sesi bertahan antar peluncuran, memulihkan outlet aktif, dan memiliki keadaan offline yang eksplisit tanpa menganggap token kedaluwarsa sebagai sesi sah
- ✅ `ui6-account` Halaman /account nyata untuk profil, business, outlet aktif, peran, status sinkronisasi, ganti outlet, dan logout
- ✅ `ui6-business` Halaman /settings/business membaca dan memperbarui identitas usaha dengan validasi serta audit actor
- ✅ `ui6-outlets` Halaman /settings/outlets untuk daftar dan formulir outlet; perubahan outlet aktif menyegarkan seluruh query terikat tenant tanpa membangun ulang router
- ✅ `ui6-users-roles` Halaman /settings/users dan /settings/roles untuk undangan/status pengguna serta assignment peran per outlet; Owner bypass dan larangan eskalasi hak diuji
- ✅ `ui6-remove-dev-session` Hapus DevSessionRepository dari rakitan produksi; fake hanya boleh hidup di test/support dan tidak dapat dipilih lewat konfigurasi release
- ⬜ `ui6-device-rbac` Buktikan login, deep link terlarang, menu berbasis izin, ganti outlet, dan logout di ponsel serta tablet Android/iOS

**Keputusan**

- BE-1 adalah entry gate UI-6 — Auth nyata tidak boleh dibangun di atas has_permission dan RLS yang belum dibuktikan; kalau kontraknya berubah setelah screen dibuat, seluruh guard dan query tenant harus diulang
- Identity dan organization dikerjakan sebelum screen operasional berikutnya — Setiap data bisnis membutuhkan actor, business_id, dan outlet_id yang nyata; sesi dev cukup untuk prototipe, bukan untuk membuktikan aplikasi

**Risiko**

- **high** Sesi offline dapat mempertahankan UI setelah token server kedaluwarsa; operasi tulis harus tetap diantrikan dan divalidasi ulang saat koneksi kembali

**Verifikasi:** BE-1 lulus; login, pemulihan sesi, ganti outlet, RBAC, dan logout lolos integration test; halaman identity/organization teruji di Android dan iOS

## ⬜ UI-7 — Master Data Katalog (0/7 · 0%)

> Menuntaskan seluruh master yang menjadi prasyarat produk, stok, pembelian, dan penjualan; setiap menu master menggantikan placeholder dengan CRUD nyata

- ⬜ `ui7-categories` Halaman /inventory/categories: daftar, cari, tambah, ubah, arsipkan, cegah penghapusan kategori yang masih dipakai produk
- ⬜ `ui7-brands` Halaman /inventory/brands: daftar dan CRUD brand dengan status aktif serta validasi nama unik dalam business
- ⬜ `ui7-units` Halaman /inventory/units: satuan dasar, simbol, presisi kuantitas, dan perlindungan referensi produk
- ⬜ `ui7-warehouses` Halaman /inventory/warehouses: gudang per outlet, gudang default, status aktif, serta larangan menonaktifkan gudang yang masih memiliki stok
- ⬜ `ui7-tax` Halaman /settings/tax: kebijakan pajak default dan override produk dengan pembulatan yang sama antara form, cart, receipt, dan backend
- ⬜ `ui7-product-variants` Perluas form produk untuk product_variants, harga, SKU, dan banyak barcode; products.parent_id lama tidak boleh dipakai setelah BE-2
- ⬜ `ui7-master-crossflow` Buktikan master baru langsung tersedia di form produk tanpa restart; perubahan outlet tidak membocorkan master outlet lain dan semua CRUD memiliki empty/loading/error/permission state

**Keputusan**

- Master data diselesaikan sebelum inventory dan transaksi — Stock, purchase order, dan cart tidak boleh menyimpan label bebas untuk kategori, unit, gudang, pajak, atau varian yang seharusnya foreign key

**Risiko**

- **high** Model produk lokal masih menyimpan beberapa identifier sebagai String sementara Supabase memakai bigint/uuid; mapping wajib gagal keras, bukan mengubah identifier tidak valid menjadi null

**Verifikasi:** Kategori, brand, unit, gudang, pajak, varian, harga, dan barcode dapat dibuat serta dipakai produk; isolasi outlet dan state kosong/loading/error teruji

## ⬜ UI-8 — CRM (0/6 · 0%)

> Menyediakan customer, supplier, dan employee nyata karena purchase dan sales membutuhkan pihak transaksi yang konsisten

- ⬜ `ui8-customer-list` Halaman /crm/customers: pencarian, filter status, pagination, saldo/ringkasan transaksi, dan empty/loading/error state
- ⬜ `ui8-customer-detail` Halaman /crm/customers/:id: profil, alamat, riwayat transaksi, edit, dan deep link kembali ke transaksi terkait
- ⬜ `ui8-supplier-list` Halaman /crm/suppliers: pencarian, filter, kontak utama, status aktif, dan aksi tambah/edit
- ⬜ `ui8-supplier-detail` Halaman /crm/suppliers/:id: profil, alamat, termin, riwayat purchase order, dan deep link ke pembelian
- ⬜ `ui8-employees` Halaman /crm/employees: data pegawai bisnis terpisah dari akun auth; tautkan akun hanya bila pegawai memang dapat masuk aplikasi
- ⬜ `ui8-crm-quality` Normalisasi nomor telepon/email/alamat, cegah duplikat yang jelas, dan uji permission serta isolasi business/outlet untuk seluruh CRM

**Keputusan**

- CRM mendahului purchase dan sales — Supplier adalah pihak purchase order dan customer adalah pihak transaksi; membuat keduanya belakangan menghasilkan data anonim yang harus dimigrasikan

**Verifikasi:** CRUD customer/supplier/employee, pencarian, detail, validasi kontak/alamat, cross-navigation, dan isolasi tenant lolos widget serta integration test

## ⬜ UI-9 — Inventory Core (0/6 · 0%)

> Menjadikan stok sebagai ledger yang dapat ditelusuri sebelum purchase dan sales mulai menghasilkan pergerakan otomatis

- ⬜ `ui9-stock-list` Halaman /inventory/stocks: saldo per produk-varian dan gudang, pencarian barcode, filter stok rendah/habis, serta drill-down ke movement
- ⬜ `ui9-movements` Halaman /inventory/movements: ledger immutable dengan sumber, tipe, actor, waktu, kuantitas sebelum/sesudah, dan tautan ke dokumen asal
- ⬜ `ui9-adjustments` Halaman /inventory/adjustments: draft, alasan wajib, item multi-produk, konfirmasi, dan idempotensi agar submit ganda tidak menggandakan stok
- ⬜ `ui9-transfers` Halaman /inventory/transfers: gudang asal/tujuan berbeda, status draft-kirim-terima-batal, dan stok tidak berpindah sebelum transisi yang benar
- ⬜ `ui9-opname` Halaman /inventory/opname: snapshot hitungan, input scan/manual, selisih, approval, dan adjustment yang dapat diaudit
- ⬜ `ui9-inventory-integrity` Uji kuantitas desimal, larangan stok negatif sesuai aturan bisnis, transaksi atomik, retry offline, dan rekonsiliasi ledger terhadap saldo

**Risiko**

- **high** Kesalahan idempotensi atau pembulatan kuantitas akan mengubah stok dua kali; semua command movement wajib memiliki identity stabil dan diuji saat retry

**Verifikasi:** Saldo stok cocok dengan ledger movement pada skenario adjustment, transfer, dan opname; seluruh screen inventory terikat outlet/gudang dan teruji offline

## ⬜ UI-10 — Pembelian (0/7 · 0%)

> Menyelesaikan alur supplier sampai penerimaan barang yang menambah stok melalui mekanisme inventory, bukan mutasi saldo langsung dari UI

- ⬜ `ui10-order-list` Halaman /purchase/orders: daftar, filter supplier/status/tanggal/outlet, total, dan aksi buat purchase order
- ⬜ `ui10-order-form` Form purchase order: supplier, gudang tujuan, item-varian, qty, harga beli, diskon, pajak, catatan, draft, dan validasi total domain
- ⬜ `ui10-order-detail` Halaman /purchase/orders/:id: timeline status, item, approval, penerimaan terkait, retur, audit actor, dan aksi sesuai state machine
- ⬜ `ui10-receiving` Halaman /purchase/receiving: penerimaan parsial/penuh, batch/expiry bila relevan, selisih, dan movement stok atomik
- ⬜ `ui10-returns` Halaman /purchase/returns: pilih penerimaan asal, alasan, qty maksimum yang dapat diretur, dan movement keluar yang dapat diaudit
- ⬜ `ui10-history` Halaman /purchase/history: histori lintas PO, receiving, dan return dengan filter serta tautan dokumen
- ⬜ `ui10-purchase-e2e` Uji end-to-end draft → approve → receive → stock bertambah → return → stock berkurang, termasuk retry dan larangan transisi status ilegal

**Risiko**

- **high** Penerimaan parsial dan retry dapat menggandakan movement bila command tidak idempotent; backend BE-3 harus lulus sebelum sinkronisasi purchase diaktifkan

**Verifikasi:** Purchase order dapat dibuat, disetujui, diterima sebagian/penuh, diretur, dan ditelusuri; stok serta histori pembelian konsisten

## ⬜ UI-11 — POS dan Penjualan (0/9 · 0%)

> Menyelesaikan alur jual nyata dari pencarian produk sampai transaksi, pembayaran, receipt, sinkronisasi, dan retur setelah inventory terbukti benar

- ⬜ `ui11-pos-catalog` Halaman /sales/pos responsif dengan ProductCard, pencarian/scan, filter kategori, harga-varian, stok tersedia, dan katalog outlet aktif
- ⬜ `ui11-cart` Sambungkan CartBloc multi-tab ke CartPanel dan PaymentSummary; qty, diskon item/transaksi, pajak, hold/resume, dan total hanya dihitung domain service
- ⬜ `ui11-scanner` Satukan scanner kamera, HID wedge, dan input manual melalui AppBarcodeScope; barcode tidak dikenal menawarkan pencarian atau pembuatan produk sesuai izin
- ⬜ `ui11-checkout-local` Checkout lokal atomik memakai outlet/cashier dari AppSession, idempotency key stabil, payment tervalidasi, dan transaksi berstatus pending sebelum sinkron
- ⬜ `ui11-transactions` Halaman /sales/transactions dan /sales/transactions/:id membaca transaksi lokal/server, memuat item, pembayaran, status sync, audit, serta aksi yang sah
- ⬜ `ui11-sync-sale` Push transaksi setelah BE-3 lulus; retry tidak boleh menggandakan transaksi, pembayaran, stock movement, atau pengurangan stok
- ⬜ `ui11-payments-invoices` Halaman /sales/payments dan /sales/invoices untuk histori pembayaran, metode, kembalian/piutang yang didukung, status, dan dokumen penjualan
- ⬜ `ui11-returns` Halaman /sales/returns: pilih transaksi asal, batas qty, alasan, refund, state void/return kanonik, dan pengembalian stok yang terbukti
- ⬜ `ui11-receipt-shortcuts` ReceiptPreview 58/80 mm serta shortcut F2/F4/ESC/Ctrl+P; shortcut hanya aktif pada keyboard fisik dan tidak mengambil fokus field

**Keputusan**

- POS dipindahkan setelah CRM, inventory, dan purchase — Roadmap dependency menetapkan transaksi baru aman setelah product, customer, supplier, dan ledger stok tersedia; prototipe POS lebih awal terlihat maju tetapi memaksa ulang kontrak data

**Risiko**

- **high** Checkout menyalakan trigger paling berisiko; jangan aktifkan push produksi sebelum BE-2 memperbaiki schema dan BE-3 membuktikan semua trigger dengan data nyata

**Verifikasi:** Skenario scan → cart → bayar → receipt → transaksi/detail → void/return lulus lokal dan Supabase; stok, pembayaran, serta retry tetap konsisten

## ⬜ UI-12 — Keuangan (0/7 · 0%)

> Menyediakan sesi kas dan arus kas yang direkonsiliasi dengan transaksi, bukan pencatatan terpisah yang dapat menyimpang

- ⬜ `ui12-cash-sessions` Halaman /finance/cash-sessions: buka/tutup shift, saldo awal, expected versus actual, selisih, actor, dan larangan dua sesi aktif untuk kasir/outlet yang sama
- ⬜ `ui12-cash-in` Halaman /finance/cash-in: penerimaan non-penjualan dengan kategori, nominal, bukti, catatan, dan audit
- ⬜ `ui12-cash-out` Halaman /finance/cash-out: pengeluaran dengan validasi saldo/kebijakan, kategori, bukti, approval bila diperlukan, dan audit
- ⬜ `ui12-categories` Halaman /finance/categories: kategori pemasukan/pengeluaran, status aktif, dan perlindungan referensi histori
- ⬜ `ui12-cash-flow` Halaman /finance/cash-flow: agregasi masuk/keluar per periode, outlet, sumber, dan drill-down tanpa menghitung ulang aturan bisnis di widget
- ⬜ `ui12-history` Halaman /finance/history: ledger kas immutable dengan filter, referensi dokumen, actor, dan ekspor terbatas izin
- ⬜ `ui12-reconciliation` Uji rekonsiliasi checkout/refund/cash-in/cash-out terhadap sesi kas, pembulatan rupiah, pergantian hari, dan retry sinkronisasi

**Verifikasi:** Saldo buka/tutup kas, cash in/out, kategori, arus kas, dan histori cocok dengan pembayaran penjualan pada skenario normal, refund, serta koreksi

## ⬜ UI-13 — Dasbor dan Laporan (0/8 · 0%)

> Mengubah data operasional yang sudah stabil menjadi informasi keputusan; laporan tidak boleh mendahului sumber datanya

- ⬜ `ui13-dashboard` Halaman /dashboard: KPI sesuai izin, penjualan hari ini, stok rendah, aktivitas penting, periode/outlet aktif, dan deep link ke sumber
- ⬜ `ui13-sales-report` Halaman /reports/sales: omzet, transaksi, item, margin yang tersedia, tren, kasir/outlet/metode bayar, dan drill-down
- ⬜ `ui13-purchase-report` Halaman /reports/purchase: nilai pembelian, supplier, status penerimaan, retur, tren, dan drill-down PO
- ⬜ `ui13-inventory-report` Halaman /reports/inventory: valuation, stok rendah/habis, movement, adjustment, opname, dan ageing bila datanya tersedia
- ⬜ `ui13-cashflow-report` Halaman /reports/cash-flow: arus kas per sumber/kategori/outlet/periode dan rekonsiliasi dengan ledger finance
- ⬜ `ui13-profit-report` Halaman /reports/profit: pendapatan, HPP, diskon, pajak, biaya yang tercakup, formula transparan, dan penanda bila data belum lengkap
- ⬜ `ui13-export` Halaman /reports/export: ekspor CSV/PDF sesuai filter dan permission, nama file stabil, proses besar tidak memblokir UI, dan data sensitif tidak bocor
- ⬜ `ui13-report-performance` Tetapkan satu model filter lintas laporan, zona waktu Asia/Jakarta, batas pagination, serta uji angka terhadap query/view Supabase dan dataset acuan

**Risiko**

- **high** Laporan dapat terlihat benar tetapi berbeda akibat zona waktu, refund, atau pembulatan; setiap KPI wajib memiliki fixture acuan dan formula terdokumentasi

**Verifikasi:** Dasbor dan seluruh laporan cocok dengan fixture transaksi/purchase/inventory/finance, filter konsisten, empty/loading/error tersedia, dan kueri memenuhi anggaran performa

## ⬜ UI-14 — Setelan dan Perangkat (0/6 · 0%)

> Menuntaskan konfigurasi operasional yang tersisa serta integrasi perangkat setelah transaksi dan laporan stabil

- ⬜ `ui14-printer` Halaman /settings/printer: discovery/pemilihan printer yang didukung, test print, ukuran 58/80 mm, timeout, retry, dan fallback tanpa crash
- ⬜ `ui14-receipt` Halaman /settings/receipt: logo, header/footer, field opsional, preview identik dengan hasil cetak, dan konfigurasi per outlet
- ⬜ `ui14-notification` Halaman /settings/notification: preferensi per jenis notifikasi, permission perangkat, serta deep link yang tunduk pada RBAC
- ⬜ `ui14-backup` Halaman /settings/backup: status backup, ekspor/restore yang aman, konfirmasi destruktif, versioning schema, enkripsi, dan audit hasil
- ⬜ `ui14-preference` Halaman /settings/preference: tema, locale, density yang didukung, perilaku scanner, dan preferensi tersimpan per pengguna/perangkat sesuai jenisnya
- ⬜ `ui14-settings-audit` Audit seluruh halaman settings untuk scope business/outlet/user yang benar, permission, validasi, state offline, dan konfirmasi perubahan berisiko

**Risiko**

- **medium** Printer dan backup bergantung kemampuan platform; dukungan harus dinyatakan per Android/iOS/Web dan fitur yang tidak tersedia harus disabled dengan penjelasan

**Verifikasi:** Seluruh rute settings tidak lagi placeholder; preferensi bertahan, printer/receipt teruji pada target yang didukung, dan backup/restore melewati uji pemulihan

## ⬜ UI-15 — Release Candidate (0/8 · 0%)

> Membuktikan aplikasi sebagai satu sistem utuh, menghapus placeholder, dan menutup kualitas lintas fitur sebelum distribusi

- ⬜ `ui15-route-completeness` Registry memiliki builder untuk setiap rute MVP di AppNavTree; RoutePlaceholderPage hanya boleh tersisa untuk fitur yang resmi dikeluarkan dari scope dan tercatat
- ⬜ `ui15-critical-journeys` Integration test login → master → purchase → receiving → POS → payment → return → finance → report pada business dan outlet nyata
- ⬜ `ui15-offline-recovery` Uji airplane mode, restart saat antrean pending, koneksi putus di tengah push/pull, retry, konflik, dan pemulihan tanpa duplikasi atau kehilangan data
- ⬜ `ui15-security` Uji lintas role, business, outlet, deep link, cache lokal setelah logout, screenshot/log sensitif, dan kegagalan RLS sebagai bagian threat model
- ⬜ `ui15-performance` Profil cold start, katalog besar, scroll tabel, pencarian, checkout, sinkronisasi, dan laporan; tetapkan anggaran terukur serta perbaiki regresi
- ⬜ `ui15-accessibility` Audit ukuran sentuh, screen reader, urutan fokus, kontras, text scale, keyboard, reduced motion, orientasi, dan keadaan error
- ⬜ `ui15-device-matrix` Uji Android/iOS pada ponsel dan tablet sasaran, kamera barcode, HID scanner, printer yang didukung, lifecycle background/foreground, dan upgrade aplikasi
- ⬜ `ui15-release-checklist` Kunci konfigurasi production, migration/rollback, privacy/permission copy, observability, versi, changelog, backup, support runbook, dan keputusan go/no-go

**Verifikasi:** Tidak ada placeholder pada rute MVP; analyzer dan seluruh test hijau; critical journey lulus di perangkat target; tidak ada defect severity tinggi terbuka

# Track Backend Supabase — 11/44 (25%)

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
- → **BE-3**: Seluruh trigger baru ditinjau baris demi baris, belum pernah dijalankan dengan data nyata

**Verifikasi:** Diverifikasi langsung ke Supabase 2026-07-15 (ref emovquokperyixwnpqaa, PostgreSQL 17.6): 51 tabel, 6 view, 10 function, 8 trigger, 24 migrasi, RLS aktif di 51/51 tabel, 7 peran, 26 permission, 106 pemetaan role_permission

## ⬜ BE-1 — Quality Gate Kontrak Inti (0/6 · 0%)

> Menutup 12 quality gate identity, product-catalog, dan CRM sebelum UI nyata mengikat kontrak auth, tenant, dan master data

- ⬜ `be1-gate-has-permission` Uji public.has_permission() untuk user global maupun user spesifik outlet, termasuk bypass Owner
- ⬜ `be1-gate-rls-tenant` Uji RLS lintas tenant: bisnis A tidak bisa membaca role, katalog, atau customer milik bisnis B
- ⬜ `be1-gate-price-trigger` Buktikan trigger histori harga menulis baris baru ke product_prices saat harga produk diubah
- ⬜ `be1-gate-unit-migrasi` Verifikasi migrasi teks unit produk lama ke foreign key unit_id tanpa produk yang hilang
- ⬜ `be1-gate-crud-crm` Jalankan CRUD customer dan supplier di schema terbaru sampai bersih dari error
- ⬜ `be1-gate-centang` Centang gate yang sudah terbukti di tasks.md spec 01-03, samakan dengan gaya spec 04-11

**Keputusan**

- BE-1 adalah release gate untuk UI-6 — Kontrak auth dan organisasi tidak boleh dibekukan sebelum permission serta isolasi tenant terbukti dengan user dan business berbeda

**Risiko**

- **high** Centang dokumentasi tanpa bukti executable menghasilkan rasa aman palsu; setiap gate harus menunjuk test, query, atau hasil verifikasi yang dapat diulang

**Verifikasi:** Seluruh gate spec 01-03 dicentang dengan bukti SQL/test; has_permission, RLS lintas tenant, trigger harga, migrasi unit, dan CRUD CRM lulus

## ⬜ BE-2 — Hardening Skema dan Keamanan (0/7 · 0%)

> Menutup temuan struktural dan keamanan sebelum data operasional tumbuh sehingga migrasi masih murah, dapat dibalik, dan mudah diverifikasi

- ⬜ `be2-transaction-flag` T-02 Kritis: tambah CHECK constraint dan migrasi nilai transactions.flag ke state kanonik; trigger void tidak boleh bergantung pada ejaan yang tidak dijaga database
- ⬜ `be2-function-grants` T-03 Tinggi: cabut EXECUTE langsung untuk 8 trigger function SECURITY DEFINER dari anon/authenticated dan buktikan trigger tetap bekerja hanya lewat operasi tabel yang sah
- ⬜ `be2-product-parent` T-04: migrasikan referensi yang perlu lalu hapus products.parent_id; product_variants menjadi satu-satunya model varian
- ⬜ `be2-audit-columns` T-06: normalkan createdat/createdby/updatedat/updatedby serta users.isemailverified ke snake_case melalui migrasi kompatibel dan pembaruan client mapping
- ⬜ `be2-remove-password` T-07: hapus users.password dan pastikan tidak ada seed, view, function, atau client yang masih membacanya
- ⬜ `be2-transaction-uuid` T-08: ubah transactions.guid dari VARCHAR ke UUID dengan migrasi FK, validasi data lama, indeks, dan rollback plan
- ⬜ `be2-otp-policy` T-09: tetapkan policy otp_verifications atau pindahkan akses ke jalur server tepercaya; tabel tidak boleh tertutup total maupun terbuka langsung

**Risiko**

- **high** Migrasi guid dan kolom audit menyentuh FK serta client mapping; wajib diuji pada salinan data dan memiliki rollback sebelum diterapkan ke environment bersama
- **medium** Window menghapus products.parent_id sedang murah; menundanya sampai varian nyata dibuat akan memperbesar migrasi dan risiko kehilangan hubungan

**Verifikasi:** Semua migrasi apply dari baseline dan rollback di branch; constraint, grant, RLS, model varian, kolom audit, UUID, dan OTP policy terverifikasi

## ⬜ BE-3 — Seed Operasional dan Pembuktian Trigger (0/7 · 0%)

> Mengisi data acuan yang repeatable lalu membuktikan purchase, sales, void, stok, dan finance pada database yang sudah di-hardening

- ⬜ `be3-seed-organization` Seed idempotent business, outlet, warehouse, role, dan user uji dengan identifier stabil yang tidak bergantung pada DevSessionRepository
- ⬜ `be3-seed-master` Seed kategori, brand, unit, pajak, produk, varian, harga, barcode, customer, dan supplier yang cukup untuk seluruh skenario E2E
- ⬜ `be3-seed-region` Impor dataset wilayah Indonesia dengan sumber/version/checksum tercatat; loader repeatable dan tidak menggandakan provinces/cities/districts/villages
- ⬜ `be3-e2e-purchase` E2E purchase order → receiving parsial/penuh → stock movement → saldo stok; ulangi request yang sama untuk membuktikan idempotensi
- ⬜ `be3-e2e-sale` E2E checkout → transaction details → payments → stock movements → saldo stok/finance; uji tunai dan sedikitnya satu metode non-tunai
- ⬜ `be3-e2e-void-return` E2E void dan return dengan state kanonik: stok kembali tepat sekali, refund tercatat, dan request retry tidak menggandakan kompensasi
- ⬜ `be3-invariant-suite` Bangun suite invariant executable untuk saldo stok versus movement, total transaksi versus detail/payment, serta saldo finance versus mutasi

**Risiko**

- **high** T-01 Kritis: 8 trigger belum pernah dijalankan dengan data nyata; NULL, urutan trigger, locking, atau RAISE EXCEPTION dapat mematahkan alur E2E

**Verifikasi:** Seed idempotent; seluruh skenario E2E dan 8 trigger lulus dua kali tanpa duplikasi; invariant stok/finance diverifikasi setelah setiap transisi

## ⬜ BE-4 — Kontrak Sinkronisasi Offline (0/7 · 0%)

> Membuat push dan pull dua arah yang idempotent, teramati, serta memiliki kebijakan konflik eksplisit untuk perangkat baru maupun perangkat yang lama offline

- ⬜ `be4-sync-contract` Tetapkan envelope sync: entity, operation, idempotency_key, business/outlet, actor, client timestamp, server version, tombstone, retry class, dan error code
- ⬜ `be4-pull-master` Tarik organization, category, brand, unit, warehouse, tax, product, variant, price, dan barcode ke Drift dengan cursor per scope
- ⬜ `be4-pull-operational` Tarik customer, supplier, inventory balance/movement, purchase, sales, payment, dan finance sesuai ownership; instalasi baru tidak boleh kosong setelah bootstrap
- ⬜ `be4-push-idempotent` Push antrean lokal dengan idempotency key server-side, ordering dependency, exponential backoff, dead-letter state, dan retry manual yang aman
- ⬜ `be4-conflicts-deletes` Tentukan kebijakan konflik per entity dan dukung tombstone/arsip; jangan memakai last-write-wins universal untuk stok, pembayaran, atau status dokumen
- ⬜ `be4-observability` Sediakan status last sync, queue depth, cursor, error terstruktur, correlation id, dan diagnostic export tanpa membocorkan token atau data sensitif
- ⬜ `be4-two-device-test` Uji dua perangkat: create/update/delete, offline lama, jam perangkat salah, restart di tengah batch, duplicate delivery, perubahan outlet, dan schema upgrade

**Keputusan**

- Konflik transaksi diselesaikan oleh aturan domain, bukan timestamp — Last-write-wins dapat menghapus pembayaran atau menggandakan stok; command finansial dan inventory bersifat append-only/idempotent

**Risiko**

- **high** Sync dua arah adalah risiko arsitektur tertinggi aplikasi offline-first; jangan menandai fitur operasional production-ready hanya karena push satu arah berhasil

**Verifikasi:** Dua perangkat bertukar master dan transaksi tanpa duplikasi; restart/koneksi putus/retry/konflik lulus; queue dan cursor dapat didiagnosis

## ⬜ BE-5 — Release Backend (0/6 · 0%)

> Membuktikan database dapat dipasang, dimigrasikan, diamankan, dipantau, dicadangkan, dan dipulihkan sebagai layanan produksi

- ⬜ `be5-migration-rehearsal` Jalankan seluruh migration dari database kosong dan upgrade dari snapshot versi sebelumnya; dokumentasikan rollback/roll-forward setiap perubahan berisiko
- ⬜ `be5-rls-matrix` Uji matriks seluruh role × business × outlet × operasi pada tabel/RPC; anon hanya memiliki akses yang memang diperlukan
- ⬜ `be5-performance` Load test katalog, checkout concurrency, stock movement, sync batch, dan laporan; periksa query plan serta indeks terhadap anggaran yang ditetapkan
- ⬜ `be5-backup-restore` Buktikan backup terjadwal dan point-in-time/restore yang tersedia ke environment terpisah; ukur RPO/RTO dan verifikasi integritas
- ⬜ `be5-observability` Aktifkan monitoring error, slow query, failed auth, RLS denial abnormal, trigger failure, queue sync, storage, dan alert runbook
- ⬜ `be5-release-gate` Kunci migration checksum, seed non-production, secret/config inventory, retention, incident contacts, dan keputusan go/no-go bersama UI-15

**Risiko**

- **medium** Backup yang belum pernah direstore bukan backup yang terbukti; release gate gagal bila pemulihan hanya diasumsikan

**Verifikasi:** Baseline-to-head migration, RLS matrix, load test, backup/restore, observability, dan rollback rehearsal lulus di environment release candidate

