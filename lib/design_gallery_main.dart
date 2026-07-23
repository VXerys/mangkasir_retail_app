import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'core/design/design.dart';
import 'core/design/gallery/design_gallery_page.dart';

/// Entrypoint khusus untuk galeri design system.
///
/// ```bash
/// flutter run -t lib/design_gallery_main.dart -d chrome
/// ```
///
/// Sengaja tidak menyentuh `.env`, Supabase, Hive, maupun `configureDependencies()`.
/// Design system harus bisa dibuka dan diperiksa tanpa satu pun infrastruktur —
/// itu sekaligus menjadi bukti bahwa tidak ada token yang diam-diam bergantung
/// pada lapisan data.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID');

  runApp(
    MaterialApp(
      title: 'Design System — MangRitel',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const DesignGalleryPage(),
    ),
  );
}
