/// Kamus hak akses, disalin persis dari tabel `permissions` di Supabase.
///
/// Dibaca langsung dari basis data pada 24 Juli 2026 — 26 baris, tidak lebih
/// dan tidak kurang. Nilai-nilai ini **bukan** karangan aplikasi: setiap kode
/// di sini juga dipakai kebijakan RLS lewat `public.has_permission(code,
/// outlet_id)`. Salah ketik satu huruf berarti menu menghilang tanpa pesan
/// kesalahan apa pun, karena himpunan izin milik pengguna hanya berisi string.
///
/// Karena itu ada [all], dan ada tes yang memaksa setiap kode yang dirujuk
/// tabel rute berada di dalamnya.
abstract final class AppPermissions {
  // --- Produk ---------------------------------------------------------------

  /// Membaca katalog produk.
  static const productRead = 'PRODUCT_READ';

  /// Menciptakan produk baru.
  static const productCreate = 'PRODUCT_CREATE';

  /// Mengubah informasi produk.
  static const productUpdate = 'PRODUCT_UPDATE';

  /// Menghapus produk.
  static const productDelete = 'PRODUCT_DELETE';

  /// Akses penuh kelola produk (buat/edit/hapus). Hanya Owner dan
  /// Administrator yang memegangnya.
  static const productManage = 'PRODUCT_MANAGE';

  // --- Stok & persediaan ----------------------------------------------------

  /// Melihat level stok dan mutasi.
  static const stockRead = 'STOCK_READ';

  /// Melakukan penyesuaian stok manual.
  static const stockAdjust = 'STOCK_ADJUST';

  /// Melakukan transfer stok antar gudang/outlet.
  static const stockTransfer = 'STOCK_TRANSFER';

  /// Melihat stok, mutasi, dan kartu stok gudang.
  ///
  /// Tumpang tindih dengan [stockRead]; lihat [synonyms].
  static const inventoryView = 'INVENTORY_VIEW';

  /// Melakukan stock opname dan adjustment gudang.
  ///
  /// Tumpang tindih dengan [stockAdjust]; lihat [synonyms].
  static const inventoryAdjust = 'INVENTORY_ADJUST';

  // --- Penjualan ------------------------------------------------------------

  /// Membuat transaksi penjualan (checkout).
  static const saleCreate = 'SALE_CREATE';

  /// Melihat histori dan detail transaksi penjualan.
  static const saleView = 'SALE_VIEW';

  /// Melihat histori transaksi penjualan.
  ///
  /// Berdeskripsi sama dengan [saleView]; lihat [synonyms].
  static const saleRead = 'SALE_READ';

  /// Membatalkan/void transaksi penjualan.
  static const saleVoid = 'SALE_VOID';

  // --- Pembelian ------------------------------------------------------------

  /// Melihat daftar dan detail PO.
  static const purchaseRead = 'PURCHASE_READ';

  /// Membuat purchase order baru.
  static const purchaseCreate = 'PURCHASE_CREATE';

  /// Menyetujui purchase order. Hanya Owner dan Administrator.
  static const purchaseApprove = 'PURCHASE_APPROVE';

  /// Membuat dan memposting Goods Receipt dari PO.
  static const purchaseReceive = 'PURCHASE_RECEIVE';

  // --- CRM ------------------------------------------------------------------

  /// Melihat data pelanggan/supplier.
  static const crmRead = 'CRM_READ';

  /// Menambah data pelanggan/supplier baru.
  static const crmCreate = 'CRM_CREATE';

  /// Mengubah data pelanggan/supplier.
  static const crmUpdate = 'CRM_UPDATE';

  // --- Kas ------------------------------------------------------------------

  /// Melihat saldo dan histori kas cabang.
  static const cashView = 'CASH_VIEW';

  /// Mencatat pengeluaran/pemasukan kas manual.
  static const cashCreate = 'CASH_CREATE';

  // --- Laporan --------------------------------------------------------------

  /// Melihat laporan penjualan dan keuangan.
  static const reportsRead = 'REPORTS_READ';

  // --- Setelan --------------------------------------------------------------

  /// Mengubah konfigurasi dan pengaturan outlet.
  static const settingManage = 'SETTING_MANAGE';

  /// Menambah, mengedit, dan menonaktifkan user cabang. Hanya Owner.
  static const userManage = 'USER_MANAGE';

  /// Seluruh isi tabel `permissions`.
  ///
  /// Dipakai tes untuk membuktikan bahwa tabel rute tidak menyebut kode yang
  /// tidak ada di server. Tanpa jaring ini, `'PRODUCT_VIEW'` (yang terdengar
  /// benar tetapi tidak pernah ada) akan lolos diam-diam dan menyembunyikan
  /// seluruh area Persediaan dari semua orang.
  static const all = <String>{
    productRead,
    productCreate,
    productUpdate,
    productDelete,
    productManage,
    stockRead,
    stockAdjust,
    stockTransfer,
    inventoryView,
    inventoryAdjust,
    saleCreate,
    saleView,
    saleRead,
    saleVoid,
    purchaseRead,
    purchaseCreate,
    purchaseApprove,
    purchaseReceive,
    crmRead,
    crmCreate,
    crmUpdate,
    cashView,
    cashCreate,
    reportsRead,
    settingManage,
    userManage,
  };

  /// Pasangan kode yang artinya sama di kamus server.
  ///
  /// Ini cacat data di sisi backend, bukan keputusan desain: `SALE_READ` dan
  /// `SALE_VIEW` berdeskripsi identik dan selalu di-seed berpasangan, sementara
  /// `INVENTORY_VIEW`/`STOCK_READ` dan `INVENTORY_ADJUST`/`STOCK_ADJUST` saling
  /// tumpang tindih.
  ///
  /// Aplikasi memilih satu wakil dari tiap pasangan dan menerima yang lain
  /// sebagai setara. Dikumpulkan di sini — bukan disebar sebagai `||` di
  /// puluhan tempat — supaya kalau tim backend membereskan kamusnya nanti,
  /// hanya berkas ini yang berubah.
  static const synonyms = <String, String>{
    saleRead: saleView,
    inventoryView: stockRead,
    inventoryAdjust: stockAdjust,
  };

  /// Menyetarakan sebuah kode dengan wakil pasangannya.
  static String canonical(String code) => synonyms[code] ?? code;
}
