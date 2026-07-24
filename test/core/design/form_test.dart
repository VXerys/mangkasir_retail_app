import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mangkasir_retail_app/core/design/design.dart';

Future<void> _pump(WidgetTester tester, Widget child, {Size? surface}) async {
  if (surface != null) {
    tester.view.physicalSize = surface;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
  }

  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      home: Scaffold(
        body: Padding(padding: const EdgeInsets.all(24), child: child),
      ),
    ),
  );
}

void main() {
  // `DateFormatter` memakai locale id_ID. Di aplikasi ini disiapkan oleh
  // `main()`; tes merender widget tanpa melewati sana, jadi harus disiapkan
  // sendiri — kalau tidak, intl melempar galat locale saat nama bulan pertama
  // kali dirender.
  setUpAll(() => initializeDateFormatting('id_ID'));

  group('AppCheckbox', () {
    testWidgets('mengirim kebalikan dari nilai saat ini', (tester) async {
      bool? received;

      await _pump(
        tester,
        AppCheckbox(
          value: false,
          label: 'Aktifkan produk',
          onChanged: (value) => received = value,
        ),
      );

      await tester.tap(find.text('Aktifkan produk'));
      expect(received, isTrue);
    });

    testWidgets('keadaan sebagian mengirim true saat ditekan', (tester) async {
      bool? received;

      await _pump(
        tester,
        AppCheckbox(
          value: null,
          tristate: true,
          label: 'Pilih semua',
          onChanged: (value) => received = value,
        ),
      );

      await tester.tap(find.text('Pilih semua'));

      // `null` berarti sebagian terpilih; menekannya harus memilih semuanya,
      // bukan mengosongkan.
      expect(received, isTrue);
    });

    testWidgets('tidak bereaksi saat dinonaktifkan', (tester) async {
      await _pump(
        tester,
        const AppCheckbox(
          value: false,
          label: 'Terkunci',
          onChanged: null,
        ),
      );

      await tester.tap(find.text('Terkunci'));
      // Tidak ada yang perlu diperiksa selain: tidak melempar galat.
      expect(tester.takeException(), isNull);
    });
  });

  group('AppRadio', () {
    testWidgets('memilih nilai lain, dan mengabaikan yang sudah terpilih',
        (tester) async {
      final received = <String>[];

      await _pump(
        tester,
        AppRadioGroup<String>(
          label: 'Metode pembayaran',
          value: 'tunai',
          options: const [
            ('tunai', 'Tunai'),
            ('qris', 'QRIS'),
          ],
          onChanged: received.add,
        ),
      );

      await tester.tap(find.text('QRIS'));
      await tester.tap(find.text('Tunai'));

      // Menekan pilihan yang sedang aktif tidak menghasilkan peristiwa —
      // radio hanya bisa dipindah, tidak dibatalkan.
      expect(received, ['qris']);
    });
  });

  group('AppSwitch', () {
    testWidgets('membalik nilainya', (tester) async {
      bool? received;

      await _pump(
        tester,
        AppSwitch(
          value: true,
          label: 'Mode gelap',
          onChanged: (value) => received = value,
        ),
      );

      await tester.tap(find.text('Mode gelap'));
      expect(received, isFalse);
    });
  });

  group('AppNumberInput', () {
    testWidgets('tombol tambah dan kurang bergerak sebesar step',
        (tester) async {
      var value = 5;

      await _pump(
        tester,
        StatefulBuilder(
          builder: (context, setState) => AppNumberInput(
            value: value,
            step: 2,
            onChanged: (next) => setState(() => value = next),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.remove));
      await tester.pump();
      expect(value, 3);

      await tester.tap(find.byIcon(AppIcons.add));
      await tester.pump();
      expect(value, 5);
    });

    testWidgets('tidak bisa melewati batas bawah', (tester) async {
      var value = 1;

      await _pump(
        tester,
        StatefulBuilder(
          builder: (context, setState) => AppNumberInput(
            value: value,
            min: 1,
            onChanged: (next) => setState(() => value = next),
          ),
        ),
      );

      // Tombol kurang harus mati, bukan sekadar menjepit nilainya.
      await tester.tap(find.byIcon(Icons.remove));
      await tester.pump();
      expect(value, 1);
    });

    testWidgets('mengetik angka langsung ikut terbaca', (tester) async {
      var value = 1;

      await _pump(
        tester,
        StatefulBuilder(
          builder: (context, setState) => AppNumberInput(
            value: value,
            max: 500,
            onChanged: (next) => setState(() => value = next),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), '42');
      await tester.pump();
      expect(value, 42);
    });
  });

  group('AppCurrencyInput', () {
    testWidgets('memformat ribuan sambil diketik dan mengembalikan angka',
        (tester) async {
      double? received;

      await _pump(
        tester,
        AppCurrencyInput(
          value: 0,
          label: 'Harga jual',
          onChanged: (value) => received = value,
        ),
      );

      await tester.enterText(find.byType(TextField), '150000');
      await tester.pump();

      expect(received, 150000);
      expect(find.text('150.000'), findsOneWidget);
    });

    testWidgets('isian kosong berarti nol, bukan galat', (tester) async {
      double? received;

      await _pump(
        tester,
        AppCurrencyInput(
          value: 5000,
          onChanged: (value) => received = value,
        ),
      );

      await tester.enterText(find.byType(TextField), '');
      await tester.pump();

      expect(received, 0);
    });
  });

  group('AppSelect', () {
    const options = [
      AppSelectOption(value: 'a', label: 'Minuman'),
      AppSelectOption(value: 'b', label: 'Makanan'),
      AppSelectOption(value: 'c', label: 'Rokok', enabled: false),
    ];

    testWidgets('membuka popover, memilih, lalu menutup', (tester) async {
      String? received;

      await _pump(
        tester,
        AppSelect<String>(
          value: null,
          label: 'Kategori',
          options: options,
          onChanged: (value) => received = value,
        ),
        surface: const Size(1600, 1200),
      );

      expect(find.text('Pilih…'), findsOneWidget);

      await tester.tap(find.text('Pilih…'));
      await tester.pumpAndSettle();

      expect(find.text('Makanan'), findsOneWidget);

      await tester.tap(find.text('Makanan'));
      await tester.pumpAndSettle();

      expect(received, 'b');
      // Popover harus ikut tertutup; kalau tidak, pilihan berikutnya menumpuk
      // di atasnya.
      expect(find.text('Minuman'), findsNothing);
    });

    testWidgets('pilihan yang dinonaktifkan tidak bisa dipilih',
        (tester) async {
      String? received;

      await _pump(
        tester,
        AppSelect<String>(
          value: null,
          options: options,
          onChanged: (value) => received = value,
        ),
        surface: const Size(1600, 1200),
      );

      await tester.tap(find.text('Pilih…'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Rokok'));
      await tester.pumpAndSettle();

      expect(received, isNull);
    });

    testWidgets('pencarian menyaring daftar', (tester) async {
      await _pump(
        tester,
        const AppSelect<String>(
          value: null,
          options: options,
          searchable: true,
          onChanged: _noop,
        ),
        surface: const Size(1600, 1200),
      );

      await tester.tap(find.text('Pilih…'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).last, 'mak');
      await tester.pumpAndSettle();

      expect(find.text('Makanan'), findsOneWidget);
      expect(find.text('Minuman'), findsNothing);
    });
  });

  group('AppDateField', () {
    testWidgets('membuka kalender dan mengembalikan tanggal terpilih',
        (tester) async {
      DateTime? received;

      await _pump(
        tester,
        AppDateField(
          value: DateTime(2026, 7, 24),
          label: 'Tanggal transaksi',
          onChanged: (value) => received = value,
        ),
        surface: const Size(1600, 1200),
      );

      expect(find.text('24 Jul 2026'), findsOneWidget);

      await tester.tap(find.text('24 Jul 2026'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('15'));
      await tester.pumpAndSettle();

      expect(received, DateTime(2026, 7, 15));
    });
  });
}

void _noop(String _) {}
