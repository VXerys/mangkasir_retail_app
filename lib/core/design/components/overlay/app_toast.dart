import 'dart:async';

import 'package:flutter/material.dart';

import '../../design.dart';

/// Peran sebuah toast. Memetakan langsung ke [SemanticColor] agar isian, garis,
/// dan ikonnya selalu satu paket yang sudah teruji kontrasnya.
enum AppToastVariant { success, danger, warning, info }

/// Umpan balik singkat yang tidak memblokir pekerjaan.
///
/// Menggantikan `SnackBar`/`ScaffoldMessenger`, yang menempel di tepi bawah
/// layar — tepat di tempat panel keranjang dan bilah total berada — dan
/// membawa tema Material sendiri.
///
/// Aturan pemakaian: toast untuk hasil yang **sudah terjadi** dan tidak
/// menuntut keputusan ("Produk tersimpan", "Sinkronisasi gagal"). Bila
/// pengguna harus memutuskan sesuatu, itu dialog, bukan toast.
///
/// ```dart
/// AppToast.success(context, 'Transaksi tersimpan');
/// AppToast.danger(context, 'Gagal terhubung ke server');
/// ```
abstract final class AppToast {
  /// Jumlah toast terlihat sekaligus. Lebih dari ini dan tumpukannya sendiri
  /// yang jadi gangguan; yang tertua digeser keluar.
  static const int maxVisible = 3;

  static void show(
    BuildContext context, {
    required String message,
    AppToastVariant variant = AppToastVariant.info,
    Duration duration = const Duration(seconds: 4),
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    final overlay = Overlay.maybeOf(context, rootOverlay: true);
    // Tanpa Overlay tidak ada tempat menggambar. Ini hanya terjadi pada widget
    // test yang merender komponen lepas tanpa MaterialApp — jangan sampai
    // membuat aplikasi ambruk karena sekadar pesan status.
    if (overlay == null) {
      assert(false, 'AppToast.show dipanggil tanpa Overlay di atasnya');
      return;
    }

    _ToastHost.of(overlay).push(
      _ToastData(
        message: message,
        variant: variant,
        duration: duration,
        actionLabel: actionLabel,
        onAction: onAction,
      ),
    );
  }

  static void success(BuildContext context, String message) =>
      show(context, message: message, variant: AppToastVariant.success);

  static void danger(BuildContext context, String message) =>
      show(context, message: message, variant: AppToastVariant.danger);

  static void warning(BuildContext context, String message) =>
      show(context, message: message, variant: AppToastVariant.warning);

  static void info(BuildContext context, String message) =>
      show(context, message: message, variant: AppToastVariant.info);

  /// Menutup seluruh toast yang sedang tampil. Dipakai saat berpindah layar
  /// agar pesan dari layar sebelumnya tidak ikut terbawa.
  static void dismissAll(BuildContext context) {
    final overlay = Overlay.maybeOf(context, rootOverlay: true);
    if (overlay == null) return;
    _ToastHost.of(overlay).clear();
  }
}

class _ToastData {
  final String message;
  final AppToastVariant variant;
  final Duration duration;
  final String? actionLabel;
  final VoidCallback? onAction;

  Timer? timer;

  /// Sudah diminta menutup; kartunya sedang menganimasikan keluar dan belum
  /// boleh dicabut dari daftar.
  bool leaving = false;

  _ToastData({
    required this.message,
    required this.variant,
    required this.duration,
    this.actionLabel,
    this.onAction,
  });
}

/// Pengelola tumpukan toast untuk satu [OverlayState].
///
/// Satu [OverlayEntry] menampung seluruh tumpukan, bukan satu entry per toast.
/// Dengan begitu urutan dan jaraknya diatur oleh sebuah [Column] biasa, dan
/// toast yang menutup di tengah tumpukan membuat yang lain bergeser dengan
/// sendirinya alih-alih meninggalkan lubang.
class _ToastHost {
  static final Map<OverlayState, _ToastHost> _hosts = {};

  final OverlayState overlay;
  final ValueNotifier<List<_ToastData>> toasts = ValueNotifier([]);
  OverlayEntry? _entry;

  _ToastHost._(this.overlay);

  static _ToastHost of(OverlayState overlay) =>
      _hosts.putIfAbsent(overlay, () => _ToastHost._(overlay));

  void push(_ToastData data) {
    final next = [...toasts.value, data];
    while (next.length > AppToast.maxVisible) {
      final evicted = next.removeAt(0);
      evicted.timer?.cancel();
    }

    if (_entry == null) {
      _entry = OverlayEntry(builder: (_) => _ToastLayer(host: this));
      overlay.insert(_entry!);
    }

    toasts.value = next;
    data.timer = Timer(data.duration, () => requestDismiss(data));
  }

