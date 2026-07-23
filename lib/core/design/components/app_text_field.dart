import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../design.dart';

/// Kolom isian standar aplikasi.
///
/// Beberapa keputusan di sini berasal langsung dari prinsip 16.1:
///
/// - [autofocus] dan [focusNode] diteruskan apa adanya supaya alur pemindaian
///   barcode bisa mengembalikan fokus ke kolom pencarian tanpa pengguna
///   menyentuh layar ("Scan Friendly").
/// - [onSubmitted] tersedia agar Enter menyelesaikan aksi tanpa mouse
///   ("Keyboard Friendly").
/// - Label berada di **atas** kolom, bukan mengambang di dalamnya. Label
///   mengambang memakan tinggi dan menghilang saat kolom terisi — pada
///   formulir padat, kasir jadi kehilangan konteks kolom mana yang sedang
///   diisi.
class AppTextField extends StatelessWidget {
  final String? label;
  final String? hint;

  /// Teks bantuan di bawah kolom. Tergantikan oleh [errorText] bila ada.
  final String? helperText;

  final String? errorText;

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  final IconData? prefixIcon;

  /// Widget di sisi kanan: tombol bersihkan, pemindai, atau satuan.
  final Widget? suffix;

  final bool autofocus;
  final bool enabled;
  final bool obscureText;
  final bool readOnly;
  final int? maxLines;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;

  /// Merender isian dengan font monospace tabular.
  ///
  /// Aktifkan untuk kolom harga, kuantitas, dan barcode agar angka yang diketik
  /// sejajar dengan angka yang ditampilkan di tabel.
  final bool isNumeric;

  const AppTextField({
    super.key,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.onSubmitted,
    this.prefixIcon,
    this.suffix,
    this.autofocus = false,
    this.enabled = true,
    this.obscureText = false,
    this.readOnly = false,
    this.maxLines = 1,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.isNumeric = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.text;
    final density = context.space;

    final textStyle = isNumeric
        ? typography.tableCellNumeric.copyWith(fontSize: 14, height: 20 / 14)
        : typography.formInput;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: typography.formLabel.copyWith(color: colors.textSecondary),
          ),
          SizedBox(height: density.xs),
        ],
        ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: maxLines == 1 ? density.controlHeight : 0,
          ),
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            onChanged: onChanged,
            onSubmitted: onSubmitted,
            autofocus: autofocus,
            enabled: enabled,
            obscureText: obscureText,
            readOnly: readOnly,
            maxLines: obscureText ? 1 : maxLines,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            inputFormatters: inputFormatters,
            style: textStyle.copyWith(
              color: enabled ? colors.textPrimary : colors.textDisabled,
            ),
            decoration: InputDecoration(
              hintText: hint,
              prefixIcon: prefixIcon == null
                  ? null
                  : Icon(prefixIcon, size: 16, color: colors.textTertiary),
              prefixIconConstraints: BoxConstraints(
                minWidth: density.controlHeight,
                minHeight: density.controlHeight,
              ),
              suffixIcon: suffix,
              suffixIconConstraints: BoxConstraints(
                minWidth: density.controlHeight,
                minHeight: density.controlHeight,
              ),
              // Galat dan bantuan ditangani di bawah agar tinggi kolom tetap
              // stabil saat pesan galat muncul — baris tabel yang bergeser
              // ketika validasi berjalan sangat mengganggu saat entri cepat.
              errorText: null,
              helperText: null,
              contentPadding: EdgeInsets.symmetric(
                horizontal: prefixIcon == null ? density.md : 0,
                vertical: density.sm,
              ),
              fillColor: enabled ? colors.surface : colors.surfaceSubtle,
              enabledBorder: _border(
                errorText != null ? colors.danger.border : colors.borderDefault,
              ),
              focusedBorder: _border(
                errorText != null ? colors.danger.fg : colors.borderFocus,
                width: 2,
              ),
            ),
          ),
        ),
        if (errorText != null || helperText != null) ...[
          SizedBox(height: density.xs),
          Text(
            errorText ?? helperText!,
            style: typography.formHelper.copyWith(
              color: errorText != null ? colors.danger.fg : colors.textTertiary,
            ),
          ),
        ],
      ],
    );
  }

  OutlineInputBorder _border(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: AppRadius.rSm,
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
