import 'package:flutter/material.dart';

import '../../../utils/number_formatter.dart';
import '../../design.dart';

/// Bilah navigasi halaman di kaki [AppDataTable].
///
/// Ukuran halaman bawaan 25 dan pilihannya 25/50/100, mengikuti 16.3 yang
/// menolak 10 baris per halaman: kasir dan pemilik toko memindai daftar, dan
/// daftar yang terpotong tiap sepuluh baris memaksa mereka menghitung halaman
/// alih-alih membaca data.
///
/// Nomor halaman satu per satu sengaja tidak ditampilkan. Pada 340 baris itu
/// berarti 14 tombol yang semuanya tidak berarti apa-apa — yang dibutuhkan
/// hanyalah maju, mundur, dan tahu sedang berada di mana.
class AppPagination extends StatelessWidget {
  /// Halaman aktif, dihitung mulai dari 1.
  final int page;

  final int pageSize;
  final int totalRows;

  final ValueChanged<int>? onPageChanged;
  final ValueChanged<int>? onPageSizeChanged;

  final List<int> pageSizeOptions;

  const AppPagination({
    super.key,
    required this.page,
    required this.pageSize,
    required this.totalRows,
    required this.onPageChanged,
    this.onPageSizeChanged,
    this.pageSizeOptions = const [25, 50, 100],
  });

  int get _totalPages => totalRows == 0 ? 1 : (totalRows / pageSize).ceil();

  int get _firstRow => totalRows == 0 ? 0 : (page - 1) * pageSize + 1;

  int get _lastRow {
    final last = page * pageSize;
    return last > totalRows ? totalRows : last;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final density = context.space;
    final isCompact = context.windowSize == WindowSize.compact;

    final canGoBack = page > 1 && onPageChanged != null;
    final canGoForward = page < _totalPages && onPageChanged != null;

    final range = Text(
      totalRows == 0
          ? 'Tidak ada data'
          : '${NumberFormatter.count(_firstRow)}–${NumberFormatter.count(_lastRow)} '
              'dari ${NumberFormatter.count(totalRows)}',
      style: context.text.formHelper.copyWith(color: colors.textSecondary),
    );

    final navigation = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppIconButton(
          icon: AppIcons.back,
          tooltip: 'Halaman sebelumnya',
          size: AppButtonSize.small,
          onPressed: canGoBack ? () => onPageChanged!(page - 1) : null,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: density.sm),
          child: Text(
            '$page / $_totalPages',
            style: context.text.tableCellNumeric
                .copyWith(color: colors.textSecondary),
          ),
        ),
        AppIconButton(
          icon: AppIcons.forward,
          tooltip: 'Halaman berikutnya',
          size: AppButtonSize.small,
          onPressed: canGoForward ? () => onPageChanged!(page + 1) : null,
        ),
      ],
    );

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: density.md,
        vertical: density.xs,
      ),
      child: Row(
        children: [
          Flexible(child: range),
          const Spacer(),
          // Pemilih ukuran halaman hilang di layar sempit: di ponsel jarang ada
          // yang ingin memuat 100 baris sekaligus, dan ruangnya lebih berguna
          // untuk keterangan jangkauan.
          if (!isCompact && onPageSizeChanged != null) ...[
            Text(
              'Baris',
              style:
                  context.text.formHelper.copyWith(color: colors.textTertiary),
            ),
            SizedBox(width: density.sm),
            SizedBox(
              width: 92,
              child: AppSelect<int>(
                value: pageSize,
                onChanged: onPageSizeChanged,
                options: [
                  for (final size in pageSizeOptions)
                    AppSelectOption(value: size, label: '$size'),
                ],
              ),
            ),
            SizedBox(width: density.lg),
          ],
          navigation,
        ],
      ),
    );
  }
}
