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
  /// Memulihkan sesi yang tersimpan saat aplikasi hidup.
  ///
  /// Mengembalikan [AuthFailure] bila tidak ada sesi tersimpan — itu keadaan
  /// biasa, bukan kerusakan.
  Future<Either<Failure, AppSession>> restore();

  /// Berpindah outlet aktif, sekaligus menghitung ulang himpunan izin.
  Future<Either<Failure, AppSession>> selectOutlet(int outletId);

  Future<void> signOut();
}
