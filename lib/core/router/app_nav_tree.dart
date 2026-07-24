import 'package:flutter/widgets.dart';

import '../constants/app_routes.dart';
import '../design/tokens/app_icons.dart';
import '../design/tokens/app_semantic_colors.dart';
import '../session/app_permissions.dart';
import '../session/app_session.dart';

/// Aksen domain sebuah area.
///
/// Disimpan sebagai enum, bukan [Color], supaya pohon navigasi tetap murni data
/// dan bisa diuji tanpa membangun widget tree sama sekali. Warnanya baru
/// diambil dari tema saat dirender.
enum AppNavAccent {
  sales,
  inventory,
  purchase,
  finance,

  /// Tanpa aksen domain sendiri; memakai aksen aplikasi.
  ///
  /// Dipakai CRM, Laporan, dan Setelan. Bukan kelalaian: `AppSemanticColors`
  /// hanya menyediakan empat warna domain, dan §16.6 meminta token lahir dari
  /// kebutuhan UX. Tiga area itu bukan area transaksional — tidak ada saat
  /// kasir harus mengenalinya dari warna sebelum sempat membaca labelnya.
  neutral;

  Color resolve(AppSemanticColors colors) => switch (this) {
        AppNavAccent.sales => colors.domainSales,
        AppNavAccent.inventory => colors.domainInventory,
        AppNavAccent.purchase => colors.domainPurchase,
        AppNavAccent.finance => colors.domainFinance,
        AppNavAccent.neutral => colors.accent,
      };
}

/// Satu tujuan navigasi.
@immutable
class AppNavDestination {
  final String label;
  final IconData icon;
  final String route;

  /// Izin yang membuka tujuan ini. Cukup **salah satu** dipegang.
  ///
  /// Kosong berarti tanpa syarat — hanya dasbor dan akun yang begitu.
  final List<String> permissions;

  /// Muncul sebagai butir menu. `false` untuk halaman detail dan formulir:
  /// keduanya tetap butuh entri agar penjaga tahu izinnya dan breadcrumb tahu
  /// induknya, tetapi tidak pantas berdiri sendiri di sidebar.
  final bool showInMenu;

  /// Halaman yang bersarang di bawah tujuan ini, misalnya detail dan formulir.
  final List<AppNavDestination> children;

  const AppNavDestination({
    required this.label,
    required this.icon,
    required this.route,
    this.permissions = const [],
    this.showInMenu = true,
    this.children = const [],
  });

  bool isVisibleTo(AppSession? session) =>
      permissions.isEmpty || (session?.canAny(permissions) ?? false);
}

/// Satu area besar aplikasi, mengikuti `13_Information_Architecture.md`.
@immutable
class AppNavArea {
  final String label;
  final IconData icon;
  final AppNavAccent accent;
  final List<String> permissions;
  final List<AppNavDestination> destinations;

  /// Muncul di sidebar dan bilah bawah. `false` untuk Akun, yang dicapai lewat
  /// bilah global dan bukan lewat navigasi utama.
  final bool showInMenu;

  const AppNavArea({
    required this.label,
    required this.icon,
    required this.destinations,
    this.accent = AppNavAccent.neutral,
    this.permissions = const [],
    this.showInMenu = true,
  });

  /// Sebuah area terlihat kalau izin areanya terpenuhi **dan** setidaknya satu
  /// tujuan di dalamnya bisa dibuka.
  ///
  /// Syarat kedua yang penting: area dengan izin longgar tapi seluruh isinya
  /// terkunci hanya menghasilkan menu yang membawa pengguna ke halaman 403.
  bool isVisibleTo(AppSession? session) {
    if (permissions.isNotEmpty && !(session?.canAny(permissions) ?? false)) {
      return false;
    }
    return destinations.any((d) => d.showInMenu && d.isVisibleTo(session));
  }

  /// Tujuan yang boleh dibuka pengguna ini, dalam urutan aslinya.
  List<AppNavDestination> visibleDestinations(AppSession? session) =>
      destinations.where((d) => d.showInMenu && d.isVisibleTo(session)).toList();

