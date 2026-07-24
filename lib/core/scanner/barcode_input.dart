import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Dari mana sebuah barcode berasal.
///
/// Dibawa sampai ke pemanggil karena keduanya butuh perlakuan berbeda pada satu
/// hal: pemindai kamera menutup lembar setelah berhasil, sedangkan wedge tetap
/// diam di halaman dan siap menerima pindaian berikutnya.
enum BarcodeSource {
  /// Kamera perangkat lewat `mobile_scanner`. Jalur utama (Tingkat 1 & 2).
  camera,

  /// Pemindai HID yang mengetik karakter lalu menekan Enter. Tingkat 3.
  wedge,

  /// Diketik manual oleh kasir. Jalan terakhir saat barcode rusak atau
  /// kameranya tidak bisa membaca.
  manual,
}

/// Satu hasil pindaian.
@immutable
class BarcodeScan {
  final String code;
  final BarcodeSource source;

  const BarcodeScan(this.code, this.source);

  @override
  String toString() => 'BarcodeScan($code, ${source.name})';
}

/// Titik masuk tunggal untuk seluruh barcode yang masuk ke aplikasi.
///
/// [16_Design_System.md] §16.1 poin 5 mensyaratkan kamera dan pemindai HID
/// bermuara ke satu tempat. Alasannya praktis: yang terjadi *setelah* barcode
/// terbaca — cari produk, tambahkan ke keranjang, tangani barcode tak dikenal,
/// bunyikan nada gagal — adalah alur yang sama, dan menuliskannya dua kali
/// berarti dua alur yang perlahan menyimpang satu sama lain.
///
/// Pasang sekali di atas halaman yang menerima pindaian:
///
/// ```dart
/// AppBarcodeScope(
///   onScan: (scan) => context.read<CartBloc>().add(
///         CartEvent.barcodeScanned(scan.code),
///       ),
///   child: const PosPage(),
/// )
/// ```
///
/// Lalu di mana pun di dalamnya, ketiga jalur memanggil tempat yang sama:
/// [AppBarcodeListener] untuk wedge, `openCameraScanner` untuk kamera, dan
/// `AppBarcodeScope.of(context).submit(...)` untuk ketikan manual.
class AppBarcodeScope extends InheritedWidget {
  final void Function(BarcodeScan scan) onScan;

  const AppBarcodeScope({
    super.key,
    required this.onScan,
    required super.child,
  });

  static AppBarcodeScope? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppBarcodeScope>();

  static AppBarcodeScope of(BuildContext context) {
    final scope = maybeOf(context);
    assert(scope != null, 'Tidak ada AppBarcodeScope di atas widget ini');
    return scope!;
  }

  /// Menyerahkan sebuah barcode ke penangan tunggal.
  void submit(String code, BarcodeSource source) {
    final trimmed = code.trim();
    if (trimmed.isEmpty) return;
    onScan(BarcodeScan(trimmed, source));
  }

  @override
  bool updateShouldNotify(AppBarcodeScope oldWidget) =>
      onScan != oldWidget.onScan;
}

/// Menangkap ketikan pemindai HID keyboard-wedge di mana pun pada halaman.
///
/// Pemindai wedge tidak butuh paket apa pun: bagi sistem operasi ia adalah
/// papan ketik yang mengetik sangat cepat lalu menekan Enter. Yang dibutuhkan
/// hanyalah membedakan ketikan itu dari ketikan manusia, dan itu dilakukan
/// lewat **kecepatan**: manusia tidak bisa mengetik 13 digit dalam 100 ms.
///
/// Tanpa pembeda kecepatan, setiap huruf yang diketik kasir di kolom pencarian
/// akan ikut terbaca sebagai bagian dari barcode.
///
/// Widget ini tidak menggambar apa pun dan tidak merebut fokus dari isian mana
/// pun — kasir tetap bisa mengetik di kolom pencarian sementara pemindai siap
/// dipakai kapan saja.
class AppBarcodeListener extends StatefulWidget {
  final Widget child;

