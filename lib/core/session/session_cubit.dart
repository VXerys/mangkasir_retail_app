import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'dev_session_repository.dart';
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

  /// Memulihkan sesi tersimpan. Dipanggil sekali dari `main()`.
  Future<void> restore() async {
    final result = await _repository.restore();
    emit(
      result.fold(
        // Gagal memulihkan bukan kesalahan yang perlu ditampilkan: pengguna
        // baru dan pengguna yang keluar kemarin sama-sama sampai di sini.
        (_) => const SessionState.signedOut(),
        SessionState.active,
      ),
    );
  }

  /// Berpindah outlet. Himpunan izin ikut dihitung ulang oleh repository.
  ///
  /// Kegagalan **tidak** mengakhiri sesi — pengguna tetap di outlet lamanya.
  /// Melempar orang keluar karena satu outlet tidak bisa dibuka akan
  /// menghentikan pekerjaan yang sedang berjalan di outlet yang lain.
  Future<void> selectOutlet(int outletId) async {
    final result = await _repository.selectOutlet(outletId);
    result.fold((_) {}, (session) => emit(SessionState.active(session)));
  }

  Future<void> signOut() async {
    await _repository.signOut();
    emit(const SessionState.signedOut());
  }

  /// Masuk sebagai peran tertentu tanpa autentikasi.
  ///
  /// Hanya berfungsi selama [DevSessionRepository] yang terpasang. Ketika fase
  /// auth mengganti implementasinya, method ini berhenti melakukan apa pun dan
  /// ikut dihapus bersama layar pemilih peran — bukan menjadi pintu belakang
  /// yang tertinggal di produksi.
  Future<void> signInAsDev(String role) async {
    final repository = _repository;
    if (repository is! DevSessionRepository) return;

    emit(SessionState.active(await repository.signInAs(role)));
  }
}
