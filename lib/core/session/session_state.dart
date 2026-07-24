import 'package:freezed_annotation/freezed_annotation.dart';

import 'app_session.dart';

part 'session_state.freezed.dart';

/// Keadaan sesi aplikasi.
///
/// Tiga keadaan, bukan dua. [SessionUnknown] adalah saat aplikasi baru hidup
/// dan belum selesai memulihkan sesi tersimpan — dan ia **tidak** sama dengan
/// [SessionSignedOut]. Kalau keduanya disatukan, setiap start dingin melempar
/// pengguna ke layar masuk selama sepersekian detik sebelum menariknya kembali.
/// Pada aplikasi kasir yang dibuka puluhan kali sehari, kedipan itu terbaca
/// sebagai kerusakan.
@freezed
sealed class SessionState with _$SessionState {
  /// Sedang memulihkan sesi. Guard rute menahan pengguna di tempatnya.
  const factory SessionState.unknown() = SessionUnknown;

  /// Tidak ada yang sedang masuk.
  const factory SessionState.signedOut() = SessionSignedOut;

  /// Ada sesi aktif.
  const factory SessionState.active(AppSession session) = SessionActive;
}

extension SessionStateX on SessionState {
  /// Sesi yang sedang aktif, atau null bila belum/tidak ada.
  AppSession? get sessionOrNull =>
      this is SessionActive ? (this as SessionActive).session : null;

  bool get isActive => this is SessionActive;
  bool get isUnknown => this is SessionUnknown;
}
