import 'package:flutter/material.dart';

import '../design.dart';

/// Satu tab.
@immutable
class AppTabItem {
  /// Pengenal stabil. Dipakai untuk memilih dan menutup, bukan indeks — indeks
  /// bergeser setiap kali sebuah tab ditutup.
  final String id;

  final String label;
  final IconData? icon;

  /// Angka kecil di sebelah label: jumlah item di keranjang, jumlah baris yang
  /// belum tersinkron.
  final int? count;

  /// Menampilkan tombol silang. Untuk tab keranjang, bukan tab navigasi.
  final bool closable;

  const AppTabItem({
    required this.id,
    required this.label,
    this.icon,
    this.count,
    this.closable = false,
  });
}

/// Deretan tab dengan garis bawah pada tab aktif.
///
/// [TabBar] Material tidak dipakai: ia menuntut [TabController] dan
/// [TickerProvider], memakai indeks sebagai identitas, dan tidak punya konsep
/// tab yang bisa ditutup atau ditambah. Untuk keranjang multi-tab — beberapa
/// pelanggan dilayani bergantian di satu kasir — ketiganya menjadi penghalang.
///
/// Dipakai untuk dua hal yang bentuknya sama tetapi sifatnya berbeda:
/// tab tetap (Detail Produk: Ringkasan / Stok / Riwayat) dan tab dinamis
/// (keranjang, dengan [onAdd] dan `closable`).
///
/// Tidak pernah membungkus ke baris kedua. Bila tidak muat, deretannya digeser
/// — tab yang pindah baris membuat tinggi bilah berubah-ubah dan mendorong
/// seluruh isi halaman ke bawah.
class AppTabs extends StatelessWidget {
  final List<AppTabItem> tabs;
  final String selectedId;
  final ValueChanged<String> onSelected;

  /// Bila diisi, tab ber-`closable` menampilkan tombol silang.
  final ValueChanged<String>? onClosed;

  /// Bila diisi, tombol tambah muncul di ujung deretan.
  final VoidCallback? onAdd;

  /// Keterangan tombol tambah.
  final String addTooltip;

  const AppTabs({
    super.key,
    required this.tabs,
    required this.selectedId,
    required this.onSelected,
    this.onClosed,
    this.onAdd,
    this.addTooltip = 'Tab baru',
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final density = context.space;

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colors.borderDefault)),
      ),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (final tab in tabs)
                    _Tab(
                      key: ValueKey(tab.id),
                      tab: tab,
                      isSelected: tab.id == selectedId,
                      onTap: () => onSelected(tab.id),
                      onClose: tab.closable && onClosed != null
                          ? () => onClosed!(tab.id)
                          : null,
                    ),
                ],
              ),
            ),
          ),
          if (onAdd != null)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: density.xs),
              child: AppIconButton(
                icon: AppIcons.add,
                tooltip: addTooltip,
                size: AppButtonSize.small,
                onPressed: onAdd,
              ),
            ),
        ],
      ),
    );
  }
}

class _Tab extends StatefulWidget {
  final AppTabItem tab;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback? onClose;

  const _Tab({
    super.key,
    required this.tab,
    required this.isSelected,
    required this.onTap,
    required this.onClose,
  });

  @override
  State<_Tab> createState() => _TabState();
}

class _TabState extends State<_Tab> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final density = context.space;
    final tab = widget.tab;

    final foreground = widget.isSelected
        ? colors.accent
        : _hovered
            ? colors.textPrimary
            : colors.textSecondary;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          height: density.controlHeight + density.sm,
          padding: EdgeInsets.symmetric(horizontal: density.md),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? colors.surface
                : _hovered
                    ? colors.surfaceHover
                    : Colors.transparent,
            border: Border(
              // Garis bawah setebal 2 px menimpa garis pemisah bilah, sehingga
              // tab aktif terbaca menyatu dengan isi di bawahnya.
              bottom: BorderSide(
                color: widget.isSelected ? colors.accent : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (tab.icon != null) ...[
                Icon(tab.icon, size: 16, color: foreground),
                SizedBox(width: density.xs),
              ],
              Text(
                tab.label,
                style: context.text.toolbarLabel.copyWith(
                  color: foreground,
                  fontWeight: widget.isSelected ? FontWeight.w600 : null,
                ),
              ),
              if (tab.count != null) ...[
                SizedBox(width: density.xs),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: density.xs),
                  constraints: const BoxConstraints(minWidth: 18),
                  decoration: BoxDecoration(
                    color: widget.isSelected
                        ? colors.accentSubtle
                        : colors.surfaceSubtle,
                    borderRadius: AppRadius.rPill,
                  ),
                  child: Text(
                    '${tab.count}',
                    textAlign: TextAlign.center,
                    style: context.text.badge.copyWith(color: foreground),
                  ),
                ),
              ],
              if (widget.onClose != null) ...[
                SizedBox(width: density.xs),
                AppIconButton(
                  icon: AppIcons.close,
                  tooltip: 'Tutup tab',
                  size: AppButtonSize.small,
                  onPressed: widget.onClose,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
