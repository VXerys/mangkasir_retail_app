import 'package:flutter/material.dart';

import '../design.dart';

/// Tombol tanpa label, hanya ikon.
///
/// Dipisahkan dari [AppButton] karena aturan ukurannya berbeda: tombol berlabel
/// melebar mengikuti isinya, sedangkan tombol ikon selalu bujur sangkar. Memaksa
/// keduanya berbagi satu widget menghasilkan parameter `label` yang boleh kosong
/// — dan tombol ikon tanpa `tooltip` yang lolos begitu saja.
///
/// [tooltip] wajib diisi. Ikon tanpa keterangan adalah teka-teki, dan pembaca
/// layar tidak punya apa pun untuk dibacakan.
class AppIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  /// Keterangan yang muncul saat kursor berhenti di atasnya, sekaligus label
  /// bagi pembaca layar.
  final String tooltip;

  final AppButtonVariant variant;
  final AppButtonSize size;

  /// Menandai tombol sedang aktif — untuk tombol yang berperan sebagai sakelar,
  /// misalnya tombol filter yang sedang menyala.
  final bool isSelected;

  const AppIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.tooltip,
    this.variant = AppButtonVariant.ghost,
    this.size = AppButtonSize.medium,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final density = context.space;
    final enabled = onPressed != null;

    final extent = switch (size) {
      AppButtonSize.small => density.controlHeight - 8,
      AppButtonSize.medium => density.controlHeight,
      AppButtonSize.large => density.controlHeight + 8,
    };

    final iconSize = switch (size) {
      AppButtonSize.small => 14.0,
      AppButtonSize.medium => 16.0,
      AppButtonSize.large => 20.0,
    };

    final (Color background, Color foreground, Color? border) = switch (
      (enabled, variant)
    ) {
      (false, _) => (Colors.transparent, colors.textDisabled, null),
      (true, AppButtonVariant.primary) => (
          colors.accent,
          colors.textOnAccent,
          null
        ),
      (true, AppButtonVariant.secondary) => (
          colors.surface,
          colors.textPrimary,
          colors.borderDefault
        ),
      (true, AppButtonVariant.danger) => (
          Colors.transparent,
          colors.danger.fg,
          null
        ),
      (true, AppButtonVariant.ghost) => isSelected
          ? (colors.accentSubtle, colors.accent, null)
          : (Colors.transparent, colors.textSecondary, null),
    };

    final button = SizedBox(
      width: extent,
      height: extent,
      child: Material(
        color: background,
        borderRadius: AppRadius.rSm,
        child: InkWell(
          onTap: onPressed,
          borderRadius: AppRadius.rSm,
          hoverColor: colors.surfaceHover,
          focusColor: colors.surfaceHover,
          highlightColor: colors.surfaceSubtle,
          splashColor: colors.surfaceSubtle,
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: AppRadius.rSm,
              border: border == null ? null : Border.all(color: border),
            ),
            child: Icon(icon, size: iconSize, color: foreground),
          ),
        ),
      ),
    );

    // Sama seperti AppButton: area sentuh tidak boleh ikut mengecil bersama
    // tampilan visual.
    final touchPadding =
        ((density.minTouchTarget - extent) / 2).clamp(0.0, double.infinity);

    return AppTooltip(
      message: tooltip,
      child: touchPadding == 0
          ? button
          : Padding(
              padding: EdgeInsets.all(touchPadding),
              child: button,
            ),
    );
  }
}
