import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangkasir_retail_app/core/design/design.dart';

/// Rasio kontras WCAG antara dua warna buram.
///
/// Dihitung dari [Color.computeLuminance], yang memang menghasilkan relative
/// luminance versi WCAG — jadi tidak perlu paket tambahan.
double _contrast(Color a, Color b) {
  final la = a.computeLuminance();
  final lb = b.computeLuminance();
  final lighter = la > lb ? la : lb;
  final darker = la > lb ? lb : la;
  return (lighter + 0.05) / (darker + 0.05);
}

/// Ambang WCAG AA untuk teks berukuran normal.
const _aaText = 4.5;

/// Ambang WCAG AA untuk elemen non-teks (cincin fokus, garis penting).
const _aaNonText = 3.0;

void main() {
  final themes = <({String name, ThemeData theme})>[
    (name: 'terang', theme: AppTheme.light),
    (name: 'gelap', theme: AppTheme.dark),
  ];

  // Kedua tema diuji dengan aturan yang sama persis. Tema terang selama ini
  // belum pernah diuji kontrasnya — kalau suatu saat ramp-nya digeser, di
  // sinilah ketahuannya, bukan setelah kasir mengeluh.
  for (final entry in themes) {
    group('Kontras tema ${entry.name}', () {
      final colors = entry.theme.extension<AppSemanticColors>()!;

      test('teks terbaca di atas surface dan canvas', () {
        final roles = {
          'textPrimary': colors.textPrimary,
          'textSecondary': colors.textSecondary,
          'textTertiary': colors.textTertiary,
        };

        for (final MapEntry(key: name, value: color) in roles.entries) {
          for (final MapEntry(key: surfaceName, value: surface) in {
            'surface': colors.surface,
            'canvas': colors.canvas,
            'surfaceSubtle': colors.surfaceSubtle,
          }.entries) {
            expect(
              _contrast(color, surface),
              greaterThanOrEqualTo(_aaText),
              reason: '$name di atas $surfaceName gagal WCAG AA',
            );
          }
        }
      });

      test('setiap trio semantik kontras terhadap isiannya sendiri', () {
        final signals = {
          'success': colors.success,
          'danger': colors.danger,
          'warning': colors.warning,
          'info': colors.info,
          'stockOut': colors.stockOut,
          'stockLow': colors.stockLow,
          'stockOk': colors.stockOk,
          'syncPending': colors.syncPending,
          'syncFailed': colors.syncFailed,
          'offline': colors.offline,
        };

        for (final MapEntry(key: name, value: signal) in signals.entries) {
          expect(
            _contrast(signal.fg, signal.bg),
            greaterThanOrEqualTo(_aaText),
            reason: '$name.fg di atas $name.bg gagal WCAG AA',
          );
          // Garis wajib ikut memberi sinyal — pengguna dengan gangguan
          // persepsi warna membaca bentuk, bukan rona. Garis yang menyatu
          // dengan isiannya membuat badge kehilangan batasnya.
          expect(
            _contrast(signal.border, signal.bg),
            greaterThan(1.1),
            reason: '$name.border tidak terbedakan dari $name.bg',
          );
        }
      });

      test('label di atas permukaan beraksen terbaca', () {
        expect(
          _contrast(colors.textOnAccent, colors.accent),
          greaterThanOrEqualTo(_aaText),
          reason: 'label tombol primer gagal WCAG AA',
        );
      });

      test('cincin fokus terlihat dari jarak pandang berdiri', () {
        // POS ini dirancang untuk dioperasikan tanpa mouse, jadi penanda fokus
        // adalah elemen non-teks paling penting di seluruh aplikasi.
        expect(
          _contrast(colors.borderFocus, colors.surface),
          greaterThanOrEqualTo(_aaNonText),
        );
      });

      test('garis default terbedakan dari permukaannya', () {
        expect(_contrast(colors.borderDefault, colors.surface),
            greaterThan(1.2));
      });

      test('lapisan permukaan tersusun benar', () {
        // Berlaku sama di kedua tema, dan ini sempat disalahpahami saat UI-0:
        // "lebih ke depan berarti lebih terang" bukan aturan khusus tema
        // gelap. Panel putih di atas kanvas keabuan mengikuti aturan yang
        // persis sama.
        final canvas = colors.canvas.computeLuminance();
        final surface = colors.surface.computeLuminance();
        final subtle = colors.surfaceSubtle.computeLuminance();
        final raised = colors.surfaceRaised.computeLuminance();

        expect(surface, greaterThan(canvas),
            reason: 'canvas harus berada di belakang surface');
        expect(surface, greaterThan(subtle),
            reason: 'surfaceSubtle harus mundur dari surface');
        expect(raised, greaterThanOrEqualTo(surface),
            reason: 'surfaceRaised harus maju terhadap surface');
      });

      test('sorotan bergerak menjauh dari permukaan', () {
        // Di sinilah kedua tema benar-benar berlawanan: pada tema terang,
        // baris tersorot menjadi lebih gelap; pada tema gelap, lebih terang.
        // Keduanya bergerak ke arah yang menambah kontras, bukan menguranginya.
        final surface = colors.surface.computeLuminance();
        final hover = colors.surfaceHover.computeLuminance();
        final isDark = entry.theme.brightness == Brightness.dark;

        expect(
          isDark ? hover > surface : hover < surface,
          isTrue,
          reason: 'surfaceHover tidak menambah kontras terhadap surface',
        );
      });
    });
  }

  group('AppTheme.dark', () {
    test('benar-benar tema gelap', () {
      // Sebelum UI-1, AppTheme.dark mengirim Brightness.light sehingga Material
      // memperlakukan dirinya sebagai tema terang walau warnanya gelap.
      expect(AppTheme.dark.brightness, Brightness.dark);
      expect(AppTheme.dark.colorScheme.brightness, Brightness.dark);
    });

    test('permukaannya gelap sungguhan', () {
      final colors = AppTheme.dark.extension<AppSemanticColors>()!;
      expect(colors.canvas.computeLuminance(), lessThan(0.05));
      expect(colors.surface.computeLuminance(), lessThan(0.1));
    });

    test('tidak lagi meminjam nilai skema terang', () {
      // Penjaga regresi: sebelum UI-1, DarkScheme.colors adalah alias
      // LightScheme.colors. Kalau alias itu kembali, uji ini yang jatuh.
      final dark = AppTheme.dark.extension<AppSemanticColors>()!;
      final light = AppTheme.light.extension<AppSemanticColors>()!;

      expect(dark.canvas, isNot(light.canvas));
      expect(dark.surface, isNot(light.surface));
      expect(dark.textPrimary, isNot(light.textPrimary));
      expect(dark.danger.bg, isNot(light.danger.bg));
    });

    test('metrik huruf identik dengan tema terang', () {
      // Hanya warnanya yang boleh berbeda. Kalau ukurannya ikut berubah,
      // tata letak bergeser saat tema ditukar.
      final dark = AppTheme.dark.extension<AppTypography>()!;
      final light = AppTheme.light.extension<AppTypography>()!;

      expect(dark.tableCell.fontSize, light.tableCell.fontSize);
      expect(dark.tableCell.height, light.tableCell.height);
      expect(dark.kpiValue.fontSize, light.kpiValue.fontSize);
      expect(dark.tableCell.color, isNot(light.tableCell.color));
    });
  });

  group('AppElevation', () {
    test('terpasang di kedua tema', () {
      for (final entry in themes) {
        expect(
          entry.theme.extension<AppElevation>(),
          isNotNull,
          reason: 'tema ${entry.name} tidak memasang AppElevation',
        );
      }
    });

    test('bayangan tema gelap lebih pekat daripada tema terang', () {
      // Bayangan bertinta biru milik tema terang praktis lenyap di atas kanvas
      // gelap; itulah alasan AppElevation ada.
      final light = AppTheme.light.extension<AppElevation>()!;
      final dark = AppTheme.dark.extension<AppElevation>()!;

      expect(dark.dialog.first.color.a, greaterThan(light.dialog.first.color.a));
      expect(
        dark.popover.first.color.a,
        greaterThan(light.popover.first.color.a),
      );
    });

    test('permukaan datar tetap tanpa bayangan', () {
      // Aturan design system: panel dan tabel dipisahkan garis, bukan bayangan.
      for (final entry in themes) {
        expect(entry.theme.extension<AppElevation>()!.flat, isEmpty);
      }
    });
  });
}
