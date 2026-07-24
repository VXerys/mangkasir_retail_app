import 'package:flutter/material.dart';

import '../../design.dart';

/// Kerangka bersama untuk checkbox, radio, dan switch.
///
/// **Bukan bagian dari API publik design system** — sengaja tidak diekspor dari
/// `design.dart`. Feature memakai `AppCheckbox`/`AppRadio`/`AppSwitch`.
///
/// Ketiga kontrol itu berbeda hanya pada gambar indikatornya. Sisanya identik
/// dan mudah menyimpang bila disalin tiga kali: area sentuh minimum, cincin
/// fokus papan ketik, sorotan kursor, label yang ikut bisa diklik, dan
/// aktivasi lewat Spasi/Enter. Semuanya dikumpulkan di sini.
class ToggleShell extends StatefulWidget {
  /// Menggambar indikator sesuai keadaan interaksi yang sedang berlaku.
  final Widget Function(bool focused, bool hovered) indicatorBuilder;

  /// `null` berarti kontrol dinonaktifkan.
  final VoidCallback? onTap;

  /// Teks di sebelah kanan indikator. Ikut bisa diklik — target sekecil kotak
  /// 16px terlalu sulit dikenai, terutama di layar sentuh.
  final String? label;

  /// Keterangan di bawah label.
  final String? helperText;

  const ToggleShell({
    super.key,
    required this.indicatorBuilder,
    required this.onTap,
    this.label,
    this.helperText,
  });

  @override
  State<ToggleShell> createState() => _ToggleShellState();
}

class _ToggleShellState extends State<ToggleShell> {
  bool _focused = false;
  bool _hovered = false;

  bool get _enabled => widget.onTap != null;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final density = context.space;
    final typography = context.text;

    final row = Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.indicatorBuilder(_focused, _hovered),
        if (widget.label != null) ...[
          SizedBox(width: density.sm),
          Flexible(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.label!,
                  style: typography.formInput.copyWith(
                    color: _enabled ? colors.textPrimary : colors.textDisabled,
                  ),
                ),
                if (widget.helperText != null) ...[
                  SizedBox(height: density.xs),
                  Text(
                    widget.helperText!,
                    style: typography.formHelper
                        .copyWith(color: colors.textTertiary),
                  ),
                ],
              ],
            ),
          ),
        ],
      ],
    );

    return FocusableActionDetector(
      enabled: _enabled,
      mouseCursor:
          _enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onShowFocusHighlight: (value) => setState(() => _focused = value),
      onShowHoverHighlight: (value) => setState(() => _hovered = value),
      actions: {
        ActivateIntent: CallbackAction<ActivateIntent>(
          onInvoke: (_) {
            widget.onTap?.call();
            return null;
          },
        ),
      },
      child: GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          // Menjaga tinggi area sentuh tanpa membesarkan indikatornya.
          padding: EdgeInsets.symmetric(vertical: density.sm),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: density.minTouchTarget / 2),
            child: row,
          ),
        ),
      ),
    );
  }
}
