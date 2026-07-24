import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../design.dart';

/// Satu aksi yang muncul saat baris digeser.
@immutable
class AppSwipeActionItem {
  final String label;
  final IconData icon;

  /// Warna latar aksi. Ambil dari peran semantik: `colors.danger` untuk hapus,
  /// `colors.info` untuk ubah.
  final SemanticColor color;

  final VoidCallback onPressed;

  /// Menjalankan aksi begitu geseran melewati ambang penuh, tanpa perlu
  /// menekan tombolnya.
  ///
  /// Hanya untuk satu aksi paling utama per sisi, dan sebaiknya hanya untuk
  /// yang bisa dibatalkan — geseran penuh mudah terjadi tanpa sengaja.
  final bool isFullSwipeAction;

  const AppSwipeActionItem({
    required this.label,
    required this.icon,
    required this.color,
    required this.onPressed,
    this.isFullSwipeAction = false,
  });
}

/// Membungkus sebuah baris agar bisa digeser untuk memunculkan aksi.
///
/// Dipakai pada baris keranjang, daftar produk, dan riwayat transaksi — tempat
/// aksi "hapus" dan "ubah" terlalu sering dipakai untuk disembunyikan di balik
/// menu tiga titik, tetapi terlalu berbahaya untuk dipasang sebagai tombol
/// permanen yang mudah tersenggol saat menggulir.
///
/// [Dismissible] bawaan tidak dipakai: ia **menghapus widgetnya sendiri** dari
/// pohon setelah geseran, yang keliru di sini. Kebenaran isi keranjang dipegang
/// bloc, dan barisnya harus hilang karena datanya hilang — bukan karena widget
/// memutuskan begitu lebih dulu. Kalau penghapusan gagal, baris yang sudah
/// telanjur lenyap tidak bisa dikembalikan tanpa kedipan.
///
/// [Slidable] dari paket luar juga tidak dipakai supaya tidak menambah
/// ketergantungan untuk perilaku sependek ini.
class AppSwipeAction extends StatefulWidget {
  final Widget child;

  /// Aksi yang muncul saat digeser dari kanan ke kiri. Diletakkan di kanan.
  final List<AppSwipeActionItem> endActions;

  /// Aksi yang muncul saat digeser dari kiri ke kanan. Diletakkan di kiri.
  final List<AppSwipeActionItem> startActions;

  /// Menonaktifkan geseran, misalnya saat baris sedang diproses.
  final bool enabled;

  const AppSwipeAction({
    super.key,
    required this.child,
    this.endActions = const [],
    this.startActions = const [],
    this.enabled = true,
  });

  @override
  State<AppSwipeAction> createState() => _AppSwipeActionState();
}

