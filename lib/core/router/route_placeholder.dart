import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_routes.dart';
import '../design/design.dart';
import 'app_nav_tree.dart';

/// Penanda tempat untuk halaman yang belum di-slice.
///
/// Sengaja dirakit dari komponen design system, bukan `Center(child: Text())`
/// seadanya. Dengan begitu setiap rute yang terdaftar sudah membuktikan bahwa
/// shell, token, breadcrumb, dan penjaga izin bekerja pada ukuran layar mana
/// pun — jauh sebelum halaman sungguhannya ada.
class RoutePlaceholderPage extends StatelessWidget {
  final AppNavMatch match;

  const RoutePlaceholderPage({super.key, required this.match});

  @override
  Widget build(BuildContext context) {
    final leaf = match.leaf;

    return Padding(
      padding: EdgeInsets.all(context.space.xl),
      child: AppPanel(
        header: Row(
          children: [
            Icon(leaf.icon, size: 18, color: context.colors.textSecondary),
            SizedBox(width: context.space.sm),
            Text(leaf.label, style: context.text.toolbarTitle),
          ],
        ),
        child: AppEmptyState(
          title: 'Belum dibangun',
          message: leaf.permissions.isEmpty
              ? 'Halaman ${leaf.label} akan dibangun pada fase slicing.'
              : 'Halaman ${leaf.label} akan dibangun pada fase slicing. '
                  'Izin yang menjaganya: ${leaf.permissions.join(" atau ")}.',
          icon: leaf.icon,
        ),
      ),
    );
  }
}

/// Halaman yang muncul saat izin tidak mencukupi.
///
/// Halaman sungguhan, bukan dialog: tautan dalam, notifikasi, dan tombol
/// kembali semuanya bisa mendarat di sini, dan ketiganya butuh tempat berdiri
/// yang punya alamat sendiri.
class AppForbiddenPage extends StatelessWidget {
  const AppForbiddenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(context.space.xl),
      child: AppEmptyState(
        title: 'Akses ditolak',
        message: 'Peran Anda tidak memiliki izin untuk membuka halaman ini. '
            'Hubungi pemilik toko bila Anda merasa seharusnya bisa.',
        icon: AppIcons.role,
        action: AppButton(
          label: 'Kembali ke beranda',
          variant: AppButtonVariant.secondary,
          size: AppButtonSize.small,
          onPressed: () => context.go(AppRoutes.root),
        ),
      ),
    );
  }
}

/// Layar selama sesi sedang dipulihkan.
///
/// Dipasang di [AppRoutes.root]. Tanpa halaman ini, alamat awal aplikasi tidak
/// punya isi selama sesi belum diketahui, dan pengguna melihat layar kosong
/// sebelum pengalihan sempat berjalan.
class AppBootPage extends StatelessWidget {
  const AppBootPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.surface,
      body: Center(
        child: AppSkeleton(
          width: context.space.sidebarExtendedWidth,
          height: context.space.minTouchTarget,
        ),
      ),
    );
  }
}
