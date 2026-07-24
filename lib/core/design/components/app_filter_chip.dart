import 'package:flutter/material.dart';

import '../design.dart';

/// Penyaring yang bisa dinyalakan dan dimatikan.
///
/// Bedanya dengan [AppBadge] penting dan sering tertukar: lencana **melaporkan**
/// keadaan sebuah data ("Stok habis") dan tidak bisa ditekan; chip **mengubah**
/// apa yang sedang dilihat dan selalu bisa ditekan. Karena itu chip memakai
/// warna aksi (`accent`), bukan warna semantik.
class AppFilterChip extends StatefulWidget {
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  /// Bila diisi, tombol silang muncul saat chip menyala. Untuk filter yang
  /// dirakit pengguna ("Kategori: Minuman") dan bukan pilihan tetap.
  final VoidCallback? onRemove;

  final IconData? icon;

  /// Jumlah hasil yang cocok dengan filter ini.
  final int? count;

  const AppFilterChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.onRemove,
    this.icon,
    this.count,
  });

  @override
  State<AppFilterChip> createState() => _AppFilterChipState();
}

class _AppFilterChipState extends State<AppFilterChip> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final density = context.space;
    final enabled = widget.onTap != null;

    final Color background;
    final Color border;
    final Color foreground;

    if (!enabled) {
      background = colors.surfaceSubtle;
      border = colors.borderSubtle;
      foreground = colors.textDisabled;
    } else if (widget.selected) {
      background = colors.accentSubtle;
      border = colors.accent;
      foreground = colors.accent;
    } else {
      background = _hovered ? colors.surfaceHover : colors.surface;
      border = _hovered ? colors.borderStrong : colors.borderDefault;
      foreground = colors.textSecondary;
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor:
          enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          height: density.controlHeight - 4,
          padding: EdgeInsets.symmetric(horizontal: density.sm),
          decoration: BoxDecoration(
            color: background,
            borderRadius: AppRadius.rSm,
            border: Border.all(color: border),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.icon != null) ...[
                Icon(widget.icon, size: 14, color: foreground),
                SizedBox(width: density.xs),
              ],
              Text(
                widget.label,
                style: context.text.toolbarLabel.copyWith(color: foreground),
              ),
              if (widget.count != null) ...[
                SizedBox(width: density.xs),
                Text(
                  '${widget.count}',
                  style: context.text.tableCellNumeric.copyWith(
                    fontSize: 11,
                    height: 14 / 11,
                    color: foreground,
                  ),
                ),
              ],
              if (widget.selected && widget.onRemove != null) ...[
                SizedBox(width: density.xs),
                GestureDetector(
                  onTap: widget.onRemove,
                  child: Icon(AppIcons.close, size: 14, color: foreground),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Bilah berisi chip penyaring, dengan jalan keluar ke filter lanjutan.
///
/// Filter yang muat sebagai chip diletakkan di sini; sisanya — rentang tanggal,
/// gabungan beberapa syarat — masuk ke laci lewat [onAdvanced]. Memaksa semua
/// filter menjadi chip menghasilkan bilah yang lebih tinggi daripada tabelnya.
class AppFilterBar extends StatelessWidget {
  final List<Widget> chips;

  /// Membuka filter lanjutan. Biasanya diisi dengan `showAppDrawer`.
  final VoidCallback? onAdvanced;

  /// Membersihkan seluruh filter. Sembunyi saat tidak ada yang aktif.
  final VoidCallback? onClear;

  /// Jumlah filter yang sedang aktif. Menentukan tampil-tidaknya [onClear] dan
  /// angka pada tombol filter lanjutan.
  final int activeCount;

  /// Widget di sisi kiri bilah, biasanya [AppSearchField].
  final Widget? leading;

  const AppFilterBar({
    super.key,
    required this.chips,
    this.onAdvanced,
    this.onClear,
    this.activeCount = 0,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    final density = context.space;

    return Row(
      children: [
        if (leading != null) ...[
          Flexible(child: leading!),
          SizedBox(width: density.sm),
        ],
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final (index, chip) in chips.indexed) ...[
                  if (index > 0) SizedBox(width: density.xs),
                  chip,
                ],
              ],
            ),
          ),
        ),
        if (onClear != null && activeCount > 0) ...[
          SizedBox(width: density.sm),
          AppButton(
            label: 'Bersihkan',
            variant: AppButtonVariant.ghost,
            size: AppButtonSize.small,
            onPressed: onClear,
          ),
        ],
        if (onAdvanced != null) ...[
          SizedBox(width: density.xs),
          AppButton(
            label: activeCount > 0 ? 'Filter ($activeCount)' : 'Filter',
            variant: AppButtonVariant.secondary,
            size: AppButtonSize.small,
            icon: AppIcons.filter,
            onPressed: onAdvanced,
          ),
        ],
      ],
    );
  }
}
