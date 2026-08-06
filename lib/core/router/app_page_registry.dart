import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_routes.dart';
import '../../features/catalog/brands/presentation/pages/brands_page.dart';
import '../../features/catalog/units/presentation/pages/units_page.dart';
import '../../features/categories/presentation/pages/categories_page.dart';
import '../../features/identity/presentation/pages/account_page.dart';
import '../../features/identity/presentation/pages/business_settings_page.dart';
import '../../features/identity/presentation/pages/outlets_page.dart';
import '../../features/identity/presentation/pages/roles_page.dart';
import '../../features/identity/presentation/pages/users_page.dart';
import '../../features/products/presentation/pages/product_form_page.dart';
import '../../features/products/presentation/pages/product_list_page.dart';
import '../../features/settings/tax/presentation/pages/tax_settings_page.dart';
import '../../features/warehouses/presentation/pages/warehouses_page.dart';

/// Membangun isi sebuah rute.
typedef AppPageBuilder = Widget Function(
  BuildContext context,
  GoRouterState state,
);

/// Halaman sungguhan yang sudah menggantikan penanda tempat.
///
/// **Ini bukan tabel rute kedua.** Tabel rute tetap diturunkan dari
/// [AppNavTree] oleh `AppRouter`; berkas ini hanya menjawab satu pertanyaan
/// tambahan — "apakah alamat ini sudah punya halaman?" Rute yang tidak
/// terdaftar di sini tetap ada, tetap dijaga izin, dan tetap punya breadcrumb;
/// isinya saja yang masih `RoutePlaceholderPage`. Konsekuensinya, mengubah
/// sebuah penanda tempat menjadi halaman sungguhan cukup satu baris di satu
/// berkas, dan tabel rute tidak pernah tersentuh.
///
/// Alternatif yang ditolak adalah menaruh pembangun halaman di
/// [AppNavDestination]. Itu memaksa `app_nav_tree.dart` mengimpor seluruh
/// halaman fitur, sedangkan pohon itu sengaja dibuat data murni supaya bisa
/// diuji tanpa membangun satu widget pun.
///
/// **Halaman di sini tidak boleh punya [Scaffold] sendiri.** Ia dirender ke
/// slot `workspace` milik `AppShell`, yang sudah menyediakan Scaffold, bilah
/// atas, sidebar, dan bilah bawah. Halaman yang menambah Scaffold-nya sendiri
/// mendapat bilah atas ganda dan bilah bawah yang rusak.
abstract final class AppPageRegistry {
  static final Map<String, AppPageBuilder> _pages = <String, AppPageBuilder>{
    // ── Identitas & organisasi (UI-6) ──────────────────────────────────────
    AppRoutes.account: AccountPage.pageBuilder,
    AppRoutes.settingsBusiness: BusinessSettingsPage.pageBuilder,
    AppRoutes.settingsOutlets: OutletsPage.pageBuilder,
    AppRoutes.settingsUsers: UsersPage.pageBuilder,
    AppRoutes.settingsRoles: RolesPage.pageBuilder,

    // ── Produk (UI-5) ──────────────────────────────────────────────────────
    // ── Master data katalog (UI-7) ─────────────────────────────────────────────
    AppRoutes.inventoryCategories: CategoriesPage.pageBuilder,
    AppRoutes.inventoryBrands: BrandsPage.pageBuilder,
    AppRoutes.inventoryUnits: UnitsPage.pageBuilder,
    AppRoutes.inventoryWarehouses: WarehousesPage.pageBuilder,
    AppRoutes.settingsTax: TaxSettingsPage.pageBuilder,

    AppRoutes.inventoryProducts: ProductListPage.build,
    AppRoutes.inventoryProductNew: ProductFormPage.buildNew,
    AppRoutes.inventoryProductDetail: ProductFormPage.buildEdit,
  };

  /// Pembangun untuk [route], atau null bila alamat itu masih penanda tempat.
  static AppPageBuilder? lookup(String route) => _pages[route];

  /// Alamat yang sudah punya halaman. Dipakai tes konsistensi.
  static Iterable<String> get routes => _pages.keys;
}
