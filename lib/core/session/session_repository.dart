import 'package:dartz/dartz.dart';

import '../error/failures.dart';
import 'app_session.dart';

/// Sumber sesi: dari mana aplikasi tahu siapa yang masuk dan boleh apa.
///
/// Antarmuka ini ada supaya Phase UI-4 bisa membangun navigasi, guard, dan
/// menu yang benar-benar berjalan **sebelum** autentikasi sungguhan ditulis.
/// Implementasi yang terpasang sekarang adalah `DevSessionRepository`.
///
/// Implementasi Supabase-nya nanti mengisi tempat yang sama dan mengerjakan
/// tiga hal yang sengaja ditinggalkan di fase ini:
///
/// 1. `auth.currentUser` → baris `users` (cocokkan `uuid` dengan `auth.uid()`),
/// 2. `user_has_outlet` untuk daftar outlet, lalu `user_roles` →
///    `role_permissions` → `permissions` **untuk outlet yang dipilih**,
/// 3. menyimpan hasilnya secara lokal — aplikasi ini offline-first, dan kasir
///    yang kehilangan sinyal tidak boleh kehilangan hak aksesnya.
abstract interface class SessionRepository {
  /// Masuk dengan email dan kata sandi.
  ///
  /// Mengembalikan [AuthFailure] bila kredensial salah, [NetworkFailure] bila
  /// tidak ada koneksi, atau [RemoteFailure] bila server merespons dengan galat
  /// lain. Berhasil berarti sesi tersimpan dan siap dipulihkan oleh [restore].
  Future<Either<Failure, AppSession>> signIn(String email, String password);

  /// Memulihkan sesi yang tersimpan saat aplikasi hidup.
  ///
  /// Mengembalikan [AuthFailure] bila tidak ada sesi tersimpan — itu keadaan
  /// biasa, bukan kerusakan. Bila token masih valid tetapi jaringan tidak ada,
  /// sesi dikembalikan dari cache lokal agar kasir tidak terkunci keluar.
  Future<Either<Failure, AppSession>> restore();

  /// Berpindah outlet aktif, sekaligus menghitung ulang himpunan izin.
  Future<Either<Failure, AppSession>> selectOutlet(int outletId);

  /// Meminta pemulihan kata sandi. Supabase mengirim email ke [email].
  Future<Either<Failure, void>> forgotPassword(String email);

  Future<void> signOut();
}