  /// Bila diisi, menggantikan [AppBarcodeScope] di atasnya. Untuk pemakaian
  /// lepas, misalnya di galeri design system.
  final ValueChanged<BarcodeScan>? onScan;

  /// Jeda maksimum antar karakter yang masih dianggap berasal dari pemindai.
  ///
  /// Pemindai HID mengirim karakter berjarak beberapa milidetik. Manusia
  /// tercepat sekalipun jarang menembus 60 ms antar tombol, jadi 120 ms
  /// memberi ruang aman tanpa menyerempet ketikan manusia.
  final Duration maxKeyInterval;

  /// Panjang minimum agar sebuah rentetan dianggap barcode.
  ///
  /// Menyaring ketukan pendek yang kebetulan cepat, seperti menekan Enter dua
  /// kali. Barcode ritel terpendek yang lazim (EAN-8) punya 8 digit.
  final int minLength;

  /// Menonaktifkan sementara, misalnya saat lembar kamera sedang terbuka.
  final bool enabled;

  const AppBarcodeListener({
    super.key,
    required this.child,
    this.onScan,
    this.maxKeyInterval = const Duration(milliseconds: 120),
    this.minLength = 8,
    this.enabled = true,
  });

  @override
  State<AppBarcodeListener> createState() => _AppBarcodeListenerState();
}

class _AppBarcodeListenerState extends State<AppBarcodeListener> {
  final _buffer = StringBuffer();

  /// Membuang rentetan yang berhenti lebih lama dari [maxKeyInterval].
  ///
  /// Inilah satu-satunya pengukur waktu di sini. Versi awal memakai
  /// `DateTime.now()` untuk menghitung jeda antar tombol, dan itu keliru dua
  /// kali: ia menduakan mekanisme yang sudah ada, dan jam dinding tidak ikut
  /// dipercepat oleh `FakeAsync` sehingga perilakunya mustahil diuji. Timer
  /// dipalsukan oleh kerangka tes, jadi jeda yang diuji benar-benar berlaku.
  Timer? _idleTimer;

  @override
  void dispose() {
    _idleTimer?.cancel();
    super.dispose();
  }

  void _emit() {
    final code = _buffer.toString();
    _buffer.clear();
    if (code.length < widget.minLength) return;

    final onScan = widget.onScan;
    if (onScan != null) {
      onScan(BarcodeScan(code, BarcodeSource.wedge));
      return;
    }
    AppBarcodeScope.maybeOf(context)?.submit(code, BarcodeSource.wedge);
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (!widget.enabled || event is! KeyDownEvent) {
      return KeyEventResult.ignored;
    }

    if (event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.numpadEnter) {
      _idleTimer?.cancel();
      final complete = _buffer.length >= widget.minLength;
      _emit();
      // Enter hanya ditelan bila memang menutup sebuah barcode. Kalau tidak,
      // Enter milik formulir dan dialog harus tetap sampai ke tujuannya.
      return complete ? KeyEventResult.handled : KeyEventResult.ignored;
    }

    final character = event.character;
    if (character != null && character.length == 1 && character != '\n') {
      _buffer.write(character);

      // Setiap tombol menyetel ulang hitungan mundur. Selama karakter datang
      // beruntun — pemindai — rentetan terus bertambah. Begitu ada jeda
      // sepanjang ketikan manusia, rentetan dibuang, dan Enter berikutnya
      // tidak menemukan apa pun untuk dikirim.
      _idleTimer?.cancel();
      _idleTimer = Timer(widget.maxKeyInterval, _buffer.clear);
    }

    // Selalu ignored: tombolnya tetap harus sampai ke isian yang sedang fokus.
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      // Tidak pernah mengambil fokus sendiri; hanya menguping tombol yang
      // lewat menuju widget di bawahnya.
      canRequestFocus: false,
      skipTraversal: true,
      onKeyEvent: _onKey,
      child: widget.child,
    );
  }
}
