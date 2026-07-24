import 'package:flutter/material.dart';

import '../../design.dart';

/// Satu ruas jejak navigasi.
@immutable
class AppBreadcrumbItem {
  final String label;

  /// Null berarti ruas ini tidak bisa ditekan — selalu berlaku untuk ruas
  /// terakhir, karena halaman yang sedang dibuka bukan tujuan ke mana pun.
  final VoidCallback? onTap;

  const AppBreadcrumbItem({required this.label, this.onTap});
}

/// Jejak navigasi untuk halaman level 2 ke atas.
///
/// Diminta `13_Information_Architecture.md` §Breadcrumb Strategy. Pada aplikasi
/// dengan delapan area dan lebih dari empat puluh layar, tanpa jejak ini
/// pengguna kehilangan tahu di mana ia berada begitu tiba lewat tautan dalam
/// atau notifikasi.
///
/// Di layar sempit ruas tengah diciutkan menjadi satu tombol `…` yang bisa
/// ditekan. Yang **tidak** pernah hilang adalah ruas pertama dan terakhir:
/// asal dan posisi sekarang. Membuang keduanya demi ruang berarti membuang
/// justru dua hal yang membuat breadcrumb ada.
class AppBreadcrumb extends StatelessWidget {
  final List<AppBreadcrumbItem> items;

  /// Jumlah ruas sebelum jejak diciutkan.
  final int maxVisible;

  const AppBreadcrumb({
    super.key,
    required this.items,
    this.maxVisible = 3,
  });

  @override
  Widget build(BuildContext context) {
    // Satu ruas bukan jejak, ia cuma judul. Halaman level 1 tidak mendapat
    // breadcrumb sama sekali, sesuai dokumen IA.
    if (items.length < 2) return const SizedBox.shrink();

    final visible = _collapse(context);

    return Semantics(
      container: true,
      label: 'Jejak navigasi',
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final (index, entry) in visible.indexed) ...[
            if (index > 0) _Separator(),
            entry,
          ],
        ],
      ),
    );
  }

  List<Widget> _collapse(BuildContext context) {
    final needsCollapse = items.length > maxVisible &&
        context.windowSize == WindowSize.compact;

    if (!needsCollapse) {
      return [
        for (final (index, item) in items.indexed)
          _Crumb(item: item, isLast: index == items.length - 1),
      ];
    }

    final hidden = items.sublist(1, items.length - 1);

    return [
      _Crumb(item: items.first, isLast: false),
      _Overflow(items: hidden),
      _Crumb(item: items.last, isLast: true),
    ];
  }
}

class _Crumb extends StatelessWidget {
  final AppBreadcrumbItem item;
  final bool isLast;

  const _Crumb({required this.item, required this.isLast});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final style = context.text.toolbarLabel.copyWith(
      color: isLast ? colors.textPrimary : colors.textSecondary,
      fontWeight: isLast ? FontWeight.w600 : FontWeight.w500,
    );

    final label = Text(
      item.label,
      style: style,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );

    // Ruas terakhir tidak pernah bisa ditekan, bahkan bila pemanggil terlanjur
    // memberinya aksi: menavigasi ke halaman yang sedang dibuka adalah
    // penekanan yang tidak melakukan apa-apa, dan pengguna membacanya sebagai
    // aplikasi yang macet.
    if (isLast || item.onTap == null) {
      return Flexible(child: label);
    }

    return Flexible(
      child: Material(
        color: Colors.transparent,
        borderRadius: AppRadius.rXs,
        child: InkWell(
          onTap: item.onTap,
          borderRadius: AppRadius.rXs,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.space.xs,
              vertical: context.space.xs,
            ),
            child: label,
          ),
        ),
      ),
    );
  }
}

class _Separator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.space.xs),
      child: Icon(
        AppIcons.forward,
        size: 14,
        color: context.colors.textTertiary,
      ),
    );
  }
}

/// Ruas tengah yang diciutkan, dibuka sebagai menu.
class _Overflow extends StatelessWidget {
  final List<AppBreadcrumbItem> items;

  const _Overflow({required this.items});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return AppTooltip(
      message: items.map((item) => item.label).join(' › '),
      child: Material(
        color: Colors.transparent,
        borderRadius: AppRadius.rXs,
        child: InkWell(
          borderRadius: AppRadius.rXs,
          onTap: () => _showMenu(context),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: context.space.xs),
            child: Text(
              '…',
              style: context.text.toolbarLabel.copyWith(
                color: colors.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showMenu(BuildContext context) async {
    final selected = await showAppDrawer<AppBreadcrumbItem>(
      context: context,
      builder: (drawerContext) => AppDrawer(
        title: 'Jejak navigasi',
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final item in items)
              _OverflowTile(
                item: item,
                onSelected: () => Navigator.of(drawerContext).pop(item),
              ),
          ],
        ),
      ),
    );

    selected?.onTap?.call();
  }
}

class _OverflowTile extends StatelessWidget {
  final AppBreadcrumbItem item;
  final VoidCallback onSelected;

  const _OverflowTile({required this.item, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    final density = context.space;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onSelected,
        child: SizedBox(
          height: density.minTouchTarget,
          child: Row(
            children: [
              SizedBox(width: density.md),
              Expanded(
                child: Text(
                  item.label,
                  style: context.text.toolbarLabel.copyWith(
                    color: context.colors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
