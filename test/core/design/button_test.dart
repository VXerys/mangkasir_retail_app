import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangkasir_retail_app/core/design/design.dart';

Future<void> _pump(WidgetTester tester, Widget child) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      home: Scaffold(body: Center(child: child)),
    ),
  );
}

void main() {
  group('AppButton', () {
    testWidgets('tombol nonaktif tidak memanggil onPressed', (tester) async {
      var taps = 0;

      await _pump(
        tester,
        AppButton(
          label: 'Bayar',
          isLoading: true,
          onPressed: () => taps++,
        ),
      );

      await tester.tap(find.text('Bayar'));
      await tester.pump();

      // isLoading harus memblokir aksi. Kalau tidak, kasir yang menekan dua kali
      // saat jaringan lambat bisa membuat transaksi ganda.
      expect(taps, 0);
    });
  });
}
