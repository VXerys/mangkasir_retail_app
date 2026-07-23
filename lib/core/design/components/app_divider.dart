import 'package:flutter/material.dart';

import '../design.dart';

/// Garis pemisah setebal satu piksel, tanpa ruang ekstra.
///
/// [Divider] bawaan Material menyisipkan `space: 16` di sekelilingnya, yang
/// pada tata letak padat menghasilkan celah tak terduga. Versi ini hanya
/// menggambar garis; jaraknya diatur oleh induknya.
class AppDivider extends StatelessWidget {
  /// Menimpa warna bawaan (`borderSubtle`).
  final Color? color;

  /// Menggambar garis tegak, bukan mendatar. Untuk memisahkan kolom pada
  /// tata letak sidebar/workspace/inspector.
  final bool vertical;

  /// Jarak masuk dari kedua ujung. Dipakai agar garis pemisah baris tidak
  /// menyentuh tepi panel.
  final double indent;

  const AppDivider({
    super.key,
    this.color,
    this.vertical = false,
    this.indent = 0,
  });

  const AppDivider.vertical({super.key, this.color, this.indent = 0})
      : vertical = true;

  @override
  Widget build(BuildContext context) {
    final resolved = color ?? context.colors.borderSubtle;

    if (vertical) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: indent),
        child: SizedBox(width: 1, child: ColoredBox(color: resolved)),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: indent),
      child: SizedBox(height: 1, child: ColoredBox(color: resolved)),
    );
  }
}
