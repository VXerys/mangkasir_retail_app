import 'app_permissions.dart';

/// Nama peran yang di-seed di tabel `roles`.
///
/// Sengaja **bukan** enum. Ketujuh peran ini berlaku global lintas tenant
/// (`roles.business_id` NULL), dan tenant boleh membuat peran sendiri kelak.
/// Enum akan melempar saat menemui nama yang tak dikenal; string tidak — peran
/// baru cukup membawa himpunan izinnya sendiri dan menu ikut menyesuaikan tanpa
/// satu baris pun berubah di sini.
///
/// Karena itu pula tidak ada satu pun tempat di aplikasi yang boleh menulis
/// `if (role == manager)`. Satu-satunya peran yang namanya benar-benar berarti
/// adalah [owner], dan itu pun bukan pilihan kita — lihat di bawah.
abstract final class AppRole {
  /// Pemilik bisnis.
  ///
  /// Satu-satunya nama peran yang boleh diperiksa langsung, karena
  /// `public.has_permission` di database mengembalikan TRUE untuk Owner tanpa
  /// melihat kode yang diminta. Kalau klien tidak ikut mem-bypass, UI akan
  /// menyembunyikan menu yang justru diizinkan server — pemilik toko melihat
  /// aplikasi yang lebih miskin daripada kasirnya.
  static const owner = 'Owner';

  static const administrator = 'Administrator';
  static const manager = 'Manager';
  static const kasir = 'Kasir';
  static const purchasing = 'Purchasing';
  static const gudang = 'Gudang';
  static const finance = 'Finance';

  /// Ketujuh peran bawaan. Bukan daftar tertutup — lihat catatan kelas.
  static const seeded = <String>[
    owner,
    administrator,
    manager,
    kasir,
    purchasing,
    gudang,
    finance,
  ];

  /// Himpunan izin bawaan tiap peran, disalin dari `role_permissions`.
  ///
  /// Hanya dipakai [DevSessionRepository] untuk membangun sesi contoh selama
  /// autentikasi sungguhan belum ada. Saat login asli terpasang, izin datang
  /// dari server dan peta ini tidak lagi dibaca siapa pun kecuali galeri.
  ///
  /// Owner sengaja diberi daftar penuh meski ia sudah mem-bypass: dengan begitu
  /// galeri tetap menampilkan sesuatu yang jujur kalau bypass-nya dimatikan.
  static const seededPermissions = <String, Set<String>>{
    owner: AppPermissions.all,
    administrator: {
      AppPermissions.productRead,
      AppPermissions.productCreate,
      AppPermissions.productUpdate,
      AppPermissions.productDelete,
      AppPermissions.productManage,
      AppPermissions.stockRead,
      AppPermissions.stockAdjust,
      AppPermissions.stockTransfer,
      AppPermissions.inventoryView,
      AppPermissions.inventoryAdjust,
      AppPermissions.saleCreate,
      AppPermissions.saleRead,
      AppPermissions.saleView,
      AppPermissions.saleVoid,
      AppPermissions.purchaseRead,
      AppPermissions.purchaseCreate,
      AppPermissions.purchaseApprove,
      AppPermissions.purchaseReceive,
      AppPermissions.crmRead,
      AppPermissions.crmCreate,
      AppPermissions.crmUpdate,
      AppPermissions.cashView,
      AppPermissions.cashCreate,
      AppPermissions.reportsRead,
      AppPermissions.settingManage,
    },
    manager: {
      AppPermissions.productRead,
      AppPermissions.productCreate,
      AppPermissions.productUpdate,
      AppPermissions.stockRead,
      AppPermissions.stockAdjust,
      AppPermissions.stockTransfer,
      AppPermissions.inventoryView,
      AppPermissions.inventoryAdjust,
      AppPermissions.saleCreate,
      AppPermissions.saleRead,
      AppPermissions.saleView,
      AppPermissions.purchaseRead,
      AppPermissions.purchaseCreate,
      AppPermissions.purchaseReceive,
      AppPermissions.crmRead,
      AppPermissions.crmCreate,
      AppPermissions.crmUpdate,
      AppPermissions.cashView,
      AppPermissions.cashCreate,
      AppPermissions.reportsRead,
      AppPermissions.settingManage,
    },
    kasir: {
      AppPermissions.productRead,
      AppPermissions.inventoryView,
      AppPermissions.saleCreate,
      AppPermissions.saleRead,
      AppPermissions.saleView,
      AppPermissions.saleVoid,
      AppPermissions.crmRead,
      AppPermissions.crmCreate,
      AppPermissions.crmUpdate,
      AppPermissions.cashView,
      AppPermissions.cashCreate,
    },
    purchasing: {
      AppPermissions.productRead,
      AppPermissions.stockRead,
      AppPermissions.inventoryView,
      AppPermissions.purchaseRead,
      AppPermissions.purchaseCreate,
      AppPermissions.purchaseReceive,
      AppPermissions.crmRead,
      AppPermissions.crmCreate,
      AppPermissions.crmUpdate,
    },
    gudang: {
      AppPermissions.productRead,
      AppPermissions.stockRead,
      AppPermissions.stockAdjust,
      AppPermissions.stockTransfer,
      AppPermissions.inventoryView,
      AppPermissions.inventoryAdjust,
      AppPermissions.purchaseRead,
      AppPermissions.purchaseReceive,
    },
    finance: {
      AppPermissions.saleRead,
      AppPermissions.saleView,
      AppPermissions.purchaseRead,
      AppPermissions.cashView,
      AppPermissions.cashCreate,
      AppPermissions.reportsRead,
    },
  };
}
