import 'package:flutter/material.dart';

import '../design.dart';

/// Wadah konten dasar: dibatasi garis, bukan bayangan.
///
/// Menggantikan [Card] bawaan Material, yang membawa bayangan, margin, dan
/// warna permukaan bertingkat yang semuanya bertentangan dengan aturan
/// "garis, bukan bayangan" pada design system ini.
///
/// [header] dan [footer] disediakan karena hampir setiap panel POS punya bilah
/// judul dan bilah aksi. Menyediakannya di sini mencegah setiap layar merakit
/// ulang pemisah dan padding yang sama dengan hasil yang sedikit berbeda-beda.
class AppPanel extends StatelessWidget {
  final Widget child;

  /// Bilah judul di atas pemisah.
  final Widget? header;

  /// Bilah aksi di bawah pemisah.
  final Widget? footer;

  /// Padding di sekeliling [child]. Bila null, memakai `space.md`.
  final EdgeInsetsGeometry? padding;

  /// Menghilangkan garis tepi. Untuk panel yang sudah berada di dalam wadah
  /// lain yang bergaris.
  final bool borderless;

  /// Memakai permukaan yang diredam. Untuk panel pendukung seperti ringkasan
  /// total di bawah keranjang.
  final bool subtle;

  const AppPanel({
    super.key,
    required this.child,
    this.header,
    this.footer,
    this.padding,
    this.borderless = false,
    this.subtle = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final density = context.space;
    final resolvedPadding = padding ?? EdgeInsets.all(density.md);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: subtle ? colors.surfaceSubtle : colors.surface,
        borderRadius: AppRadius.rMd,
        border: borderless ? null : Border.all(color: colors.borderDefault),
      ),
      child: ClipRRect(
        borderRadius: AppRadius.rMd,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (header != null) ...[
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: density.md,
                  vertical: density.sm,
                ),
                child: header,
              ),
              AppDivider(color: colors.borderSubtle),
            ],
            Flexible(
              child: Padding(padding: resolvedPadding, child: child),
            ),
            if (footer != null) ...[
              AppDivider(color: colors.borderSubtle),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: density.md,
                  vertical: density.sm,
                ),
                child: footer,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
