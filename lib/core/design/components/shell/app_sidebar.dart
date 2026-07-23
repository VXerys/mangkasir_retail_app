import 'package:flutter/material.dart';

import '../../design.dart';

/// Satu tujuan navigasi pada sidebar.
@immutable
class AppSidebarItem {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  /// Aksen domain untuk item ini (lihat `colors.domainSales` dkk).
  ///
  /// Dipakai sebagai strip penanda saat item terpilih, sehingga kasir mengenali
  /// modul dari warna sebelum sempat membaca labelnya.
  final Color? domainColor;

  /// Angka pada lencana, misalnya jumlah data yang belum tersinkron.
  final int? badgeCount;

  const AppSidebarItem({
    required this.label,
    required this.icon,
    required this.onTap,
    this.domainColor,
    this.badgeCount,
  });
}

/// Bentuk tampilan sidebar, ditentukan oleh ruang yang tersedia.
enum AppSidebarMode {
  /// Ikon beserta label. Untuk layar lebar.
  extended,

  /// Hanya ikon, label muncul sebagai tooltip.
  rail,

  /// Isi laci navigasi pada layar sempit — selalu berlabel, karena laci
  /// memang dibuka dengan sengaja dan ruangnya tidak terbatas.
  drawer,
}

/// Kolom navigasi utama.
///
/// Bukan [NavigationRail] bawaan Material: rail bawaan memaksa tinggi item
/// minimum yang besar dan tidak menyediakan mode berlabel penuh maupun strip
/// aksen per domain.
class AppSidebar extends StatelessWidget {
  final List<AppSidebarItem> items;

  /// Indeks item yang sedang aktif. `-1` berarti tidak ada.
  final int selectedIndex;

  final AppSidebarMode mode;

  /// Widget merek di bagian atas, misalnya logo beserta nama outlet.
  final Widget? header;

  /// Widget di bagian bawah, misalnya status sync dan menu akun.
  final Widget? footer;

  const AppSidebar({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.mode,
    this.header,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final density = context.space;

    final width = switch (mode) {
      AppSidebarMode.extended => density.sidebarExtendedWidth,
      AppSidebarMode.rail => density.sidebarRailWidth,
      AppSidebarMode.drawer => density.sidebarExtendedWidth,
    };

    return Container(
      width: width,
      color: colors.surfaceSubtle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (header != null) ...[
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: mode == AppSidebarMode.rail ? density.xs : density.md,
                vertical: density.md,
              ),
              child: header,
            ),
            AppDivider(color: colors.borderSubtle),
          ],
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(
                horizontal: density.xs,
                vertical: density.sm,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) => _SidebarTile(
                item: items[index],
                isSelected: index == selectedIndex,
                mode: mode,
              ),
            ),
          ),
          if (footer != null) ...[
            AppDivider(color: colors.borderSubtle),
            Padding(
              padding: EdgeInsets.all(
                mode == AppSidebarMode.rail ? density.xs : density.md,
              ),
              child: footer,
            ),
          ],
        ],
      ),
    );
  }
}

class _SidebarTile extends StatelessWidget {
  final AppSidebarItem item;
  final bool isSelected;
  final AppSidebarMode mode;

  const _SidebarTile({
    required this.item,
    required this.isSelected,
    required this.mode,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final density = context.space;
    final isRail = mode == AppSidebarMode.rail;

    final foreground = isSelected ? colors.accent : colors.textSecondary;
    final accent = item.domainColor ?? colors.accent;

    final tile = Material(
      color: isSelected ? colors.accentSubtle : Colors.transparent,
      borderRadius: AppRadius.rSm,
      child: InkWell(
        onTap: item.onTap,
        borderRadius: AppRadius.rSm,
        hoverColor: colors.surfaceHover,
        child: SizedBox(
          // Item navigasi selalu memenuhi area sentuh minimum, apa pun
          // kerapatannya. Salah tekan pada navigasi berarti kehilangan konteks
          // kerja — jauh lebih mahal daripada beberapa piksel yang dihemat.
          height: density.minTouchTarget,
          child: Row(
            children: [
              // Strip aksen domain di tepi kiri item terpilih.
              SizedBox(
                width: 3,
                height: density.minTouchTarget - density.sm,
                child: ColoredBox(
                  color: isSelected ? accent : Colors.transparent,
                ),
              ),
              SizedBox(width: isRail ? density.xs : density.sm),
              Icon(item.icon, size: 18, color: foreground),
              if (!isRail) ...[
                SizedBox(width: density.sm),
                Expanded(
                  child: Text(
                    item.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.text.toolbarLabel.copyWith(
                      color: foreground,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                ),
                if (item.badgeCount != null && item.badgeCount! > 0)
                  AppBadge(
                    label: '${item.badgeCount}',
                    color: colors.syncPending,
                  ),
                SizedBox(width: density.sm),
              ],
            ],
          ),
        ),
      ),
    );

    final spaced = Padding(
      padding: EdgeInsets.only(bottom: density.xs),
      child: tile,
    );

    // Pada mode rail label tidak terlihat, jadi tooltip menjadi satu-satunya
    // cara mengetahui tujuan sebuah ikon.
    return isRail
        ? Tooltip(message: item.label, child: spaced)
        : spaced;
  }
}
