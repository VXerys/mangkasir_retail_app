import 'package:flutter/material.dart';

import '../design.dart';

/// Peran visual sebuah tombol.
enum AppButtonVariant {
  /// Satu aksi utama per layar. Lebih dari satu berarti tidak ada yang utama.
  primary,

  /// Aksi pendamping: Batal, Kembali, Filter.
  secondary,

  /// Aksi tersier di dalam toolbar dan sel tabel, tanpa garis tepi.
  ghost,

  /// Aksi merusak: Hapus, Batalkan Transaksi, Kosongkan Keranjang.
  danger,
}

enum AppButtonSize { small, medium, large }

/// Tombol standar aplikasi.
///
/// Tingginya mengikuti kerapatan yang berlaku, tetapi area sentuhnya tidak
/// pernah turun di bawah `minTouchTarget`. Selisihnya diisi padding transparan
/// lewat [Semantics]-friendly [ConstrainedBox], sehingga tombol setinggi 32px
/// pada layar desktop tetap nyaman ditekan pada layar sentuh.
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;

  /// Ikon di sebelah kiri label. Ambil dari `AppIcons`.
  final IconData? icon;

  /// Menampilkan pemintal dan menonaktifkan tombol.
  ///
  /// Dipisahkan dari `onPressed == null` supaya tombol yang sedang memproses
  /// tetap terlihat berbeda dari tombol yang memang dinonaktifkan.
  final bool isLoading;

  /// Melebar memenuhi lebar induk. Untuk tombol bayar dan aksi di bottom sheet.
  final bool isFullWidth;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
  });

  bool get _isEnabled => onPressed != null && !isLoading;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final density = context.space;

    final height = switch (size) {
      AppButtonSize.small => density.controlHeight - 4,
      AppButtonSize.medium => density.controlHeight,
      AppButtonSize.large => density.controlHeight + 8,
    };

    final horizontalPadding = switch (size) {
      AppButtonSize.small => density.md,
      AppButtonSize.medium => density.lg,
      AppButtonSize.large => density.xl,
    };

    final style = _resolveStyle(colors);

    final child = Row(
      mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading)
          SizedBox(
            width: 14,
            height: 14,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: style.foreground,
            ),
          )
        else if (icon != null)
          Icon(icon, size: 16, color: style.foreground),
        if (isLoading || icon != null) SizedBox(width: density.sm),
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.text.buttonLabel.copyWith(color: style.foreground),
          ),
        ),
      ],
    );

    final button = SizedBox(
      height: height,
      width: isFullWidth ? double.infinity : null,
      child: Material(
        color: style.background,
        borderRadius: AppRadius.rSm,
        child: InkWell(
          onTap: _isEnabled ? onPressed : null,
          borderRadius: AppRadius.rSm,
          hoverColor: style.hover,
          highlightColor: style.pressed,
          splashColor: style.pressed,
          // Fokus keyboard harus terlihat jelas — POS ini dioperasikan
          // dengan pintasan papan ketik.
          focusColor: style.hover,
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: AppRadius.rSm,
              border: style.border == null
                  ? null
                  : Border.all(color: style.border!),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Center(child: child),
            ),
          ),
        ),
      ),
    );

    // Jaga area sentuh minimum tanpa mengubah tinggi visual tombol.
    final touchPadding = ((density.minTouchTarget - height) / 2)
        .clamp(0.0, double.infinity);

    if (touchPadding == 0) return button;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: touchPadding),
      child: button,
    );
  }

  _ButtonStyle _resolveStyle(AppSemanticColors colors) {
    if (!_isEnabled) {
      return _ButtonStyle(
        background: variant == AppButtonVariant.ghost
            ? Colors.transparent
            : colors.surfaceSubtle,
        foreground: colors.textDisabled,
        border: variant == AppButtonVariant.ghost ? null : colors.borderSubtle,
        hover: Colors.transparent,
        pressed: Colors.transparent,
      );
    }

    return switch (variant) {
      AppButtonVariant.primary => _ButtonStyle(
          background: colors.accent,
          foreground: colors.textOnAccent,
          border: null,
          hover: colors.accentHover,
          pressed: colors.accentPressed,
        ),
      AppButtonVariant.secondary => _ButtonStyle(
          background: colors.surface,
          foreground: colors.textPrimary,
          border: colors.borderDefault,
          hover: colors.surfaceHover,
          pressed: colors.surfaceSubtle,
        ),
      AppButtonVariant.ghost => _ButtonStyle(
          background: Colors.transparent,
          foreground: colors.textSecondary,
          border: null,
          hover: colors.surfaceHover,
          pressed: colors.surfaceSubtle,
        ),
      AppButtonVariant.danger => _ButtonStyle(
          background: colors.danger.fg,
          foreground: colors.textOnAccent,
          border: null,
          hover: colors.danger.fg,
          pressed: colors.danger.fg,
        ),
    };
  }
}

@immutable
class _ButtonStyle {
  final Color background;
  final Color foreground;
  final Color? border;
  final Color hover;
  final Color pressed;

  const _ButtonStyle({
    required this.background,
    required this.foreground,
    required this.border,
    required this.hover,
    required this.pressed,
  });
}
