import 'package:flutter/material.dart';

import '../../design.dart';

/// Keterangan singkat yang muncul saat kursor berhenti di atas sebuah elemen.
///
/// [Tooltip] bawaan Material membawa dekorasinya sendiri — permukaan abu-abu
/// gelap dengan sudut membulat 4 dan teks putih — yang tidak berubah mengikuti
/// tema dan karenanya terlihat asing di atas kanvas gelap. Versi ini hanya
/// mengganti dekorasinya; seluruh logika penundaan, penempatan, dan pembacaan
/// oleh pembaca layar tetap milik Material.
///
/// Dipakai paling sering pada sidebar mode rail, di mana ikon adalah
/// satu-satunya petunjuk tujuan sebuah menu.
class AppTooltip extends StatelessWidget {
  final String message;
  final Widget child;

  /// Menempatkan tooltip di bawah [child], bukan di atasnya.
  final bool preferBelow;

  const AppTooltip({
    super.key,
    required this.message,
    required this.child,
    this.preferBelow = true,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final density = context.space;

    return Tooltip(
      message: message,
      preferBelow: preferBelow,
      // Sedikit lebih lama dari bawaan Material (0 ms untuk mouse) supaya
      // tooltip tidak berkedip saat kursor sekadar melintas di atas rail.
      waitDuration: const Duration(milliseconds: 400),
      padding: EdgeInsets.symmetric(
        horizontal: density.sm,
        vertical: density.xs,
      ),
      margin: EdgeInsets.all(density.xs),
      textStyle: context.text.formHelper.copyWith(color: colors.textPrimary),
      decoration: BoxDecoration(
        color: colors.surfaceRaised,
        borderRadius: AppRadius.rSm,
        border: Border.all(color: colors.borderDefault),
        boxShadow: context.elevation.popover,
      ),
      child: child,
    );
  }
}
