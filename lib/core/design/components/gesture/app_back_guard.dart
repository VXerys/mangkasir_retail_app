import 'package:flutter/material.dart';

import '../../design.dart';

/// Menahan tombol Back Android saat ada pekerjaan yang belum selesai.
///
/// Di Android, Back adalah gestur — geser dari tepi layar — dan karenanya jauh
/// lebih mudah terpicu tanpa sengaja daripada klik tombol. Di layar kasir, satu
/// geseran tak sengaja bisa membuang keranjang berisi dua puluh barang yang
/// sudah dipindai.
///
/// Memakai [PopScope], bukan `WillPopScope` yang sudah usang dan tidak bekerja
/// dengan predictive back Android 14+.
///
/// ```dart
/// AppBackGuard(
///   isBlocking: cart.isNotEmpty,
///   title: 'Tinggalkan transaksi?',
///   message: '20 item di keranjang akan hilang.',
///   confirmLabel: 'Tinggalkan',
///   child: const PosPage(),
/// )
/// ```
///
/// Hanya untuk kehilangan yang **tidak bisa dipulihkan**. Memasangnya di setiap
/// halaman melatih pengguna menekan "Ya" tanpa membaca, dan saat itu terjadi,
/// dialog ini berhenti melindungi apa pun.
class AppBackGuard extends StatelessWidget {
  final Widget child;

  /// Saat `true`, Back memunculkan konfirmasi lebih dulu.
  final bool isBlocking;

  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;

  /// Dipanggil setelah pengguna menegaskan ingin keluar, sebelum halaman
  /// ditutup. Tempat membersihkan keranjang atau membatalkan draf.
  final VoidCallback? onConfirmed;

  const AppBackGuard({
    super.key,
    required this.child,
    required this.isBlocking,
    this.title = 'Tinggalkan halaman ini?',
    this.message = 'Perubahan yang belum disimpan akan hilang.',
    this.confirmLabel = 'Tinggalkan',
    this.cancelLabel = 'Tetap di sini',
    this.onConfirmed,
  });

  @override
  Widget build(BuildContext context) {
    // Argumen tipe ditulis eksplisit. Tanpa itu Dart menyimpulkannya sebagai
    // `dynamic` — bukan `Object?` — dan hasil pop kehilangan pemeriksaan tipe.
    return PopScope<Object?>(
      canPop: !isBlocking,
      onPopInvokedWithResult: (didPop, _) async {
        // Sudah tertutup berarti tidak ada yang perlu ditahan.
        if (didPop) return;

        final confirmed = await showAppConfirm(
          context: context,
          title: title,
          message: message,
          confirmLabel: confirmLabel,
          cancelLabel: cancelLabel,
          isDestructive: true,
        );

        if (!confirmed || !context.mounted) return;

        onConfirmed?.call();
        if (context.mounted) Navigator.of(context).pop();
      },
      child: child,
    );
  }
}

/// Memberi ruang di bawah isi agar papan ketik layar tidak menutupinya.
///
/// Dipakai di dalam lembar bawah dan panel yang tumbuh dari tepi bawah. Di
/// halaman biasa, `Scaffold` sudah menanganinya lewat `resizeToAvoidBottomInset`
/// — tetapi lembar bawah dan rute overlay tidak melewati Scaffold halaman, dan
/// di sanalah isian sering tertutup papan ketik.
///
/// Jaraknya dianimasikan supaya isi ikut naik bersama papan ketik, bukan
/// melompat setelah papan ketik selesai muncul.
class AppKeyboardInset extends StatelessWidget {
  final Widget child;

  /// Jarak tambahan di bawah papan ketik.
  final double extra;

  const AppKeyboardInset({super.key, required this.child, this.extra = 0});

  @override
  Widget build(BuildContext context) {
    final inset = MediaQuery.viewInsetsOf(context).bottom;

    return AnimatedPadding(
      duration: AppMotion.fast,
      curve: AppMotion.standard,
      padding: EdgeInsets.only(bottom: inset + (inset > 0 ? extra : 0)),
      child: child,
    );
  }
}
