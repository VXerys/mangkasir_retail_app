import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../error/failures.dart';
import 'session_repository.dart';
import 'session_state.dart';

/// Pemegang sesi untuk seluruh aplikasi.
///
/// Dimulai dari [SessionState.unknown] dan tetap di sana sampai [restore]
/// selesai. Guard rute membaca keadaan ini, jadi keadaan awal yang salah
/// langsung terlihat sebagai pengguna terlempar ke layar masuk saat aplikasi
/// baru dibuka.
@lazySingleton
class SessionCubit extends Cubit<SessionState> {
  final SessionRepository _repository;

  SessionCubit(this._repository) : super(const SessionState.unknown());

  /// Masuk dengan email dan kata sandi.
  ///
  /// Mengembalikan [Failure] bila gagal sehingga halaman login bisa menampilkan
  /// pesan yang tepat, atau null bila berhasil. Keadaan cubit bertransisi ke
  /// [SessionState.active] saat berhasil — GoRouter redirect mengambil alih dari
  /// situ.
  Future<Failure?> signIn(String email, String password) async {
    final result = await _repository.signIn(email, password);
    return result.fold(
      (failure) => failure,
      (session) {
        emit(SessionState.active(session));
        return null;
      },
    );
  }

  /// Memulihkan sesi tersimpan. Dipanggil sekali dari `main()`.
  Future<void> restore() async {
    final result = await _repository.restore();
    emit(
      result.fold(
        (_) => const SessionState.signedOut(),
        SessionState.active,
      ),
    );
  }

  /// Berpindah outlet. Himpunan izin ikut dihitung ulang oleh repository.
  ///
  /// Kegagalan **tidak** mengakhiri sesi — pengguna tetap di outlet lamanya.
  Future<void> selectOutlet(int outletId) async {
    final result = await _repository.selectOutlet(outletId);
    result.fold((_) {}, (session) => emit(SessionState.active(session)));
  }

  Future<void> signOut() async {
    await _repository.signOut();
    emit(const SessionState.signedOut());
  }
}
