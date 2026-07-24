import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_routes.dart';
import '../design/design.dart';

/// Kerangka navigasi aplikasi: mengisi slot [AppShell] dengan menu sebenarnya.
///
/// Memisahkan berkas ini dari [AppShell] adalah keputusan yang disengaja.
/// [AppShell] hanya tahu soal tata letak dan titik henti — dia tidak tahu
/// apa-apa tentang rute maupun modul bisnis. Di sinilah keduanya dipertemukan.
class AppNavigationShell extends StatelessWidget {
  /// Halaman yang sedang aktif, disediakan oleh `ShellRoute`.
  final Widget child;

  const AppNavigationShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final destinations = _destinations(context);
    final selectedIndex =
        destinations.indexWhere((d) => location.startsWith(d.route));

    return AppShell(
      sidebarBuilder: (context, mode) => AppSidebar(
        mode: mode,
        selectedIndex: selectedIndex,
        items: [
          for (final d in destinations)
            AppNavItem(
              label: d.label,
              icon: d.icon,
              domainColor: d.color,
              onTap: () => _goTo(context, d.route),
            ),
        ],
        header: _ShellHeader(mode: mode),
      ),
      // Layar sempit: tujuan yang sama, bentuk yang berbeda.
      bottomNavBuilder: (context) => AppBottomNav(
        selectedIndex: selectedIndex,
        items: [
          for (final d in destinations)
            AppNavItem(
              label: d.label,
              icon: d.icon,
              domainColor: d.color,
              onTap: () => _goTo(context, d.route),
            ),
        ],
        overflowItem: AppNavItem(
          label: 'Lainnya',
          icon: AppIcons.menu,
          onTap: () => Scaffold.of(context).openDrawer(),
        ),
      ),
      secondaryMenuBuilder: (context) => const _SecondaryMenu(),
      workspace: child,
    );
  }

  /// Berpindah rute, sekaligus menutup laci bila ia yang membuka jalan.
  void _goTo(BuildContext context, String route) {
    // Tanpa ini laci tetap menutupi halaman tujuan setelah perpindahan.
    if (Scaffold.of(context).isDrawerOpen) Navigator.of(context).pop();
    context.go(route);
  }

  List<_Destination> _destinations(BuildContext context) {
    final colors = context.colors;
    return [
      _Destination(
        label: 'Kasir',
        icon: AppIcons.pos,
        route: AppRoutes.pos,
        color: colors.domainSales,
      ),
      _Destination(
        label: 'Dasbor',
        icon: AppIcons.dashboard,
        route: AppRoutes.dashboard,
        color: colors.accent,
      ),
      _Destination(
        label: 'Produk',
        icon: AppIcons.product,
        route: AppRoutes.products,
        color: colors.domainInventory,
      ),
      _Destination(
        label: 'Transaksi',
        icon: AppIcons.transaction,
        route: AppRoutes.transactions,
        color: colors.domainFinance,
      ),
    ];
  }
}

@immutable
class _Destination {
  final String label;
  final IconData icon;
  final String route;
  final Color color;

  const _Destination({
    required this.label,
    required this.icon,
    required this.route,
    required this.color,
  });
}

/// Isi laci di layar sempit.
///
/// Bukan navigasi utama — itu sudah di bilah bawah. Yang tersisa di sini adalah
/// hal yang disentuh sekali sehari atau kurang, dan justru berbahaya bila mudah
/// tersenggol: ganti outlet mengubah seluruh konteks kerja, keluar mengakhiri
/// sesi kasir.
class _SecondaryMenu extends StatelessWidget {
  const _SecondaryMenu();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final density = context.space;

    return Container(
      color: colors.surfaceSubtle,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.all(density.md),
              child: const _ShellHeader(mode: AppSidebarMode.drawer),
            ),
            AppDivider(color: colors.borderSubtle),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: density.sm),
                children: [
                  _SecondaryTile(
                    icon: AppIcons.outlet,
                    label: 'Ganti outlet',
                    onTap: () {},
                  ),
                  _SecondaryTile(
                    icon: AppIcons.settings,
                    label: 'Setelan',
                    onTap: () {},
                  ),
                  _SecondaryTile(
                    icon: AppIcons.account,
                    label: 'Akun',
                    onTap: () {},
                  ),
                ],
              ),
            ),
            AppDivider(color: colors.borderSubtle),
            _SecondaryTile(
              icon: AppIcons.logout,
              label: 'Keluar',
              isDestructive: true,
              onTap: () {},
            ),
            SizedBox(height: density.sm),
          ],
        ),
      ),
    );
  }
}

class _SecondaryTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  const _SecondaryTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final density = context.space;
    final foreground =
        isDestructive ? colors.danger.fg : colors.textSecondary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: density.minTouchTarget,
          child: Row(
            children: [
              SizedBox(width: density.md),
              Icon(icon, size: 18, color: foreground),
              SizedBox(width: density.sm),
              Expanded(
                child: Text(
                  label,
                  style: context.text.toolbarLabel.copyWith(color: foreground),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShellHeader extends StatelessWidget {
  final AppSidebarMode mode;

  const _ShellHeader({required this.mode});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final mark = Container(
      width: 28,
      height: 28,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colors.accent,
        borderRadius: AppRadius.rSm,
      ),
      child: Text(
        'M',
        style: context.text.tableCellEmphasis.copyWith(
          color: colors.textOnAccent,
        ),
      ),
    );

    if (mode == AppSidebarMode.rail) return Center(child: mark);

    return Row(
      children: [
        mark,
        SizedBox(width: context.space.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('MangRitel', style: context.text.toolbarTitle),
              Text(
                'Outlet belum dipilih',
                style: context.text.formHelper.copyWith(
                  color: colors.textTertiary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
