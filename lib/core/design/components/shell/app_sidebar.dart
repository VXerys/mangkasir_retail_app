import 'package:flutter/material.dart';

import '../../design.dart';

/// Satu tujuan navigasi utama.
///
/// Dipakai bersama oleh [AppSidebar] dan `AppBottomNav`. Keduanya menampilkan
/// daftar tujuan yang sama dengan bentuk berbeda menurut ruang yang tersedia,
/// jadi memberi masing-masing model sendiri hanya membuka peluang keduanya
/// menyimpang — sidebar punya lencana, bilah bawah lupa.
@immutable
class AppNavItem {
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

  /// Apakah tujuan ini yang sedang dibuka.
  ///
  /// Melekat pada item, bukan disimpulkan dari indeks. Sejak sidebar
  /// dikelompokkan per area, "indeks ke-3" tidak lagi menunjuk apa pun yang
  /// pasti — nomor yang sama berarti tujuan berbeda tergantung berapa area yang
  /// terlihat oleh peran yang sedang masuk.
  final bool isSelected;

  const AppNavItem({
    required this.label,
    required this.icon,
    required this.onTap,
    this.domainColor,
    this.badgeCount,
    this.isSelected = false,
  });

  AppNavItem copyWith({bool? isSelected}) => AppNavItem(
        label: label,
        icon: icon,
        onTap: onTap,
        domainColor: domainColor,
        badgeCount: badgeCount,
        isSelected: isSelected ?? this.isSelected,
      );
}

/// Sekelompok tujuan di bawah satu judul area.
///
/// Ada karena tabel rute penuh membawa delapan area dan lebih dari empat puluh
/// tujuan. Daftar rata sepanjang itu tidak bisa dipindai mata — dan pada mode
/// rail, yang hanya menampilkan ikon, empat puluh ikon tanpa pengelompokan
/// tidak berarti apa-apa.
@immutable
class AppNavSection {
  /// Judul kelompok. Null berarti kelompok tanpa judul: satu section tanpa
  /// judul memulihkan persis perilaku daftar rata.
  final String? label;

  /// Ikon yang mewakili kelompok pada mode rail.
  final IconData? icon;

  /// Aksen domain kelompok, dipakai sebagai strip penanda.
  final Color? accentColor;

  final List<AppNavItem> items;

  /// Apakah kelompok ini sedang memuat tujuan yang aktif.
  final bool isSelected;

  /// Ditekan pada mode rail, tempat butir-butirnya tidak terlihat.
  final VoidCallback? onTap;

  const AppNavSection({
    required this.items,
    this.label,
    this.icon,
    this.accentColor,
    this.isSelected = false,
    this.onTap,
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
  /// Kelompok tujuan. Satu section tanpa judul menghasilkan daftar rata.
  final List<AppNavSection> sections;

  final AppSidebarMode mode;

  /// Widget merek di bagian atas, misalnya logo beserta nama outlet.
  final Widget? header;

  /// Widget di bagian bawah, misalnya status sync dan menu akun.
  final Widget? footer;

  const AppSidebar({
    super.key,
    required this.sections,
    required this.mode,
    this.header,
    this.footer,
  });

  /// Sidebar berisi satu daftar rata tanpa pengelompokan.
  ///
  /// Dipakai galeri dan layar yang tujuannya sedikit.
  factory AppSidebar.flat({
    Key? key,
    required List<AppNavItem> items,
    required int selectedIndex,
    required AppSidebarMode mode,
    Widget? header,
    Widget? footer,
  }) {
    return AppSidebar(
      key: key,
      mode: mode,
      header: header,
      footer: footer,
      sections: [
        AppNavSection(
          items: [
            for (final (index, item) in items.indexed)
              item.copyWith(isSelected: index == selectedIndex),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final density = context.space;
    final isRail = mode == AppSidebarMode.rail;

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
                horizontal: isRail ? density.xs : density.md,
                vertical: density.md,
              ),
              child: header,
            ),
            AppDivider(color: colors.borderSubtle),
          ],
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(
                horizontal: density.xs,
                vertical: density.sm,
              ),
              children: [
                for (final section in sections)
                  // Pada mode rail sebuah kelompok menyusut menjadi satu ikon
                  // areanya. Menampilkan seluruh isinya di kolom selebar 56 px
                  // menghasilkan tumpukan ikon tanpa arti — dan menyembunyikan
                  // judulnya, satu-satunya hal yang menjelaskannya.
                  if (isRail)
                    _RailAreaTile(section: section)
                  else
                    _SidebarSection(section: section, mode: mode),
              ],
            ),
          ),
          if (footer != null) ...[
            AppDivider(color: colors.borderSubtle),
            Padding(
              padding: EdgeInsets.all(isRail ? density.xs : density.md),
              child: footer,
            ),
          ],
        ],
      ),
    );
  }
}

/// Satu kelompok berlabel beserta isinya.
class _SidebarSection extends StatelessWidget {
  final AppNavSection section;
  final AppSidebarMode mode;

  const _SidebarSection({required this.section, required this.mode});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final density = context.space;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (section.label != null)
          Padding(
            padding: EdgeInsets.fromLTRB(
              density.sm,
              density.sm,
              density.sm,
              density.xs,
            ),
            child: Row(
              children: [
                if (section.icon != null) ...[
                  Icon(
                    section.icon,
                    size: 14,
                    color: section.accentColor ?? colors.textTertiary,
                  ),
                  SizedBox(width: density.xs),
                ],
                Expanded(
                  child: Text(
                    section.label!.toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.text.badge.copyWith(
                      color: colors.textTertiary,
                      letterSpacing: 0.6,
                    ),
                  ),
                ),
              ],
            ),
          ),
        for (final item in section.items)
          _SidebarTile(
            item: item,
            isSelected: item.isSelected,
            mode: mode,
          ),
        SizedBox(height: density.xs),
      ],
    );
  }
}

/// Kelompok yang menyusut menjadi satu ikon pada mode rail.
class _RailAreaTile extends StatelessWidget {
  final AppNavSection section;

  const _RailAreaTile({required this.section});

  @override
  Widget build(BuildContext context) {
    return _SidebarTile(
      item: AppNavItem(
        label: section.label ?? '',
        icon: section.icon ?? AppIcons.more,
        onTap: section.onTap ?? () {},
        domainColor: section.accentColor,
        isSelected: section.isSelected,
      ),
      isSelected: section.isSelected,
      mode: AppSidebarMode.rail,
    );
  }
}

class _SidebarTile extends StatelessWidget {
  final AppNavItem item;
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
        ? AppTooltip(message: item.label, preferBelow: false, child: spaced)
        : spaced;
  }
}
