import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangkasir_retail_app/core/design/design.dart';

class _Product {
  final String id;
  final String name;
  final String sku;
  final int stock;

  const _Product(this.id, this.name, this.sku, this.stock);
}

List<_Product> _products(int count) => [
      for (var i = 1; i <= count; i++)
        _Product('p$i', 'Produk $i', 'SKU-$i', i * 3),
    ];

final _columns = <AppColumn<_Product>>[
  AppColumn.text(
    id: 'name',
    label: 'Nama',
    value: (row) => row.name,
    priority: ColumnPriority.primary,
    sortable: true,
    emphasis: true,
    flex: 3,
  ),
  AppColumn.number(
    id: 'stock',
    label: 'Stok',
    value: (row) => '${row.stock}',
    priority: ColumnPriority.secondary,
    sortable: true,
    width: 100,
  ),
  AppColumn.text(
    id: 'sku',
    label: 'SKU',
    value: (row) => row.sku,
    priority: ColumnPriority.detail,
    width: 120,
  ),
];

Future<void> _pump(
  WidgetTester tester,
  Widget table, {
  required Size surface,
}) async {
  tester.view.physicalSize = surface;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      home: Scaffold(body: table),
    ),
  );
}

/// Ukuran jendela `large` — tabel penuh, kerapatan compact.
const _wide = Size(1600, 900);

/// Ukuran jendela `compact` — jalur kartu.
const _narrow = Size(400, 800);

