import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../design/design.dart';
import 'barcode_input.dart';

/// Format yang dikenali pemindai kamera.
///
/// Sengaja dibatasi, tidak memakai [BarcodeFormat.all]. Membuka semua format
/// berarti kamera juga berusaha membaca QR, PDF417, dan Aztec pada setiap
/// bingkai — memperlambat deteksi dan membuka peluang salah baca pada kemasan
/// yang kebetulan bermotif. Ini daftar yang benar-benar dipakai ritel
/// Indonesia, ditambah code128/39 untuk label cetak sendiri.
const _retailFormats = <BarcodeFormat>[
  BarcodeFormat.ean13,
  BarcodeFormat.ean8,
  BarcodeFormat.upcA,
  BarcodeFormat.upcE,
  BarcodeFormat.code128,
  BarcodeFormat.code39,
  // Dipakai pada kardus/karton lusinan saat penerimaan barang.
  BarcodeFormat.itf14,
];

/// Membuka pemindai kamera dan mengembalikan barcode yang terbaca.
///
/// Mengembalikan `null` bila kasir menutup tanpa memindai apa pun.
///
/// Sebaiknya jangan dipanggil langsung — pakai [scanWithCamera] supaya hasilnya
/// melewati [AppBarcodeScope] seperti jalur wedge, dan alur setelah barcode
/// terbaca hanya ditulis satu kali.
Future<String?> showBarcodeScanner(BuildContext context) {
  return Navigator.of(context).push<String>(
    MaterialPageRoute(
      fullscreenDialog: true,
      builder: (_) => const BarcodeScannerPage(),
    ),
  );
}

/// Memindai lewat kamera lalu menyerahkan hasilnya ke [AppBarcodeScope].
///
/// Inilah yang dipanggil tombol pindai di layar kasir.
Future<void> scanWithCamera(BuildContext context) async {
  final scope = AppBarcodeScope.maybeOf(context);
  final code = await showBarcodeScanner(context);

  if (code == null) return;
  scope?.submit(code, BarcodeSource.camera);
}

/// Halaman pemindai kamera.
///
/// Halaman penuh, bukan lembar bawah: kamera butuh seluruh tinggi layar agar
/// barcode pada kemasan besar muat di dalam bingkai, dan lembar bawah yang
/// menutupi separuh layar memaksa kasir menjauhkan barang sampai di luar
/// jangkauan fokus kamera.
class BarcodeScannerPage extends StatefulWidget {
  const BarcodeScannerPage({super.key});

  @override
  State<BarcodeScannerPage> createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<BarcodeScannerPage> {
  late final MobileScannerController _controller = MobileScannerController(
    // Menolak barcode yang sama berturut-turut. Tanpa ini, satu barang yang
    // diam di depan kamera terbaca puluhan kali per detik dan masuk keranjang
    // sebanyak itu pula.
    detectionSpeed: DetectionSpeed.noDuplicates,
    formats: _retailFormats,
    facing: CameraFacing.back,
  );

  /// Menahan agar hanya pindaian pertama yang menutup halaman.
  bool _handled = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_handled) return;

    final code = capture.barcodes
        .map((barcode) => barcode.rawValue)
        .whereType<String>()
        .where((value) => value.trim().isNotEmpty)
        .firstOrNull;

    if (code == null) return;

    _handled = true;
    Navigator.of(context).pop(code.trim());
  }

  Future<void> _enterManually() async {
    final code = await showAppDialog<String>(
      context: context,
      builder: (dialogContext) => const _ManualEntryDialog(),
    );

    if (code == null || !mounted) return;
    Navigator.of(context).pop(code);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final density = context.space;

    return Scaffold(
      backgroundColor: colors.canvas,
      appBar: AppBar(
        title: const Text('Pindai barcode'),
        leading: AppIconButton(
          icon: AppIcons.close,
          tooltip: 'Batal',
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          ValueListenableBuilder<MobileScannerState>(
            valueListenable: _controller,
            builder: (context, state, _) {
              if (state.torchState == TorchState.unavailable) {
                return const SizedBox.shrink();
              }

              final isOn = state.torchState == TorchState.on;
              return AppIconButton(
                icon: isOn ? Icons.flashlight_on : Icons.flashlight_off,
                tooltip: isOn ? 'Matikan senter' : 'Nyalakan senter',
                isSelected: isOn,
                onPressed: _controller.toggleTorch,
              );
            },
          ),
          AppIconButton(
            icon: Icons.cameraswitch_outlined,
            tooltip: 'Ganti kamera',
            onPressed: _controller.switchCamera,
          ),
          SizedBox(width: density.xs),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Jendela pindai di tengah: memberi tahu kasir ke mana barang
                // harus diarahkan, sekaligus membuat mesin pembaca mengabaikan
                // barcode lain yang kebetulan ikut masuk bingkai.
                final size = constraints.biggest;
                final width = size.width * 0.8;
                final height = size.height * 0.32;
                final window = Rect.fromCenter(
                  center: size.center(Offset.zero),
                  width: width,
                  height: height,
                );

                return MobileScanner(
                  controller: _controller,
                  onDetect: _onDetect,
                  scanWindow: window,
                  errorBuilder: (context, error) => _ScannerError(
                    error: error,
                    onManualEntry: _enterManually,
                  ),
                  overlayBuilder: (context, _) => _ScanWindowOverlay(
                    window: window,
                  ),
                );
              },
            ),
          ),
          _ScannerFooter(onManualEntry: _enterManually),
        ],
      ),
    );
  }
}

