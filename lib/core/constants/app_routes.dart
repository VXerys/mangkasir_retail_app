/// Alamat rute aplikasi.
///
/// Disimpan sebagai konstanta, bukan ditulis sebagai literal di tempat
/// pemanggilan, supaya salah ketik ketahuan saat kompilasi dan bukan saat
/// kasir menekan tombol.
///
/// Jalur mengikuti `05_UI/15_Screen_Spesification.md`, dan hierarkinya
/// mengikuti area di `05_UI/13_Information_Architecture.md`: setiap layar
/// bersarang di bawah areanya. Dua koreksi dokumen yang tercermin di sini —
/// Produk pindah dari `/products` ke `/inventory/products` karena ia milik
/// area Persediaan, dan Dasbor bernama `/dashboard` dengan `/` diturunkan
/// menjadi pengalihan yang memilih tujuan menurut peran.
///
/// Yang menentukan **siapa** boleh membuka apa bukan berkas ini melainkan
/// `core/router/app_nav_tree.dart`; di sini hanya alamatnya.
abstract final class AppRoutes {
  // --- Di luar shell --------------------------------------------------------

  /// Pengalihan, bukan halaman: Kasir ke [salesPos], peran lain ke [dashboard].
  static const root = '/';

  static const login = '/login';

  /// Ditolak hak akses. Ada sebagai halaman sungguhan, bukan dialog, supaya
  /// tautan dalam yang tidak berhak punya tempat mendarat.
  static const forbidden = '/403';

  /// Galeri design system. Hanya terdaftar pada build debug.
  static const designGallery = '/dev/design';

  // --- Dasbor & akun --------------------------------------------------------

  static const dashboard = '/dashboard';
  static const account = '/account';

  // --- Penjualan ------------------------------------------------------------

  /// Kasir. Layar yang paling sering dibuka — pemilik toko boleh mampir ke
  /// dasbor, kasir tidak.
  static const salesPos = '/sales/pos';

  static const salesTransactions = '/sales/transactions';
  static const salesTransactionDetail = '/sales/transactions/:id';
  static const salesReturns = '/sales/returns';
  static const salesPayments = '/sales/payments';
  static const salesInvoices = '/sales/invoices';

  // --- Persediaan -----------------------------------------------------------

  static const inventoryProducts = '/inventory/products';
  static const inventoryProductNew = '/inventory/products/new';
  static const inventoryProductDetail = '/inventory/products/:id';
  static const inventoryCategories = '/inventory/categories';
  static const inventoryBrands = '/inventory/brands';
  static const inventoryUnits = '/inventory/units';
  static const inventoryWarehouses = '/inventory/warehouses';
  static const inventoryStocks = '/inventory/stocks';
  static const inventoryAdjustments = '/inventory/adjustments';
  static const inventoryTransfers = '/inventory/transfers';
  static const inventoryOpname = '/inventory/opname';
  static const inventoryMovements = '/inventory/movements';

  // --- Pembelian ------------------------------------------------------------

  static const purchaseOrders = '/purchase/orders';
  static const purchaseOrderDetail = '/purchase/orders/:id';
  static const purchaseReceiving = '/purchase/receiving';
  static const purchaseReturns = '/purchase/returns';
  static const purchaseHistory = '/purchase/history';

  // --- CRM ------------------------------------------------------------------
  //
  // Rumah kanonik seluruh kontak. Pembelian menaut ke pemasok di sini alih-alih
  // memiliki daftarnya sendiri — lihat koreksi di 13_Information_Architecture.md.

  static const crmCustomers = '/crm/customers';
  static const crmCustomerDetail = '/crm/customers/:id';
  static const crmSuppliers = '/crm/suppliers';
  static const crmSupplierDetail = '/crm/suppliers/:id';
  static const crmEmployees = '/crm/employees';

  // --- Keuangan -------------------------------------------------------------

  static const financeCashSessions = '/finance/cash-sessions';
  static const financeCashIn = '/finance/cash-in';
  static const financeCashOut = '/finance/cash-out';
  static const financeCategories = '/finance/categories';
  static const financeCashFlow = '/finance/cash-flow';
  static const financeHistory = '/finance/history';

  // --- Laporan --------------------------------------------------------------

  static const reportsSales = '/reports/sales';
  static const reportsPurchase = '/reports/purchase';
  static const reportsInventory = '/reports/inventory';
  static const reportsCashFlow = '/reports/cash-flow';
  static const reportsProfit = '/reports/profit';
  static const reportsExport = '/reports/export';

  // --- Setelan --------------------------------------------------------------

  static const settingsBusiness = '/settings/business';
  static const settingsOutlets = '/settings/outlets';
  static const settingsUsers = '/settings/users';
  static const settingsRoles = '/settings/roles';
  static const settingsPrinter = '/settings/printer';
  static const settingsTax = '/settings/tax';
  static const settingsReceipt = '/settings/receipt';
  static const settingsNotification = '/settings/notification';
  static const settingsBackup = '/settings/backup';
  static const settingsPreference = '/settings/preference';

  // --- Pembentuk jalur berparameter -----------------------------------------
  //
  // Menyusun jalur dengan interpolasi di tempat pemanggilan berarti pola
  // `:id` disalin ke banyak berkas, dan yang satu terlewat saat polanya
  // berubah. Ini pintu satu-satunya.

  static String transactionDetail(String id) => '/sales/transactions/$id';
  static String productDetail(String id) => '/inventory/products/$id';
  static String purchaseOrder(String id) => '/purchase/orders/$id';
  static String customerDetail(String id) => '/crm/customers/$id';
  static String supplierDetail(String id) => '/crm/suppliers/$id';

  /// Rute yang sengaja berada di luar pohon navigasi.
  ///
  /// Dipakai tes konsistensi: setiap rute lain **wajib** punya entri di
  /// `AppNavTree`, karena tanpa entri ia tidak punya izin penjaga, tidak punya
  /// induk breadcrumb, dan tidak bisa dicapai dari mana pun.
  static const outsideNavTree = <String>{
    root,
    login,
    forbidden,
    designGallery,
  };
}
