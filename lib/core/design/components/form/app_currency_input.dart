import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../utils/currency_formatter.dart';
import '../../design.dart';

/// Isian nilai uang yang memformat dirinya sambil diketik.
///
/// Kasir mengetik `150000` dan langsung melihat `150.000`. Tanpa itu, angka
/// panjang harus dihitung digitnya dengan mata — sumber kesalahan yang mahal
/// ketika yang salah adalah harga jual.
///
/// Pemformatan memakai [CurrencyFormatter.plain] yang sudah ada, bukan
/// `NumberFormat` yang dirakit ulang di sini: pemisah ribuan hanya boleh
/// ditetapkan di satu tempat, kalau tidak isian dan kolom tabel akan
/// menampilkan angka yang sama dengan bentuk berbeda.
class AppCurrencyInput extends StatefulWidget {
  final double value;

  /// `null` menonaktifkan kontrol.
  final ValueChanged<double>? onChanged;

  final String? label;
  final String? hint;
  final String? helperText;
  final String? errorText;

  final FocusNode? focusNode;
  final bool autofocus;

  /// Menampilkan awalan `Rp` di dalam bingkai isian.
  final bool showSymbol;

  const AppCurrencyInput({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.focusNode,
    this.autofocus = false,
    this.showSymbol = true,
  });

  @override
  State<AppCurrencyInput> createState() => _AppCurrencyInputState();
}

class _AppCurrencyInputState extends State<AppCurrencyInput> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.value == 0 ? '' : CurrencyFormatter.plain(widget.value),
  );

  @override
  void didUpdateWidget(AppCurrencyInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value == oldWidget.value) return;

    final formatted =
        widget.value == 0 ? '' : CurrencyFormatter.plain(widget.value);
    if (_controller.text != formatted) _controller.text = formatted;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final density = context.space;

    return AppTextField(
      label: widget.label,
      hint: widget.hint ?? '0',
      helperText: widget.helperText,
      errorText: widget.errorText,
      controller: _controller,
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      enabled: widget.onChanged != null,
      isNumeric: true,
      keyboardType: TextInputType.number,
      inputFormatters: [_ThousandsFormatter()],
      prefixIcon: null,
      suffix: widget.showSymbol
          ? Padding(
              padding: EdgeInsets.only(right: density.md),
              child: Text(
                'Rp',
                style: context.text.formHelper
                    .copyWith(color: colors.textTertiary),
              ),
            )
          : null,
      onChanged: (text) {
        final digits = text.replaceAll(RegExp(r'[^0-9]'), '');
        widget.onChanged?.call(digits.isEmpty ? 0 : double.parse(digits));
      },
    );
  }
}

/// Menyisipkan pemisah ribuan sambil menjaga posisi kursor.
///
/// Kursor dihitung ulang dari **jumlah digit di sebelah kirinya**, bukan dari
/// posisi karakternya. Kalau memakai posisi karakter, setiap kali sebuah titik
/// tersisip kursor akan melompat satu langkah ke kiri — dan mengetik angka
/// panjang jadi mustahil.
class _ThousandsFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) return const TextEditingValue();

    final digitsBeforeCursor = newValue.text
        .substring(0, newValue.selection.baseOffset.clamp(0, newValue.text.length))
        .replaceAll(RegExp(r'[^0-9]'), '')
        .length;

    final formatted = CurrencyFormatter.plain(double.parse(digits));

    var offset = formatted.length;
    var seen = 0;
    for (var i = 0; i < formatted.length; i++) {
      if (seen == digitsBeforeCursor) {
        offset = i;
        break;
      }
      if (RegExp(r'[0-9]').hasMatch(formatted[i])) seen++;
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: offset),
    );
  }
}
