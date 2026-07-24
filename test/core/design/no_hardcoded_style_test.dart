import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Satu aturan pemindaian.
class _Rule {
  final String name;
  final RegExp pattern;
  final String remedy;

  /// Berkas di dalam folder ini dilewati oleh aturan ini.
  final List<String> skipFolders;

  const _Rule({
    required this.name,
    required this.pattern,
    required this.remedy,
    this.skipFolders = const [],
  });
}

final _rules = <_Rule>[
  _Rule(
    name: 'Warna mentah',
    // `Colors.` dari Material, dan literal `Color(0x...)`.
    pattern: RegExp(r'\bColors\.|\bColor\(0x'),
    remedy: 'pakai context.colors.<peran>',
  ),
  _Rule(
    name: 'Gaya teks lepas',
    pattern: RegExp(r'\bTextStyle\('),
    remedy: 'pakai context.text.<peran>, dan copyWith bila perlu ganti warna',
  ),
  _Rule(
    name: 'Spasi telanjang',
    // Hanya memicu bila angka menyusul langsung. `EdgeInsets.all(context.space.md)`
    // lolos justru karena isinya bukan digit.
    pattern: RegExp(
      r'EdgeInsets\.(all|symmetric|only|fromLTRB)\(\s*[\d.]|'
      r'SizedBox\(\s*(height|width):\s*[\d.]',
    ),
    remedy: 'pakai context.space.<xs|sm|md|lg|xl>',
  ),
  _Rule(
    name: 'Radius telanjang',
    pattern: RegExp(r'BorderRadius\.circular\(\s*[\d.]|Radius\.circular\(\s*[\d.]'),
    remedy: 'pakai AppRadius.rXs/rSm/rMd/rLg/rPill',
  ),
  _Rule(
    name: 'Ikon Material langsung',
    pattern: RegExp(r'\bIcons\.'),
    remedy: 'pakai AppIcons.<nama>; tambahkan tokennya bila belum ada',
  ),
  _Rule(
    name: 'Durasi telanjang',
    pattern: RegExp(r'\bDuration\('),
    remedy: 'pakai AppMotion.instant/fast/normal/deliberate',
    // Bloc memakai Duration untuk debounce dan timeout — itu keputusan alur
    // kerja, bukan keputusan visual, dan tidak tunduk pada plafon gerak 220 ms.
    skipFolders: ['bloc'],
  ),
];

/// Berkas hasil generator tidak ditulis manusia dan tidak bisa diperbaiki.
bool _isGenerated(String path) =>
    path.endsWith('.g.dart') ||
    path.endsWith('.freezed.dart') ||
    path.endsWith('.config.dart');

bool _skips(_Rule rule, String relativePath) => rule.skipFolders
    .any((folder) => relativePath.split('/').contains(folder));

/// Membuang komentar dan literal string agar tidak menghasilkan temuan palsu.
///
/// Contoh yang harus tetap lolos: dokumentasi yang menyebut `Colors.red` untuk
/// menjelaskan mengapa ia terlarang, dan teks tampilan seperti `'Duration('`.
String _strip(String line) {
  final withoutComment = line.replaceFirst(RegExp(r'//.*$'), '');
  return withoutComment
      .replaceAll(RegExp(r"'(?:[^'\\]|\\.)*'"), "''")
      .replaceAll(RegExp(r'"(?:[^"\\]|\\.)*"'), '""');
}

void main() {
  test(
    'lib/features/ tidak memuat nilai visual mentah',
    () {
      final root = Directory('lib/features');
      // Kalau foldernya belum ada, tidak ada yang perlu dijaga — dan tes ini
      // tidak boleh menjadi alasan gagal di lingkungan yang belum lengkap.
      if (!root.existsSync()) return;

      final violations = <String>[];

      final files = root
          .listSync(recursive: true)
          .whereType<File>()
          .where((file) => file.path.endsWith('.dart'))
          .where((file) => !_isGenerated(file.path));

      for (final file in files) {
        final relative =
            file.path.replaceAll(r'\', '/').split('lib/').last;
        final lines = file.readAsLinesSync();

        for (var i = 0; i < lines.length; i++) {
          final code = _strip(lines[i]);
          if (code.trim().isEmpty) continue;

          for (final rule in _rules) {
            if (_skips(rule, relative)) continue;
            if (!rule.pattern.hasMatch(code)) continue;

            violations.add(
              'lib/$relative:${i + 1}  ${rule.name} — ${rule.remedy}\n'
              '    ${lines[i].trim()}',
            );
          }
        }
      }

      expect(
        violations,
        isEmpty,
        reason: 'Design system dilanggar di ${violations.length} tempat.\n\n'
            '${violations.join('\n\n')}\n\n'
            'Aturannya ada di lib/core/design/design.dart: seluruh nilai visual '
            'dibaca lewat context.colors / context.text / context.space / '
            'context.elevation, dan AppRadius / AppIcons / AppMotion.\n'
            'Kalau sebuah nilai belum punya token, tambahkan tokennya — '
            'jangan kecualikan barisnya.',
      );
    },
  );

  test('pemindai benar-benar mengenali pelanggaran', () {
    // Tanpa ini, tes di atas akan tetap hijau seandainya polanya salah tulis
    // dan tidak pernah cocok dengan apa pun.
    final samples = {
      'Warna mentah': 'color: Colors.red,',
      'Gaya teks lepas': 'style: TextStyle(fontSize: 12),',
      'Spasi telanjang': 'padding: EdgeInsets.all(16),',
      'Radius telanjang': 'borderRadius: BorderRadius.circular(8),',
      'Ikon Material langsung': 'icon: Icons.add,',
      'Durasi telanjang': 'duration: Duration(milliseconds: 300),',
    };

    for (final rule in _rules) {
      final sample = samples[rule.name]!;
      expect(
        rule.pattern.hasMatch(_strip(sample)),
        isTrue,
        reason: 'Aturan "${rule.name}" tidak mengenali contohnya sendiri.',
      );
    }
  });

  test('pemakaian token yang benar tidak ikut tertangkap', () {
    final allowed = [
      'padding: EdgeInsets.all(context.space.md),',
      'padding: EdgeInsets.symmetric(horizontal: density.lg),',
      'SizedBox(height: context.space.sm),',
      'borderRadius: AppRadius.rMd,',
      'color: context.colors.surfaceSubtle,',
      'style: context.text.tableCell,',
      'icon: AppIcons.search,',
      'duration: AppMotion.fast,',
      "// Jangan pernah menulis Colors.red di dalam lib/features/.",
      "final label = 'EdgeInsets.all(16) dilarang';",
    ];

    for (final line in allowed) {
      for (final rule in _rules) {
        expect(
          rule.pattern.hasMatch(_strip(line)),
          isFalse,
          reason: 'Aturan "${rule.name}" salah menuduh: $line',
        );
      }
    }
  });
}
