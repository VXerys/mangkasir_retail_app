import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_routes.dart';
import '../design/design.dart';
import '../session/app_session.dart';
import '../session/session_cubit.dart';
import '../session/session_scope.dart';
import '../sync/sync_bloc/sync_bloc.dart';
import '../sync/sync_failure_listener.dart';
import 'app_nav_tree.dart';

/// Kerangka navigasi aplikasi: mengisi slot [AppShell] dengan menu sebenarnya.
///
/// Memisahkan berkas ini dari [AppShell] adalah keputusan yang disengaja.
/// [AppShell] hanya tahu soal tata letak dan titik henti — dia tidak tahu
/// apa-apa tentang rute maupun modul bisnis. Di sinilah keduanya dipertemukan,
/// dan sejak Phase UI-4 juga tempat sesi bertemu keduanya.
///
/// Tidak ada satu pun daftar tujuan yang ditulis di berkas ini. Semuanya
/// diturunkan dari [AppNavTree] lalu disaring oleh izin yang dipegang pengguna,
/// sesuai `13_Information_Architecture.md`: "Menu dibangun secara dinamis
/// berdasarkan permission, bukan hardcoded."
class AppNavigationShell extends StatefulWidget {
  /// Halaman yang sedang aktif, disediakan oleh `ShellRoute`.
  final Widget child;

  /// Sumber kabar sinkronisasi. Ditempatkan di sini — bukan di AppRoot.builder
  /// — karena ShellRoute berada di dalam Navigator sehingga konteksnya punya
  /// Overlay. AppRoot.builder berada di atas Navigator dan konteksnya tidak
  /// mempunyai Overlay, sehingga AppToast tidak bisa menggambar di sana.
  final SyncBloc? sync;

  const AppNavigationShell({super.key, required this.child, this.sync});

  @override
  State<AppNavigationShell> createState() => _AppNavigationShellState();
}

class _AppNavigationShellState extends State<AppNavigationShell> {
  /// Kunci ke Scaffold milik [AppShell].
  ///
  /// Bilah atas dan bilah bawah dibangun dari konteks widget ini, yang berada
  /// di atas Scaffold — `Scaffold.of` dari sini tidak menemukan apa pun.
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  /// Jumlah area yang muat di bilah bawah sebelum sisanya masuk "Lainnya".
  ///
  /// Empat, bukan lima: slot kelima selalu milik "Lainnya". Peran yang kebetulan
  /// berhak atas tepat lima area pun tetap kehilangan satu ke laci — konsisten
  /// lebih berharga daripada satu ketukan yang dihemat, karena posisi tombol
  /// yang berpindah-pindah menurut peran justru melatih tangan yang salah.
  static const _primaryBottomNavSlots = 4;

  @override
  Widget build(BuildContext context) {
    final session = context.sessionOrNull;
    final location = GoRouterState.of(context).uri.path;
    final match = AppNavTree.match(location);
    final areas = AppNavTree.visibleAreas(session);

    return SyncFailureListener(
      bloc: widget.sync,
      child: AppShell(
        scaffoldKey: _scaffoldKey,
        appBar: _buildTopBar(context, session, match),
        sidebarBuilder: (context, mode) => AppSidebar(
          mode: mode,
          header: _ShellHeader(mode: mode, session: session),
          // Keluar hidup di kaki sidebar, bukan hanya di laci ponsel. Tanpa ini
          // tablet — yang tidak punya laci sekunder — tidak punya jalan keluar
          // sama sekali sampai halaman Akun dibangun.
          footer: session == null
              ? null
              : _ShellFooter(mode: mode, scaffoldKey: _scaffoldKey),
          sections: [
            for (final area in areas)
              _sectionFor(context, area, match, session),
          ],
        ),
        bottomNavBuilder: (context) =>
            _buildBottomNav(context, areas, match, session),
        secondaryMenuBuilder: (context) => _SecondaryMenu(
          areas: areas,
          match: match,
          session: session,
          scaffoldKey: _scaffoldKey,
        ),
        workspace: widget.child,
      ),
    );
  }

