import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../router/app_nav_tree.dart';
import '../../scanner/barcode_input.dart';
import '../../scanner/barcode_scanner_sheet.dart';
import '../../session/app_role.dart';
import '../../session/dev_session_repository.dart';
import '../../session/session_scope.dart';
import '../../utils/currency_formatter.dart';
import '../../utils/date_formatter.dart';
import '../../utils/number_formatter.dart';
import '../design.dart';

/// Galeri hidup design system.
///
/// Halaman ini adalah alat verifikasi utama Phase UI-0. Kalau ada token yang
/// kontrasnya kurang, angka yang tidak sejajar, atau kerapatan yang tidak
/// berubah, ketahuannya di sini — bukan setelah sepuluh halaman disusun di
/// atas fondasi yang salah.
///
/// Hanya terdaftar pada build debug (lihat `app_router.dart`).
class DesignGalleryPage extends StatelessWidget {
  /// Mode tema yang sedang aktif, untuk menyorot posisi sakelar.
  ///
  /// Sakelar tema hanya muncul bila [themeMode] dan [onThemeModeChanged]
  /// keduanya diisi. Galeri sengaja tidak membaca `ThemeCubit` sendiri:
  /// halaman ini harus tetap bisa dirender tanpa DI apa pun — itu yang
  /// menjadikannya uji asap yang murah. Perakitannya dilakukan di
  /// `app_router.dart`.
  final ThemeMode? themeMode;

  final ValueChanged<ThemeMode>? onThemeModeChanged;