class _AppSwipeActionState extends State<AppSwipeAction>
    with SingleTickerProviderStateMixin {
  /// Dibuat di [initState], bukan sebagai `late final` pada deklarasinya.
  ///
  /// Pada baris tanpa aksi, `build` mengembalikan anaknya lebih awal dan
  /// controller tidak pernah tersentuh — sehingga `late` baru menjalankan
  /// pembuatannya saat `dispose` memanggilnya, dan `SingleTickerProviderStateMixin`
  /// menolak membuat ticker setelah state dibuang.
  late final AnimationController _controller;
  late final Animation<double> _curve;

  /// Titik awal dan tujuan animasi geser yang sedang berjalan.
  ///
  /// Disimpan sebagai field, bukan ditangkap di dalam closure listener. Versi
  /// awal memasang listener baru pada setiap geseran dan tidak pernah
  /// melepasnya: listener menumpuk sepanjang umur baris, masing-masing
  /// membawa tujuan lamanya sendiri, dan semuanya ikut berjalan tiap bingkai.
  double _from = 0;
  double _target = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: AppMotion.fast);
    _curve = CurvedAnimation(parent: _controller, curve: AppMotion.standard);
    _curve.addListener(() {
      setState(() => _offset = _from + (_target - _from) * _curve.value);
    });
  }

  /// Geseran saat ini dalam piksel. Negatif berarti terbuka ke kiri.
  double _offset = 0;

  /// Lebar satu tombol aksi.
  static const double _actionWidth = 76;

  /// Bagian dari lebar baris yang harus dilewati agar geseran penuh terpicu.
  static const double _fullSwipeFraction = 0.55;

  bool _fullSwipeArmed = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double get _maxEnd => widget.endActions.length * _actionWidth;
  double get _maxStart => widget.startActions.length * _actionWidth;

  void _animateTo(double target) {
    _from = _offset;
    _target = target;
    _controller
      ..reset()
      ..forward();
  }

  /// Menutup baris tanpa animasi balik yang terlihat patah.
  void close() => _animateTo(0);

  void _onUpdate(DragUpdateDetails details, double width) {
    final next = (_offset + details.delta.dx).clamp(-_maxEnd, _maxStart);
    final threshold = width * _fullSwipeFraction;

    final hasFullSwipe = next < 0
        ? widget.endActions.any((a) => a.isFullSwipeAction)
        : widget.startActions.any((a) => a.isFullSwipeAction);

    final armed = hasFullSwipe && next.abs() >= threshold;
    if (armed != _fullSwipeArmed) {
      // Getaran singkat menandai ambang tercapai. Di layar sentuh, ini
      // satu-satunya umpan balik yang terasa tanpa harus melihat.
      HapticFeedback.selectionClick();
      _fullSwipeArmed = armed;
    }

    setState(() => _offset = next);
  }

  void _onEnd(DragEndDetails details, double width) {
    if (_fullSwipeArmed) {
      final action = _offset < 0
          ? widget.endActions.firstWhere((a) => a.isFullSwipeAction)
          : widget.startActions.firstWhere((a) => a.isFullSwipeAction);

      _fullSwipeArmed = false;
      _animateTo(0);
      action.onPressed();
      return;
    }

    // Menempel terbuka bila sudah lewat setengah tombol pertama, atau bila
    // dilempar cepat ke satu arah.
    final velocity = details.primaryVelocity ?? 0;
    final openEnd = _offset < 0 &&
        (_offset.abs() > _actionWidth / 2 || velocity < -300);
    final openStart =
        _offset > 0 && (_offset > _actionWidth / 2 || velocity > 300);

    _animateTo(
      openEnd
          ? -_maxEnd
          : openStart
              ? _maxStart
              : 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled ||
        (widget.endActions.isEmpty && widget.startActions.isEmpty)) {
      return widget.child;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        return Stack(
          children: [
            Positioned.fill(
              child: Row(
                children: [
                  for (final action in widget.startActions)
                    _ActionButton(
                      action: action,
                      width: _actionWidth,
                      // Aksi hanya terlihat sejauh baris tergeser; menampilkan
                      // seluruhnya sejak awal membuat baris terlihat "bocor".
                      visible: _offset > 0,
                      onPressed: () {
                        close();
                        action.onPressed();
                      },
                    ),
                  const Spacer(),
                  for (final action in widget.endActions)
                    _ActionButton(
                      action: action,
                      width: _actionWidth,
                      visible: _offset < 0,
                      onPressed: () {
                        close();
                        action.onPressed();
                      },
                    ),
                ],
              ),
            ),
            GestureDetector(
              onHorizontalDragUpdate: (details) => _onUpdate(details, width),
              onHorizontalDragEnd: (details) => _onEnd(details, width),
              // Ketukan di baris yang sedang terbuka menutupnya kembali,
              // bukan meneruskan ketukan ke isi baris.
              onTap: _offset == 0 ? null : close,
              child: Transform.translate(
                offset: Offset(_offset, 0),
                child: widget.child,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ActionButton extends StatelessWidget {
  final AppSwipeActionItem action;
  final double width;
  final bool visible;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.action,
    required this.width,
    required this.visible,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    if (!visible) return const SizedBox.shrink();

    return SizedBox(
      width: width,
      child: Material(
        color: action.color.bg,
        child: InkWell(
          onTap: onPressed,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(action.icon, size: 18, color: action.color.fg),
              SizedBox(height: context.space.xs),
              Text(
                action.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.text.badge.copyWith(color: action.color.fg),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