  AppNavSection _sectionFor(
    BuildContext context,
    AppNavArea area,
    AppNavMatch? match,
    AppSession? session,
  ) {
    final accent = area.accent.resolve(context.colors);
    final isCurrentArea = match?.area.label == area.label;

    return AppNavSection(
      label: area.label,
      icon: area.icon,
      accentColor: accent,
      isSelected: isCurrentArea,
      onTap: () => _goToArea(context, _scaffoldKey, area, session),
      items: [
        for (final destination in area.visibleDestinations(session))
          AppNavItem(
            label: destination.label,
            icon: destination.icon,
            domainColor: accent,
            isSelected: match?.destination.route == destination.route,
            onTap: () => _goTo(context, _scaffoldKey, destination.route),
          ),
      ],
    );
  }

  Widget _buildBottomNav(
    BuildContext context,
    List<AppNavArea> areas,
    AppNavMatch? match,
    AppSession? session,
  ) {
    final primary = areas.take(_primaryBottomNavSlots).toList();
    final hasOverflow = areas.length > primary.length;

    return AppBottomNav(
      selectedIndex:
          primary.indexWhere((area) => area.label == match?.area.label),
      items: [
        for (final area in primary)
          AppNavItem(
            label: area.label,
            icon: area.icon,
            domainColor: area.accent.resolve(context.colors),
            onTap: () => _goToArea(context, _scaffoldKey, area, session),
          ),
      ],
      // Laci tetap tersedia meski seluruh area muat, karena isinya bukan hanya
      // area yang meluap: ganti outlet, akun, dan keluar hanya ada di sana.
      overflowItem: AppNavItem(
        label: hasOverflow ? 'Lainnya' : 'Menu',
        icon: AppIcons.menu,
        onTap: () => _scaffoldKey.currentState?.openDrawer(),
      ),
    );
  }

  PreferredSizeWidget _buildTopBar(
    BuildContext context,
    AppSession? session,
    AppNavMatch? match,
  ) {
    return AppTopBar(
      breadcrumbs: _breadcrumbsFor(context, match, session),
      outletName: session?.activeOutlet?.name,
      onSwitchOutlet: session != null && session.outlets.length > 1
          ? () => _showOutletSwitcher(context, _scaffoldKey, session)
          : null,
      onOpenAccount:
          session == null
              ? null
              : () => _goTo(context, _scaffoldKey, AppRoutes.account),
      // Ponsel membuka laci sekunder; tablet potret membuka pohon navigasi
      // penuh, karena rail di sampingnya hanya memuat ikon area. Mulai
      // `expanded` tombol ini hilang — sidebar sudah menampilkan seluruh
      // isinya, dan tombol yang membuka apa yang sudah terlihat hanya
      // mengajari pengguna bahwa ia perlu ditekan.
      onOpenMenu: context.windowSize <= WindowSize.medium
          ? () => _scaffoldKey.currentState?.openDrawer()
          : null,
    );
  }

  /// Jejak navigasi untuk halaman yang sedang dibuka.
  ///
  /// Ruas pertama selalu area, ruas berikutnya tujuan, dan ruas terakhir
  /// halaman anak bila ada. Halaman level 1 menghasilkan satu ruas saja, dan
  /// [AppBreadcrumb] sendiri yang memutuskan untuk tidak menampilkan apa pun.
  List<AppBreadcrumbItem> _breadcrumbsFor(
    BuildContext context,
    AppNavMatch? match,
    AppSession? session,
  ) {
    if (match == null) return const [];

    return [
      AppBreadcrumbItem(
        label: match.area.label,
        onTap: () => _goToArea(context, _scaffoldKey, match.area, session),
      ),
      AppBreadcrumbItem(
        label: match.destination.label,
        onTap: () => _goTo(context, _scaffoldKey, match.destination.route),
      ),
      if (match.child != null) AppBreadcrumbItem(label: match.child!.label),
    ];
  }

}

