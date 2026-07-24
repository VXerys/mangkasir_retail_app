import 'package:flutter/material.dart';

import '../../design.dart';

/// Seberapa penting sebuah kolom ketika ruang menyempit.
///
/// Ini bukan sekadar urutan menyembunyikan kolom. Pada layar `compact`
/// [AppDataTable] berhenti menjadi tabel dan menjadi daftar kartu, dan
/// prioritas inilah yang menentukan bagian mana dari sebuah baris menjadi
/// judul dan bagian mana menjadi keterangan.
enum ColumnPriority {
  /// Identitas baris: nama produk, nomor transaksi. Menjadi judul kartu.
  ///
  /// Harus ada tepat satu per tabel. Bila ada beberapa, yang pertama dipakai.
  primary,

  /// Angka dan status yang menentukan keputusan: harga, stok, tanggal.
  /// Menjadi baris keterangan di dalam kartu.
  secondary,

  /// Pelengkap yang hanya berguna saat layar lebar. Hilang pada kartu.
  detail,
}

/// Perataan isi sel.
enum ColumnAlign { start, center, end }

/// Definisi satu kolom [AppDataTable].
///
/// Lebarnya ditentukan dengan salah satu dari dua cara: [width] tetap untuk
/// kolom yang isinya berukuran tetap (status, aksi, tanggal), atau [flex] untuk
/// kolom yang harus memakan sisa ruang (nama produk). Mencampur keduanya
/// disengaja — tabel POS hampir selalu berupa satu kolom nama yang melar
/// diapit kolom-kolom angka yang lebarnya bisa diprediksi.
@immutable
class AppColumn<T> {
  /// Pengenal kolom. Dipakai sebagai kunci pengurutan, bukan untuk ditampilkan.
  final String id;

  /// Label pada header, dan label keterangan saat baris menjadi kartu.
  final String label;

  /// Menggambar isi sel untuk satu baris.
  final Widget Function(BuildContext context, T row) cell;

  /// Lebar tetap dalam piksel. Bila diisi, [flex] diabaikan.
  final double? width;

  /// Bagian dari sisa ruang yang diambil kolom ini.
  final int flex;

  /// Perataan isi. Bila null, kolom [numeric] rata kanan dan sisanya rata kiri.
  final ColumnAlign? align;

  /// Kolom berisi angka. Memakai gaya `tableCellNumeric` dan rata kanan.
  ///
  /// Bukan urusan selera: angka yang rata kiri membuat satuan, ribuan, dan
  /// jutaan berada di kolom optis yang berbeda, sehingga besar-kecilnya tidak
  /// bisa dibandingkan sekilas.
  final bool numeric;

  /// Header kolom bisa ditekan untuk mengurutkan.
  final bool sortable;

  final ColumnPriority priority;

  const AppColumn({
    required this.id,
    required this.label,
    required this.cell,
    this.width,
    this.flex = 1,
    this.align,
    this.numeric = false,
    this.sortable = false,
    this.priority = ColumnPriority.secondary,
  });

  /// Kolom teks biasa.
  ///
  /// ```dart
  /// AppColumn.text(
  ///   id: 'name',
  ///   label: 'Nama produk',
  ///   value: (product) => product.name,
  ///   priority: ColumnPriority.primary,
  ///   sortable: true,
  /// )
  /// ```
  factory AppColumn.text({
    required String id,
    required String label,
    required String Function(T row) value,
    double? width,
    int flex = 1,
    ColumnAlign? align,
    bool sortable = false,
    ColumnPriority priority = ColumnPriority.secondary,

    /// Menonjolkan teks. Untuk kolom identitas.
    bool emphasis = false,
  }) {
    return AppColumn<T>(
      id: id,
      label: label,
      width: width,
      flex: flex,
      align: align,
      sortable: sortable,
      priority: priority,
      cell: (context, row) => _CellText(
        value(row),
        emphasis: emphasis,
        numeric: false,
      ),
    );
  }

  /// Kolom angka yang sudah diformat oleh pemanggil.
  ///
  /// Pemformatan tetap menjadi urusan pemanggil ([CurrencyFormatter],
  /// [NumberFormatter]) karena kolom tidak tahu apakah isinya rupiah, cacah,
  /// atau persen — dan menebaknya akan salah tepat di tempat yang paling
  /// merugikan.
  factory AppColumn.number({
    required String id,
    required String label,
    required String Function(T row) value,
    double? width,
    int flex = 1,
    bool sortable = false,
    ColumnPriority priority = ColumnPriority.secondary,
  }) {
    return AppColumn<T>(
      id: id,
      label: label,
      width: width,
      flex: flex,
      numeric: true,
      sortable: sortable,
      priority: priority,
      cell: (context, row) => _CellText(value(row), numeric: true),
    );
  }

  /// Perataan yang benar-benar dipakai setelah aturan bawaan diterapkan.
  ColumnAlign get effectiveAlign =>
      align ?? (numeric ? ColumnAlign.end : ColumnAlign.start);

  Alignment get alignment => switch (effectiveAlign) {
        ColumnAlign.start => Alignment.centerLeft,
        ColumnAlign.center => Alignment.center,
        ColumnAlign.end => Alignment.centerRight,
      };

  TextAlign get textAlign => switch (effectiveAlign) {
        ColumnAlign.start => TextAlign.left,
        ColumnAlign.center => TextAlign.center,
        ColumnAlign.end => TextAlign.right,
      };
}

/// Teks sel dengan gaya yang sudah sesuai peran kolomnya.
class _CellText extends StatelessWidget {
  final String value;
  final bool emphasis;
  final bool numeric;

  const _CellText(this.value, {this.emphasis = false, this.numeric = false});

  @override
  Widget build(BuildContext context) {
    final typography = context.text;

    return Text(
      value,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: numeric
          ? typography.tableCellNumeric
          : emphasis
              ? typography.tableCellEmphasis
              : typography.tableCell,
    );
  }
}
