import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_routes.dart';
import '../design/design.dart';
import '../design/gallery/design_gallery_page.dart';
import '../design/theme/theme_cubit.dart';
import 'app_navigation_shell.dart';

/// Konfigurasi rute aplikasi.
///
/// Halaman-halaman modul masih berupa penanda tempat — Phase UI-0 hanya
/// membangun fondasinya. Yang sudah nyata di sini adalah rangkanya: shell
/// navigasi, transisi yang mematuhi aturan gerak, dan galeri design system.
abstract final class AppRouter {
  static GoRouter build() {
    return GoRouter(
      initialLocation: AppRoutes.pos,
      debugLogDiagnostics: kDebugMode,
      routes: [
        ShellRoute(
          builder: (context, state, child) =>
              AppNavigationShell(child: child),
          routes: [
            _shellRoute(
              AppRoutes.pos,
              (context) => const _PlaceholderPage(
                title: 'Kasir',
                icon: AppIcons.pos,
                note: 'Layar POS akan dibangun pada fase berikutnya. '
                    'CartBloc dan CheckoutUseCase sudah siap dipakai.',
              ),
            ),
            _shellRoute(
              AppRoutes.dashboard,
              (context) => const _PlaceholderPage(
                title: 'Dasbor',
                icon: AppIcons.dashboard,
                note: 'Ringkasan penjualan, laba, dan peringatan stok.',
              ),
            ),
            _shellRoute(
              AppRoutes.products,
              (context) => const _PlaceholderPage(
                title: 'Produk',
                icon: AppIcons.product,
                note: 'ProductBloc sudah tersedia lewat get_it.',
              ),
            ),
            _shellRoute(
              AppRoutes.transactions,
              (context) => const _PlaceholderPage(
                title: 'Transaksi',
                icon: AppIcons.transaction,
                note: 'Riwayat transaksi beserta status sinkronisasinya.',
              ),
            ),
          ],
        ),

        // Galeri berada di luar shell agar bisa memakai seluruh lebar layar,
        // dan hanya terdaftar pada build debug supaya tidak pernah ikut
        // terkirim ke perangkat kasir.
        if (kDebugMode)
          GoRoute(
            path: AppRoutes.designGallery,
            // Sakelar tema dirakit di sini, bukan di dalam galeri: galeri harus
            // tetap bisa dirender tanpa DI agar uji asapnya murah.
            pageBuilder: (context, state) => _page(
              state,
              BlocBuilder<ThemeCubit, ThemeMode>(
                builder: (context, mode) => DesignGalleryPage(
                  themeMode: mode,
                  onThemeModeChanged: context.read<ThemeCubit>().setMode,
                ),
              ),
            ),
          ),
      ],
    );
  }

  static GoRoute _shellRoute(String path, WidgetBuilder builder) {
    return GoRoute(
      path: path,
      pageBuilder: (context, state) => _page(state, builder(context)),
    );
  }

  /// Membungkus halaman dengan transisi milik design system.
  ///
  /// Durasi ditetapkan di sini, bukan di [PageTransitionsTheme], karena tema
  /// hanya menentukan tampilan transisi sedangkan lamanya milik rute.
  /// Tanpa ini, transisi akan memakai 300 ms bawaan Material — melebihi plafon
  /// 220 ms yang ditetapkan design system.
  static CustomTransitionPage<void> _page(GoRouterState state, Widget child) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionDuration: AppMotion.deliberate,
      reverseTransitionDuration: AppMotion.deliberate,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        if (MediaQuery.disableAnimationsOf(context)) return child;

        final curved = CurvedAnimation(
          parent: animation,
          curve: AppMotion.standard,
        );

        return FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.02, 0),
              end: Offset.zero,
            ).animate(curved),
            child: child,
          ),
        );
      },
    );
  }
}

/// Penanda tempat sementara untuk modul yang belum di-slice.
///
/// Sengaja dibuat memakai komponen design system, bukan `Center(child: Text())`
/// seadanya: dengan begitu setiap rute yang ada sudah membuktikan bahwa shell,
/// token, dan primitive bekerja pada ukuran layar mana pun.
class _PlaceholderPage extends StatelessWidget {
  final String title;
  final IconData icon;
  final String note;

  const _PlaceholderPage({
    required this.title,
    required this.icon,
    required this.note,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(context.space.xl),
      child: AppPanel(
        header: Row(
          children: [
            Icon(icon, size: 18, color: context.colors.textSecondary),
            SizedBox(width: context.space.sm),
            Text(title, style: context.text.toolbarTitle),
          ],
        ),
        child: AppEmptyState(
          title: 'Belum dibangun',
          message: note,
          icon: icon,
          action: kDebugMode
              ? AppButton(
                  label: 'Buka galeri design system',
                  variant: AppButtonVariant.secondary,
                  size: AppButtonSize.small,
                  onPressed: () => context.go(AppRoutes.designGallery),
                )
              : null,
        ),
      ),
    );
  }
}