/// Menutup laci bila ia sedang terbuka.
///
/// Memakai kunci, bukan `Scaffold.of(context)`: seluruh pemanggil di berkas ini
/// dibangun dari konteks di atas Scaffold, dan `Scaffold.of` dari sana melempar
/// — tepat pada saat tombol ditekan, bukan saat dibangun.
void _closeDrawer(GlobalKey<ScaffoldState> key) {
  final state = key.currentState;
  if (state != null && state.isDrawerOpen) state.closeDrawer();
}

/// Berpindah rute, sekaligus menutup laci bila ia yang membuka jalan.
///
/// Fungsi tingkat berkas, bukan method: sidebar, bilah bawah, laci sekunder,
/// dan breadcrumb semuanya memerlukannya, dan tiga di antaranya adalah widget
/// terpisah yang tidak memegang [AppNavigationShell].
void _goTo(
  BuildContext context,
  GlobalKey<ScaffoldState> scaffoldKey,
  String route,
) {
  // Tanpa ini laci tetap menutupi halaman tujuan setelah perpindahan.
  _closeDrawer(scaffoldKey);
  context.go(route);
}

/// Membuka area pada tujuan pertama yang boleh dibuka pengguna ini.
void _goToArea(
  BuildContext context,
  GlobalKey<ScaffoldState> scaffoldKey,
  AppNavArea area,
  AppSession? session,
) {
  final route = area.defaultRouteFor(session);
  if (route != null) _goTo(context, scaffoldKey, route);
}

Future<void> _showOutletSwitcher(
  BuildContext context,
  GlobalKey<ScaffoldState> scaffoldKey,
  AppSession session,
) async {
  _closeDrawer(scaffoldKey);

  final cubit = context.read<SessionCubit>();

  final selected = await showAppDrawer<int>(
    context: context,
    builder: (drawerContext) => AppDrawer(
      title: 'Ganti outlet',
      subtitle: 'Seluruh data dan hak akses mengikuti outlet yang dipilih.',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final outlet in session.outlets)
            _OutletTile(
              name: outlet.name,
              isActive: outlet.id == session.activeOutlet?.id,
              onTap: () => Navigator.of(drawerContext).pop(outlet.id),
            ),
        ],
      ),
    ),
  );

  if (selected != null) await cubit.selectOutlet(selected);
}

class _OutletTile extends StatelessWidget {
  final String name;
  final bool isActive;
  final VoidCallback onTap;