  const DesignGalleryPage({
    super.key,
    this.themeMode,
    this.onThemeModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.canvas,
      appBar: AppBar(
        title: const Text('Design System — MangRitel'),
        actions: [
          if (themeMode != null && onThemeModeChanged != null)
            Center(
              child: _ThemeSwitch(
                current: themeMode!,
                onChanged: onThemeModeChanged!,
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Center(
              child: AppBadge(
                label: context.windowSize.name,
                color: colors.info,
                icon: AppIcons.info,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(context.space.xl),
        children: const [
          _Section(
            title: 'Kerapatan',
            note: 'Berubah otomatis mengikuti lebar jendela. '
                'Ubah ukuran jendela untuk melihat efeknya.',
            child: _DensitySection(),
          ),
          _Section(
            title: 'Warna semantik',
            note: 'Feature hanya menyebut peran, tidak pernah menyebut rona.',
            child: _ColorSection(),
          ),
          _Section(
            title: 'Tipografi',
            note: 'Disusun per peran pemakaian, bukan tingkat judul.',
            child: _TypographySection(),
          ),
          _Section(
            title: 'Angka tabular',
            note: 'Kolom kanan harus sejajar sempurna. Kalau meleset, '
                'berkas font belum ada di assets/fonts/.',
            child: _NumericSection(),
          ),
          _Section(
            title: 'Tombol',
            child: _ButtonSection(),
          ),
          _Section(
            title: 'Isian',
            child: _FieldSection(),
          ),
          _Section(
            title: 'Kontrol pilihan',
            note: 'Digambar sendiri, bukan Checkbox/Switch Material — '
                'keduanya mengambil warna dari ColorScheme.',
            child: _ToggleSection(),
          ),
          _Section(
            title: 'Daftar pilihan dan tanggal',
            note: 'Popover menempel pada isian dan bisa dijelajahi '
                'dengan panah lalu Enter.',
            child: _SelectSection(),
          ),
          _Section(
            title: 'Angka dan uang',
            child: _NumberSection(),
          ),
          _Section(
            title: 'Tabel data',
            note: 'Perkecil jendela sampai di bawah 600 px: tabel berubah '
                'menjadi daftar kartu, bukan menggeser mendatar.',
            child: _TableSection(),
          ),
          _Section(
            title: 'Tab',
            note: 'Identitas tab memakai id, bukan indeks — supaya tab yang '
                'ditutup tidak menggeser tab lain.',
            child: _TabsSection(),
          ),
          _Section(
            title: 'Pencarian dan penyaring',
            child: _FilterSection(),
          ),
          _Section(
            title: 'Lapisan mengambang',
            note: 'Dialog, laci, dan toast. Semuanya memakai tirai '
                'colors.overlay dan tunduk pada plafon gerak 220 ms.',
            child: _OverlaySection(),
          ),
          _Section(
            title: 'Navigasi bawah',
            note: 'Navigasi utama di layar sempit. Laci samping turun '
                'perannya jadi menu sekunder — §16.4.',
            child: _BottomNavSection(),
          ),
          _Section(
            title: 'Gestur',
            note: 'Geser baris ke kiri untuk memunculkan aksi. '
                'Tarik daftar ke bawah untuk memicu sinkronisasi.',
            child: _GestureSection(),
          ),
          _Section(
            title: 'Pindai barcode',
            note: 'Kamera dan pemindai HID bermuara ke satu penangan. '
                'Coba ketik cepat lalu Enter untuk meniru pemindai.',
            child: _ScannerSection(),
          ),
          _Section(
            title: 'Pintasan papan ketik',
            note: 'Lambang pintasan hanya muncul bila papan ketik fisik '
                'terdeteksi. Tekan F2 atau ESC untuk membuktikannya.',
            child: _ShortcutSection(),
          ),
          _Section(
            title: 'Sesi & hak akses',
            note: 'Ganti peran, lalu perhatikan navigasi menyusun ulang '
                'dirinya. Izin tiap peran disalin apa adanya dari tabel '
                'role_permissions di Supabase.',
            child: _SessionSection(),
          ),
          _Section(
            title: 'Jejak navigasi',
            note: 'Ruas terakhir tidak bisa ditekan. Di layar sempit ruas '
                'tengah menciut menjadi satu tombol.',
            child: _BreadcrumbSection(),
          ),
          _Section(
            title: 'Bilah global',
            note: 'Slot Cari, Notifikasi, dan status sync sengaja kosong di '
                'Phase UI-4 — tombol mati lebih buruk daripada tidak ada.',
            child: _TopBarSection(),
          ),
          _Section(
            title: 'Lencana status',
            child: _BadgeSection(),
          ),
          _Section(
            title: 'Keadaan kosong dan galat',
            child: _StateSection(),
          ),
          _Section(
            title: 'Ikon domain',
            note: 'Dinamai menurut konsep bisnis, bukan bentuk gambarnya.',
            child: _IconSection(),
          ),
          _Section(
            title: 'Sudut dan ketinggian',
            note: 'Pemisahan memakai garis. Bayangan hanya untuk lapisan '
                'yang benar-benar melayang.',
            child: _SurfaceSection(),
          ),
        ],
      ),
    );
  }
}

/// Sakelar tiga posisi: Sistem / Terang / Gelap.
///
/// Inilah yang menjadikan galeri alat QA, bukan sekadar katalog: setiap token
/// di halaman ini bisa diperiksa pada kedua tema tanpa mengubah setelan sistem
/// operasi lebih dulu.
class _ThemeSwitch extends StatelessWidget {
  final ThemeMode current;
  final ValueChanged<ThemeMode> onChanged;

  const _ThemeSwitch({required this.current, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    Widget option(ThemeMode mode, IconData icon, String tooltip) {
      final isSelected = mode == current;

      return Tooltip(
        message: tooltip,
        child: InkWell(
          onTap: () => onChanged(mode),
          borderRadius: AppRadius.rSm,
          child: Container(
            width: 34,
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected ? colors.accentSubtle : Colors.transparent,
              borderRadius: AppRadius.rSm,
            ),
            child: Icon(
              icon,
              size: 16,
              color: isSelected ? colors.accent : colors.textTertiary,
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: colors.surfaceSubtle,
        borderRadius: AppRadius.rSm,
        border: Border.all(color: colors.borderDefault),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          option(ThemeMode.system, AppIcons.themeSystem, 'Ikuti sistem'),
          option(ThemeMode.light, AppIcons.themeLight, 'Terang'),
          option(ThemeMode.dark, AppIcons.themeDark, 'Gelap'),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Kerangka
// ---------------------------------------------------------------------------

class _Section extends StatelessWidget {
  final String title;
  final String? note;
  final Widget child;

  const _Section({required this.title, this.note, required this.child});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final density = context.space;

    return Padding(
      padding: EdgeInsets.only(bottom: density.xl),
      child: AppPanel(
        header: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: context.text.toolbarTitle),
            if (note != null) ...[
              SizedBox(height: density.xs),
              Text(
                note!,
                style: context.text.formHelper.copyWith(
                  color: colors.textTertiary,
                ),
              ),
            ],
          ],
        ),
        padding: EdgeInsets.all(density.lg),
        child: child,
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;

  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.space.sm),
      child: Text(
        text,
        style: context.text.tableHeader.copyWith(
          color: context.colors.textTertiary,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Kerapatan
// ---------------------------------------------------------------------------

class _DensitySection extends StatelessWidget {
  const _DensitySection();

  @override
  Widget build(BuildContext context) {
    final active = context.space;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Aktif: ${active.level.name} · baris ${active.rowHeight.toInt()}px · '
          'kontrol ${active.controlHeight.toInt()}px · '
          'sentuh ${active.minTouchTarget.toInt()}px',
          style: context.text.tableCellEmphasis,
        ),
        SizedBox(height: active.lg),
        Wrap(
          spacing: active.lg,
          runSpacing: active.lg,
          children: const [
            _DensityPreview(AppDensity.compact),
            _DensityPreview(AppDensity.normal),
            _DensityPreview(AppDensity.comfortable),
          ],
        ),
      ],
    );
  }
}

class _DensityPreview extends StatelessWidget {
  final AppDensity density;

  const _DensityPreview(this.density);

  @override
  Widget build(BuildContext context) {
    return DensityScope(
      density: density,
      child: Builder(
        builder: (context) => SizedBox(
          width: 260,
          child: AppPanel(
            header: Text(
              density.level.name,
              style: context.text.tableCellEmphasis,
            ),
            padding: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final row in const [
                  ('Indomie Goreng', 3500.0),
                  ('Aqua 600ml', 4000.0),
                  ('Teh Botol Sosro', 5500.0),
                ])
                  SizedBox(
                    height: density.rowHeight,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: density.md),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              row.$1,
                              style: context.text.tableCell,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            CurrencyFormatter.plain(row.$2),
                            style: context.text.tableCellNumeric,
                          ),
                        ],
                      ),
                    ),
                  ),
                Padding(
                  padding: EdgeInsets.all(density.md),
                  child: AppButton(
                    label: 'Bayar',
                    isFullWidth: true,
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Warna
// ---------------------------------------------------------------------------

class _ColorSection extends StatelessWidget {
  const _ColorSection();

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final density = context.space;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _Label('PERMUKAAN & GARIS'),
        Wrap(
          spacing: density.sm,
          runSpacing: density.sm,
          children: [
            _Swatch('canvas', c.canvas),
            _Swatch('surface', c.surface),
            _Swatch('surfaceSubtle', c.surfaceSubtle),
            _Swatch('surfaceHover', c.surfaceHover),
            _Swatch('borderSubtle', c.borderSubtle),
            _Swatch('borderDefault', c.borderDefault),
            _Swatch('borderStrong', c.borderStrong),
            _Swatch('borderFocus', c.borderFocus),
          ],
        ),
        SizedBox(height: density.lg),
        const _Label('TEKS — periksa kontrasnya di sini'),
        Container(
          padding: EdgeInsets.all(density.md),
          color: c.surfaceSubtle,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('textPrimary — isi utama',
                  style: context.text.tableCell.copyWith(color: c.textPrimary)),
              Text('textSecondary — label',
                  style:
                      context.text.tableCell.copyWith(color: c.textSecondary)),
              Text('textTertiary — metadata',
                  style: context.text.tableCell.copyWith(color: c.textTertiary)),
              Text('textDisabled — nonaktif',
                  style: context.text.tableCell.copyWith(color: c.textDisabled)),
            ],
          ),
        ),
        SizedBox(height: density.lg),
        const _Label('INTERAKTIF'),
        Wrap(
          spacing: density.sm,
          runSpacing: density.sm,
          children: [
            _Swatch('accent', c.accent),
            _Swatch('accentHover', c.accentHover),
            _Swatch('accentPressed', c.accentPressed),
            _Swatch('accentSubtle', c.accentSubtle),
          ],
        ),
        SizedBox(height: density.lg),
        const _Label('AKSEN DOMAIN — hanya identitas modul, bukan aksi'),
        Wrap(
          spacing: density.sm,
          runSpacing: density.sm,
          children: [
            _Swatch('sales', c.domainSales),
            _Swatch('inventory', c.domainInventory),
            _Swatch('finance', c.domainFinance),
            _Swatch('purchase', c.domainPurchase),
          ],
        ),
      ],
    );
  }
}

class _Swatch extends StatelessWidget {
  final String name;
  final Color color;

  const _Swatch(this.name, this.color);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 116,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 36,
            decoration: BoxDecoration(
              color: color,
              borderRadius: AppRadius.rSm,
              border: Border.all(color: context.colors.borderDefault),
            ),
          ),
          SizedBox(height: context.space.xs),
          Text(name, style: context.text.formHelper),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Tipografi
// ---------------------------------------------------------------------------

class _TypographySection extends StatelessWidget {
  const _TypographySection();

  @override
  Widget build(BuildContext context) {
    final t = context.text;

    final samples = <(String, TextStyle)>[
      ('toolbarTitle', t.toolbarTitle),
      ('toolbarLabel', t.toolbarLabel),
      ('tableHeader', t.tableHeader),
      ('tableCell', t.tableCell),
      ('tableCellEmphasis', t.tableCellEmphasis),
      ('tableCellNumeric', t.tableCellNumeric),
      ('formLabel', t.formLabel),
      ('formInput', t.formInput),
      ('formHelper', t.formHelper),
      ('kpiLabel', t.kpiLabel),
      ('kpiValue', t.kpiValue),
      ('dialogTitle', t.dialogTitle),
      ('dialogBody', t.dialogBody),
      ('receiptHeader', t.receiptHeader),
      ('receiptLine', t.receiptLine),
      ('receiptTotal', t.receiptTotal),
      ('badge', t.badge),
      ('buttonLabel', t.buttonLabel),
      ('priceRegular', t.priceRegular),
      ('priceLarge', t.priceLarge),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final (name, style) in samples)
          Padding(
            padding: EdgeInsets.only(bottom: context.space.sm),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                SizedBox(
                  width: 150,
                  child: Text(
                    name,
                    style: context.text.formHelper.copyWith(
                      color: context.colors.textTertiary,
                    ),
                  ),
                ),
                Expanded(
                  child: Text('Rp 1.234.567 — Indomie Goreng', style: style),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Angka
// ---------------------------------------------------------------------------

class _NumericSection extends StatelessWidget {
  const _NumericSection();

  @override
  Widget build(BuildContext context) {
    final density = context.space;
    final now = DateTime.now();

    const rows = <(String, double, double)>[
      ('Indomie Goreng', 3500, 1),
      ('Aqua 600ml', 4000, 12),
      ('Teh Botol Sosro', 5500, 111),
      ('Beras Ramos 5kg', 68000, 2.5),
      ('Minyak Goreng 2L', 111999, 9),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: density.rowHeight,
          child: Row(
            children: [
              Expanded(child: Text('PRODUK', style: context.text.tableHeader)),
              SizedBox(
                width: 90,
                child: Text('QTY',
                    textAlign: TextAlign.right,
                    style: context.text.tableHeader),
              ),
              SizedBox(
                width: 120,
                child: Text('HARGA',
                    textAlign: TextAlign.right,
                    style: context.text.tableHeader),
              ),
              SizedBox(
                width: 130,
                child: Text('SUBTOTAL',
                    textAlign: TextAlign.right,
                    style: context.text.tableHeader),
              ),
            ],
          ),
        ),
        const AppDivider(),
        for (final (name, price, qty) in rows)
          SizedBox(
            height: density.rowHeight,
            child: Row(
              children: [
                Expanded(child: Text(name, style: context.text.tableCell)),
                SizedBox(
                  width: 90,
                  child: Text(
                    NumberFormatter.quantity(qty),
                    textAlign: TextAlign.right,
                    style: context.text.tableCellNumeric,
                  ),
                ),
                SizedBox(
                  width: 120,
                  child: Text(
                    CurrencyFormatter.plain(price),
                    textAlign: TextAlign.right,
                    style: context.text.tableCellNumeric,
                  ),
                ),
                SizedBox(
                  width: 130,
                  child: Text(
                    CurrencyFormatter.plain(price * qty),
                    textAlign: TextAlign.right,
                    style: context.text.tableCellNumeric,
                  ),
                ),
              ],
            ),
          ),
        SizedBox(height: density.lg),
        const _Label('FORMATTER'),
        Text('format   → ${CurrencyFormatter.format(1250000)}',
            style: context.text.receiptLine),
        Text('compact  → ${CurrencyFormatter.compact(1250000)} · '
            '${CurrencyFormatter.compact(2400000000)} · '
            '${CurrencyFormatter.compact(8500)}',
            style: context.text.receiptLine),
        Text('percent  → ${NumberFormatter.percent(12.5)} · '
            '${NumberFormatter.percent(10)}',
            style: context.text.receiptLine),
        Text('tanggal  → ${DateFormatter.dateWithWeekday(now)}',
            style: context.text.receiptLine),
        Text('struk    → ${DateFormatter.receipt(now)}',
            style: context.text.receiptLine),
        Text('relatif  → '
            '${DateFormatter.relative(now.subtract(const Duration(minutes: 7)))}',
            style: context.text.receiptLine),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Komponen
// ---------------------------------------------------------------------------

class _ButtonSection extends StatelessWidget {
  const _ButtonSection();

  @override
  Widget build(BuildContext context) {
    final density = context.space;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _Label('VARIAN'),
        Wrap(
          spacing: density.sm,
          runSpacing: density.sm,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            AppButton(label: 'Bayar', onPressed: () {}),
            AppButton(
              label: 'Batal',
              variant: AppButtonVariant.secondary,
              onPressed: () {},
            ),
            AppButton(
              label: 'Filter',
              icon: AppIcons.filter,
              variant: AppButtonVariant.ghost,
              onPressed: () {},
            ),
            AppButton(
              label: 'Hapus',
              icon: AppIcons.delete,
              variant: AppButtonVariant.danger,
              onPressed: () {},
            ),
          ],
        ),
        SizedBox(height: density.lg),
        const _Label('UKURAN & KEADAAN'),
        Wrap(
          spacing: density.sm,
          runSpacing: density.sm,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            AppButton(
              label: 'Small',
              size: AppButtonSize.small,
              onPressed: () {},
            ),
            AppButton(label: 'Medium', onPressed: () {}),
            AppButton(
              label: 'Large',
              size: AppButtonSize.large,
              onPressed: () {},
            ),
            const AppButton(label: 'Nonaktif', onPressed: null),
            AppButton(label: 'Memproses', isLoading: true, onPressed: () {}),
            AppButton(
              label: 'Dengan ikon',
              icon: AppIcons.scanBarcode,
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }
}

class _FieldSection extends StatelessWidget {
  const _FieldSection();

  @override
  Widget build(BuildContext context) {
    final density = context.space;

    return Wrap(
      spacing: density.lg,
      runSpacing: density.lg,
      children: [
        SizedBox(
          width: 280,
          child: AppTextField(
            label: 'Cari produk',
            hint: 'Nama, SKU, atau barcode',
            prefixIcon: AppIcons.search,
            helperText: 'Tekan F2 untuk melompat ke sini',
            onChanged: (_) {},
          ),
        ),
        const SizedBox(
          width: 200,
          child: AppTextField(
            label: 'Harga jual',
            hint: '0',
            isNumeric: true,
            keyboardType: TextInputType.number,
          ),
        ),
        const SizedBox(
          width: 240,
          child: AppTextField(
            label: 'Barcode',
            errorText: 'Barcode sudah dipakai produk lain',
            isNumeric: true,
          ),
        ),
        const SizedBox(
          width: 200,
          child: AppTextField(
            label: 'Nonaktif',
            hint: 'Tidak bisa diubah',
            enabled: false,
          ),
        ),
      ],
    );
  }
}

class _BadgeSection extends StatelessWidget {
  const _BadgeSection();

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final density = context.space;

    return Wrap(
      spacing: density.sm,
      runSpacing: density.sm,
      children: [
        AppBadge(label: 'Lunas', color: c.success, icon: AppIcons.success),
        AppBadge(label: 'Batal', color: c.danger, icon: AppIcons.danger),
        AppBadge(label: 'Menunggu', color: c.warning, icon: AppIcons.warning),
        AppBadge(label: 'Informasi', color: c.info, icon: AppIcons.info),
        AppBadge(label: 'Stok habis', color: c.stockOut, showDot: true),
        AppBadge(label: 'Stok menipis', color: c.stockLow, showDot: true),
        AppBadge(label: 'Stok aman', color: c.stockOk, showDot: true),
        AppBadge(
          label: '12 belum tersinkron',
          color: c.syncPending,
          icon: AppIcons.syncPending,
        ),
        AppBadge(
          label: 'Sync gagal',
          color: c.syncFailed,
          icon: AppIcons.syncFailed,
        ),
        AppBadge(label: 'Offline', color: c.offline, icon: AppIcons.offline),
      ],
    );
  }
}

class _StateSection extends StatelessWidget {
  const _StateSection();

  @override
  Widget build(BuildContext context) {
    final density = context.space;

    return Wrap(
      spacing: density.lg,
      runSpacing: density.lg,
      children: [
        SizedBox(
          width: 300,
          height: 240,
          child: AppPanel(
            child: AppEmptyState(
              title: 'Belum ada produk',
              message: 'Tambah produk pertama untuk mulai berjualan.',
              icon: AppIcons.product,
              action: AppButton(
                label: 'Tambah Produk',
                icon: AppIcons.add,
                size: AppButtonSize.small,
                onPressed: () {},
              ),
            ),
          ),
        ),
        SizedBox(
          width: 320,
          height: 240,
          child: AppPanel(
            child: AppErrorView(
              message: 'Tidak bisa memuat daftar produk.',
              detail: 'LocalFailure: no such table: product_table',
              onRetry: () {},
            ),
          ),
        ),
        SizedBox(
          width: 260,
          height: 240,
          child: AppPanel(
            header: Text('Memuat', style: context.text.tableCellEmphasis),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = 0; i < 5; i++)
                  Padding(
                    padding: EdgeInsets.only(bottom: density.sm),
                    child: AppSkeleton.text(width: 200.0 - i * 18),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _IconSection extends StatelessWidget {
  const _IconSection();

  @override
  Widget build(BuildContext context) {
    const icons = <(String, IconData)>[
      ('pos', AppIcons.pos),
      ('transaction', AppIcons.transaction),
      ('payment', AppIcons.payment),
      ('discount', AppIcons.discount),
      ('product', AppIcons.product),
      ('category', AppIcons.category),
      ('warehouse', AppIcons.warehouse),
      ('stockAdjustment', AppIcons.stockAdjustment),
      ('stockTransfer', AppIcons.stockTransfer),
      ('stockOpname', AppIcons.stockOpname),
      ('movementHistory', AppIcons.movementHistory),
      ('supplier', AppIcons.supplier),
      ('purchaseOrder', AppIcons.purchaseOrder),
      ('receiving', AppIcons.receiving),
      ('customer', AppIcons.customer),
      ('cashSession', AppIcons.cashSession),
      ('reporting', AppIcons.reporting),
      ('syncPending', AppIcons.syncPending),
      ('syncFailed', AppIcons.syncFailed),
      ('offline', AppIcons.offline),
      ('scanBarcode', AppIcons.scanBarcode),
      ('printReceipt', AppIcons.printReceipt),
    ];

    final density = context.space;

    return Wrap(
      spacing: density.sm,
      runSpacing: density.sm,
      children: [
        for (final (name, icon) in icons)
          SizedBox(
            width: 132,
            child: Row(
              children: [
                Icon(icon, size: 18, color: context.colors.textSecondary),
                SizedBox(width: density.xs),
                Expanded(
                  child: Text(
                    name,
                    overflow: TextOverflow.ellipsis,
                    style: context.text.formHelper,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _SurfaceSection extends StatelessWidget {
  const _SurfaceSection();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final density = context.space;
    final elevation = context.elevation;

    Widget box(String label, BorderRadius radius, List<BoxShadow> shadow) {
      return Container(
        width: 128,
        height: 64,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          // Kotak melayang memakai surfaceRaised, bukan surface. Di tema gelap
          // justru permukaan yang lebih terang inilah pemisah utamanya —
          // bayangan hanya menegaskan.
          color: shadow.isEmpty ? colors.surface : colors.surfaceRaised,
          borderRadius: radius,
          border: Border.all(color: colors.borderDefault),
          boxShadow: shadow,
        ),
        child: Text(label, style: context.text.formHelper),
      );
    }

    return Wrap(
      spacing: density.lg,
      runSpacing: density.lg,
      children: [
        box('xs · badge', AppRadius.rXs, elevation.flat),
        box('sm · kontrol', AppRadius.rSm, elevation.flat),
        box('md · panel', AppRadius.rMd, elevation.flat),
        box('lg · popover', AppRadius.rLg, elevation.popover),
        box('lg · dialog', AppRadius.rLg, elevation.dialog),
        box('drag', AppRadius.rMd, elevation.drag),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Komponen UI-2
// ---------------------------------------------------------------------------

class _ToggleSection extends StatefulWidget {
  const _ToggleSection();

  @override
  State<_ToggleSection> createState() => _ToggleSectionState();
}

class _ToggleSectionState extends State<_ToggleSection> {
  bool _active = true;
  bool _printReceipt = false;
  bool? _selectAll;
  String _payment = 'tunai';

  @override
  Widget build(BuildContext context) {
    final density = context.space;

    return Wrap(
      spacing: density.xl,
      runSpacing: density.lg,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const _Label('KOTAK CENTANG'),
            AppCheckbox(
              value: _active,
              label: 'Produk aktif',
              helperText: 'Muncul di layar kasir',
              onChanged: (value) => setState(() => _active = value),
            ),
            AppCheckbox(
              value: _selectAll,
              tristate: true,
              label: 'Pilih semua baris',
              helperText: 'Keadaan setengah dipakai header tabel',
              onChanged: (value) => setState(() => _selectAll = value),
            ),
            const AppCheckbox(
              value: false,
              label: 'Nonaktif',
              onChanged: null,
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const _Label('PILIHAN TUNGGAL'),
            AppRadioGroup<String>(
              value: _payment,
              options: const [
                ('tunai', 'Tunai'),
                ('qris', 'QRIS'),
                ('transfer', 'Transfer bank'),
              ],
              onChanged: (value) => setState(() => _payment = value),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const _Label('SAKELAR'),
            AppSwitch(
              value: _printReceipt,
              label: 'Cetak struk otomatis',
              helperText: 'Berlaku seketika, tanpa tombol Simpan',
              onChanged: (value) => setState(() => _printReceipt = value),
            ),
            const AppSwitch(
              value: true,
              label: 'Nonaktif',
              onChanged: null,
            ),
          ],
        ),
      ],
    );
  }
}

class _SelectSection extends StatefulWidget {
  const _SelectSection();

  @override
  State<_SelectSection> createState() => _SelectSectionState();
}

class _SelectSectionState extends State<_SelectSection> {
  String? _category;
  String? _product;
  DateTime? _date = DateTime.now();
  DateTime? _start;
  DateTime? _end;

  @override
  Widget build(BuildContext context) {
    final density = context.space;

    return Wrap(
      spacing: density.lg,
      runSpacing: density.lg,
      children: [
        SizedBox(
          width: 240,
          child: AppSelect<String>(
            label: 'Kategori',
            value: _category,
            options: const [
              AppSelectOption(value: 'minuman', label: 'Minuman'),
              AppSelectOption(value: 'makanan', label: 'Makanan'),
              AppSelectOption(
                value: 'rokok',
                label: 'Rokok',
                description: 'Perlu izin khusus',
                enabled: false,
              ),
            ],
            onChanged: (value) => setState(() => _category = value),
          ),
        ),
        SizedBox(
          width: 280,
          child: AppSelect<String>(
            label: 'Produk',
            hint: 'Cari lalu pilih',
            searchable: true,
            prefixIcon: AppIcons.product,
            value: _product,
            options: const [
              AppSelectOption(
                value: 'p1',
                label: 'Indomie Goreng',
                description: 'SKU-0001',
              ),
              AppSelectOption(
                value: 'p2',
                label: 'Teh Botol Sosro 350ml',
                description: 'SKU-0002',
              ),
              AppSelectOption(
                value: 'p3',
                label: 'Aqua 600ml',
                description: 'SKU-0003',
              ),
            ],
            onChanged: (value) => setState(() => _product = value),
          ),
        ),
        SizedBox(
          width: 220,
          child: AppDateField(
            label: 'Tanggal transaksi',
            value: _date,
            onChanged: (value) => setState(() => _date = value),
            onCleared: () => setState(() => _date = null),
          ),
        ),
        SizedBox(
          width: 360,
          child: AppDateRangeField(
            label: 'Periode laporan',
            start: _start,
            end: _end,
            onStartChanged: (value) => setState(() => _start = value),
            onEndChanged: (value) => setState(() => _end = value),
          ),
        ),
      ],
    );
  }
}

class _NumberSection extends StatefulWidget {
  const _NumberSection();

  @override
  State<_NumberSection> createState() => _NumberSectionState();
}

class _NumberSectionState extends State<_NumberSection> {
  int _qty = 2;
  double _price = 15000;

  @override
  Widget build(BuildContext context) {
    final density = context.space;

    return Wrap(
      spacing: density.lg,
      runSpacing: density.lg,
      crossAxisAlignment: WrapCrossAlignment.start,
      children: [
        AppNumberInput(
          label: 'Kuantitas',
          value: _qty,
          min: 1,
          max: 99,
          suffix: 'pcs',
          width: 180,
          onChanged: (value) => setState(() => _qty = value),
        ),
        SizedBox(
          width: 220,
          child: AppCurrencyInput(
            label: 'Harga jual',
            value: _price,
            helperText: 'Terformat sambil diketik',
            onChanged: (value) => setState(() => _price = value),
          ),
        ),
        SizedBox(
          width: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const _Label('SUBTOTAL'),
              Text(
                CurrencyFormatter.format(_qty * _price),
                style: context.text.priceLarge,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Baris contoh untuk tabel galeri.
class _DemoRow {
  final String id;
  final String name;
  final String sku;
  final int stock;
  final double price;

  const _DemoRow(this.id, this.name, this.sku, this.stock, this.price);
}

class _TableSection extends StatefulWidget {
  const _TableSection();

  @override
  State<_TableSection> createState() => _TableSectionState();
}

class _TableSectionState extends State<_TableSection> {
  static const _all = [
    _DemoRow('1', 'Indomie Goreng', 'SKU-0001', 120, 3500),
    _DemoRow('2', 'Teh Botol Sosro 350ml', 'SKU-0002', 8, 5000),
    _DemoRow('3', 'Aqua 600ml', 'SKU-0003', 0, 4000),
    _DemoRow('4', 'Kopi Kapal Api Sachet', 'SKU-0004', 240, 1500),
    _DemoRow('5', 'Beras Ramos 5kg', 'SKU-0005', 15, 68000),
    _DemoRow('6', 'Minyak Goreng 1L', 'SKU-0006', 42, 17500),
  ];

  AppSortState _sort = const AppSortState('name');
  Set<Object> _selected = {};
  int _page = 1;
  int _pageSize = 25;

  List<_DemoRow> get _sorted {
    final rows = [..._all];
    rows.sort((a, b) {
      final result = switch (_sort.columnId) {
        'stock' => a.stock.compareTo(b.stock),
        'price' => a.price.compareTo(b.price),
        _ => a.name.compareTo(b.name),
      };
      return _sort.ascending ? result : -result;
    });
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return SizedBox(
      height: 320,
      child: AppDataTable<_DemoRow>(
        rows: _sorted,
        rowId: (row) => row.id,
        sort: _sort,
        onSortChanged: (sort) => setState(() => _sort = sort),
        selectedIds: _selected,
        onSelectionChanged: (next) => setState(() => _selected = next),
        onRowTap: (_) {},
        minWidth: 720,
        toolbar: Row(
          children: [
            Text('Produk', style: context.text.toolbarTitle),
            const Spacer(),
            AppButton(
              label: 'Tambah',
              icon: AppIcons.add,
              size: AppButtonSize.small,
              onPressed: () {},
            ),
          ],
        ),
        columns: [
          AppColumn.text(
            id: 'name',
            label: 'Nama produk',
            value: (row) => row.name,
            priority: ColumnPriority.primary,
            sortable: true,
            emphasis: true,
            flex: 3,
          ),
          AppColumn.text(
            id: 'sku',
            label: 'SKU',
            value: (row) => row.sku,
            priority: ColumnPriority.detail,
            width: 120,
          ),
          AppColumn<_DemoRow>(
            id: 'status',
            label: 'Status stok',
            width: 130,
            priority: ColumnPriority.secondary,
            cell: (context, row) => AppBadge(
              label: row.stock == 0
                  ? 'Habis'
                  : row.stock < 10
                      ? 'Menipis'
                      : 'Aman',
              color: row.stock == 0
                  ? colors.stockOut
                  : row.stock < 10
                      ? colors.stockLow
                      : colors.stockOk,
              showDot: true,
            ),
          ),
          AppColumn.number(
            id: 'stock',
            label: 'Stok',
            value: (row) => NumberFormatter.count(row.stock),
            sortable: true,
            width: 90,
          ),
          AppColumn.number(
            id: 'price',
            label: 'Harga',
            value: (row) => CurrencyFormatter.plain(row.price),
            sortable: true,
            width: 120,
          ),
        ],
        footer: AppPagination(
          page: _page,
          pageSize: _pageSize,
          totalRows: _all.length,
          onPageChanged: (page) => setState(() => _page = page),
          onPageSizeChanged: (size) => setState(() {
            _pageSize = size;
            _page = 1;
          }),
        ),
      ),
    );
  }
}

class _TabsSection extends StatefulWidget {
  const _TabsSection();

  @override
  State<_TabsSection> createState() => _TabsSectionState();
}

class _TabsSectionState extends State<_TabsSection> {
  var _tabs = <AppTabItem>[
    const AppTabItem(id: 't1', label: 'Pelanggan 1', count: 3, closable: true),
    const AppTabItem(id: 't2', label: 'Pelanggan 2', count: 7, closable: true),
  ];
  String _selected = 't1';
  int _counter = 2;

  String _detailTab = 'ringkasan';

  @override
  Widget build(BuildContext context) {
    final density = context.space;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _Label('TAB DINAMIS — KERANJANG MULTI-TAB'),
        AppTabs(
          tabs: _tabs,
          selectedId: _selected,
          onSelected: (id) => setState(() => _selected = id),
          onClosed: (id) => setState(() {
            _tabs = _tabs.where((tab) => tab.id != id).toList();
            if (_selected == id && _tabs.isNotEmpty) {
              _selected = _tabs.first.id;
            }
          }),
          onAdd: () => setState(() {
            _counter++;
            final id = 't$_counter';
            _tabs = [
              ..._tabs,
              AppTabItem(id: id, label: 'Pelanggan $_counter', closable: true),
            ];
            _selected = id;
          }),
        ),
        SizedBox(height: density.lg),
        const _Label('TAB TETAP — DETAIL PRODUK'),
        AppTabs(
          selectedId: _detailTab,
          onSelected: (id) => setState(() => _detailTab = id),
          tabs: const [
            AppTabItem(id: 'ringkasan', label: 'Ringkasan'),
            AppTabItem(id: 'stok', label: 'Stok', icon: AppIcons.stock),
            AppTabItem(
              id: 'riwayat',
              label: 'Riwayat',
              icon: AppIcons.movementHistory,
            ),
          ],
        ),
      ],
    );
  }
}

class _FilterSection extends StatefulWidget {
  const _FilterSection();

  @override
  State<_FilterSection> createState() => _FilterSectionState();
}

class _FilterSectionState extends State<_FilterSection> {
  final _active = <String>{'minuman'};
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final density = context.space;

    Widget chip(String id, String label, int count) => AppFilterChip(
          label: label,
          count: count,
          selected: _active.contains(id),
          onTap: () => setState(() {
            _active.contains(id) ? _active.remove(id) : _active.add(id);
          }),
          onRemove: () => setState(() => _active.remove(id)),
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppFilterBar(
          activeCount: _active.length,
          leading: SizedBox(
            width: 260,
            child: AppSearchField(
              hint: 'Cari produk…',
              onChanged: (value) => setState(() => _query = value),
            ),
          ),
          chips: [
            chip('minuman', 'Minuman', 42),
            chip('makanan', 'Makanan', 118),
            chip('rokok', 'Rokok', 9),
          ],
          onClear: () => setState(_active.clear),
          onAdvanced: () => showAppDrawer<void>(
            context: context,
            builder: (_) => const AppDrawer(
              title: 'Filter lanjutan',
              subtitle: 'Syarat yang tidak muat sebagai chip',
              content: Text(
                'Rentang harga, tanggal masuk, supplier, dan gabungan '
                'beberapa syarat sekaligus.',
              ),
            ),
          ),
        ),
        SizedBox(height: density.md),
        Text(
          _query.isEmpty
              ? 'Kata kunci dilaporkan 300 ms setelah pengetikan berhenti.'
              : 'Kata kunci: "$_query"',
          style: context.text.formHelper.copyWith(
            color: context.colors.textTertiary,
          ),
        ),
      ],
    );
  }
}

class _OverlaySection extends StatelessWidget {
  const _OverlaySection();

  @override
  Widget build(BuildContext context) {
    final density = context.space;

    return Wrap(
      spacing: density.sm,
      runSpacing: density.sm,
      children: [
        AppButton(
          label: 'Dialog',
          variant: AppButtonVariant.secondary,
          onPressed: () => showAppDialog<void>(
            context: context,
            builder: (dialogContext) => AppDialog(
              title: 'Tambah produk',
              subtitle: 'Produk baru masuk ke outlet yang sedang aktif',
              content: const Text(
                'Isi formulir di sini. Pada layar sempit dialog ini masuk '
                'sebagai lembar dari tepi bawah.',
              ),
              onSubmit: () => Navigator.of(dialogContext).pop(),
              actions: [
                AppButton(
                  label: 'Batal',
                  variant: AppButtonVariant.secondary,
                  onPressed: () => Navigator.of(dialogContext).pop(),
                ),
                AppButton(
                  label: 'Simpan',
                  onPressed: () => Navigator.of(dialogContext).pop(),
                ),
              ],
            ),
          ),
        ),
        AppButton(
          label: 'Konfirmasi merusak',
          variant: AppButtonVariant.danger,
          onPressed: () async {
            final confirmed = await showAppConfirm(
              context: context,
              title: 'Kosongkan keranjang?',
              message: '3 item akan dihapus dari tab ini.',
              confirmLabel: 'Kosongkan',
              isDestructive: true,
            );
            if (!context.mounted) return;
            confirmed
                ? AppToast.success(context, 'Keranjang dikosongkan')
                : AppToast.info(context, 'Dibatalkan');
          },
        ),
        AppButton(
          label: 'Laci',
          variant: AppButtonVariant.secondary,
          onPressed: () => showAppDrawer<void>(
            context: context,
            builder: (drawerContext) => AppDrawer(
              title: 'Detail transaksi',
              subtitle: 'TRX-20260724-0031',
              content: const Text(
                'Masuk dari kanan pada layar lebar, dari bawah pada layar '
                'sempit.',
              ),
              actions: [
                AppButton(
                  label: 'Tutup',
                  variant: AppButtonVariant.secondary,
                  onPressed: () => Navigator.of(drawerContext).pop(),
                ),
              ],
            ),
          ),
        ),
        AppButton(
          label: 'Toast sukses',
          variant: AppButtonVariant.ghost,
          onPressed: () => AppToast.success(context, 'Transaksi tersimpan'),
        ),
        AppButton(
          label: 'Toast gagal',
          variant: AppButtonVariant.ghost,
          onPressed: () => AppToast.danger(context, 'Sinkronisasi gagal'),
        ),
        AppIconButton(
          icon: AppIcons.refresh,
          tooltip: 'Tombol ikon dengan tooltip',
          variant: AppButtonVariant.secondary,
          onPressed: () {},
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Komponen UI-3 — mobile-first
// ---------------------------------------------------------------------------

class _BottomNavSection extends StatefulWidget {
  const _BottomNavSection();

  @override
  State<_BottomNavSection> createState() => _BottomNavSectionState();
}

class _BottomNavSectionState extends State<_BottomNavSection> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    // Dibingkai selebar ponsel supaya proporsinya jujur, walaupun galeri
    // sedang dibuka di jendela lebar.
    return Align(
      alignment: Alignment.centerLeft,
      child: SizedBox(
        width: 380,
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(color: colors.borderDefault),
            borderRadius: AppRadius.rMd,
          ),
          child: ClipRRect(
            borderRadius: AppRadius.rMd,
            child: AppBottomNav(
              selectedIndex: _selected,
              items: [
                AppNavItem(
                  label: 'Kasir',
                  icon: AppIcons.pos,
                  domainColor: colors.domainSales,
                  onTap: () => setState(() => _selected = 0),
                ),
                AppNavItem(
                  label: 'Dasbor',
                  icon: AppIcons.dashboard,
                  onTap: () => setState(() => _selected = 1),
                ),
                AppNavItem(
                  label: 'Produk',
                  icon: AppIcons.product,
                  domainColor: colors.domainInventory,
                  badgeCount: 12,
                  onTap: () => setState(() => _selected = 2),
                ),
                AppNavItem(
                  label: 'Transaksi',
                  icon: AppIcons.transaction,
                  domainColor: colors.domainFinance,
                  onTap: () => setState(() => _selected = 3),
                ),
              ],
              overflowItem: AppNavItem(
                label: 'Lainnya',
                icon: AppIcons.menu,
                onTap: () {},
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GestureSection extends StatefulWidget {
  const _GestureSection();

  @override
  State<_GestureSection> createState() => _GestureSectionState();
}

class _GestureSectionState extends State<_GestureSection> {
  var _rows = <String>['Indomie Goreng', 'Teh Botol 350ml', 'Aqua 600ml'];

  Future<void> _refresh() async {
    await Future<void>.delayed(const Duration(milliseconds: 800));
    if (mounted) {
      setState(() {
        _rows = ['Indomie Goreng', 'Teh Botol 350ml', 'Aqua 600ml'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final density = context.space;

    return Align(
      alignment: Alignment.centerLeft,
      child: SizedBox(
        width: 380,
        height: 200,
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(color: colors.borderDefault),
            borderRadius: AppRadius.rMd,
          ),
          child: ClipRRect(
            borderRadius: AppRadius.rMd,
            child: AppRefreshView(
              onRefresh: _refresh,
              child: _rows.isEmpty
                  ? ListView(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(density.xl),
                          child: const AppEmptyState(
                            message: 'Semua baris terhapus. '
                                'Tarik ke bawah untuk memulihkan.',
                            compact: true,
                          ),
                        ),
                      ],
                    )
                  : ListView.separated(
                      itemCount: _rows.length,
                      separatorBuilder: (context, _) =>
                          AppDivider(color: colors.borderSubtle),
                      itemBuilder: (context, index) => AppSwipeAction(
                        key: ValueKey(_rows[index]),
                        endActions: [
                          AppSwipeActionItem(
                            label: 'Hapus',
                            icon: AppIcons.delete,
                            color: colors.danger,
                            isFullSwipeAction: true,
                            onPressed: () => setState(
                              () => _rows = [..._rows]..removeAt(index),
                            ),
                          ),
                        ],
                        startActions: [
                          AppSwipeActionItem(
                            label: 'Ubah',
                            icon: AppIcons.edit,
                            color: colors.info,
                            onPressed: () {},
                          ),
                        ],
                        child: Container(
                          color: colors.surface,
                          height: 56,
                          padding:
                              EdgeInsets.symmetric(horizontal: density.md),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  _rows[index],
                                  style: context.text.tableCellEmphasis,
                                ),
                              ),
                              Text(
                                CurrencyFormatter.format(3500),
                                style: context.text.priceRegular,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ScannerSection extends StatefulWidget {
  const _ScannerSection();

  @override
  State<_ScannerSection> createState() => _ScannerSectionState();
}

class _ScannerSectionState extends State<_ScannerSection> {
  final _scans = <BarcodeScan>[];

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final density = context.space;

    return AppBarcodeListener(
      onScan: (scan) => setState(() => _scans.insert(0, scan)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  label: 'Kolom pencarian biasa',
                  hint: 'Ketik pelan di sini — tidak terbaca sebagai barcode',
                  prefixIcon: AppIcons.search,
                  onChanged: (_) {},
                ),
              ),
              SizedBox(width: density.sm),
              // Pemindai kamera hanya ada di Android, iOS, macOS, dan web.
              // Di galeri desktop Windows, tombolnya sengaja dimatikan
              // daripada memunculkan galat plugin yang membingungkan.
              AppButton(
                label: 'Pindai kamera',
                icon: AppIcons.scanBarcode,
                onPressed: _cameraSupported
                    ? () => scanWithCamera(context)
                    : null,
              ),
            ],
          ),
          SizedBox(height: density.md),
          const _Label('HASIL PINDAIAN'),
          if (_scans.isEmpty)
            Text(
              _cameraSupported
                  ? 'Belum ada. Tekan tombol pindai, atau tiru pemindai HID '
                      'dengan mengetik cepat lalu Enter.'
                  : 'Belum ada. Kamera tidak tersedia di platform ini — '
                      'tiru pemindai HID dengan mengetik cepat lalu Enter.',
              style: context.text.formHelper
                  .copyWith(color: colors.textTertiary),
            )
          else
            Wrap(
              spacing: density.sm,
              runSpacing: density.sm,
              children: [
                for (final scan in _scans.take(6))
                  AppBadge(
                    label: '${scan.code} · ${scan.source.name}',
                    color: colors.success,
                    icon: AppIcons.check,
                  ),
              ],
            ),
        ],
      ),
    );
  }

  bool get _cameraSupported {
    if (kIsWeb) return true;
    return switch (defaultTargetPlatform) {
      TargetPlatform.android ||
      TargetPlatform.iOS ||
      TargetPlatform.macOS =>
        true,
      _ => false,
    };
  }
}

class _ShortcutSection extends StatelessWidget {
  const _ShortcutSection();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final density = context.space;

    return AppShortcuts(
      // Tidak autofocus: galeri punya banyak isian, dan merebut fokus di sini
      // akan mengganggu bagian lain halaman.
      autofocus: false,
      onSearch: () => AppToast.info(context, 'F2 — Cari produk'),
      onPay: () => AppToast.success(context, 'F4 — Bayar'),
      onPrint: () => AppToast.info(context, 'Ctrl + P — Cetak struk'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PhysicalKeyboardDetector(
            builder: (context, hasKeyboard) => Row(
              children: [
                Icon(
                  hasKeyboard ? AppIcons.check : AppIcons.info,
                  size: 14,
                  color: hasKeyboard ? colors.success.fg : colors.textTertiary,
                ),
                SizedBox(width: density.xs),
                Text(
                  hasKeyboard
                      ? 'Papan ketik fisik terdeteksi — lambang pintasan tampil.'
                      : 'Belum ada papan ketik fisik. Tekan F2, ESC, atau '
                          'panah untuk membuktikannya.',
                  style: context.text.formHelper
                      .copyWith(color: colors.textSecondary),
                ),
              ],
            ),
          ),
          SizedBox(height: density.md),
          Wrap(
            spacing: density.sm,
            runSpacing: density.sm,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              for (final (label, activator) in const [
                ('Cari produk', AppShortcutKeys.search),
                ('Bayar', AppShortcutKeys.pay),
                ('Batal', AppShortcutKeys.cancel),
                ('Cetak struk', AppShortcutKeys.print),
              ])
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: density.sm,
                    vertical: density.xs,
                  ),
                  decoration: BoxDecoration(
                    color: colors.surfaceSubtle,
                    borderRadius: AppRadius.rSm,
                    border: Border.all(color: colors.borderSubtle),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(label, style: context.text.toolbarLabel),
                      AppShortcutHint(activator: activator),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Memperlihatkan navigasi menyusun ulang dirinya menurut hak akses.
///
/// Inilah cara membuktikan RBAC tanpa autentikasi: himpunan izin tiap peran
/// disalin apa adanya dari `role_permissions` di Supabase, jadi menu yang
/// muncul di sini sama dengan menu yang nanti muncul setelah login sungguhan.
class _SessionSection extends StatefulWidget {
  const _SessionSection();

  @override
  State<_SessionSection> createState() => _SessionSectionState();
}

class _SessionSectionState extends State<_SessionSection> {
  String _role = AppRole.owner;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final density = context.space;
    final session = DevSessionRepository.sampleSession(_role);
    final areas = AppNavTree.visibleAreas(session);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _Label('Peran'),
        Wrap(
          spacing: density.sm,
          runSpacing: density.sm,
          children: [
            for (final role in AppRole.seeded)
              AppFilterChip(
                label: role,
                selected: role == _role,
                onTap: () => setState(() => _role = role),
              ),
          ],
        ),
        SizedBox(height: density.lg),
        Row(
          children: [
            AppBadge(
              label: '${areas.length} area',
              color: colors.info,
              icon: AppIcons.dashboard,
            ),
            SizedBox(width: density.sm),
            AppBadge(
              label: _role == AppRole.owner
                  ? 'bypass Owner'
                  : '${session.permissions.length} izin',
              color: _role == AppRole.owner ? colors.warning : colors.success,
              icon: AppIcons.role,
            ),
          ],
        ),
        SizedBox(height: density.lg),
        const _Label('Navigasi yang dihasilkan'),
        SizedBox(
          height: 320,
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(color: colors.borderDefault),
              borderRadius: AppRadius.rSm,
            ),
            child: SessionScope(
              session: session,
              child: AppSidebar(
                mode: AppSidebarMode.extended,
                sections: [
                  for (final area in areas)
                    AppNavSection(
                      label: area.label,
                      icon: area.icon,
                      accentColor: area.accent.resolve(colors),
                      onTap: () {},
                      items: [
                        for (final destination
                            in area.visibleDestinations(session))
                          AppNavItem(
                            label: destination.label,
                            icon: destination.icon,
                            domainColor: area.accent.resolve(colors),
                            onTap: () {},
                          ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: density.md),
        Text(
          _role == AppRole.owner
              ? 'Owner melewati seluruh pemeriksaan izin — begitu pula '
                  'public.has_permission di sisi database.'
              : 'Area dan butir yang tidak terlihat memang tidak dipegang '
                  'peran ini di role_permissions.',
          style: context.text.formHelper.copyWith(color: colors.textTertiary),
        ),
      ],
    );
  }
}

class _BreadcrumbSection extends StatelessWidget {
  const _BreadcrumbSection();

  @override
  Widget build(BuildContext context) {
    final density = context.space;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _Label('Dua ruas'),
        AppBreadcrumb(
          items: [
            AppBreadcrumbItem(label: 'Persediaan', onTap: () {}),
            const AppBreadcrumbItem(label: 'Produk'),
          ],
        ),
        SizedBox(height: density.lg),
        const _Label('Empat ruas'),
        AppBreadcrumb(
          items: [
            AppBreadcrumbItem(label: 'Persediaan', onTap: () {}),
            AppBreadcrumbItem(label: 'Produk', onTap: () {}),
            AppBreadcrumbItem(label: 'Detail produk', onTap: () {}),
            const AppBreadcrumbItem(label: 'Riwayat harga'),
          ],
        ),
        SizedBox(height: density.lg),
        const _Label('Satu ruas — sengaja tidak menghasilkan apa pun'),
        const AppBreadcrumb(items: [AppBreadcrumbItem(label: 'Dasbor')]),
      ],
    );
  }
}

class _TopBarSection extends StatelessWidget {
  const _TopBarSection();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: colors.borderDefault),
        borderRadius: AppRadius.rSm,
      ),
      child: AppTopBar(
        breadcrumbs: [
          AppBreadcrumbItem(label: 'Penjualan', onTap: () {}),
          const AppBreadcrumbItem(label: 'Transaksi'),
        ],
        outletName: 'Outlet Pusat',
        onSwitchOutlet: () {},
        onOpenAccount: () {},
      ),
    );
  }
}
