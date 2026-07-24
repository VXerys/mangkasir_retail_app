import 'dart:async';

import 'package:flutter/material.dart';

import '../design.dart';

/// Kotak pencarian dengan penundaan.
///
/// Penundaan bukan hiasan. Setiap ketukan tombol pada daftar produk berarti
/// satu kueri Drift dan satu pembangunan ulang tabel; mengetik "indomie" tanpa
/// penundaan menjalankan tujuh kueri, enam di antaranya hasilnya langsung
/// dibuang. Pada perangkat kasir yang murah, itu terasa sebagai lag mengetik.
///
/// [onChanged] karenanya dipanggil setelah pengguna berhenti mengetik selama
/// [debounce]. Yang butuh nilai seketika — misalnya pemindai barcode yang
/// menekan Enter — memakai [onSubmitted], yang tidak tertunda.
class AppSearchField extends StatefulWidget {
  /// Nilai awal. Perubahan berikutnya dikelola sendiri oleh widget ini.
  final String? initialValue;

  /// Dipanggil setelah pengetikan berhenti selama [debounce].
  final ValueChanged<String> onChanged;

  /// Dipanggil seketika saat Enter ditekan, tanpa menunggu penundaan.
  final ValueChanged<String>? onSubmitted;

  final String hint;

  /// Jeda sejak ketukan terakhir sebelum [onChanged] dipanggil.
  ///
  /// 300 ms adalah titik di mana pengetikan terasa masih responsif tetapi
  /// kata utuh sudah selesai diketik. Sengaja bukan token [AppMotion]: itu
  /// plafon untuk **animasi**, sedangkan angka ini soal beban kueri.
  final Duration debounce;

  final bool autofocus;
  final FocusNode? focusNode;

  /// Lebar tetap. Bila null, melebar mengikuti induknya.
  final double? width;

  const AppSearchField({
    super.key,
    required this.onChanged,
    this.initialValue,
    this.onSubmitted,
    this.hint = 'Cari…',
    this.debounce = const Duration(milliseconds: 300),
    this.autofocus = false,
    this.focusNode,
    this.width,
  });

  @override
  State<AppSearchField> createState() => _AppSearchFieldState();
}

class _AppSearchFieldState extends State<AppSearchField> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.initialValue);
  Timer? _timer;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _hasText = _controller.text.isNotEmpty;
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    // Tombol bersihkan muncul/hilang seketika; hanya kuerinya yang tertunda.
    final hasText = value.isNotEmpty;
    if (hasText != _hasText) setState(() => _hasText = hasText);

    _timer?.cancel();
    _timer = Timer(widget.debounce, () => widget.onChanged(value));
  }

  void _clear() {
    _timer?.cancel();
    _controller.clear();
    setState(() => _hasText = false);
    // Mengosongkan adalah tindakan yang disengaja, bukan hasil mengetik —
    // jadi hasilnya diberitahukan tanpa penundaan.
    widget.onChanged('');
  }

  @override
  Widget build(BuildContext context) {
    final field = AppTextField(
      controller: _controller,
      focusNode: widget.focusNode,
      hint: widget.hint,
      autofocus: widget.autofocus,
      prefixIcon: AppIcons.search,
      textInputAction: TextInputAction.search,
      onChanged: _onChanged,
      onSubmitted: (value) {
        _timer?.cancel();
        widget.onSubmitted?.call(value);
      },
      suffix: _hasText
          ? AppIconButton(
              icon: AppIcons.close,
              tooltip: 'Bersihkan',
              size: AppButtonSize.small,
              onPressed: _clear,
            )
          : null,
    );

    return widget.width == null
        ? field
        : SizedBox(width: widget.width, child: field);
  }
}