/// Bingkai penanda daerah pindai.
class _ScanWindowOverlay extends StatelessWidget {
  final Rect window;

  const _ScanWindowOverlay({required this.window});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return IgnorePointer(
      child: Stack(
        children: [
          Positioned.fromRect(
            rect: window,
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(color: colors.accent, width: 2),
                borderRadius: AppRadius.rMd,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Ditampilkan saat kamera tidak bisa dipakai.
///
/// Izin ditolak bukan jalan buntu: kasir tetap harus bisa menyelesaikan
/// transaksi lewat ketik manual. Itu sebabnya jalan keluarnya selalu ada di
/// layar ini, bukan cuma pesan galat.
class _ScannerError extends StatelessWidget {
  final MobileScannerException error;
  final VoidCallback onManualEntry;

  const _ScannerError({required this.error, required this.onManualEntry});

  @override
  Widget build(BuildContext context) {
    final (title, message) = switch (error.errorCode) {
      MobileScannerErrorCode.permissionDenied => (
          'Izin kamera belum diberikan',
          'Berikan izin kamera lewat setelan perangkat, atau ketik barcode '
              'secara manual.',
        ),
      MobileScannerErrorCode.unsupported => (
          'Kamera tidak didukung',
          'Perangkat ini tidak bisa memindai lewat kamera. Pakai pemindai '
              'barcode atau ketik manual.',
        ),
      _ => (
          'Kamera gagal dijalankan',
          error.errorDetails?.message ?? 'Coba tutup lalu buka kembali.',
        ),
    };

    return Padding(
      padding: EdgeInsets.all(context.space.xl),
      child: AppErrorView(
        title: title,
        message: message,
        onRetry: null,
        action: AppButton(
          label: 'Ketik manual',
          icon: AppIcons.edit,
          onPressed: onManualEntry,
        ),
      ),
    );
  }
}

class _ScannerFooter extends StatelessWidget {
  final VoidCallback onManualEntry;

  const _ScannerFooter({required this.onManualEntry});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final density = context.space;

    return Container(
      color: colors.surface,
      padding: EdgeInsets.all(density.lg),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Arahkan barcode ke dalam bingkai',
              textAlign: TextAlign.center,
              style: context.text.dialogBody.copyWith(
                color: colors.textSecondary,
              ),
            ),
            SizedBox(height: density.sm),
            AppButton(
              label: 'Ketik barcode manual',
              icon: AppIcons.edit,
              variant: AppButtonVariant.secondary,
              isFullWidth: true,
              onPressed: onManualEntry,
            ),
          ],
        ),
      ),
    );
  }
}

/// Jalan terakhir: barcode diketik sendiri.
///
/// Selalu tersedia, karena barcode robek dan kamera berembun adalah kejadian
/// sehari-hari di toko — dan antrean tidak berhenti untuk menunggu.
class _ManualEntryDialog extends StatefulWidget {
  const _ManualEntryDialog();

  @override
  State<_ManualEntryDialog> createState() => _ManualEntryDialogState();
}

class _ManualEntryDialogState extends State<_ManualEntryDialog> {
  final _controller = TextEditingController();
  bool _hasText = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final code = _controller.text.trim();
    if (code.isEmpty) return;
    Navigator.of(context).pop(code);
  }

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      title: 'Ketik barcode',
      maxWidth: 380,
      onSubmit: _hasText ? _submit : null,
      content: AppTextField(
        controller: _controller,
        label: 'Barcode',
        hint: 'Contoh: 8991002101017',
        autofocus: true,
        isNumeric: true,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.done,
        onChanged: (value) {
          final hasText = value.trim().isNotEmpty;
          if (hasText != _hasText) setState(() => _hasText = hasText);
        },
        onSubmitted: (_) => _submit(),
      ),
      actions: [
        AppButton(
          label: 'Batal',
          variant: AppButtonVariant.secondary,
          onPressed: () => Navigator.of(context).pop(),
        ),
        AppButton(
          label: 'Gunakan',
          onPressed: _hasText ? _submit : null,
        ),
      ],
    );
  }
}
