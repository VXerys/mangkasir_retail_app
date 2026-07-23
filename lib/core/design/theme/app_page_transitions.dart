import 'package:flutter/material.dart';

import '../tokens/app_motion.dart';

/// Transisi halaman yang mematuhi plafon gerak design system.
///
/// Bawaan Material ([ZoomPageTransitionsBuilder]) berdurasi 300 ms disertai
/// perbesaran — dua hal yang secara eksplisit ditolak oleh 16_Design_System.md.
/// Penggantinya di sini berupa geser tipis disertai pudar: cukup untuk memberi
/// arah navigasi, tanpa membuat pengguna menunggu.
///
/// Durasi sesungguhnya ditetapkan oleh rute (lihat `app_router.dart`), karena
/// [PageTransitionsBuilder] hanya menentukan tampilan, bukan lamanya.
class AppPageTransitionsBuilder extends PageTransitionsBuilder {
  const AppPageTransitionsBuilder();

  @override
  Duration get transitionDuration => AppMotion.deliberate;

  @override
  Widget buildTransitions<T>(
    PageRoute<T>? route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (MediaQuery.disableAnimationsOf(context)) return child;

    final curved = CurvedAnimation(
      parent: animation,
      curve: AppMotion.standard,
      reverseCurve: AppMotion.standard.flipped,
    );

    return FadeTransition(
      opacity: curved,
      child: SlideTransition(
        // Geser 2% lebar layar. Cukup terbaca sebagai gerakan maju, tidak
        // cukup besar untuk terasa sebagai penundaan.
        position: Tween<Offset>(
          begin: const Offset(0.02, 0),
          end: Offset.zero,
        ).animate(curved),
        child: child,
      ),
    );
  }
}
