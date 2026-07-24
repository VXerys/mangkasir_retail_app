import 'package:flutter/material.dart';

import '../../design.dart';

/// Navigasi utama untuk layar sempit.
///
/// Menggantikan laci samping sebagai navigasi utama di ponsel, sesuai
/// [16_Design_System.md] §16.4. Alasannya bukan selera: laci menyembunyikan
/// setiap tujuan di balik satu ketukan tambahan, dan menaruh pemicunya di pojok
/// kiri atas — sudut terjauh dari ibu jari pada perangkat yang dipegang satu
/// tangan. Kasir memegang ponsel sambil tangan lain memegang barang.
///
/// [NavigationBar] Material tidak dipakai: tingginya dipatok 80 px oleh
/// spesifikasi Material 3, warnanya diambil dari `ColorScheme`, dan indikator
/// pilnya bertentangan dengan sudut tegas design system ini.
///
/// Maksimum lima tujuan. Lebih dari itu, labelnya terpotong dan sasaran
/// sentuhnya menyempit di bawah ambang yang aman — tujuan selebihnya masuk ke
/// laci sekunder lewat [overflowItem].
class AppBottomNav extends StatelessWidget {
  final List<AppNavItem> items;

  /// Indeks tujuan yang sedang aktif. `-1` berarti tidak ada.
  final int selectedIndex;

  /// Tujuan tambahan di ujung kanan, biasanya "Lainnya" yang membuka laci
  /// berisi menu yang jarang disentuh: ganti outlet, setelan, keluar.
  final AppNavItem? overflowItem;

  const AppBottomNav({
    super.key,
    required this.items,
    required this.selectedIndex,
    this.overflowItem,
  }) : assert(
          items.length <= 5,
          'Maksimum lima tujuan; sisanya lewat overflowItem',
        );

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(top: BorderSide(color: colors.borderDefault)),
      ),
      // Menjaga bilah tetap di atas area gestur sistem di bagian bawah layar.
      // Tanpa ini, tujuan paling bawah bertabrakan dengan batang navigasi
      // Android dan indikator home iOS.
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            for (final (index, item) in items.indexed)
              Expanded(
                child: _NavTile(
                  item: item,
                  isSelected: index == selectedIndex,
                ),
              ),
            if (overflowItem != null)
              Expanded(
                child: _NavTile(
                  item: overflowItem!,
                  isSelected: false,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _NavTile extends StatelessWidget {
  final AppNavItem item;
  final bool isSelected;

  const _NavTile({required this.item, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final density = context.space;

    final foreground = isSelected ? colors.accent : colors.textSecondary;
    final accent = item.domainColor ?? colors.accent;

    final icon = Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(item.icon, size: 22, color: foreground),
        if (item.badgeCount != null && item.badgeCount! > 0)
          Positioned(
            top: -4,
            right: -8,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: density.xs),
              constraints: const BoxConstraints(minWidth: 16),
              decoration: BoxDecoration(
                color: colors.syncPending.bg,
                borderRadius: AppRadius.rPill,
                border: Border.all(color: colors.syncPending.border),
              ),
              child: Text(
                // Angka besar merusak lebar tujuan. Yang penting "banyak",
                // bukan berapa persisnya — angka pastinya ada di halamannya.
                item.badgeCount! > 99 ? '99+' : '${item.badgeCount}',
                textAlign: TextAlign.center,
                style: context.text.badge.copyWith(
                  color: colors.syncPending.fg,
                  fontSize: 10,
                  height: 1.2,
                ),
              ),
            ),
          ),
      ],
    );

    return Semantics(
      button: true,
      selected: isSelected,
      label: item.label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: item.onTap,
          child: SizedBox(
            // Setinggi area sentuh minimum ditambah ruang label. Navigasi
            // utama tidak pernah ikut mengecil bersama kerapatan.
            height: density.minTouchTarget + 14,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Strip aksen di atas tujuan aktif, sejajar dengan strip kiri
                // pada sidebar — bahasa penandanya sama, arahnya saja berbeda.
                Container(
                  height: 2,
                  width: 24,
                  color: isSelected ? accent : Colors.transparent,
                ),
                SizedBox(height: density.xs),
                icon,
                SizedBox(height: density.xs),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: density.xs),
                  child: Text(
                    item.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: context.text.badge.copyWith(
                      color: foreground,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