  /// Menandai [data] agar menganimasikan keluar. Pencabutan dari daftar terjadi
  /// di [remove], setelah animasinya selesai.
  void requestDismiss(_ToastData data) {
    if (data.leaving || !toasts.value.contains(data)) return;
    data.timer?.cancel();
    data.leaving = true;
    toasts.value = [...toasts.value];
  }

  void remove(_ToastData data) {
    data.timer?.cancel();
    final next = [...toasts.value]..remove(data);
    toasts.value = next;

    if (next.isEmpty) {
      _entry?.remove();
      _entry = null;
      _hosts.remove(overlay);
    }
  }

  void clear() {
    for (final data in toasts.value) {
      data.timer?.cancel();
    }
    toasts.value = [];
    _entry?.remove();
    _entry = null;
    _hosts.remove(overlay);
  }
}

class _ToastLayer extends StatelessWidget {
  final _ToastHost host;

  const _ToastLayer({required this.host});

  @override
  Widget build(BuildContext context) {
    final density = DensityScope.of(context);
    final isCompact = context.windowSize == WindowSize.compact;

    return ValueListenableBuilder<List<_ToastData>>(
      valueListenable: host.toasts,
      builder: (context, toasts, _) {
        final stack = Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            for (final data in toasts)
              Padding(
                padding: EdgeInsets.only(top: density.sm),
                child: _ToastCard(
                  key: ObjectKey(data),
                  data: data,
                  onDismissed: () => host.remove(data),
                  onDismissRequested: () => host.requestDismiss(data),
                ),
              ),
          ],
        );

        return SafeArea(
          child: Align(
            // Di layar lebar toast menempati pojok kanan atas, jauh dari panel
            // keranjang dan bilah total di bawah. Di layar sempit tidak ada
            // pojok yang lega, jadi ia turun ke bawah tempat ibu jari berada.
            alignment:
                isCompact ? Alignment.bottomCenter : Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.all(density.lg),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 380),
                child: stack,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ToastCard extends StatefulWidget {
  final _ToastData data;
  final VoidCallback onDismissed;
  final VoidCallback onDismissRequested;

  const _ToastCard({
    super.key,
    required this.data,
    required this.onDismissed,
    required this.onDismissRequested,
  });

  @override
  State<_ToastCard> createState() => _ToastCardState();
}

class _ToastCardState extends State<_ToastCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppMotion.normal,
  )..forward();

  // Harus disimpan sebagai field — jika dibuat ulang di build() setiap frame
  // akan menumpuk listener pada _controller tanpa dilepas, sehingga
  // pumpAndSettle() di widget test tidak pernah settle setelah dismiss manual.
  late final CurvedAnimation _curved = CurvedAnimation(
    parent: _controller,
    curve: AppMotion.standard,
  );

  @override
  void didUpdateWidget(_ToastCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.data.leaving && !_controller.isDismissed) {
      _controller.reverse().then((_) {
        if (mounted) widget.onDismissed();
      });
    }
  }

  @override
  void dispose() {
    _curved.dispose();
    _controller.dispose();
    super.dispose();
  }

  (SemanticColor, IconData) _resolve(AppSemanticColors colors) =>
      switch (widget.data.variant) {
        AppToastVariant.success => (colors.success, AppIcons.success),
        AppToastVariant.danger => (colors.danger, AppIcons.danger),
        AppToastVariant.warning => (colors.warning, AppIcons.warning),
        AppToastVariant.info => (colors.info, AppIcons.info),
      };

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final density = context.space;
    final (semantic, icon) = _resolve(colors);

    return FadeTransition(
      opacity: _curved,
      child: SlideTransition(
        position: Tween(
          begin: const Offset(0, 0.2),
          end: Offset.zero,
        ).animate(_curved),
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: density.md,
              vertical: density.sm,
            ),
            decoration: BoxDecoration(
              color: semantic.bg,
              borderRadius: AppRadius.rMd,
              border: Border.all(color: semantic.border),
              boxShadow: context.elevation.popover,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(icon, size: 16, color: semantic.fg),
                SizedBox(width: density.sm),
                Flexible(
                  child: Text(
                    widget.data.message,
                    style: context.text.dialogBody.copyWith(color: semantic.fg),
                  ),
                ),
                if (widget.data.actionLabel != null) ...[
                  SizedBox(width: density.sm),
                  AppButton(
                    label: widget.data.actionLabel!,
                    variant: AppButtonVariant.ghost,
                    size: AppButtonSize.small,
                    onPressed: () {
                      widget.data.onAction?.call();
                      widget.onDismissRequested();
                    },
                  ),
                ],
                SizedBox(width: density.xs),
                AppIconButton(
                  icon: AppIcons.close,
                  tooltip: 'Tutup',
                  size: AppButtonSize.small,
                  onPressed: widget.onDismissRequested,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
