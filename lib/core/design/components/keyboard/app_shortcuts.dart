import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../design.dart';

/// Pintasan papan ketik baku POS, sesuai [16_Design_System.md] §16.1 poin 4.
///
/// Disimpan sebagai konstanta, bukan ditulis sebagai literal di tiap halaman,
/// supaya F4 berarti Bayar di seluruh aplikasi — bukan Bayar di satu layar dan
/// Simpan di layar lain.
abstract final class AppShortcutKeys {
  /// Melompat ke kolom cari produk.
  static const search = SingleActivator(LogicalKeyboardKey.f2);

  /// Membuka pembayaran.
  static const pay = SingleActivator(LogicalKeyboardKey.f4);

  /// Membatalkan, menutup, atau mundur satu langkah.
  static const cancel = SingleActivator(LogicalKeyboardKey.escape);

  /// Mencetak struk.
  static const print = SingleActivator(LogicalKeyboardKey.keyP, control: true);

  /// Label yang ditampilkan kepada pengguna.
  static String labelOf(SingleActivator activator) {
    final key = activator.trigger;
    final name = switch (key) {
      LogicalKeyboardKey.escape => 'ESC',
      LogicalKeyboardKey.enter => 'Enter',
      _ => key.keyLabel.toUpperCase(),
    };
    return activator.control ? 'Ctrl + $name' : name;
  }
}

/// Memasang pintasan papan ketik pada sebuah subtree.
///
/// **Pintasan tidak pernah menjadi satu-satunya jalan menuju sebuah aksi.**
/// §16.0 menetapkan ponsel sebagai perangkat Tingkat 1, dan ponsel tidak punya
/// tombol F2. Setiap aksi di sini harus juga tersedia sebagai tombol yang
/// terlihat; yang ini cuma jalan pintasnya.
///
/// ```dart
/// AppShortcuts(
///   onSearch: () => searchFocus.requestFocus(),
///   onPay: cart.isEmpty ? null : _openPayment,
///   onCancel: _clearSelection,
///   child: const PosPage(),
/// )
/// ```
///
/// Aksi yang bernilai `null` tidak dipasang sama sekali, sehingga tombolnya
/// diteruskan ke widget di bawah — ESC tetap bisa menutup dialog walaupun
/// halaman ini tidak memakai ESC untuk apa pun.
class AppShortcuts extends StatelessWidget {
  final Widget child;

  final VoidCallback? onSearch;
  final VoidCallback? onPay;
  final VoidCallback? onCancel;
  final VoidCallback? onPrint;

  /// Pintasan tambahan khusus halaman ini.
  final Map<ShortcutActivator, VoidCallback> extra;

  /// Meminta fokus saat dipasang, supaya pintasan langsung bekerja tanpa
  /// pengguna harus menekan atau menyentuh apa pun lebih dulu.
  final bool autofocus;

  const AppShortcuts({
    super.key,
    required this.child,
    this.onSearch,
    this.onPay,
    this.onCancel,
    this.onPrint,
    this.extra = const {},
    this.autofocus = true,
  });

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: {
        AppShortcutKeys.search: ?onSearch,
        AppShortcutKeys.pay: ?onPay,
        AppShortcutKeys.cancel: ?onCancel,
        AppShortcutKeys.print: ?onPrint,
        ...extra,
      },
      // Sama seperti pada AppDialog: peristiwa papan ketik merambat ke leluhur,
      // jadi harus ada sesuatu di bawah sini yang memegang fokus — kalau tidak,
      // tidak satu pun pintasan kebagian tombol.
      child: Focus(autofocus: autofocus, child: child),
    );
  }
}

/// Menampilkan lambang pintasan, tetapi hanya bila papan ketik fisik ada.
///
/// Di layar sentuh murni ia tidak merender apa pun. §16.1 poin 4 melarang
/// menuliskan "Tekan F2" pada perangkat yang tidak punya F2 — pengguna akan
/// mencari tombol yang tidak ada, dan berhenti mempercayai petunjuk berikutnya.
///
/// ```dart
/// Row(children: [
///   const Text('Bayar'),
///   AppShortcutHint(activator: AppShortcutKeys.pay),
/// ])
/// ```
class AppShortcutHint extends StatelessWidget {
  final SingleActivator activator;

  const AppShortcutHint({super.key, required this.activator});

  @override
  Widget build(BuildContext context) {
    return PhysicalKeyboardDetector(
      builder: (context, hasKeyboard) {
        if (!hasKeyboard) return const SizedBox.shrink();

        final colors = context.colors;
        final density = context.space;

        return Padding(
          padding: EdgeInsets.only(left: density.xs),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: density.xs,
              vertical: 1,
            ),
            decoration: BoxDecoration(
              color: colors.surfaceSubtle,
              borderRadius: AppRadius.rXs,
              border: Border.all(color: colors.borderDefault),
            ),
            child: Text(
              AppShortcutKeys.labelOf(activator),
              style: context.text.badge.copyWith(
                color: colors.textTertiary,
                fontSize: 10,
                height: 1.3,
              ),
            ),
          ),
        );
      },
    );
  }
}
