import 'package:flutter/material.dart';

import 'tokens/app_density.dart';
import 'tokens/app_elevation.dart';
import 'tokens/app_semantic_colors.dart';
import 'tokens/app_typography.dart';

export 'components/app_badge.dart';
export 'components/app_button.dart';
export 'components/app_divider.dart';
export 'components/app_empty_state.dart';
export 'components/app_error_view.dart';
export 'components/app_filter_chip.dart';
export 'components/app_icon_button.dart';
export 'components/app_panel.dart';
export 'components/app_search_field.dart';
export 'components/app_skeleton.dart';
export 'components/app_tabs.dart';
export 'components/app_text_field.dart';
export 'components/form/app_checkbox.dart';
export 'components/form/app_currency_input.dart';
export 'components/form/app_date_picker.dart';
export 'components/form/app_number_input.dart';
export 'components/form/app_radio.dart';
export 'components/form/app_select.dart';
export 'components/form/app_switch.dart';
// `form/toggle_shell.dart` sengaja tidak diekspor: ia kerangka bersama untuk
// checkbox/radio/switch, bukan komponen yang dipakai langsung oleh feature.
export 'components/gesture/app_back_guard.dart';
export 'components/gesture/app_refresh_view.dart';
export 'components/gesture/app_swipe_action.dart';
export 'components/keyboard/app_shortcuts.dart';
export 'components/keyboard/physical_keyboard.dart';
export 'components/overlay/app_dialog.dart';
export 'components/overlay/app_drawer.dart';
export 'components/overlay/app_toast.dart';
export 'components/overlay/app_tooltip.dart';
export 'components/shell/app_bottom_nav.dart';
export 'components/shell/app_breadcrumb.dart';
export 'components/shell/app_shell.dart';
export 'components/shell/app_sidebar.dart';
export 'components/shell/app_top_bar.dart';
export 'components/table/app_column.dart';
export 'components/table/app_data_table.dart';
export 'components/table/app_pagination.dart';
export 'theme/app_theme.dart';
export 'tokens/app_breakpoints.dart';
export 'tokens/app_density.dart';
export 'tokens/app_elevation.dart';
export 'tokens/app_icons.dart';
export 'tokens/app_motion.dart';
export 'tokens/app_radius.dart';
export 'tokens/app_semantic_colors.dart';
// `app_shadows.dart` sengaja tidak diekspor, sama seperti `app_palette.dart`:
// keduanya nilai mentah. Feature membaca bayangan lewat `context.elevation`.
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

  /// Bayangan per peran ketinggian, sudah sesuai tema yang sedang aktif.
  AppElevation get elevation => Theme.of(this).extension<AppElevation>()!;

  /// Spasi dan metrik kontrol untuk kerapatan yang berlaku di sini.
  ///
  /// Nilainya mengikuti [DensityScope] terdekat, dan bila tidak ada, dihitung
  /// dari lebar jendela. Jadi selalu aman dipanggil.
  AppDensity get space => DensityScope.of(this);
}
