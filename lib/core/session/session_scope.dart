import 'package:flutter/widgets.dart';

import 'app_session.dart';

/// Menyediakan sesi ke seluruh subtree.
///
/// Sengaja membawa [AppSession] mentah, bukan cubit-nya. Dua alasan:
///
/// - Galeri design system harus bisa dirender **tanpa DI** — itu syarat yang
///   sudah berlaku sejak UI-0 dan yang membuat uji asapnya murah. Galeri
///   memasang sesi contoh langsung di sini tanpa menyentuh `get_it`.
/// - Tes widget bisa menyusun sesi apa pun dalam satu baris, termasuk yang
///   memegang tepat satu izin — bentuk yang paling berguna untuk membuktikan
///   sebuah menu benar-benar bergantung pada izin yang diklaimnya.
///
/// Di aplikasi sungguhan, `SessionCubit` yang mengisinya.
class SessionScope extends InheritedWidget {
  final AppSession? session;

  const SessionScope({
    super.key,
    required this.session,
    required super.child,
  });

  static AppSession? maybeOf(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<SessionScope>()
      ?.session;

  static AppSession of(BuildContext context) {
    final session = maybeOf(context);
    assert(session != null, 'Tidak ada SessionScope aktif di atas widget ini');
    return session!;
  }

  @override
  bool updateShouldNotify(SessionScope oldWidget) =>
      session != oldWidget.session;
}

/// Cara membaca hak akses dari dalam widget, sejalan dengan gaya
/// `context.colors` / `context.space` milik design system.
extension SessionContext on BuildContext {
  /// Sesi aktif, atau null bila belum ada.
  AppSession? get sessionOrNull => SessionScope.maybeOf(this);

  /// Sesi aktif. Melempar bila dipanggil di luar [SessionScope].
  AppSession get session => SessionScope.of(this);

  /// Apakah pengguna boleh melakukan sesuatu yang menuntut [code].
  ///
  /// Tanpa sesi jawabannya **selalu tidak**. Itu bawaan yang benar: layar yang
  /// sempat terlihat sebelum sesi siap adalah kebocoran, bukan keramahan.
  bool can(String code) => sessionOrNull?.can(code) ?? false;

  bool canAny(Iterable<String> codes) => sessionOrNull?.canAny(codes) ?? false;

  bool canAll(Iterable<String> codes) => sessionOrNull?.canAll(codes) ?? false;
}