  /// Alamat yang dituju saat area ditekan di mode rail atau bilah bawah.
  ///
  /// Tujuan pertama yang **boleh dibuka**, bukan tujuan pertama begitu saja:
  /// Gudang yang menekan Persediaan tidak boleh mendarat di halaman yang
  /// langsung menolaknya.
  String? defaultRouteFor(AppSession? session) {
    final visible = visibleDestinations(session);
    return visible.isEmpty ? null : visible.first.route;
  }
}

/// Hasil pencocokan sebuah alamat terhadap pohon.
@immutable
class AppNavMatch {
  final AppNavArea area;
  final AppNavDestination destination;

  /// Terisi bila yang cocok adalah anak dari [destination], misalnya halaman
  /// detail. Breadcrumb memakainya sebagai ruas terakhir.
  final AppNavDestination? child;

  const AppNavMatch({
    required this.area,
    required this.destination,
    this.child,
  });

  /// Simpul terdalam yang cocok — inilah yang izinnya diperiksa penjaga.
  AppNavDestination get leaf => child ?? destination;
}

/// Sumber tunggal struktur navigasi.
///
/// Sidebar, bilah bawah, breadcrumb, tabel rute, dan penjaga izin semuanya
/// diturunkan dari sini. Memberi masing-masing daftarnya sendiri berarti
/// membuka peluang kelimanya menyimpang — menu menampilkan halaman yang
/// penjaganya tolak, atau breadcrumb kehilangan induk yang sidebar punya.
abstract final class AppNavTree {
  static const areas = <AppNavArea>[
    AppNavArea(
      label: 'Dasbor',
      icon: AppIcons.dashboard,
      destinations: [
        AppNavDestination(
          label: 'Ringkasan',
          icon: AppIcons.dashboard,
          route: AppRoutes.dashboard,
        ),
      ],
    ),
    AppNavArea(
      label: 'Penjualan',
      icon: AppIcons.sales,
      accent: AppNavAccent.sales,
      permissions: [AppPermissions.saleCreate, AppPermissions.saleView],
      destinations: [
        AppNavDestination(
          label: 'Kasir',
          icon: AppIcons.pos,
          route: AppRoutes.salesPos,
          permissions: [AppPermissions.saleCreate],
        ),
        AppNavDestination(
          label: 'Transaksi',
          icon: AppIcons.transaction,
          route: AppRoutes.salesTransactions,
          permissions: [AppPermissions.saleView],
          children: [
            AppNavDestination(
              label: 'Detail transaksi',
              icon: AppIcons.transaction,
              route: AppRoutes.salesTransactionDetail,
              permissions: [AppPermissions.saleView],
              showInMenu: false,
            ),
          ],
        ),
        AppNavDestination(
          label: 'Retur',
          icon: AppIcons.salesReturn,
          route: AppRoutes.salesReturns,
          permissions: [AppPermissions.saleVoid],
        ),
        AppNavDestination(
          label: 'Pembayaran',
          icon: AppIcons.payment,
          route: AppRoutes.salesPayments,
          permissions: [AppPermissions.saleView],
        ),
        AppNavDestination(
          label: 'Faktur',
          icon: AppIcons.invoice,
          route: AppRoutes.salesInvoices,
          permissions: [AppPermissions.saleView],
        ),
      ],
    ),
    AppNavArea(
      label: 'Persediaan',
      icon: AppIcons.inventory,
      accent: AppNavAccent.inventory,
      permissions: [AppPermissions.productRead, AppPermissions.stockRead],
      destinations: [
        AppNavDestination(
          label: 'Produk',
          icon: AppIcons.product,
          route: AppRoutes.inventoryProducts,
          permissions: [AppPermissions.productRead],
          children: [
            AppNavDestination(
              label: 'Produk baru',
              icon: AppIcons.add,
              route: AppRoutes.inventoryProductNew,
              permissions: [AppPermissions.productCreate],
              showInMenu: false,
            ),
            AppNavDestination(
              label: 'Detail produk',
              icon: AppIcons.product,
              route: AppRoutes.inventoryProductDetail,
              permissions: [AppPermissions.productRead],
              showInMenu: false,
            ),
          ],
        ),
        AppNavDestination(
          label: 'Kategori',
          icon: AppIcons.category,
          route: AppRoutes.inventoryCategories,
          permissions: [AppPermissions.productRead],
        ),
        AppNavDestination(
          label: 'Merek',
          icon: AppIcons.brand,
          route: AppRoutes.inventoryBrands,
          permissions: [AppPermissions.productRead],
        ),
        AppNavDestination(
          label: 'Satuan',
          icon: AppIcons.unit,
          route: AppRoutes.inventoryUnits,
          permissions: [AppPermissions.productRead],
        ),
        AppNavDestination(
          label: 'Gudang',
          icon: AppIcons.warehouse,
          route: AppRoutes.inventoryWarehouses,
          permissions: [AppPermissions.stockRead],
        ),
        AppNavDestination(
          label: 'Stok',
          icon: AppIcons.stock,
          route: AppRoutes.inventoryStocks,
          permissions: [AppPermissions.stockRead],
        ),
        AppNavDestination(
          label: 'Penyesuaian',
          icon: AppIcons.stockAdjustment,
          route: AppRoutes.inventoryAdjustments,
          permissions: [AppPermissions.stockAdjust],
        ),
        AppNavDestination(
          label: 'Transfer',
          icon: AppIcons.stockTransfer,
          route: AppRoutes.inventoryTransfers,
          permissions: [AppPermissions.stockTransfer],
        ),
        AppNavDestination(
          label: 'Stock opname',
          icon: AppIcons.stockOpname,
          route: AppRoutes.inventoryOpname,
          permissions: [AppPermissions.inventoryAdjust],
        ),
        AppNavDestination(
          label: 'Riwayat mutasi',
          icon: AppIcons.movementHistory,
          route: AppRoutes.inventoryMovements,
          permissions: [AppPermissions.stockRead],
        ),
      ],
    ),
    AppNavArea(
      label: 'Pembelian',
      icon: AppIcons.purchase,
      accent: AppNavAccent.purchase,
      permissions: [AppPermissions.purchaseRead],
      destinations: [
        AppNavDestination(
          label: 'Purchase order',
          icon: AppIcons.purchaseOrder,
          route: AppRoutes.purchaseOrders,
          permissions: [AppPermissions.purchaseRead],
          children: [
            AppNavDestination(
              label: 'Detail PO',
              icon: AppIcons.purchaseOrder,
              route: AppRoutes.purchaseOrderDetail,
              permissions: [AppPermissions.purchaseRead],
              showInMenu: false,
            ),
          ],
        ),
        AppNavDestination(
          label: 'Penerimaan',
          icon: AppIcons.receiving,
          route: AppRoutes.purchaseReceiving,
          permissions: [AppPermissions.purchaseReceive],
        ),
        AppNavDestination(
          label: 'Retur',
          icon: AppIcons.purchaseReturn,
          route: AppRoutes.purchaseReturns,
          permissions: [AppPermissions.purchaseRead],
        ),
        AppNavDestination(
          label: 'Riwayat',
          icon: AppIcons.movementHistory,
          route: AppRoutes.purchaseHistory,
          permissions: [AppPermissions.purchaseRead],
        ),
      ],
    ),
    AppNavArea(
      label: 'CRM',
      icon: AppIcons.crm,
      permissions: [AppPermissions.crmRead, AppPermissions.userManage],
      destinations: [
        AppNavDestination(
          label: 'Pelanggan',
          icon: AppIcons.customer,
          route: AppRoutes.crmCustomers,
          permissions: [AppPermissions.crmRead],
          children: [
            AppNavDestination(
              label: 'Detail pelanggan',
              icon: AppIcons.customer,
              route: AppRoutes.crmCustomerDetail,
              permissions: [AppPermissions.crmRead],
              showInMenu: false,
            ),
          ],
        ),
        AppNavDestination(
          label: 'Pemasok',
          icon: AppIcons.supplier,
          route: AppRoutes.crmSuppliers,
          permissions: [AppPermissions.crmRead],
          children: [
            AppNavDestination(
              label: 'Detail pemasok',
              icon: AppIcons.supplier,
              route: AppRoutes.crmSupplierDetail,
              permissions: [AppPermissions.crmRead],
              showInMenu: false,
            ),
          ],
        ),
        AppNavDestination(
          label: 'Pegawai',
          icon: AppIcons.employee,
          route: AppRoutes.crmEmployees,
          permissions: [AppPermissions.userManage],
        ),
      ],
    ),
    AppNavArea(
      label: 'Keuangan',
      icon: AppIcons.finance,
      accent: AppNavAccent.finance,
      permissions: [AppPermissions.cashView],
      destinations: [
        AppNavDestination(
          label: 'Sesi kas',
          icon: AppIcons.cashSession,
          route: AppRoutes.financeCashSessions,
          permissions: [AppPermissions.cashView],
        ),
        AppNavDestination(
          label: 'Kas masuk',
          icon: AppIcons.cashIn,
          route: AppRoutes.financeCashIn,
          permissions: [AppPermissions.cashCreate],
        ),
        AppNavDestination(
          label: 'Kas keluar',
          icon: AppIcons.cashOut,
          route: AppRoutes.financeCashOut,
          permissions: [AppPermissions.cashCreate],
        ),
        AppNavDestination(
          label: 'Kategori kas',
          icon: AppIcons.category,
          route: AppRoutes.financeCategories,
          permissions: [AppPermissions.cashView],
        ),
        AppNavDestination(
          label: 'Arus kas',
          icon: AppIcons.cashFlow,
          route: AppRoutes.financeCashFlow,
          permissions: [AppPermissions.cashView],
        ),
        AppNavDestination(
          label: 'Riwayat kas',
          icon: AppIcons.movementHistory,
          route: AppRoutes.financeHistory,
          permissions: [AppPermissions.cashView],
        ),
      ],
    ),
    AppNavArea(
      label: 'Laporan',
      icon: AppIcons.reporting,
      permissions: [AppPermissions.reportsRead],
      destinations: [
        AppNavDestination(
          label: 'Penjualan',
          icon: AppIcons.sales,
          route: AppRoutes.reportsSales,
          permissions: [AppPermissions.reportsRead],
        ),
        AppNavDestination(
          label: 'Pembelian',
          icon: AppIcons.purchase,
          route: AppRoutes.reportsPurchase,
          permissions: [AppPermissions.reportsRead],
        ),
        AppNavDestination(
          label: 'Persediaan',
          icon: AppIcons.inventory,
          route: AppRoutes.reportsInventory,
          permissions: [AppPermissions.reportsRead],
        ),
        AppNavDestination(
          label: 'Arus kas',
          icon: AppIcons.cashFlow,
          route: AppRoutes.reportsCashFlow,
          permissions: [AppPermissions.reportsRead],
        ),
        AppNavDestination(
          label: 'Laba',
          icon: AppIcons.profit,
          route: AppRoutes.reportsProfit,
          permissions: [AppPermissions.reportsRead],
        ),
        AppNavDestination(
          label: 'Ekspor',
          icon: AppIcons.export,
          route: AppRoutes.reportsExport,
          permissions: [AppPermissions.reportsRead],
        ),
      ],
    ),
    AppNavArea(
      label: 'Setelan',
      icon: AppIcons.settings,
      permissions: [AppPermissions.settingManage, AppPermissions.userManage],
      destinations: [
        AppNavDestination(
          label: 'Bisnis',
          icon: AppIcons.business,
          route: AppRoutes.settingsBusiness,
          permissions: [AppPermissions.settingManage],
        ),
        AppNavDestination(
          label: 'Outlet',
          icon: AppIcons.outlet,
          route: AppRoutes.settingsOutlets,
          permissions: [AppPermissions.settingManage],
        ),
        AppNavDestination(
          label: 'Pengguna',
          icon: AppIcons.user,
          route: AppRoutes.settingsUsers,
          permissions: [AppPermissions.userManage],
        ),
        AppNavDestination(
          label: 'Peran',
          icon: AppIcons.role,
          route: AppRoutes.settingsRoles,
          permissions: [AppPermissions.userManage],
        ),
        AppNavDestination(
          label: 'Printer',
          icon: AppIcons.printReceipt,
          route: AppRoutes.settingsPrinter,
          permissions: [AppPermissions.settingManage],
        ),
        AppNavDestination(
          label: 'Pajak',
          icon: AppIcons.tax,
          route: AppRoutes.settingsTax,
          permissions: [AppPermissions.settingManage],
        ),
        AppNavDestination(
          label: 'Struk',
          icon: AppIcons.invoice,
          route: AppRoutes.settingsReceipt,
          permissions: [AppPermissions.settingManage],
        ),
        AppNavDestination(
          label: 'Notifikasi',
          icon: AppIcons.notification,
          route: AppRoutes.settingsNotification,
          permissions: [AppPermissions.settingManage],
        ),
        AppNavDestination(
          label: 'Cadangan',
          icon: AppIcons.backup,
          route: AppRoutes.settingsBackup,
          permissions: [AppPermissions.settingManage],
        ),
        AppNavDestination(
          label: 'Preferensi',
          icon: AppIcons.preference,
          route: AppRoutes.settingsPreference,
          permissions: [AppPermissions.settingManage],
        ),
      ],
    ),
    // Akun dicapai lewat bilah global dan laci sekunder, bukan lewat navigasi
    // utama — karena itu punya entri (agar punya rute, penjaga, dan breadcrumb)
    // tetapi tidak muncul sebagai area di sidebar maupun bilah bawah.
    AppNavArea(
      label: 'Akun',
      icon: AppIcons.account,
      showInMenu: false,
      destinations: [
        AppNavDestination(
          label: 'Akun saya',
          icon: AppIcons.account,
          route: AppRoutes.account,
        ),
      ],
    ),
  ];

