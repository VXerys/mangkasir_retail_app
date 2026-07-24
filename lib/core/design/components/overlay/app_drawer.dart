import 'package:flutter/material.dart';

import '../../design.dart';

/// Panel yang menggeser masuk dari tepi layar.
///
/// Dipakai untuk isi yang terlalu panjang bagi sebuah dialog tetapi tidak layak
/// mendapat halaman sendiri: filter lanjutan, detail cepat sebuah baris tabel,
/// riwayat pergerakan stok.
///
/// Bedanya dengan [AppDialog] bukan sekadar arah masuk. Dialog memotong alur
/// kerja dan menuntut jawaban; laci mendampingi alur kerja dan boleh diabaikan.
/// Karena itu laci memakai lebar tetap `density.inspectorWidth` — sama dengan
/// panel inspector pada `AppShell` — supaya terasa sebagai perpanjangan
/// workspace, bukan lapisan asing.
///
/// Buka lewat [showAppDrawer].
class AppDrawer extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget content;

  /// Bilah aksi yang menempel di kaki laci. Tidak ikut tergulir.
  final List<Widget> actions;

  const AppDrawer({
    super.key,
    required this.title,
    required this.content,
    this.subtitle,
    this.actions = const [],
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final density = context.space;
    final typography = context.text;
    final isCompact = context.windowSize == WindowSize.compact;

    final radius = isCompact
        ? const BorderRadius.vertical(top: Radius.circular(AppRadius.lg))
        : const BorderRadius.horizontal(left: Radius.circular(AppRadius.lg));

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: radius,
        border: Border.all(color: colors.borderDefault),
        boxShadow: context.elevation.dialog,
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: SafeArea(
          top: !isCompact,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: density.lg,
                  vertical: density.md,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(title, style: typography.dialogTitle),
                          if (subtitle != null) ...[
                            SizedBox(height: density.xs),
                            Text(
                              subtitle!,
                              style: typography.formHelper
                                  .copyWith(color: colors.textSecondary),
                            ),
                          ],
                        ],
                      ),
                    ),
                    SizedBox(width: density.sm),
                    AppIconButton(
                      icon: AppIcons.close,
                      tooltip: 'Tutup',
                      size: AppButtonSize.small,
                      onPressed: () => Navigator.of(context).maybePop(),
                    ),
                  ],
                ),
              ),
              AppDivider(color: colors.borderSubtle),
              Flexible(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(density.lg),
                  child: content,
                ),
              ),
              if (actions.isNotEmpty) ...[
                AppDivider(color: colors.borderSubtle),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: density.lg,
                    vertical: density.md,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      for (final (index, action) in actions.indexed) ...[
                        if (index > 0) SizedBox(width: density.sm),
                        action,
                      ],
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Membuka [builder] sebagai laci.
///
/// Masuk dari kanan pada layar `medium` ke atas dan dari bawah pada layar
/// `compact`. Tingginya dibatasi 88% layar pada mode bawah, menyisakan sedikit
/// kanvas yang terlihat sebagai penanda bahwa halaman di belakang masih ada.
Future<T?> showAppDrawer<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool barrierDismissible = true,
}) {
  final colors = context.colors;
  final isCompact = context.windowSize == WindowSize.compact;
  final density = DensityScope.of(context);

  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: colors.overlay,
    transitionDuration: AppMotion.deliberate,
    pageBuilder: (drawerContext, _, _) {
      final child = Builder(builder: builder);
      final media = MediaQuery.sizeOf(drawerContext);

      if (isCompact) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: media.height * 0.88),
            child: child,
          ),
        );
      }

      return Align(
        alignment: Alignment.centerRight,
        child: SizedBox(
          width: density.inspectorWidth,
          height: double.infinity,
          child: child,
        ),
      );
    },
    transitionBuilder: (context, animation, _, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: AppMotion.emphasized,
        reverseCurve: AppMotion.emphasized.flipped,
      );

      return SlideTransition(
        position: Tween(
          begin: isCompact ? const Offset(0, 1) : const Offset(1, 0),
          end: Offset.zero,
        ).animate(curved),
        child: child,
      );
    },
  );
}
