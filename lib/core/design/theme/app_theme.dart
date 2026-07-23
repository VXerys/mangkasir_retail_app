import 'package:flutter/material.dart';

import '../tokens/app_density.dart';
import '../tokens/app_radius.dart';
import '../tokens/app_semantic_colors.dart';
import '../tokens/app_typography.dart';
import 'app_page_transitions.dart';
import 'dark_scheme.dart';
import 'light_scheme.dart';

/// Merakit [ThemeData] dari token design system.
///
/// Selain memasang [ThemeExtension] milik kita, berkas ini juga memetakan token
/// ke slot bawaan Material. Langkah itu mudah dilewatkan tapi sangat penting:
/// `Dialog`, `SnackBar`, `Switch`, penanda seleksi teks, dan efek riak semuanya
/// membaca [ColorScheme]. Tanpa pemetaan ini, separuh aplikasi akan tetap
/// memakai ungu bawaan Flutter sementara separuh lainnya mengikuti design
/// system.
abstract final class AppTheme {
  static ThemeData get light => _build(
        brightness: Brightness.light,
        colors: LightScheme.colors,
        typography: LightScheme.typography,
      );

  /// Tema gelap. Saat ini memakai nilai skema terang — lihat [DarkScheme].
  static ThemeData get dark => _build(
        brightness: Brightness.light,
        colors: DarkScheme.colors,
        typography: DarkScheme.typography,
      );

  static ThemeData _build({
    required Brightness brightness,
    required AppSemanticColors colors,
    required AppTypography typography,
  }) {
    // Tema global tidak punya akses ke lebar layar, jadi metrik kontrol di sini
    // memakai kerapatan menengah. Komponen kita membaca kerapatan yang benar
    // lewat `context.space`; nilai di bawah hanya menjadi cadangan bagi widget
    // Material bawaan.
    const density = AppDensity.normal;

    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: colors.accent,
      onPrimary: colors.textOnAccent,
      primaryContainer: colors.accentSubtle,
      onPrimaryContainer: colors.accentPressed,
      secondary: colors.domainFinance,
      onSecondary: colors.textOnAccent,
      error: colors.danger.fg,
      onError: colors.textOnAccent,
      errorContainer: colors.danger.bg,
      onErrorContainer: colors.danger.fg,
      surface: colors.surface,
      onSurface: colors.textPrimary,
      surfaceContainerLowest: colors.surface,
      surfaceContainerLow: colors.canvas,
      surfaceContainer: colors.surfaceSubtle,
      surfaceContainerHigh: colors.surfaceHover,
      surfaceContainerHighest: colors.surfaceHover,
      onSurfaceVariant: colors.textSecondary,
      outline: colors.borderDefault,
      outlineVariant: colors.borderSubtle,
      shadow: const Color(0xFF101828),
      scrim: colors.overlay,
      inverseSurface: colors.textPrimary,
      onInverseSurface: colors.surface,
      inversePrimary: colors.accentSubtle,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colors.canvas,
      canvasColor: colors.surface,
      dividerColor: colors.borderDefault,

      // Token kita hidup di sini. Diakses lewat `context.colors` / `context.text`.
      extensions: <ThemeExtension<dynamic>>[colors, typography],

      // Rapatkan widget Material bawaan agar sejalan dengan prinsip kerapatan
      // tinggi. Area sentuh minimum tetap dijaga oleh komponen kita sendiri.
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,

      textTheme: _textTheme(typography),
      fontFamily: AppFontFamily.ui,

      pageTransitionsTheme: const PageTransitionsTheme(
        builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.android: AppPageTransitionsBuilder(),
          TargetPlatform.iOS: AppPageTransitionsBuilder(),
          TargetPlatform.windows: AppPageTransitionsBuilder(),
          TargetPlatform.macOS: AppPageTransitionsBuilder(),
          TargetPlatform.linux: AppPageTransitionsBuilder(),
          TargetPlatform.fuchsia: AppPageTransitionsBuilder(),
        },
      ),

      iconTheme: IconThemeData(color: colors.textSecondary, size: 18),