void main() {
  group('AppDataTable — jalur lebar', () {
    testWidgets('merender header dan seluruh baris yang terlihat',
        (tester) async {
      await _pump(
        tester,
        AppDataTable<_Product>(
          rows: _products(30),
          columns: _columns,
          rowId: (row) => row.id,
        ),
        surface: _wide,
      );

      expect(find.text('Nama'), findsOneWidget);
      expect(find.text('Stok'), findsOneWidget);
      expect(find.text('SKU'), findsOneWidget);

      // Baris pertama terlihat; yang jauh di bawah belum dibangun karena
      // ListView.builder hanya membangun yang masuk layar.
      expect(find.text('Produk 1'), findsOneWidget);
      expect(find.text('SKU-1'), findsOneWidget);
    });

    testWidgets('melaporkan pengurutan alih-alih mengurutkan sendiri',
        (tester) async {
      final reported = <AppSortState>[];
      final rows = _products(5);

      await _pump(
        tester,
        AppDataTable<_Product>(
          rows: rows,
          columns: _columns,
          rowId: (row) => row.id,
          sort: const AppSortState('name'),
          onSortChanged: reported.add,
        ),
        surface: _wide,
      );

      // Kolom yang sedang aktif: menekannya membalik arah.
      await tester.tap(find.text('Nama'));
      await tester.pump();
      expect(reported.last, const AppSortState('name', ascending: false));

      // Kolom lain selalu mulai menaik.
      await tester.tap(find.text('Stok'));
      await tester.pump();
      expect(reported.last, const AppSortState('stock'));

      // Urutan data di layar tidak berubah — itu tugas pemanggil.
      expect(rows.first.name, 'Produk 1');
    });

    testWidgets('kotak centang header memilih dan mengosongkan semuanya',
        (tester) async {
      var selected = <Object>{};

      await _pump(
        tester,
        StatefulBuilder(
          builder: (context, setState) => AppDataTable<_Product>(
            rows: _products(4),
            columns: _columns,
            rowId: (row) => row.id,
            selectedIds: selected,
            onSelectionChanged: (next) => setState(() => selected = next),
          ),
        ),
        surface: _wide,
      );

      await tester.tap(find.byType(AppCheckbox).first);
      await tester.pump();
      expect(selected, {'p1', 'p2', 'p3', 'p4'});

      await tester.tap(find.byType(AppCheckbox).first);
      await tester.pump();
      expect(selected, isEmpty);
    });

    testWidgets('memilih satu baris tidak ikut memilih yang lain',
        (tester) async {
      var selected = <Object>{};

      await _pump(
        tester,
        StatefulBuilder(
          builder: (context, setState) => AppDataTable<_Product>(
            rows: _products(4),
            columns: _columns,
            rowId: (row) => row.id,
            selectedIds: selected,
            onSelectionChanged: (next) => setState(() => selected = next),
          ),
        ),
        surface: _wide,
      );

      // Indeks 0 adalah kotak centang header, jadi baris pertama ada di 1.
      await tester.tap(find.byType(AppCheckbox).at(1));
      await tester.pump();

      expect(selected, {'p1'});
    });

    testWidgets('ketukan baris melaporkan barisnya', (tester) async {
      _Product? tapped;

      await _pump(
        tester,
        AppDataTable<_Product>(
          rows: _products(5),
          columns: _columns,
          rowId: (row) => row.id,
          onRowTap: (row) => tapped = row,
        ),
        surface: _wide,
      );

      await tester.tap(find.text('Produk 2'));
      await tester.pump();

      expect(tapped?.id, 'p2');
    });
  });

  group('AppDataTable — keadaan', () {
    testWidgets('kosong menampilkan AppEmptyState, bukan tabel kosong',
        (tester) async {
      await _pump(
        tester,
        AppDataTable<_Product>(
          rows: const [],
          columns: _columns,
          rowId: (row) => row.id,
          emptyTitle: 'Belum ada produk',
          emptyMessage: 'Tambahkan produk pertama Anda.',
        ),
        surface: _wide,
      );

      expect(find.byType(AppEmptyState), findsOneWidget);
      expect(find.text('Belum ada produk'), findsOneWidget);
      // Header kolom ikut hilang: header di atas ruang kosong terbaca sebagai
      // tabel yang gagal memuat.
      expect(find.text('Nama'), findsNothing);
    });

    testWidgets('galat menampilkan AppErrorView dengan tombol coba lagi',
        (tester) async {
      var retried = false;

      await _pump(
        tester,
        AppDataTable<_Product>(
          rows: _products(5),
          columns: _columns,
          rowId: (row) => row.id,
          error: 'Gagal memuat produk.',
          onRetry: () => retried = true,
        ),
        surface: _wide,
      );

      expect(find.byType(AppErrorView), findsOneWidget);
      // Galat mengalahkan data yang kebetulan masih tersimpan.
      expect(find.text('Produk 1'), findsNothing);

      await tester.tap(find.text('Coba lagi'));
      expect(retried, isTrue);
    });

    testWidgets('memuat menampilkan baris rangka', (tester) async {
      await _pump(
        tester,
        AppDataTable<_Product>(
          rows: const [],
          columns: _columns,
          rowId: (row) => row.id,
          isLoading: true,
        ),
        surface: _wide,
      );

      expect(find.byType(AppSkeleton), findsWidgets);
      // Memuat mengalahkan keadaan kosong; keduanya sekaligus akan membuat
      // pengguna mengira datanya memang tidak ada.
      expect(find.byType(AppEmptyState), findsNothing);
    });
  });

  group('AppDataTable — jalur kartu', () {
    testWidgets('layar sempit meninggalkan header dan memakai kartu',
        (tester) async {
      await _pump(
        tester,
        AppDataTable<_Product>(
          rows: _products(5),
          columns: _columns,
          rowId: (row) => row.id,
        ),
        surface: _narrow,
      );

      // Tidak ada header kolom pada jalur kartu.
      expect(find.text('SKU'), findsNothing);

      // Kolom primary menjadi judul kartu.
      expect(find.text('Produk 1'), findsOneWidget);

      // Kolom secondary menjadi baris keterangan berlabel…
      expect(find.text('Stok'), findsWidgets);
      expect(find.text('3'), findsOneWidget);

      // …dan kolom detail hilang sama sekali.
      expect(find.text('SKU-1'), findsNothing);
    });
  });

  group('AppPagination', () {
    testWidgets('menghitung jangkauan baris dan jumlah halaman',
        (tester) async {
      await _pump(
        tester,
        const Align(
          child: AppPagination(
            page: 2,
            pageSize: 25,
            totalRows: 340,
            onPageChanged: _noopPage,
          ),
        ),
        surface: _wide,
      );

      expect(find.text('26–50 dari 340'), findsOneWidget);
      expect(find.text('2 / 14'), findsOneWidget);
    });

    testWidgets('halaman terakhir memotong jangkauan pada jumlah sebenarnya',
        (tester) async {
      await _pump(
        tester,
        const Align(
          child: AppPagination(
            page: 14,
            pageSize: 25,
            totalRows: 340,
            onPageChanged: _noopPage,
          ),
        ),
        surface: _wide,
      );

      expect(find.text('326–340 dari 340'), findsOneWidget);
    });

    testWidgets('maju dan mundur melaporkan halaman baru', (tester) async {
      final pages = <int>[];

      await _pump(
        tester,
        Align(
          child: AppPagination(
            page: 3,
            pageSize: 25,
            totalRows: 340,
            onPageChanged: pages.add,
          ),
        ),
        surface: _wide,
      );

      await tester.tap(find.byIcon(AppIcons.back));
      await tester.tap(find.byIcon(AppIcons.forward));

      expect(pages, [2, 4]);
    });

    testWidgets('tanpa data, tombol navigasi mati', (tester) async {
      final pages = <int>[];

      await _pump(
        tester,
        Align(
          child: AppPagination(
            page: 1,
            pageSize: 25,
            totalRows: 0,
            onPageChanged: pages.add,
          ),
        ),
        surface: _wide,
      );

      expect(find.text('Tidak ada data'), findsOneWidget);

      await tester.tap(find.byIcon(AppIcons.back));
      await tester.tap(find.byIcon(AppIcons.forward));

      expect(pages, isEmpty);
    });
  });
}

void _noopPage(int _) {}
