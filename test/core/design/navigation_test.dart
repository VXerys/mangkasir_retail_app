import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangkasir_retail_app/core/design/design.dart';

Future<void> _pump(WidgetTester tester, Widget child) async {
  tester.view.physicalSize = const Size(1600, 900);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      home: Scaffold(body: child),
    ),
  );
}

void main() {
  group('AppTabs', () {
    const tabs = [
      AppTabItem(id: 't1', label: 'Pelanggan 1', count: 3, closable: true),
      AppTabItem(id: 't2', label: 'Pelanggan 2', closable: true),
    ];

    testWidgets('memilih tab melaporkan id, bukan indeks', (tester) async {
      String? selected;

      await _pump(
        tester,
        AppTabs(
          tabs: tabs,
          selectedId: 't1',
          onSelected: (id) => selected = id,
        ),
      );

      await tester.tap(find.text('Pelanggan 2'));
      expect(selected, 't2');
    });

    testWidgets('tombol tutup melaporkan tab yang ditutup', (tester) async {
      String? closed;

      await _pump(
        tester,
        AppTabs(
          tabs: tabs,
          selectedId: 't1',
          onSelected: (_) {},
          onClosed: (id) => closed = id,
        ),
      );

      await tester.tap(find.byIcon(AppIcons.close).first);
      expect(closed, 't1');
    });

    testWidgets('tanpa onClosed, tombol tutup tidak muncul', (tester) async {
      await _pump(
        tester,
        AppTabs(
          tabs: tabs,
          selectedId: 't1',
          onSelected: (_) {},
        ),
      );

      expect(find.byIcon(AppIcons.close), findsNothing);
    });

    testWidgets('tombol tambah hanya muncul bila onAdd diisi', (tester) async {
      var added = false;

      await _pump(
        tester,
        AppTabs(
          tabs: tabs,
          selectedId: 't1',
          onSelected: (_) {},
          onAdd: () => added = true,
        ),
      );

      await tester.tap(find.byIcon(AppIcons.add));
      expect(added, isTrue);
    });

    testWidgets('menampilkan angka penghitung', (tester) async {
      await _pump(
        tester,
        AppTabs(
          tabs: tabs,
          selectedId: 't1',
          onSelected: (_) {},
        ),
      );

      expect(find.text('3'), findsOneWidget);
    });
  });

  group('AppFilterChip', () {
    testWidgets('ketukan melaporkan, dan tombol hapus terpisah dari ketukan',
        (tester) async {
      var tapped = false;
      var removed = false;

      await _pump(
        tester,
        Align(
          child: AppFilterChip(
            label: 'Minuman',
            selected: true,
            onTap: () => tapped = true,
            onRemove: () => removed = true,
          ),
        ),
      );

      await tester.tap(find.byIcon(AppIcons.close));
      expect(removed, isTrue);
      // Tombol hapus tidak boleh ikut membalik keadaan chip.
      expect(tapped, isFalse);
    });

    testWidgets('tombol hapus tersembunyi saat chip mati', (tester) async {
      await _pump(
        tester,
        Align(
          child: AppFilterChip(
            label: 'Minuman',
            selected: false,
            onTap: () {},
            onRemove: () {},
          ),
        ),
      );

      expect(find.byIcon(AppIcons.close), findsNothing);
    });
  });

  group('AppFilterBar', () {
    testWidgets('tombol bersihkan muncul hanya saat ada filter aktif',
        (tester) async {
      await _pump(
        tester,
        AppFilterBar(
          chips: const [],
          activeCount: 0,
          onClear: () {},
          onAdvanced: () {},
        ),
      );

      expect(find.text('Bersihkan'), findsNothing);
      expect(find.text('Filter'), findsOneWidget);

      await _pump(
        tester,
        AppFilterBar(
          chips: const [],
          activeCount: 2,
          onClear: () {},
          onAdvanced: () {},
        ),
      );

      expect(find.text('Bersihkan'), findsOneWidget);
      // Jumlah filter aktif ikut tampil supaya filter yang tersembunyi di laci
      // tidak terlupakan.
      expect(find.text('Filter (2)'), findsOneWidget);
    });
  });

  group('AppSearchField', () {
    testWidgets('menunda pelaporan sampai pengetikan berhenti', (tester) async {
      final reported = <String>[];

      await _pump(
        tester,
        AppSearchField(
          onChanged: reported.add,
          debounce: const Duration(milliseconds: 300),
        ),
      );

      await tester.enterText(find.byType(TextField), 'ind');
      await tester.pump(const Duration(milliseconds: 100));
      await tester.enterText(find.byType(TextField), 'indom');
      await tester.pump(const Duration(milliseconds: 100));

      // Belum ada yang dilaporkan: pengguna masih mengetik.
      expect(reported, isEmpty);

      await tester.pump(const Duration(milliseconds: 400));

      // Hanya nilai terakhir yang sampai — bukan satu laporan per ketukan.
      expect(reported, ['indom']);
    });

    testWidgets('Enter melaporkan seketika tanpa menunggu penundaan',
        (tester) async {
      final submitted = <String>[];

      await _pump(
        tester,
        AppSearchField(
          onChanged: (_) {},
          onSubmitted: submitted.add,
        ),
      );

      await tester.enterText(find.byType(TextField), '8991002101017');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pump();

      // Jalur pemindai barcode: hasil pindaian tidak boleh menunggu 300 ms.
      expect(submitted, ['8991002101017']);

      await tester.pump(const Duration(milliseconds: 400));
    });

    testWidgets('tombol bersihkan mengosongkan dan melapor tanpa penundaan',
        (tester) async {
      final reported = <String>[];

      await _pump(
        tester,
        AppSearchField(onChanged: reported.add),
      );

      await tester.enterText(find.byType(TextField), 'indomie');
      await tester.pump();

      await tester.tap(find.byIcon(AppIcons.close));
      await tester.pump();

      expect(reported, ['']);
      expect(find.text('indomie'), findsNothing);

      await tester.pump(const Duration(milliseconds: 400));
    });
  });
}
