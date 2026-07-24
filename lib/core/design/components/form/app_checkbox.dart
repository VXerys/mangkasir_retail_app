import 'package:flutter/material.dart';

import '../../design.dart';
import 'toggle_shell.dart';

/// Kotak centang.
///
/// [Checkbox] Material tidak dipakai karena warnanya diambil dari
/// `ColorScheme` dan riak sentuhnya digambar di luar batas kotak — dua hal yang
/// tidak bisa dipetakan bersih ke `AppSemanticColors` maupun ke aturan sudut
/// tegas design system ini.
///
/// [value] boleh `null` bila [tristate] menyala. Keadaan itu dipakai oleh
/// header tabel: sebagian baris terpilih bukan berarti terpilih, dan bukan pula
/// berarti tidak.
class AppCheckbox extends StatelessWidget {
  final bool? value;

  /// `null` menonaktifkan kontrol.
  ///
  /// Selalu menerima `bool`, tidak pernah `null`, walaupun [tristate] menyala:
  /// keadaan setengah hanya bisa datang dari data, bukan dari klik pengguna.
  final ValueChanged<bool>? onChanged;

  final String? label;
  final String? helperText;

  /// Mengizinkan [value] bernilai `null` sebagai keadaan "sebagian".
  final bool tristate;

  const AppCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.helperText,
    this.tristate = false,
  }) : assert(
          tristate || value != null,
          'value hanya boleh null bila tristate menyala',
        );

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final enabled = onChanged != null;
    final checked = value ?? false;
    final partial = value == null;

    return ToggleShell(
      label: label,
      helperText: helperText,
      onTap: enabled ? () => onChanged!(!checked) : null,
      indicatorBuilder: (focused, hovered) {
        final Color fill;
        final Color border;

        if (!enabled) {
          fill = colors.surfaceSubtle;
          border = colors.borderSubtle;
        } else if (checked || partial) {
          fill = colors.accent;
          border = colors.accent;
        } else {
          fill = hovered ? colors.surfaceHover : colors.surface;
          border = hovered ? colors.borderStrong : colors.borderDefault;
        }

        return Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            color: fill,
            borderRadius: AppRadius.rXs,
            border: Border.all(color: border, width: 1.5),
            // Cincin fokus digambar di luar kotak supaya tidak menutupi
            // centangnya. POS ini dioperasikan dengan papan ketik — fokus yang
            // samar sama saja dengan tidak ada fokus.
            boxShadow: focused
                ? [
                    BoxShadow(
                      color: colors.borderFocus,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
          child: partial
              ? Center(
                  child: Container(
                    width: 8,
                    height: 2,
                    color: enabled ? colors.textOnAccent : colors.textDisabled,
                  ),
                )
              : checked
                  ? Icon(
                      AppIcons.check,
                      size: 14,
                      color:
                          enabled ? colors.textOnAccent : colors.textDisabled,
                    )
                  : null,
        );
      },
    );
  }
}
