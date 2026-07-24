import 'package:flutter/material.dart';

import '../../design.dart';

/// Bilah global di puncak area kerja.
///
/// `13_Information_Architecture.md` §Global Navigation menyebut lima penghuni:
/// Cari, Notifikasi, Bantuan, Profil, dan Pengalih Outlet. Phase UI-4 hanya
/// menyalakan dua yang benar-benar punya sumber data hari ini — pengalih outlet
/// dan menu akun. Sisanya menunggu UI-5, yang membawa status sync dan pusat
/// notifikasi sekaligus.
///
/// Slot yang belum terisi **tidak dirender**, bukan dirender dalam keadaan mati.
/// Tombol mati mengajari pengguna bahwa sebagian aplikasi tidak bisa dipercaya,
/// dan pelajaran itu bertahan lebih lama daripada tombolnya.
class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  /// Jejak navigasi. Halaman level 1 mengirim daftar kosong.
  final List<AppBreadcrumbItem> breadcrumbs;

  /// Nama outlet aktif. Null berarti belum ada sesi.
  final String? outletName;

  /// Membuka pengalih outlet. Null menyembunyikannya — outlet tunggal tidak
  /// perlu tombol untuk berpindah ke dirinya sendiri.
  final VoidCallback? onSwitchOutlet;

  /// Membuka menu akun.
  final VoidCallback? onOpenAccount;

  /// Membuka laci navigasi. Hanya dipakai di layar sempit.
  final VoidCallback? onOpenMenu;

  /// Diisi UI-5: indikator sync dan status jaringan.
  final Widget? status;

  /// Diisi fase pencarian global.
  final Widget? search;

  /// Aksi khusus halaman, misalnya "Tambah Produk".
  final List<Widget> actions;

  const AppTopBar({
    super.key,
    this.breadcrumbs = const [],
    this.outletName,
    this.onSwitchOutlet,
    this.onOpenAccount,
    this.onOpenMenu,
    this.status,
    this.search,
    this.actions = const [],
  });

  @override
  Size get preferredSize => const Size.fromHeight(52);

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final density = context.space;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(bottom: BorderSide(color: colors.borderDefault)),
      ),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: preferredSize.height,
          child: Row(
            children: [
              SizedBox(width: density.sm),
              if (onOpenMenu != null)
                AppIconButton(
                  icon: AppIcons.menu,
                  tooltip: 'Menu',
                  onPressed: onOpenMenu,
                ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: density.sm),
                  child: AppBreadcrumb(items: breadcrumbs),
                ),
              ),
              ?search,
              ?status,
              ...actions,
              if (outletName != null && onSwitchOutlet != null)
                _OutletChip(name: outletName!, onTap: onSwitchOutlet!),
              if (onOpenAccount != null)
                AppIconButton(
                  icon: AppIcons.account,
                  tooltip: 'Akun',
                  onPressed: onOpenAccount,
                ),
              SizedBox(width: density.sm),
            ],
          ),
        ),
      ),
    );
  }
}

/// Penanda outlet aktif, sekaligus pemicu pengalihnya.
///
/// Menampilkan nama outlet secara permanen, bukan menyembunyikannya di balik
/// menu: pada bisnis multi-outlet, tidak tahu sedang berada di outlet mana
/// berarti setiap transaksi berisiko masuk ke pembukuan cabang yang salah.
class _OutletChip extends StatelessWidget {
  final String name;
  final VoidCallback onTap;

  const _OutletChip({required this.name, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final density = context.space;
    final isCompact = context.windowSize == WindowSize.compact;

    return AppTooltip(
      message: 'Outlet aktif: $name',
      child: Material(
        color: Colors.transparent,
        borderRadius: AppRadius.rSm,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.rSm,
          child: Container(
            constraints: BoxConstraints(minHeight: density.minTouchTarget),
            padding: EdgeInsets.symmetric(horizontal: density.sm),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(AppIcons.outlet, size: 16, color: colors.textSecondary),
                // Di layar sempit hanya ikonnya yang tersisa; namanya sudah
                // dijamin muncul lewat tooltip dan laci pengalih.
                if (!isCompact) ...[
                  SizedBox(width: density.xs),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 140),
                    child: Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.text.toolbarLabel.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  ),
                ],
                Icon(AppIcons.expand, size: 16, color: colors.textTertiary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
