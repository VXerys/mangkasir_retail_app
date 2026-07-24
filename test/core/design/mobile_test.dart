import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangkasir_retail_app/core/design/design.dart';
import 'package:mangkasir_retail_app/core/scanner/barcode_input.dart';

/// Ukuran ponsel — jalur `WindowSize.compact`.
const _phone = Size(400, 800);

/// Ukuran tablet lanskap — jalur rail/sidebar.
const _tablet = Size(1200, 900);

Future<void> _pump(
  WidgetTester tester,
  Widget child, {
  Size surface = _phone,
}) async {
  tester.view.physicalSize = surface;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    MaterialApp(theme: AppTheme.light, home: child),
  );
}

void main() {
  group('AppShell — navigasi utama per ukuran layar', () {
    Widget shell({
      required Size surface,
      bool withBottomNav = true,
    }) {
      final items = [
        AppNavItem(label: 'Kasir', icon: AppIcons.pos, onTap: () {}),
        AppNavItem(label: 'Produk', icon: AppIcons.product, onTap: () {}),
      ];

      return AppShell(
        sidebarBuilder: (context, mode) => AppSidebar.flat(
          mode: mode,
          selectedIndex: 0,
          items: items,
        ),
        bottomNavBuilder: withBottomNav
            ? (context) => AppBottomNav(selectedIndex: 0, items: items)
            : null,
        workspace: const SizedBox.expand(),
      );
    }

    testWidgets('ponsel memakai bilah bawah, bukan sidebar', (tester) async {
      await _pump(tester, shell(surface: _phone));

      expect(find.byType(AppBottomNav), findsOneWidget);
      expect(find.byType(AppSidebar), findsNothing);
    });

    testWidgets('tablet lanskap memakai sidebar, bukan bilah bawah',
        (tester) async {
      await _pump(tester, shell(surface: _tablet), surface: _tablet);

      expect(find.byType(AppSidebar), findsOneWidget);
      expect(find.byType(AppBottomNav), findsNothing);
    });

    testWidgets('tanpa bilah bawah, ponsel jatuh kembali ke laci navigasi',
        (tester) async {
      await _pump(tester, shell(surface: _phone, withBottomNav: false));

      // Halaman tanpa navigasi bawah tidak boleh kehilangan jalan sama sekali.
      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.drawer, isNotNull);
      expect(scaffold.bottomNavigationBar, isNull);
    });
  });

  group('AppBottomNav', () {
    testWidgets('menekan tujuan melaporkan ketukannya', (tester) async {
      String? tapped;

      await _pump(
        tester,
        Scaffold(
          bottomNavigationBar: AppBottomNav(
            selectedIndex: 0,
            items: [
              AppNavItem(
                label: 'Kasir',
                icon: AppIcons.pos,
                onTap: () => tapped = 'kasir',
              ),
              AppNavItem(
                label: 'Produk',
                icon: AppIcons.product,
                onTap: () => tapped = 'produk',
              ),
            ],
          ),
        ),
      );

      await tester.tap(find.text('Produk'));
      expect(tapped, 'produk');
    });

    testWidgets('lencana besar dipersingkat jadi 99+', (tester) async {
      await _pump(
        tester,
        Scaffold(
          bottomNavigationBar: AppBottomNav(
            selectedIndex: 0,
            items: [
              AppNavItem(
                label: 'Sync',
                icon: AppIcons.syncPending,
                badgeCount: 1240,
                onTap: () {},
              ),
            ],
          ),
        ),
      );

      // Angka penuh akan melebarkan tujuan dan memotong labelnya.
      expect(find.text('99+'), findsOneWidget);
      expect(find.text('1240'), findsNothing);
    });

    testWidgets('menolak lebih dari lima tujuan', (tester) async {
      expect(
        () => AppBottomNav(
          selectedIndex: 0,
          items: [
            for (var i = 0; i < 6; i++)
              AppNavItem(label: '$i', icon: AppIcons.pos, onTap: () {}),
          ],
        ),
        throwsAssertionError,
      );
    });
  });

  group('AppBarcodeListener', () {
    /// Mengetik seperti pemindai HID: cepat, lalu Enter.
    Future<void> scan(WidgetTester tester, String code) async {
      for (final char in code.split('')) {
        await tester.sendKeyEvent(_digitKey(char));
      }
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();
    }

    testWidgets('rentetan cepat yang diakhiri Enter terbaca sebagai barcode',
        (tester) async {
      final scans = <BarcodeScan>[];

      await _pump(
        tester,
        Scaffold(
          body: AppBarcodeListener(
            onScan: scans.add,
            child: const Focus(autofocus: true, child: SizedBox.expand()),
          ),
        ),
      );

      await scan(tester, '8991002101017');

      expect(scans, hasLength(1));
      expect(scans.single.code, '8991002101017');
      expect(scans.single.source, BarcodeSource.wedge);
    });

    testWidgets('ketikan yang terlalu pendek diabaikan', (tester) async {
      final scans = <BarcodeScan>[];

      await _pump(
        tester,
        Scaffold(
          body: AppBarcodeListener(
            onScan: scans.add,
            child: const Focus(autofocus: true, child: SizedBox.expand()),
          ),
        ),
      );

      // Enter di dalam formulir tidak boleh disalahartikan sebagai barcode.
      await scan(tester, '123');

      expect(scans, isEmpty);
    });

    testWidgets('ketikan manusia yang lambat tidak terbaca sebagai barcode',
        (tester) async {
      final scans = <BarcodeScan>[];

      await _pump(
        tester,
        Scaffold(
          body: AppBarcodeListener(
            onScan: scans.add,
            maxKeyInterval: const Duration(milliseconds: 120),
            child: const Focus(autofocus: true, child: SizedBox.expand()),
          ),
        ),
      );

      for (final char in '8991002101017'.split('')) {
        await tester.sendKeyEvent(_digitKey(char));
        // Jeda antar tombol jauh di atas ambang pemindai.
        await tester.pump(const Duration(milliseconds: 200));
      }
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();

      expect(scans, isEmpty);
    });

    testWidgets('menyerahkan hasil ke AppBarcodeScope bila tidak ada onScan',
        (tester) async {
      final scans = <BarcodeScan>[];

      await _pump(
        tester,
        AppBarcodeScope(
          onScan: scans.add,
          child: Scaffold(
            body: AppBarcodeListener(
              child: const Focus(autofocus: true, child: SizedBox.expand()),
            ),
          ),
        ),
      );

      await scan(tester, '8991002101017');

      expect(scans.single.code, '8991002101017');
    });
  });

  group('PhysicalKeyboard', () {
    setUp(() => PhysicalKeyboard.instance.resetForTest());
    tearDown(() => PhysicalKeyboard.instance.resetForTest());

    testWidgets('petunjuk pintasan tersembunyi di layar sentuh murni',
        (tester) async {
      await _pump(
        tester,
        const Scaffold(
          body: AppShortcutHint(activator: AppShortcutKeys.pay),
        ),
      );

      expect(find.text('F4'), findsNothing);
    });

    testWidgets('petunjuk muncul setelah tombol fungsi ditekan',
        (tester) async {
      await _pump(
        tester,
        const Scaffold(
          body: AppShortcutHint(activator: AppShortcutKeys.pay),
        ),
      );

      await tester.sendKeyEvent(LogicalKeyboardKey.f2);
      await tester.pumpAndSettle();

      expect(find.text('F4'), findsOneWidget);
    });

    testWidgets('digit dan Enter tidak dianggap bukti papan ketik fisik',
        (tester) async {
      await _pump(
        tester,
        const Scaffold(
          body: AppShortcutHint(activator: AppShortcutKeys.pay),
        ),
      );

      // Persis yang dikirim pemindai HID. Pemindai bukan papan ketik, dan
      // tidak boleh memunculkan petunjuk "Tekan F4".
      for (final char in '8991002101017'.split('')) {
        await tester.sendKeyEvent(_digitKey(char));
      }
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();

      expect(find.text('F4'), findsNothing);
    });
  });

  group('AppShortcutKeys', () {
    test('label pintasan terbaca manusia', () {
      expect(AppShortcutKeys.labelOf(AppShortcutKeys.search), 'F2');
      expect(AppShortcutKeys.labelOf(AppShortcutKeys.pay), 'F4');
      expect(AppShortcutKeys.labelOf(AppShortcutKeys.cancel), 'ESC');
      expect(AppShortcutKeys.labelOf(AppShortcutKeys.print), 'Ctrl + P');
    });
  });

  group('AppShortcuts', () {
    testWidgets('F2 dan F4 menjalankan aksinya', (tester) async {
      final fired = <String>[];

      await _pump(
        tester,
        Scaffold(
          body: AppShortcuts(
            onSearch: () => fired.add('search'),
            onPay: () => fired.add('pay'),
            child: const SizedBox.expand(),
          ),
        ),
      );
      await tester.pump();

      await tester.sendKeyEvent(LogicalKeyboardKey.f2);
      await tester.sendKeyEvent(LogicalKeyboardKey.f4);
      await tester.pump();

      expect(fired, ['search', 'pay']);
    });

    testWidgets('aksi null tidak dipasang sama sekali', (tester) async {
      final fired = <String>[];

      await _pump(
        tester,
        Scaffold(
          body: AppShortcuts(
            onSearch: () => fired.add('search'),
            child: const SizedBox.expand(),
          ),
        ),
      );
      await tester.pump();

      // F4 tidak dipasang, jadi tidak melakukan apa pun dan tidak melempar.
      await tester.sendKeyEvent(LogicalKeyboardKey.f4);
      await tester.pump();

      expect(fired, isEmpty);
    });
  });

  group('AppBackGuard', () {
    /// `PopScope` juga dipakai di dalam Scaffold dan rute Material, jadi
    /// pencarian harus dibatasi ke milik AppBackGuard sendiri.
    PopScope<Object?> guardOf(WidgetTester tester) => tester.widget(
          find
              .descendant(
                of: find.byType(AppBackGuard),
                matching: find.byType(PopScope<Object?>),
              )
              .first,
        );

    testWidgets('tidak menahan saat tidak ada yang perlu dilindungi',
        (tester) async {
      await _pump(
        tester,
        const AppBackGuard(
          isBlocking: false,
          child: Scaffold(body: SizedBox.expand()),
        ),
      );

      expect(guardOf(tester).canPop, isTrue);
    });

    testWidgets('menahan saat ada pekerjaan yang belum selesai',
        (tester) async {
      await _pump(
        tester,
        const AppBackGuard(
          isBlocking: true,
          child: Scaffold(body: SizedBox.expand()),
        ),
      );

      expect(guardOf(tester).canPop, isFalse);
    });
  });

  group('AppSwipeAction', () {
    testWidgets('geseran membuka aksi, dan menekannya menjalankan aksi',
        (tester) async {
      var deleted = false;

      await _pump(
        tester,
        Scaffold(
          body: Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: 360,
              child: Builder(
                builder: (context) => AppSwipeAction(
                  endActions: [
                    AppSwipeActionItem(
                      label: 'Hapus',
                      icon: AppIcons.delete,
                      color: context.colors.danger,
                      onPressed: () => deleted = true,
                    ),
                  ],
                  child: const SizedBox(
                    height: 56,
                    child: Center(child: Text('Indomie Goreng')),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      // Aksi tersembunyi sebelum digeser.
      expect(find.text('Hapus'), findsNothing);

      await tester.drag(find.text('Indomie Goreng'), const Offset(-120, 0));
      await tester.pumpAndSettle();

      expect(find.text('Hapus'), findsOneWidget);

      await tester.tap(find.text('Hapus'));
      await tester.pumpAndSettle();

      expect(deleted, isTrue);
    });

    testWidgets('tanpa aksi, widget diteruskan apa adanya', (tester) async {
      await _pump(
        tester,
        const Scaffold(
          body: AppSwipeAction(child: Text('Tanpa aksi')),
        ),
      );

      expect(find.text('Tanpa aksi'), findsOneWidget);
      // Tidak ada lapisan geser yang dipasang — dan yang lebih penting,
      // membuang widget ini tidak boleh melempar galat ticker.
      expect(
        find.descendant(
          of: find.byType(AppSwipeAction),
          matching: find.byType(LayoutBuilder),
        ),
        findsNothing,
      );
    });
  });
}

/// Memetakan satu karakter angka ke tombol papan ketiknya.
LogicalKeyboardKey _digitKey(String char) => switch (char) {
      '0' => LogicalKeyboardKey.digit0,
      '1' => LogicalKeyboardKey.digit1,
      '2' => LogicalKeyboardKey.digit2,
      '3' => LogicalKeyboardKey.digit3,
      '4' => LogicalKeyboardKey.digit4,
      '5' => LogicalKeyboardKey.digit5,
      '6' => LogicalKeyboardKey.digit6,
      '7' => LogicalKeyboardKey.digit7,
      '8' => LogicalKeyboardKey.digit8,
      _ => LogicalKeyboardKey.digit9,
    };
