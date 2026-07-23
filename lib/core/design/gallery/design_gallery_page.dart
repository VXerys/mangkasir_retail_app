import 'package:flutter/material.dart';

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
