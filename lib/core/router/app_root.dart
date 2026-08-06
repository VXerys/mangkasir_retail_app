import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../design/theme/app_theme.dart';
import '../session/session_cubit.dart';
import '../session/session_scope.dart';
import '../session/session_state.dart';
import '../sync/sync_bloc/sync_bloc.dart';
import 'app_router.dart';

/// Merakit router, tema, dan sesi menjadi satu aplikasi.
///
/// Diangkat keluar dari `main()` supaya tes bisa menjalankan **rakitan yang
/// sama** dengan yang dipakai perangkat sungguhan. Menyusun ulang perakitan ini
/// di dalam tes berarti tes tetap hijau meski `main()` merakitnya keliru — dan
/// urutan pemasangan `SessionScope` justru salah satu hal yang paling mudah
/// keliru di sini.
class AppRoot extends StatefulWidget {
  final SessionCubit session;
  final ThemeMode themeMode;

  /// Sumber kabar sinkronisasi. Null pada rakitan yang tidak memakainya —
  /// tes widget menaikkan aplikasi tanpa DI penuh, dan `SyncBloc` menyeret
  /// empat repositori beserta Drift di belakangnya.
  final SyncBloc? sync;

  const AppRoot({
    super.key,
    required this.session,
    this.themeMode = ThemeMode.system,
    this.sync,
  });

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  // Router dibuat sekali dan disimpan, bukan dibangun ulang di dalam build().
  // GoRouter menyimpan riwayat navigasi; membangunnya ulang akan mengembalikan
  // pengguna ke halaman awal setiap kali widget ini dibangun ulang — termasuk
  // setiap kali tema berganti.
  late final _router = AppRouter.build(session: widget.session, sync: widget.sync);

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.session,
      child: MaterialApp.router(
        title: 'MangRitel',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: widget.themeMode,
        routerConfig: _router,
        // Sesi dipasang lewat `builder`, bukan di atas MaterialApp: builder
        // membungkus Navigator, sehingga setiap halaman yang dibangun router
        // berada di dalam scope-nya. Memasangnya di luar MaterialApp membuat
        // halaman berada di subtree yang berbeda dan `context.can()` selalu
        // menjawab tidak — menu kosong tanpa satu pun galat.
        // Pendengar sinkronisasi dipasang di dalam `builder`, bukan di atas
        // MaterialApp, karena toast menggambar dirinya di Overlay milik
        // Navigator — dan Navigator baru ada mulai dari sini ke bawah.
        builder: (context, child) => BlocBuilder<SessionCubit, SessionState>(
          builder: (context, state) => SessionScope(
            session: state.sessionOrNull,
            child: child ?? const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }
}
