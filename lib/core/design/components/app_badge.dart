import 'package:flutter/material.dart';

import '../design.dart';

/// Label status ringkas.
///
/// Menerima [SemanticColor] utuh, bukan satu warna, sehingga isian, teks, dan
/// garis tepinya dijamin serasi. Pemanggil cukup menyebut peran:
///
/// ```dart
/// AppBadge(label: 'Stok habis', color: context.colors.stockOut)
/// AppBadge(label: 'Belum tersinkron', color: context.colors.syncPending)
/// ```
///
/// Garis tepi selalu digambar. Itu bukan hiasan: pengguna dengan gangguan
/// persepsi warna membedakan lencana lewat bentuk dan kontras, bukan rona.
class AppBadge extends StatelessWidget {
  final String label;
  final SemanticColor color;

  /// Ikon kecil di sebelah kiri label. Ambil dari `AppIcons`.
  final IconData? icon;

  /// Menampilkan titik penanda alih-alih ikon. Untuk indikator status yang
  /// muncul berulang di dalam tabel, di mana ikon terasa terlalu berisik.
  final bool showDot;

  const AppBadge({
    super.key,
    required this.label,
    required this.color,
    this.icon,
    this.showDot = false,
  });

  @override
  Widget build(BuildContext context) {
    final density = context.space;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: density.sm,
        vertical: density.xs,
      ),
      decoration: BoxDecoration(
        color: color.bg,
        borderRadius: AppRadius.rXs,
        border: Border.all(color: color.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showDot) ...[
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: color.fg,
                borderRadius: AppRadius.rPill,
              ),
            ),
            SizedBox(width: density.xs),
          ] else if (icon != null) ...[
            Icon(icon, size: 12, color: color.fg),
            SizedBox(width: density.xs),
          ],
          Text(
            label,
            style: context.text.badge.copyWith(color: color.fg),
          ),
        ],
      ),
    );
  }
}
