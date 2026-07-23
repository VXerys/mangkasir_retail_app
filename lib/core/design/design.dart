import 'package:flutter/material.dart';

import 'tokens/app_density.dart';
import 'tokens/app_semantic_colors.dart';
import 'tokens/app_typography.dart';

export 'components/app_badge.dart';
export 'components/app_button.dart';
export 'components/app_divider.dart';
export 'components/app_empty_state.dart';
export 'components/app_error_view.dart';
export 'components/app_panel.dart';
export 'components/app_skeleton.dart';
export 'components/app_text_field.dart';
export 'components/shell/app_shell.dart';
export 'components/shell/app_sidebar.dart';
export 'theme/app_theme.dart';
export 'tokens/app_breakpoints.dart';
export 'tokens/app_density.dart';
export 'tokens/app_icons.dart';
export 'tokens/app_motion.dart';
export 'tokens/app_radius.dart';
export 'tokens/app_semantic_colors.dart';
export 'tokens/app_shadows.dart';
export 'tokens/app_typography.dart';

/// Pintu masuk design system.
///
/// Satu-satunya cara yang benar untuk mengakses token dari dalam feature:
///
/// ```dart
/// Container(
///   padding: EdgeInsets.all(context.space.md),
///   decoration: BoxDecoration(
///     color: context.colors.surface,
///     border: Border.all(color: context.colors.borderDefault),
///     borderRadius: AppRadius.rMd,
///   ),
///   child: Text('Total', style: context.text.tableCellEmphasis),
/// )
/// ```
///
/// Jangan pernah menulis `Colors.x`, `TextStyle(...)` lepas, atau angka padding
/// telanjang di dalam `lib/features/`. Kalau sebuah nilai belum ada tokennya,
/// tambahkan tokennya — jangan menyelundupkan nilai mentah.
extension AppThemeContext on BuildContext {
  /// Peran warna untuk tema yang sedang aktif.
  AppSemanticColors get colors => Theme.of(this).extension<AppSemanticColors>()!;

  /// Gaya teks berbasis peran.
  AppTypography get text => Theme.of(this).extension<AppTypography>()!;

  /// Spasi dan metrik kontrol untuk kerapatan yang berlaku di sini.
  ///
  /// Nilainya mengikuti [DensityScope] terdekat, dan bila tidak ada, dihitung
  /// dari lebar jendela. Jadi selalu aman dipanggil.
  AppDensity get space => DensityScope.of(this);
}