  /// Area yang boleh dilihat pengguna ini, dalam urutan aslinya.
  static List<AppNavArea> visibleAreas(AppSession? session) => areas
      .where((area) => area.showInMenu && area.isVisibleTo(session))
      .toList();

  /// Seluruh tujuan di seluruh area, termasuk yang tersembunyi.
  static Iterable<AppNavDestination> get allDestinations sync* {
    for (final area in areas) {
      for (final destination in area.destinations) {
        yield destination;
        yield* destination.children;
      }
    }
  }

  /// Mencari entri yang memuat [location].
  ///
  /// Kecocokan persis diuji lebih dulu, baru pola berparameter. Urutan itu
  /// bukan optimasi melainkan kebenaran: `/inventory/products/new` juga cocok
  /// dengan pola `/inventory/products/:id`, dan mendahulukan pola membuat
  /// formulir produk baru diperiksa dengan izin halaman detail.
  static AppNavMatch? match(String location) {
    final path = _normalize(location);

    for (final exact in [true, false]) {
      for (final area in areas) {
        for (final destination in area.destinations) {
          for (final child in destination.children) {
            if (_matches(child.route, path, exact: exact)) {
              return AppNavMatch(
                area: area,
                destination: destination,
                child: child,
              );
            }
          }
          if (_matches(destination.route, path, exact: exact)) {
            return AppNavMatch(area: area, destination: destination);
          }
        }
      }
    }

    return null;
  }

  /// Membuang query string dan garis miring di ujung.
  static String _normalize(String location) {
    final withoutQuery = location.split('?').first;
    if (withoutQuery.length > 1 && withoutQuery.endsWith('/')) {
      return withoutQuery.substring(0, withoutQuery.length - 1);
    }
    return withoutQuery;
  }

  static bool _matches(String pattern, String path, {required bool exact}) {
    final hasParam = pattern.contains(':');
    if (exact) return !hasParam && pattern == path;
    if (!hasParam) return false;

    final patternSegments = pattern.split('/');
    final pathSegments = path.split('/');
    if (patternSegments.length != pathSegments.length) return false;

    for (var i = 0; i < patternSegments.length; i++) {
      if (patternSegments[i].startsWith(':')) continue;
      if (patternSegments[i] != pathSegments[i]) return false;
    }
    return true;
  }
}
