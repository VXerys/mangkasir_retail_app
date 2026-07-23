import 'package:flutter/material.dart';

import '../design.dart';

/// Tampilan kegagalan disertai jalan keluar.
///
/// [onRetry] sengaja dibuat wajib-secara-praktik: layar galat tanpa cara
/// memulihkan diri memaksa kasir menutup aplikasi di tengah antrean. Kalau
/// memang tidak ada yang bisa dicoba ulang, sediakan [action] lain.
class AppErrorView extends StatelessWidget {
  final String message;

  /// Judul singkat. Bawaannya cocok untuk sebagian besar kegagalan.
  final String title;

  /// Detail teknis, hanya ditampilkan bila diisi.
  ///
  /// Berguna untuk `Failure.message` dari lapisan data — kasir bisa
  /// membacakannya ke tim dukungan tanpa perlu membuka log.
  final String? detail;

  final VoidCallback? onRetry;
  final String retryLabel;

  /// Aksi pengganti bila mencoba ulang tidak masuk akal.
  final Widget? action;

  const AppErrorView({
    super.key,
    required this.message,
    this.title = 'Terjadi kesalahan',
    this.detail,
    this.onRetry,
    this.retryLabel = 'Coba lagi',
    this.action,
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
            Icon(AppIcons.danger, size: 40, color: colors.danger.fg),
            SizedBox(height: density.md),
            Text(
              title,
              textAlign: TextAlign.center,
              style: context.text.tableCellEmphasis
                  .copyWith(color: colors.textPrimary),
            ),
            SizedBox(height: density.xs),
            Text(
              message,
              textAlign: TextAlign.center,
              style: context.text.tableCell.copyWith(color: colors.textSecondary),
            ),
            if (detail != null) ...[
              SizedBox(height: density.md),
              Container(
                padding: EdgeInsets.all(density.sm),
                decoration: BoxDecoration(
                  color: colors.surfaceSubtle,
                  borderRadius: AppRadius.rSm,
                  border: Border.all(color: colors.borderSubtle),
                ),
                child: SelectableText(
                  detail!,
                  style: context.text.receiptLine
                      .copyWith(color: colors.textTertiary),
                ),
              ),
            ],
            if (onRetry != null || action != null) ...[
              SizedBox(height: density.lg),
              action ??
                  AppButton(
                    label: retryLabel,
                    icon: AppIcons.refresh,
                    variant: AppButtonVariant.secondary,
                    onPressed: onRetry,
                  ),
            ],
          ],
        ),
      ),
    );
  }
}
