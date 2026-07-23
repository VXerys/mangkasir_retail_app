import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/design/design.dart';
import 'core/di/injection.dart';
import 'core/router/app_router.dart';
import 'core/sync/connectivity_service.dart';
import 'core/sync/sync_bloc/sync_bloc.dart';
import 'core/sync/sync_bloc/sync_event.dart';
import 'features/cashier/presentation/bloc/cart/cart_bloc.dart';
import 'features/cashier/presentation/bloc/cart/cart_event.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();
  await Hive.initFlutter();

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

  // Auto-sync when device goes online
  getIt<ConnectivityService>()
      .onOnline
      .listen((_) => getIt<SyncBloc>().add(const SyncEvent.triggered()));

  runApp(const MangRitelApp());
}

class MangRitelApp extends StatefulWidget {
  const MangRitelApp({super.key});

  @override
  State<MangRitelApp> createState() => _MangRitelAppState();
}

class _MangRitelAppState extends State<MangRitelApp> {
  // Router dibuat sekali dan disimpan, bukan dibangun ulang di dalam build().
  // GoRouter menyimpan riwayat navigasi; membangunnya ulang akan mengembalikan
  // pengguna ke halaman awal setiap kali widget ini dibangun ulang.
  final _router = AppRouter.build();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Keduanya terdaftar sebagai @lazySingleton. Memakai
        // `BlocProvider(create: ...)` akan menyerahkan kepemilikan ke widget
        // tree dan men-dispose singleton saat widget dilepas — keranjang jadi
        // hilang dan sinkronisasi berhenti diam-diam.
        BlocProvider.value(value: getIt<CartBloc>()),
        BlocProvider.value(value: getIt<SyncBloc>()),
      ],
      child: MaterialApp.router(
        title: 'MangRitel',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        // Tema gelap belum diisi (lihat DarkScheme), jadi mode dikunci ke
        // terang agar tidak ada layar yang terbaca salah.
        themeMode: ThemeMode.light,
        routerConfig: _router,
      ),
    );
  }
}
