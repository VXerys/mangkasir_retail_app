import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mangkasir_retail_app/core/design/design.dart';
import 'package:mangkasir_retail_app/core/di/injection.dart';
import 'package:mangkasir_retail_app/core/error/failures.dart';
import 'package:mangkasir_retail_app/core/router/app_root.dart';
import 'package:mangkasir_retail_app/core/session/app_session.dart';
import 'package:mangkasir_retail_app/core/session/dev_session_repository.dart';
import 'package:mangkasir_retail_app/core/session/session_cubit.dart';
import 'package:mangkasir_retail_app/core/session/session_repository.dart';
import 'package:mangkasir_retail_app/core/sync/sync_bloc/sync_bloc.dart';

/// Perkakas bersama untuk menaikkan **aplikasi sungguhan** di dalam tes.
///
/// Menaikkan [AppRoot], bukan menyusun ulang router dan sesi sendiri: rakitan
/// yang disusun ulang di tes akan tetap hijau meski `main()` merakitnya keliru.
///
/// Yang sengaja **tidak** dipanggil adalah [configureDependencies] — ia
/// menuntut `.env`, Supabase, dan Hive. Sebagai gantinya tiap tes mendaftarkan
/// gandanya sendiri lewat [registerFake], dan [pumpApp] membersihkan seluruh
/// isi `getIt` setelah tes selesai.

const phoneSurface = Size(390, 844);
const tabletSurface = Size(1280, 800);

/// Sumber sesi yang seluruhnya ditentukan tes.
///
/// Tidak memakai [DevSessionRepository] apa adanya karena ia menulis ke Hive;
/// yang diuji di sini halamannya, bukan penyimpanannya. Bentuk sesinya tetap
/// asli — dibangun lewat [DevSessionRepository.sampleSession] supaya izin yang
/// berlaku di tes sama persis dengan yang berlaku di perangkat.
class FakeSessionRepository implements SessionRepository {
  AppSession? session;

  FakeSessionRepository(this.session);

  @override
  Future<Either<Failure, AppSession>> restore() async =>
      session == null ? const Left(AuthFailure('kosong')) : Right(session!);

  @override
  Future<Either<Failure, AppSession>> selectOutlet(int outletId) async {
    final current = session;
    if (current == null) return const Left(AuthFailure('kosong'));

    session = current.copyWith(
      activeOutlet:
          current.outlets.firstWhere((outlet) => outlet.id == outletId),
    );
    return Right(session!);
  }

  @override
  Future<void> signOut() async => session = null;
}

/// Mendaftarkan ganda ke `getIt` untuk satu tes.
///
/// Selalu `registerFactory`, tidak pernah singleton: halaman meminta bloc-nya
/// tiap kali dipasang, dan bloc yang sudah ditutup di tes sebelumnya akan
/// melempar `emit was called after close` di tes berikutnya.
void registerFake<T extends Object>(T Function() factory) {
  if (getIt.isRegistered<T>()) getIt.unregister<T>();
  getIt.registerFactory<T>(factory);
}

/// Menaikkan aplikasi sebagai [role], lalu menunggu sesi selesai dipulihkan.
///
/// [role] null berarti belum masuk — penjaga rute akan mendaratkan aplikasi di
/// layar masuk.
Future<SessionCubit> pumpApp(
  WidgetTester tester, {
  required String? role,
  Size surface = tabletSurface,
  int outletId = 1,
  SyncBloc? sync,
}) async {
  await initializeDateFormatting('id_ID');

  tester.view.physicalSize = surface;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  addTearDown(getIt.reset);

  final cubit = SessionCubit(
    FakeSessionRepository(
      role == null
          ? null
          : DevSessionRepository.sampleSession(role, outletId: outletId),
    ),
  );
  addTearDown(cubit.close);

  await tester.pumpWidget(
    AppRoot(session: cubit, themeMode: ThemeMode.light, sync: sync),
  );
  await cubit.restore();
  await tester.pumpAndSettle();

  return cubit;
}

/// Mengetik [query] ke [AppSearchField] lalu menunggu jeda debounce lewat.
///
/// [WidgetTester.pumpAndSettle] saja tidak cukup, dan kegagalannya diam-diam:
/// ia berhenti begitu tidak ada frame terjadwal, sedangkan pengetikan kedua
/// tidak menjadwalkan frame apa pun — tombol bersihkan sudah terlanjur muncul
/// pada pengetikan pertama. Akibatnya timer 300 ms tidak pernah maju dan tes
/// memeriksa hasil pencarian sebelumnya sambil terlihat lulus.
Future<void> search(WidgetTester tester, String query) async {
  await tester.enterText(find.byType(AppSearchField), query);
  await tester.pump(const Duration(milliseconds: 350));
  await tester.pumpAndSettle();
}

/// Menunggu toast selesai dengan sendirinya.
///
/// [AppToast] hidup di Overlay dan menutup diri lewat [Timer] empat detik. Timer
/// itu masih menyala saat tes berakhir, dan `flutter_test` menganggap timer yang
/// menggantung sebagai kegagalan — jadi setiap aksi yang menampilkan toast harus
/// diikuti pemanggilan ini.
Future<void> settleToasts(WidgetTester tester) async {
  await tester.pump(const Duration(seconds: 5));
  await tester.pumpAndSettle();
}

/// Berpindah alamat lewat router aplikasi yang sedang hidup.
///
/// Router dimiliki [AppRoot] dan tidak diekspos, jadi ia diambil dari
/// `BuildContext` — cara yang sama dengan yang dipakai halaman sungguhan.
Future<void> goTo(WidgetTester tester, String location) async {
  final context = tester.element(find.byType(Navigator).first);
  GoRouter.of(context).go(location);
  await tester.pumpAndSettle();
}
