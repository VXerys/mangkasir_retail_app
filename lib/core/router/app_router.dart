import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_routes.dart';
import '../design/design.dart';
import '../session/session_cubit.dart';
import '../session/session_state.dart';
import 'app_nav_tree.dart';
import 'app_navigation_shell.dart';
import 'app_page_registry.dart';
import 'app_route_guard.dart';
import 'login_page.dart';
import 'route_placeholder.dart';

/// Konfigurasi rute aplikasi.
///
/// Seluruh tabel rute **diturunkan** dari [AppNavTree], tidak ditulis ulang di
/// sini. Dua daftar terpisah pasti menyimpang cepat atau lambat: menu yang
/// menunjuk rute yang tidak terdaftar, atau rute yang terdaftar tapi tak
/// terjangkau menu mana pun. Dengan satu sumber, keduanya mustahil.
abstract final class AppRouter {
  static GoRouter build({required SessionCubit session}) {
    return GoRouter(
      initialLocation: AppRoutes.root,
      debugLogDiagnostics: kDebugMode,
      // Tanpa ini, keputusan penjaga membeku pada keadaan sesi saat rute
      // pertama kali dibangun — masuk berhasil tetapi layar tidak berpindah.
      refreshListenable: _SessionRefresh(session),
      redirect: (context, state) =>
          AppRouteGuard.redirect(session.state, state.uri.path),
      routes: [
        GoRoute(
          path: AppRoutes.root,
          pageBuilder: (context, state) => _page(state, const AppBootPage()),
        ),
        GoRoute(
          path: AppRoutes.login,
          pageBuilder: (context, state) => _page(state, const LoginPage()),
        ),
        ShellRoute(
          builder: (context, state, child) => AppNavigationShell(child: child),
          routes: [
            // Urutannya mengikuti pohon, dan itu penting: anak didaftarkan
            // sesudah induknya, dan `/inventory/products/new` sebelum
            // `/inventory/products/:id` — kalau terbalik, formulir produk baru
            // ditelan pola detail.
            for (final area in AppNavTree.areas)
              for (final destination in area.destinations) ...[
                _navRoute(area, destination),
                for (final child in destination.children)
                  _navRoute(area, destination, child),
              ],
            GoRoute(
              path: AppRoutes.forbidden,
              pageBuilder: (context, state) =>
                  _page(state, const AppForbiddenPage()),
            ),
          ],
        ),
      ],
    );
  }

  static GoRoute _navRoute(
    AppNavArea area,
    AppNavDestination destination, [
    AppNavDestination? child,
  ]) {
    final match = AppNavMatch(
      area: area,
      destination: destination,
      child: child,
    );

    final path = (child ?? destination).route;
    final builder = AppPageRegistry.lookup(path);

    return GoRoute(
      path: path,
      // Rute selalu terdaftar; yang berbeda hanya isinya. Alamat yang belum
      // punya halaman tetap membuktikan shell, izin, dan breadcrumb bekerja.
      pageBuilder: (context, state) => _page(
        state,
        builder?.call(context, state) ?? RoutePlaceholderPage(match: match),
      ),
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

/// Menjembatani aliran [SessionCubit] ke `refreshListenable` GoRouter.
///
/// GoRouter menuntut [Listenable], sedangkan bloc menyiarkan [Stream].
class _SessionRefresh extends ChangeNotifier {
  late final StreamSubscription<SessionState> _subscription;

  _SessionRefresh(SessionCubit cubit) {
    _subscription = cubit.stream.listen((_) => notifyListeners());
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
