import 'package:flutter/material.dart';

import '../design.dart';

/// Penanda tempat saat data sedang dimuat.
///
/// Dipilih ketimbang pemintal karena mempertahankan bentuk tata letak: begitu
/// data tiba, tidak ada yang bergeser. Pada layar yang isinya tabel padat,
/// pergeseran tata letak jauh lebih mengganggu daripada penundaan itu sendiri.
///
/// Denyutnya lambat dan halus, sesuai aturan gerak — bukan kilatan gradien
/// yang menarik perhatian ke bagian layar yang justru belum bisa dipakai.
class AppSkeleton extends StatefulWidget {
  final double? width;
  final double height;
  final BorderRadius borderRadius;

  const AppSkeleton({
    super.key,
    this.width,
    this.height = 12,
    this.borderRadius = AppRadius.rXs,
  });

  /// Sebaris teks. Lebarnya diacak sedikit agar tumpukan beberapa baris tidak
  /// terlihat seperti balok seragam.
  factory AppSkeleton.text({double width = 120}) =>
      AppSkeleton(width: width, height: 12);

  /// Satu baris tabel setinggi kerapatan yang berlaku.
  static Widget row(BuildContext context) =>
      AppSkeleton(height: context.space.rowHeight - 8, borderRadius: AppRadius.rSm);

  @override
  State<AppSkeleton> createState() => _AppSkeletonState();
}

class _AppSkeletonState extends State<AppSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );

  @override
  void initState() {
    super.initState();
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    // Hormati preferensi aksesibilitas: tanpa animasi, tampilkan balok statis.
    if (MediaQuery.disableAnimationsOf(context)) {
      return _box(colors.surfaceSubtle);
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final color = Color.lerp(
          colors.surfaceSubtle,
          colors.surfaceHover,
          _controller.value,
        )!;
        return _box(color);
      },
    );
  }

  Widget _box(Color color) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: widget.borderRadius,
      ),
    );
  }
}