      dividerTheme: DividerThemeData(
        color: colors.borderSubtle,
        thickness: 1,
        space: 1,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surface,
        isDense: true,
        contentPadding: EdgeInsets.symmetric(
          horizontal: density.md,
          vertical: density.sm,
        ),
        hintStyle: typography.formInput.copyWith(color: colors.textTertiary),
        labelStyle: typography.formLabel.copyWith(color: colors.textSecondary),
        helperStyle: typography.formHelper.copyWith(color: colors.textTertiary),
        errorStyle: typography.formHelper.copyWith(color: colors.danger.fg),
        border: _inputBorder(colors.borderDefault),
        enabledBorder: _inputBorder(colors.borderDefault),
        // Cincin fokus dibuat 2px: POS ini dirancang untuk dioperasikan lewat
        // papan ketik, jadi posisi fokus harus terlihat dari jarak pandang
        // berdiri.
        focusedBorder: _inputBorder(colors.borderFocus, width: 2),
        errorBorder: _inputBorder(colors.danger.border),
        focusedErrorBorder: _inputBorder(colors.danger.fg, width: 2),
        disabledBorder: _inputBorder(colors.borderSubtle),
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: colors.surfaceRaised,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.rLg),
        titleTextStyle: typography.dialogTitle,
        contentTextStyle: typography.dialogBody,
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: colors.textPrimary,
        contentTextStyle: typography.dialogBody.copyWith(color: colors.surface),
        actionTextColor: colors.accentSubtle,
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.rSm),
        elevation: 0,
      ),

      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: colors.textPrimary,
          borderRadius: AppRadius.rSm,
        ),
        textStyle: typography.formHelper.copyWith(color: colors.surface),
        waitDuration: const Duration(milliseconds: 500),
      ),

      textSelectionTheme: TextSelectionThemeData(
        cursorColor: colors.accent,
        selectionColor: colors.accentSubtle,
        selectionHandleColor: colors.accent,
      ),

      popupMenuTheme: PopupMenuThemeData(
        color: colors.surfaceRaised,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.rMd,
          side: BorderSide(color: colors.borderDefault),
        ),
        textStyle: typography.toolbarLabel,
      ),

      cardTheme: CardThemeData(
        color: colors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.rMd,
          side: BorderSide(color: colors.borderDefault),
        ),
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: colors.surface,
        surfaceTintColor: Colors.transparent,
        foregroundColor: colors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: typography.toolbarTitle,
        iconTheme: IconThemeData(color: colors.textSecondary, size: 20),
        shape: Border(bottom: BorderSide(color: colors.borderDefault)),
      ),

      drawerTheme: DrawerThemeData(
        backgroundColor: colors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: const RoundedRectangleBorder(),
      ),

      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
        ),
      ),

      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return colors.accent;
          return Colors.transparent;
        }),
        checkColor: WidgetStatePropertyAll(colors.textOnAccent),
        side: BorderSide(color: colors.borderStrong, width: 1.5),
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.rXs),
      ),

      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return colors.textOnAccent;
          return colors.surface;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return colors.accent;
          return colors.borderStrong;
        }),
        trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
      ),

      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colors.accent,
        linearTrackColor: colors.borderSubtle,
        circularTrackColor: colors.borderSubtle,
      ),

      scrollbarTheme: ScrollbarThemeData(
        thickness: const WidgetStatePropertyAll(8),
        radius: const Radius.circular(AppRadius.sm),
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.hovered)) return colors.borderStrong;
          return colors.borderDefault;
        }),
      ),
    );
  }

  static OutlineInputBorder _inputBorder(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: AppRadius.rSm,
      borderSide: BorderSide(color: color, width: width),
    );
  }

  /// Memetakan peran tipografi kita ke slot [TextTheme] Material.
  ///
  /// Widget bawaan (judul dialog, label tombol, item menu) membaca slot ini.
  /// Pemetaannya perkiraan — yang penting mereka mewarisi font dan metrik yang
  /// benar, bukan Roboto 14.
  static TextTheme _textTheme(AppTypography t) {
    return TextTheme(
      headlineMedium: t.kpiValue,
      headlineSmall: t.priceLarge,
      titleLarge: t.dialogTitle,
      titleMedium: t.toolbarTitle,
      titleSmall: t.toolbarLabel,
      bodyLarge: t.formInput,
      bodyMedium: t.dialogBody,
      bodySmall: t.formHelper,
      labelLarge: t.buttonLabel,
      labelMedium: t.formLabel,
      labelSmall: t.badge,
    );
  }
}
