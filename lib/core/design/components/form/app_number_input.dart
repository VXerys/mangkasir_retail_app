import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../design.dart';

/// Isian angka bulat dengan tombol kurang dan tambah.
///
/// Dipakai untuk kuantitas: baris keranjang, jumlah terima barang, hasil hitung
/// stok opname. Angkanya memakai `tableCellNumeric` supaya lebar digitnya tetap
/// dan kolom qty di dalam tabel tidak bergeser saat nilainya berubah.
///
/// Dua jalur masuk yang harus sama-sama benar: tombol −/+ untuk sentuhan, dan
/// mengetik langsung untuk kasir yang hafal jumlahnya. Karena itu nilai diambil
/// dari pengetikan hanya ketika hasilnya angka sah — mengetik "1" lalu
/// menghapusnya tidak boleh langsung melompat ke [min].
class AppNumberInput extends StatefulWidget {
  final int value;

  /// `null` menonaktifkan kontrol.
  final ValueChanged<int>? onChanged;

  final String? label;
  final String? helperText;
  final String? errorText;

  final int min;
  final int max;

  /// Besar loncatan tiap kali tombol ditekan.
  final int step;

  /// Satuan yang ditampilkan di kanan angka: "pcs", "box", "kg".
  final String? suffix;

  /// Lebar tetap. Bila null, melebar mengikuti induknya.
  final double? width;

  const AppNumberInput({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.helperText,
    this.errorText,
    this.min = 0,
    this.max = 999999,
    this.step = 1,
    this.suffix,
    this.width,
  });

  @override
  State<AppNumberInput> createState() => _AppNumberInputState();
}

class _AppNumberInputState extends State<AppNumberInput> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.value.toString());
  final _focusNode = FocusNode();

  bool get _enabled => widget.onChanged != null;

  @override
  void initState() {
    super.initState();
    // Saat fokus lepas, isian dikembalikan ke nilai sah — kalau pengguna
    // meninggalkannya dalam keadaan kosong, yang terlihat harus angka, bukan
    // kolom kosong yang artinya ambigu.
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) _syncText();
    });
  }

  @override
  void didUpdateWidget(AppNumberInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Nilai boleh berubah dari luar (mis. baris keranjang di-reset oleh bloc).
    // Jangan menimpa teks selagi pengguna sedang mengetik di dalamnya.
    if (widget.value != oldWidget.value && !_focusNode.hasFocus) _syncText();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _syncText() {
    final text = widget.value.toString();
    if (_controller.text != text) _controller.text = text;
  }

  void _emit(int next) {
    final clamped = next.clamp(widget.min, widget.max);
    if (clamped != widget.value) widget.onChanged?.call(clamped);
    // Nilai yang dijepit ke batas tetap harus terlihat di isian, walaupun
    // `widget.value` tidak berubah dan didUpdateWidget tidak terpanggil.
    if (_controller.text != clamped.toString() && !_focusNode.hasFocus) {
      _controller.text = clamped.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final density = context.space;
    final typography = context.text;

    final canDecrease = _enabled && widget.value > widget.min;
    final canIncrease = _enabled && widget.value < widget.max;

    final field = Container(
      height: density.controlHeight,
      decoration: BoxDecoration(
        color: _enabled ? colors.surface : colors.surfaceSubtle,
        borderRadius: AppRadius.rSm,
        border: Border.all(
          color: widget.errorText != null
              ? colors.danger.border
              : colors.borderDefault,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepButton(
            icon: Icons.remove,
            tooltip: 'Kurangi',
            onPressed:
                canDecrease ? () => _emit(widget.value - widget.step) : null,
          ),
          AppDivider.vertical(color: colors.borderSubtle),
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              enabled: _enabled,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: typography.tableCellNumeric.copyWith(
                fontSize: 14,
                height: 20 / 14,
                color: _enabled ? colors.textPrimary : colors.textDisabled,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: (text) {
                final parsed = int.tryParse(text);
                if (parsed != null) _emit(parsed);
              },
            ),
          ),
          if (widget.suffix != null) ...[
            Text(
              widget.suffix!,
              style: typography.formHelper.copyWith(color: colors.textTertiary),
            ),
            SizedBox(width: density.sm),
          ],
          AppDivider.vertical(color: colors.borderSubtle),
          _StepButton(
            icon: AppIcons.add,
            tooltip: 'Tambah',
            onPressed:
                canIncrease ? () => _emit(widget.value + widget.step) : null,
          ),
        ],
      ),
    );

    final message = widget.errorText ?? widget.helperText;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: typography.formLabel.copyWith(color: colors.textSecondary),
          ),
          SizedBox(height: density.xs),
        ],
        widget.width == null ? field : SizedBox(width: widget.width, child: field),
        if (message != null) ...[
          SizedBox(height: density.xs),
          Text(
            message,
            style: typography.formHelper.copyWith(
              color: widget.errorText != null
                  ? colors.danger.fg
                  : colors.textTertiary,
            ),
          ),
        ],
      ],
    );
  }
}

/// Tombol −/+ yang menempel rapat di dalam bingkai isian.
///
/// Tidak memakai [AppIconButton] karena tombol itu membawa padding area sentuh
/// di sekelilingnya, yang di sini akan merusak bingkai bersama.
class _StepButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;

  const _StepButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final density = context.space;

    return AppTooltip(
      message: tooltip,
      child: SizedBox(
        width: density.controlHeight,
        height: density.controlHeight,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            hoverColor: colors.surfaceHover,
            focusColor: colors.surfaceHover,
            highlightColor: colors.surfaceSubtle,
            splashColor: colors.surfaceSubtle,
            child: Icon(
              icon,
              size: 16,
              color: onPressed == null
                  ? colors.textDisabled
                  : colors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
