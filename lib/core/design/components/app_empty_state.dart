import 'package:flutter/material.dart';

import '../design.dart';

/// Tampilan untuk daftar yang kosong.
///
/// [message] wajib diisi dan sebaiknya menjelaskan *langkah berikutnya*, bukan
/// sekadar menyatakan kekosongan. "Belum ada produk. Tambah produk pertama
/// untuk mulai berjualan." lebih berguna daripada "Tidak ada data."
class AppEmptyState extends StatelessWidget {
  final String message;

  /// Baris pertama yang lebih tebal, bila pesan perlu dipecah.
  final String? title;

  final IconData icon;

  /// Aksi yang menyelesaikan kekosongan ini, misalnya "Tambah Produk".
  final Widget? action;

  /// Versi ringkas tanpa ikon, untuk ruang sempit seperti panel inspector.
  final bool compact;

  const AppEmptyState({
    super.key,
    required this.message,
    this.title,
    this.icon = AppIcons.empty,
    this.action,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final density = context.space;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(density.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!compact) ...[
              Icon(icon, size: 40, color: colors.textDisabled),
              SizedBox(height: density.md),
            ],
            if (title != null) ...[
              Text(
                title!,
                textAlign: TextAlign.center,
                style: context.text.tableCellEmphasis
                    .copyWith(color: colors.textSecondary),
              ),
              SizedBox(height: density.xs),
            ],
            Text(
              message,
              textAlign: TextAlign.center,
              style: context.text.tableCell.copyWith(color: colors.textTertiary),
            ),
            if (action != null) ...[
              SizedBox(height: density.lg),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
