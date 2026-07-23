import 'package:flutter/material.dart';

import '../../design.dart';

/// Kerangka tata letak aplikasi: **Sidebar + Workspace + Inspector +
/// Bottom Panel**.
///
/// 16_Design_System.md Tahap 16.4 menolak tata letak "container 1280px ala
/// dashboard SaaS" dan meminta susunan panel seperti perangkat lunak
/// profesional (VS Code, Excel, Figma), karena POS adalah aplikasi kerja, bukan
/// situs yang dibaca sekali lalu ditinggalkan.
///
/// Shell menyesuaikan diri terhadap ruang yang tersedia:
///
/// | Ukuran   | Sidebar   | Inspector      | Bottom panel |
/// |----------|-----------|----------------|--------------|
/// | compact  | Laci      | Bottom sheet   | Disembunyikan |
/// | medium   | Rail ikon | Laci kanan     | Disembunyikan |
/// | expanded | Rail ikon | Kolom tetap    | Ditampilkan   |
/// | large    | Berlabel  | Kolom tetap    | Ditampilkan   |
///
/// Shell juga memasang [DensityScope] untuk seluruh subtree, sehingga setiap
/// widget di dalamnya otomatis memakai kerapatan yang sesuai perangkat tanpa
/// perlu memeriksa lebar layar sendiri-sendiri.
class AppShell extends StatelessWidget {
  /// Kolom navigasi. Biasanya sebuah [AppSidebar].
  final Widget Function(BuildContext context, AppSidebarMode mode) sidebarBuilder;

  /// Area kerja utama.
  final Widget workspace;

  /// Panel kanan berisi detail dari apa pun yang sedang dipilih di [workspace].
  final Widget? inspector;

  /// Panel bawah selebar layar: log, ringkasan, atau konsol sync.
  final Widget? bottomPanel;

  /// Bilah atas di dalam area kerja.
  final PreferredSizeWidget? appBar;

  /// Menimpa kerapatan yang dipilih otomatis.
  ///
  /// Hanya untuk keperluan khusus seperti halaman galeri design system; pada
  /// pemakaian normal biarkan shell yang memutuskan.
  final AppDensity? densityOverride;

  const AppShell({
    super.key,
    required this.sidebarBuilder,
    required this.workspace,
    this.inspector,
    this.bottomPanel,
    this.appBar,
    this.densityOverride,
  });

  @override
  Widget build(BuildContext context) {
    final windowSize = context.windowSize;
    final density = densityOverride ?? AppDensity.forWindow(windowSize);

    return DensityScope(
      density: density,
      child: Builder(
        // Builder baru diperlukan agar `context.space` di bawah ini membaca
        // DensityScope yang baru saja dipasang, bukan yang di atasnya.
        builder: (context) => switch (windowSize) {
          WindowSize.compact => _buildCompact(context),
          WindowSize.medium => _buildMedium(context),
          WindowSize.expanded ||
          WindowSize.large =>
            _buildWide(context, windowSize),
        },
      ),
    );
  }

  /// Ponsel: navigasi masuk ke laci, inspector dibuka manual sebagai sheet.
  Widget _buildCompact(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      drawer: Drawer(
        width: context.space.sidebarExtendedWidth,
        child: sidebarBuilder(context, AppSidebarMode.drawer),
      ),
      body: workspace,
    );
  }

  /// Tablet potret: rail ikon, inspector sebagai laci kanan.
  Widget _buildMedium(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      appBar: appBar,
      endDrawer: inspector == null
          ? null
          : Drawer(
              width: context.space.inspectorWidth,
              child: inspector,
            ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          sidebarBuilder(context, AppSidebarMode.rail),
          AppDivider.vertical(color: colors.borderDefault),
          Expanded(child: workspace),
        ],
      ),
    );
  }

  /// Tablet lanskap dan desktop: semua panel terlihat bersamaan.
  Widget _buildWide(BuildContext context, WindowSize windowSize) {
    final colors = context.colors;
    final density = context.space;

    final mode = windowSize == WindowSize.large
        ? AppSidebarMode.extended
        : AppSidebarMode.rail;

    return Scaffold(
      appBar: appBar,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                sidebarBuilder(context, mode),
                AppDivider.vertical(color: colors.borderDefault),
                Expanded(child: workspace),
                if (inspector != null) ...[
                  AppDivider.vertical(color: colors.borderDefault),
                  SizedBox(width: density.inspectorWidth, child: inspector),
                ],
              ],
            ),
          ),
          if (bottomPanel != null) ...[
            AppDivider(color: colors.borderDefault),
            bottomPanel!,
          ],
        ],
      ),
    );
  }

  /// Membuka [inspector] sebagai lembar bawah.
  ///
  /// Pada layar sempit inspector tidak muat di samping, jadi workspace harus
  /// membukanya sendiri — misalnya saat kasir menekan sebuah baris keranjang.
  /// Pada layar lebar panggilan ini tidak diperlukan karena inspector memang
  /// sudah terlihat.
  static Future<T?> openInspectorSheet<T>(
    BuildContext context, {
    required WidgetBuilder builder,
  }) {
    final density = DensityScope.of(context);

    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.85,
      ),
      builder: (sheetContext) => DensityScope(
        // Lembar bawah berada di rute terpisah, jadi scope kerapatan halaman
        // tidak ikut terbawa. Dipasang ulang di sini agar isinya tidak
        // mendadak berpindah kerapatan.
        density: density,
        child: Builder(builder: builder),
      ),
    );
  }
}