  const _OutletTile({
    required this.name,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final density = context.space;

    return Material(
      color: isActive ? colors.accentSubtle : Colors.transparent,
      borderRadius: AppRadius.rSm,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.rSm,
        child: SizedBox(
          height: density.minTouchTarget,
          child: Row(
            children: [
              SizedBox(width: density.md),
              Icon(
                AppIcons.outlet,
                size: 18,
                color: isActive ? colors.accent : colors.textSecondary,
              ),
              SizedBox(width: density.sm),
              Expanded(
                child: Text(
                  name,
                  style: context.text.toolbarLabel.copyWith(
                    color: isActive ? colors.accent : colors.textSecondary,
                  ),
                ),
              ),
              if (isActive) ...[
                Icon(AppIcons.check, size: 16, color: colors.accent),
                SizedBox(width: density.md),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Isi laci di layar sempit.
///
/// Dua lapis. Di atas, area yang tidak muat di bilah bawah — tanpa ini, peran
/// dengan delapan area kehilangan empat di antaranya sama sekali. Di bawah, hal
/// yang disentuh sekali sehari atau kurang dan justru berbahaya bila mudah
/// tersenggol: ganti outlet mengubah seluruh konteks kerja, keluar mengakhiri
/// sesi kasir.
class _SecondaryMenu extends StatelessWidget {
  final List<AppNavArea> areas;
  final AppNavMatch? match;
  final AppSession? session;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const _SecondaryMenu({
    required this.areas,
    required this.match,
    required this.session,
    required this.scaffoldKey,
  });

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
              child: _ShellHeader(
                mode: AppSidebarMode.drawer,
                session: session,
              ),
            ),
            AppDivider(color: colors.borderSubtle),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: density.sm),
                children: [
                  for (final area in areas)
                    _SecondaryTile(
                      icon: area.icon,
                      label: area.label,
                      isActive: match?.area.label == area.label,
                      accentColor: area.accent.resolve(colors),
                      onTap: () =>
                          _goToArea(context, scaffoldKey, area, session),
                    ),
                  AppDivider(color: colors.borderSubtle),
                  if (session != null && session!.outlets.length > 1)
                    _SecondaryTile(
                      icon: AppIcons.outlet,
                      label: 'Ganti outlet',
                      onTap: () =>
                          _showOutletSwitcher(context, scaffoldKey, session!),
                    ),
                  _SecondaryTile(
                    icon: AppIcons.account,
                    label: 'Akun',
                    onTap: () =>
                        _goTo(context, scaffoldKey, AppRoutes.account),
                  ),
                ],
              ),
            ),
            AppDivider(color: colors.borderSubtle),
            _SecondaryTile(
              icon: AppIcons.logout,
              label: 'Keluar',
              isDestructive: true,
              onTap: () => _confirmSignOut(context, scaffoldKey),
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
  final bool isActive;
  final Color? accentColor;

  const _SecondaryTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
    this.isActive = false,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final density = context.space;
    final foreground = switch ((isDestructive, isActive)) {
      (true, _) => colors.danger.fg,
      (false, true) => colors.accent,
      (false, false) => colors.textSecondary,
    };

    return Material(
      color: isActive ? colors.accentSubtle : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: density.minTouchTarget,
          child: Row(
            children: [
              SizedBox(
                width: 3,
                height: density.minTouchTarget - density.sm,
                child: ColoredBox(
                  color: isActive
                      ? (accentColor ?? colors.accent)
                      : Colors.transparent,
                ),
              ),
              SizedBox(width: density.md - 3),
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

/// Kaki sidebar: satu-satunya jalan keluar di layar yang tidak punya laci
/// sekunder.
class _ShellFooter extends StatelessWidget {
  final AppSidebarMode mode;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const _ShellFooter({required this.mode, required this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    if (mode == AppSidebarMode.rail) {
      return AppIconButton(
        icon: AppIcons.logout,
        tooltip: 'Keluar',
        onPressed: () => _confirmSignOut(context, scaffoldKey),
      );
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: AppButton(
        label: 'Keluar',
        icon: AppIcons.logout,
        variant: AppButtonVariant.ghost,
        size: AppButtonSize.small,
        onPressed: () => _confirmSignOut(context, scaffoldKey),
      ),
    );
  }
}

/// Meminta penegasan sebelum mengakhiri sesi.
///
/// Sengaja menyebut akibatnya, bukan sekadar bertanya. Kasir yang keluar di
/// tengah antrean harus tahu apa yang terjadi pada keranjangnya.
Future<void> _confirmSignOut(
  BuildContext context,
  GlobalKey<ScaffoldState> scaffoldKey,
) async {
  final cubit = context.read<SessionCubit>();

  final confirmed = await showAppConfirm(
    context: context,
    title: 'Keluar dari MangRitel?',
    message: 'Keranjang yang belum diselesaikan akan tetap tersimpan di '
        'perangkat ini, tetapi Anda harus masuk lagi untuk membukanya.',
    confirmLabel: 'Keluar',
    isDestructive: true,
  );

  if (confirmed != true) return;

  _closeDrawer(scaffoldKey);
  await cubit.signOut();
}

class _ShellHeader extends StatelessWidget {
  final AppSidebarMode mode;
  final AppSession? session;

  const _ShellHeader({required this.mode, this.session});

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
              Text(
                session?.business.name ?? 'MangRitel',
                style: context.text.toolbarTitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                session?.activeOutlet?.name ?? 'Outlet belum dipilih',
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
