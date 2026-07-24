import 'package:flutter/material.dart';

import '../../design.dart';
import 'toggle_shell.dart';

/// Sakelar hidup/mati.
///
/// Bedanya dengan [AppCheckbox] bukan selera bentuk: sakelar berlaku **seketika**
/// (aktifkan produk, nyalakan mode gelap), sedangkan kotak centang menunggu
/// tombol Simpan. Memakai yang keliru membuat pengguna menebak apakah
/// perubahannya sudah tersimpan.
class AppSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? label;
  final String? helperText;

  const AppSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.helperText,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final enabled = onChanged != null;

    const trackWidth = 34.0;
    const trackHeight = 18.0;
    const thumbSize = 14.0;

    return ToggleShell(
      label: label,
      helperText: helperText,
      onTap: enabled ? () => onChanged!(!value) : null,
      indicatorBuilder: (focused, hovered) {
        final Color track;

        if (!enabled) {
          track = colors.surfaceSubtle;
        } else if (value) {
          track = hovered ? colors.accentHover : colors.accent;
        } else {
          track = hovered ? colors.borderStrong : colors.borderDefault;
        }

        return Container(
          width: trackWidth,
          height: trackHeight,
          decoration: BoxDecoration(
            color: track,
            borderRadius: AppRadius.rPill,
            border: Border.all(
              color: enabled ? Colors.transparent : colors.borderSubtle,
            ),
            boxShadow: focused
                ? [BoxShadow(color: colors.borderFocus, spreadRadius: 2)]
                : null,
          ),
          child: AnimatedAlign(
            duration: AppMotion.fast,
            curve: AppMotion.standard,
            alignment: value ? Alignment.centerRight : Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Container(
                width: thumbSize,
                height: thumbSize,
                decoration: BoxDecoration(
                  color: enabled ? colors.surface : colors.textDisabled,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
