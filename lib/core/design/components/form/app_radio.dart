import 'package:flutter/material.dart';

import '../../design.dart';
import 'toggle_shell.dart';

/// Satu pilihan dalam sekelompok pilihan yang saling meniadakan.
///
/// Hampir selalu dipakai lewat [AppRadioGroup]. Bentuk tunggalnya disediakan
/// untuk tata letak yang tidak berupa daftar lurus — misalnya pilihan metode
/// pembayaran yang disusun sebagai kisi.
class AppRadio<T> extends StatelessWidget {
  final T value;

  /// Nilai yang sedang terpilih di dalam kelompok.
  final T? groupValue;

  final ValueChanged<T>? onChanged;
  final String? label;
  final String? helperText;

  const AppRadio({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.label,
    this.helperText,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final enabled = onChanged != null;
    final selected = value == groupValue;

    return ToggleShell(
      label: label,
      helperText: helperText,
      // Menekan pilihan yang sudah terpilih tidak melakukan apa-apa: radio
      // tidak bisa dibatalkan, hanya dipindah.
      onTap: enabled && !selected ? () => onChanged!(value) : null,
      indicatorBuilder: (focused, hovered) {
        final Color border;

        if (!enabled) {
          border = colors.borderSubtle;
        } else if (selected) {
          border = colors.accent;
        } else {
          border = hovered ? colors.borderStrong : colors.borderDefault;
        }

        return Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            color: enabled
                ? (hovered && !selected ? colors.surfaceHover : colors.surface)
                : colors.surfaceSubtle,
            shape: BoxShape.circle,
            border: Border.all(color: border, width: 1.5),
            boxShadow: focused
                ? [BoxShadow(color: colors.borderFocus, spreadRadius: 2)]
                : null,
          ),
          child: selected
              ? Center(
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: enabled ? colors.accent : colors.textDisabled,
                      shape: BoxShape.circle,
                    ),
                  ),
                )
              : null,
        );
      },
    );
  }
}

/// Sekelompok [AppRadio] beserta label kelompoknya.
///
/// Menyusun pilihan menjadi kolom pada layar sempit dan baris pada layar lebar
/// bila [horizontal] menyala. Menyatukan kelompoknya di satu widget membuat
/// `groupValue` mustahil lupa disebarkan ke salah satu pilihan.
class AppRadioGroup<T> extends StatelessWidget {
  final String? label;
  final T? value;
  final ValueChanged<T>? onChanged;

  /// Pasangan nilai dan labelnya, berurutan sesuai tampilan.
  final List<(T value, String label)> options;

  /// Menyusun pilihan mendatar. Hanya untuk 2–3 pilihan berlabel pendek.
  final bool horizontal;

  const AppRadioGroup({
    super.key,
    required this.value,
    required this.onChanged,
    required this.options,
    this.label,
    this.horizontal = false,
  });

  @override
  Widget build(BuildContext context) {
    final density = context.space;

    final radios = [
      for (final (optionValue, optionLabel) in options)
        AppRadio<T>(
          value: optionValue,
          groupValue: value,
          onChanged: onChanged,
          label: optionLabel,
        ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: context.text.formLabel
                .copyWith(color: context.colors.textSecondary),
          ),
          SizedBox(height: density.xs),
        ],
        if (horizontal)
          Wrap(spacing: density.lg, children: radios)
        else
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: radios,
          ),
      ],
    );
  }
}
