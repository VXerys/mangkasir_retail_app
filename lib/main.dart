import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/design/theme/theme_cubit.dart';
import 'core/di/injection.dart';
import 'core/preferences/app_preferences.dart';
import 'core/router/app_root.dart';
import 'core/session/session_cubit.dart';
import 'core/sync/connectivity_service.dart';
import 'core/sync/sync_bloc/sync_bloc.dart';
import 'core/sync/sync_bloc/sync_event.dart';
import 'core/sync/sync_policy.dart';
import 'features/cashier/presentation/bloc/cart/cart_bloc.dart';
import 'features/cashier/presentation/bloc/cart/cart_event.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();
  await Hive.initFlutter();

  // Dibuka sebelum runApp supaya ThemeCubit bisa membaca mode tema secara
  // sinkron. Kalau dibaca belakangan, aplikasi selalu berkedip terang lebih
  // dulu sebelum berpindah ke gelap.
  await AppPreferences.open();

  // Nama hari dan bulan berbahasa Indonesia dipakai oleh DateFormatter.
  // Tanpa pemanggilan ini, intl melempar galat locale saat pertama kali
  // sebuah tanggal dirender.
  await initializeDateFormatting('id_ID');

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  await configureDependencies();

  // Load persisted cart on startup
  getIt<CartBloc>().add(const CartEvent.started());

  // Memulihkan sesi tersimpan. Sengaja tidak ditunggu: menahan runApp sampai
  // sesi selesai dibaca berarti layar putih selama pemulihan. SessionCubit
  // memulai dari keadaan `unknown`, dan penjaga rute menahan pengguna di
  // halaman boot sampai jawabannya tiba.
  unawaited(getIt<SessionCubit>().restore());

  // Mendorong data saat perangkat kembali online — bila fase saat ini memang
  // sudah membolehkannya. Lihat [SyncPolicy.pushEnabled] untuk alasannya.
  if (SyncPolicy.pushEnabled) {
    getIt<ConnectivityService>()
        .onOnline
        .listen((_) => getIt<SyncBloc>().add(const SyncEvent.triggered()));
  }

  runApp(const MangRitelApp());
}

class MangRitelApp extends StatelessWidget {
  const MangRitelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Semuanya terdaftar sebagai @lazySingleton. Memakai
        // `BlocProvider(create: ...)` akan menyerahkan kepemilikan ke widget
        // tree dan men-dispose singleton saat widget dilepas — keranjang jadi
        // hilang dan sinkronisasi berhenti diam-diam.
        BlocProvider.value(value: getIt<CartBloc>()),
        BlocProvider.value(value: getIt<SyncBloc>()),
        BlocProvider.value(value: getIt<ThemeCubit>()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) => AppRoot(
          session: getIt<SessionCubit>(),
          themeMode: themeMode,
          sync: getIt<SyncBloc>(),
        ),
      ),
    );
  }
}
