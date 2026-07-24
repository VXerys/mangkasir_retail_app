import 'package:flutter/material.dart';

import '../../design.dart';

/// Kerangka tata letak aplikasi.
///
/// 16_Design_System.md Tahap 16.4 menolak tata letak "container 1280px ala
/// dashboard SaaS" dan meminta susunan panel seperti perangkat lunak
/// profesional (VS Code, Excel, Figma), karena POS adalah aplikasi kerja, bukan
/// situs yang dibaca sekali lalu ditinggalkan.
///
/// Susunan empat panel itu adalah bentuk **tablet lanskap**, bukan bentuk
/// universal — batas berlakunya ditetapkan §16.4 setelah perangkat sasaran
/// diperbaiki di §16.0. Di layar sempit navigasi utama turun ke bilah bawah:
///
/// | Ukuran   | Navigasi utama   | Inspector    | Bottom panel  |
/// |----------|------------------|--------------|---------------|
/// | compact  | **Bilah bawah**  | Bottom sheet | Disembunyikan |
/// | medium   | Rail ikon        | Laci kanan   | Disembunyikan |
/// | expanded | Sidebar berlabel | Kolom tetap  | Ditampilkan   |
/// | large    | Sidebar berlabel | Kolom tetap  | Ditampilkan   |
///
/// Baris `expanded` diperbaiki di Phase UI-4. Sebelumnya ia memakai rail, yang
/// bertentangan dengan tabel §16.4 — dokumen itu menetapkan sidebar berlabel
/// mulai 1024 px. Ketidakcocokan itu tidak terasa selama menu hanya berisi
/// empat tujuan rata, tetapi menjadi merusak begitu menu dikelompokkan ke
/// delapan area: rail hanya menampilkan ikon area, dan seluruh tujuan di
/// dalamnya tidak bisa dicapai. Karena §16.0 menghapus PC dari daftar perangkat
/// sasaran, ambang 1440 praktis tidak pernah tercapai — artinya sidebar
/// berlabel nyaris tidak pernah muncul di perangkat sungguhan.
///
/// Laci samping tetap ada di layar sempit, tetapi turun perannya menjadi menu
/// sekunder — ganti outlet, setelan, keluar — dan hanya muncul bila
/// [secondaryMenuBuilder] diisi.
///
/// Shell juga memasang [DensityScope] untuk seluruh subtree, sehingga setiap
/// widget di dalamnya otomatis memakai kerapatan yang sesuai perangkat tanpa
/// perlu memeriksa lebar layar sendiri-sendiri.
class AppShell extends StatelessWidget {
  /// Kolom navigasi untuk layar `medium` ke atas. Biasanya sebuah [AppSidebar].
  final Widget Function(BuildContext context, AppSidebarMode mode) sidebarBuilder;

  /// Navigasi utama untuk layar `compact`. Biasanya sebuah [AppBottomNav].
  ///
  /// Bila dibiarkan null, layar sempit jatuh kembali ke laci navigasi. Itu
  /// hanya untuk halaman yang memang tidak punya navigasi utama — halaman
  /// masuk, galeri design system — bukan pilihan yang sah untuk halaman kerja.
  final WidgetBuilder? bottomNavBuilder;

  /// Isi laci sekunder di layar `compact`: menu yang jarang disentuh.
  final WidgetBuilder? secondaryMenuBuilder;

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

  /// Kunci ke [ScaffoldState] milik shell.
  ///
  /// Diperlukan karena pemanggil membangun bilah atas dan bilah bawah dari
  /// konteksnya sendiri, yang berada **di atas** Scaffold yang dibuat di sini.
  /// `Scaffold.of(context)` dari sana tidak menemukan apa pun dan melempar —
  /// dan melemparnya baru terjadi saat tombol ditekan, bukan saat dibangun,
  /// sehingga lolos dari pandangan sampai seseorang menekannya.
  final GlobalKey<ScaffoldState>? scaffoldKey;

  const AppShell({
    super.key,
    required this.sidebarBuilder,
    required this.workspace,
    this.bottomNavBuilder,
    this.secondaryMenuBuilder,
    this.inspector,
    this.bottomPanel,
    this.appBar,
    this.densityOverride,
    this.scaffoldKey,
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
          WindowSize.expanded || WindowSize.large => _buildWide(context),
        },
      ),
    );
  }

  /// Ponsel: navigasi utama di bilah bawah, inspector dibuka manual sebagai
  /// sheet, laci hanya menampung menu sekunder.
  Widget _buildCompact(BuildContext context) {
    final bottomNav = bottomNavBuilder;

    return Scaffold(
      key: scaffoldKey,
      appBar: appBar,
      // Papan ketik layar tidak boleh mendorong bilah navigasi ke atas isian
      // yang sedang diketik. Scaffold mengubah ukuran body untuk isiannya, dan
      // bilah bawah ikut naik kalau dibiarkan — jadi ia disembunyikan selama
      // papan ketik terbuka.
      bottomNavigationBar: bottomNav == null ||
              MediaQuery.viewInsetsOf(context).bottom > 0
          ? null
          : bottomNav(context),
      drawer: switch ((secondaryMenuBuilder, bottomNav)) {
        // Ada menu sekunder: laci berisi itu.
        (final builder?, _) => Drawer(
            width: context.space.sidebarExtendedWidth,
            child: builder(context),
          ),
        // Tidak ada bilah bawah sama sekali: laci kembali memikul navigasi
        // utama, supaya halaman tanpa bilah bawah tidak kehilangan jalan.
        (null, null) => Drawer(
            width: context.space.sidebarExtendedWidth,
            child: sidebarBuilder(context, AppSidebarMode.drawer),
          ),
        _ => null,
      },
      body: workspace,
    );
  }

  /// Tablet potret: rail ikon, inspector sebagai laci kanan.
  Widget _buildMedium(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      key: scaffoldKey,
      appBar: appBar,
      // Rail hanya memuat ikon area; seluruh tujuan di dalamnya tidak terlihat.
      // Tanpa laci ini, tablet potret kehilangan akses ke sebagian besar
      // halaman aplikasi — bukan menyembunyikannya, benar-benar memutusnya.
      drawer: Drawer(
        width: context.space.sidebarExtendedWidth,
        child: sidebarBuilder(context, AppSidebarMode.drawer),
      ),
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

  /// Tablet lanskap: semua panel terlihat bersamaan, navigasi berlabel penuh.
  Widget _buildWide(BuildContext context) {
    final colors = context.colors;
    final density = context.space;

    return Scaffold(
      key: scaffoldKey,
      appBar: appBar,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                sidebarBuilder(context, AppSidebarMode.extended),
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
