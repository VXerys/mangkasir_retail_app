import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Menebak apakah ada papan ketik fisik yang tersambung.
///
/// Flutter tidak menyediakan API untuk ini, dan sistem operasi mobile pun tidak
/// memberitahukannya secara langsung. Yang bisa dilakukan hanyalah menyimpulkan
/// dari perilaku, dan itulah yang dikerjakan di sini.
///
/// Aturannya:
///
/// - Pada desktop dan web, papan ketik dianggap **selalu** ada.
/// - Pada Android dan iOS, dianggap ada begitu muncul satu tombol yang
///   **tidak mungkin** berasal dari papan ketik layar: tombol fungsi, Ctrl,
///   Alt, Meta, Escape, Tab, atau panah. Papan ketik layar tidak punya tombol
///   itu, dan teks biasa dari papan ketik layar tidak lewat sebagai key event
///   melainkan lewat kanal input teks.
///
/// Sengaja **tidak** menghitung angka dan huruf sebagai bukti. Pemindai barcode
/// HID mengetik digit lalu Enter, dan ia bukan papan ketik: menganggapnya
/// begitu akan memunculkan petunjuk "Tekan F2" pada tablet yang cuma punya
/// pemindai — persis kebohongan yang dilarang §16.1 poin 4.
///
/// Setelah menyala, tidak pernah dimatikan lagi dalam satu sesi. Papan ketik
/// Bluetooth kadang terputus sesaat, dan petunjuk yang berkedip hilang-muncul
/// jauh lebih mengganggu daripada petunjuk yang tertinggal sebentar.
class PhysicalKeyboard {
  PhysicalKeyboard._();

  static final PhysicalKeyboard instance = PhysicalKeyboard._();

  /// Bernilai `true` bila papan ketik fisik diyakini ada.
  ///
  /// Dengar perubahannya lewat [ValueListenable], atau pakai
  /// [PhysicalKeyboardDetector] agar widget ikut dibangun ulang.
  final ValueNotifier<bool> isAvailable =
      ValueNotifier(_alwaysHasKeyboardPlatform);

  static bool get _alwaysHasKeyboardPlatform {
    if (kIsWeb) return true;
    return switch (defaultTargetPlatform) {
      TargetPlatform.windows ||
      TargetPlatform.macOS ||
      TargetPlatform.linux =>
        true,
      _ => false,
    };
  }

  /// Tombol yang tidak ada pada papan ketik layar mana pun.
  static bool _provesPhysicalKeyboard(LogicalKeyboardKey key) {
    if (key == LogicalKeyboardKey.escape ||
        key == LogicalKeyboardKey.tab ||
        key == LogicalKeyboardKey.arrowUp ||
        key == LogicalKeyboardKey.arrowDown ||
        key == LogicalKeyboardKey.arrowLeft ||
        key == LogicalKeyboardKey.arrowRight) {
      return true;
    }

    if (key == LogicalKeyboardKey.controlLeft ||
        key == LogicalKeyboardKey.controlRight ||
        key == LogicalKeyboardKey.altLeft ||
        key == LogicalKeyboardKey.altRight ||
        key == LogicalKeyboardKey.metaLeft ||
        key == LogicalKeyboardKey.metaRight) {
      return true;
    }

    return _functionKeys.contains(key);
  }

  // `final`, bukan `const`: LogicalKeyboardKey menimpa `==`, dan Dart melarang
  // tipe semacam itu menjadi anggota himpunan konstan.
  static final _functionKeys = <LogicalKeyboardKey>{
    LogicalKeyboardKey.f1,
    LogicalKeyboardKey.f2,
    LogicalKeyboardKey.f3,
    LogicalKeyboardKey.f4,
    LogicalKeyboardKey.f5,
    LogicalKeyboardKey.f6,
    LogicalKeyboardKey.f7,
    LogicalKeyboardKey.f8,
    LogicalKeyboardKey.f9,
    LogicalKeyboardKey.f10,
    LogicalKeyboardKey.f11,
    LogicalKeyboardKey.f12,
  };

  bool _listening = false;

  /// Mulai menguping tombol. Aman dipanggil berkali-kali.
  void start() {
    if (_listening || isAvailable.value) return;
    _listening = true;
    HardwareKeyboard.instance.addHandler(_handle);
  }

  bool _handle(KeyEvent event) {
    if (event is! KeyDownEvent) return false;

    if (_provesPhysicalKeyboard(event.logicalKey)) {
      isAvailable.value = true;
      HardwareKeyboard.instance.removeHandler(_handle);
      _listening = false;
    }

    // Selalu false: ini penguping, bukan penangan. Tombolnya harus tetap
    // sampai ke tujuannya.
    return false;
  }

  @visibleForTesting
  void resetForTest({bool available = false}) {
    if (_listening) {
      HardwareKeyboard.instance.removeHandler(_handle);
      _listening = false;
    }
    isAvailable.value = available;
  }
}

/// Membangun ulang [builder] setiap kali keberadaan papan ketik fisik berubah.
///
/// ```dart
/// PhysicalKeyboardDetector(
///   builder: (context, hasKeyboard) =>
///       hasKeyboard ? const Text('F2') : const SizedBox.shrink(),
/// )
/// ```
class PhysicalKeyboardDetector extends StatefulWidget {
  final Widget Function(BuildContext context, bool hasPhysicalKeyboard) builder;

  const PhysicalKeyboardDetector({super.key, required this.builder});

  @override
  State<PhysicalKeyboardDetector> createState() =>
      _PhysicalKeyboardDetectorState();
}

class _PhysicalKeyboardDetectorState extends State<PhysicalKeyboardDetector> {
  @override
  void initState() {
    super.initState();
    PhysicalKeyboard.instance.start();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: PhysicalKeyboard.instance.isAvailable,
      builder: (context, hasKeyboard, _) => widget.builder(context, hasKeyboard),
    );
  }
}
