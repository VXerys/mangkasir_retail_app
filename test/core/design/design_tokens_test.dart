import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangkasir_retail_app/core/design/design.dart';

void main() {
  group('AppBreakpoints', () {
    test('memetakan lebar ke kelas jendela yang benar', () {
      expect(AppBreakpoints.fromWidth(320), WindowSize.compact);
      expect(AppBreakpoints.fromWidth(599), WindowSize.compact);
      expect(AppBreakpoints.fromWidth(600), WindowSize.medium);
      expect(AppBreakpoints.fromWidth(1023), WindowSize.medium);
      expect(AppBreakpoints.fromWidth(1024), WindowSize.expanded);
      expect(AppBreakpoints.fromWidth(1439), WindowSize.expanded);
      expect(AppBreakpoints.fromWidth(1440), WindowSize.large);
    });

    test('bisa dibandingkan urutannya', () {
      expect(WindowSize.large >= WindowSize.expanded, isTrue);
      expect(WindowSize.compact >= WindowSize.medium, isFalse);
    });
  });

  group('AppDensity', () {
    test('layar sempit mendapat tampilan paling lega', () {
      expect(AppDensity.forWindow(WindowSize.compact).level,
          DensityLevel.comfortable);
      expect(AppDensity.forWindow(WindowSize.medium).level, DensityLevel.normal);
      expect(AppDensity.forWindow(WindowSize.large).level, DensityLevel.compact);
    });

    test('area sentuh tidak pernah turun di bawah 44px', () {
      // Aturan 16.1 "Large Touch Area". Kerapatan boleh mengecilkan tampilan,
      // tapi tidak boleh mengecilkan area yang bisa ditekan.
      for (final density in [
        AppDensity.compact,
        AppDensity.normal,
        AppDensity.comfortable,
      ]) {
        expect(density.minTouchTarget, greaterThanOrEqualTo(44));
      }
    });

    test('touchPadding menutup selisih terhadap tinggi kontrol', () {
      expect(AppDensity.compact.touchPadding, 6); // (44 - 32) / 2
      expect(AppDensity.comfortable.touchPadding, 0); // 48 == 48
    });
  });

  group('DensityScope', () {
    testWidgets('memakai lebar jendela bila tidak ada scope', (tester) async {
      late AppDensity resolved;

      tester.view.physicalSize = const Size(1600, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: Builder(
            builder: (context) {
              resolved = context.space;
              return const SizedBox();
            },
          ),
        ),
      );

      expect(resolved.level, DensityLevel.compact);
    });

    testWidgets('scope terdekat menang', (tester) async {
      late AppDensity resolved;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: DensityScope(
            density: AppDensity.comfortable,
            child: Builder(
              builder: (context) {
                resolved = context.space;
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      expect(resolved.level, DensityLevel.comfortable);
    });
  });

  group('AppTheme', () {
    test('memasang ketiga ThemeExtension', () {
      for (final theme in [AppTheme.light, AppTheme.dark]) {
        expect(theme.extension<AppSemanticColors>(), isNotNull);
        expect(theme.extension<AppTypography>(), isNotNull);
        expect(theme.extension<AppElevation>(), isNotNull);
      }
    });

    test('ColorScheme mengikuti token, bukan ungu bawaan Flutter', () {
      final theme = AppTheme.light;
      final colors = theme.extension<AppSemanticColors>()!;

      expect(theme.colorScheme.primary, colors.accent);
      expect(theme.colorScheme.error, colors.danger.fg);
      expect(theme.colorScheme.outline, colors.borderDefault);
      expect(theme.scaffoldBackgroundColor, colors.canvas);
    });

    test('gaya numerik memakai angka tabular', () {
      // Tanpa ini kolom harga di tabel POS bergeser setiap angka berubah.
      final t = AppTheme.light.extension<AppTypography>()!;

      for (final style in [
        t.tableCellNumeric,
        t.kpiValue,
        t.priceRegular,
        t.priceLarge,
        t.receiptLine,
        t.receiptTotal,
      ]) {
        expect(style.fontFamily, AppFontFamily.numeric);
        expect(
          style.fontFeatures?.any((f) => f.feature == 'tnum'),
          isTrue,
          reason: 'gaya numerik wajib memakai tabularFigures',
        );
      }
    });
  });

  group('AppMotion', () {
    test('tidak ada durasi yang melewati plafon 220ms', () {
      for (final duration in [
        AppMotion.instant,
        AppMotion.fast,
        AppMotion.normal,
        AppMotion.deliberate,
      ]) {
        expect(duration.inMilliseconds, lessThanOrEqualTo(220));
      }
    });
  });
}
