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
            AppSidebarItem(
              label: d.label,
              icon: d.icon,
              domainColor: d.color,
              onTap: () {
                // Laci harus ditutup lebih dulu pada layar sempit, kalau tidak
                // ia tetap menutupi halaman tujuan.
                if (Scaffold.of(context).isDrawerOpen) {
                  Navigator.of(context).pop();
                }
                context.go(d.route);
              },
            ),
        ],
        header: _ShellHeader(mode: mode),
      ),
      workspace: child,
    );
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
