import 'package:flutter/painting.dart';

import '../tokens/app_elevation.dart';
import '../tokens/app_palette.dart';
import '../tokens/app_semantic_colors.dart';
import '../tokens/app_typography.dart';

/// Pemetaan ramp mentah ke peran semantik untuk tema terang.
///
/// Berkas inilah satu-satunya tempat yang memutuskan "teks utama itu n700".
/// Semua berkas lain hanya menyebut perannya.
abstract final class LightScheme {
  static const colors = AppSemanticColors(
    // Permukaan disusun bertingkat dari belakang ke depan:
    // canvas (n25) < surfaceSubtle (n50) < surface (n0).
    // Panel putih di atas kanvas keabuan menciptakan pemisahan lapisan
    // tanpa satu bayangan pun.
    canvas: AppPalette.n25,
    surface: AppPalette.n0,
    surfaceSubtle: AppPalette.n50,
    surfaceHover: AppPalette.n75,
    surfaceRaised: AppPalette.n0,
    overlay: Color(0x99101828),

    borderSubtle: AppPalette.n100,
    borderDefault: AppPalette.n200,
    borderStrong: AppPalette.n300,
    borderFocus: AppPalette.accent500,

    textPrimary: AppPalette.n700,
    textSecondary: AppPalette.n600,
    textTertiary: AppPalette.n500,
    textDisabled: AppPalette.n400,
    textOnAccent: AppPalette.n0,

    accent: AppPalette.accent500,
    accentHover: AppPalette.accent600,
    accentPressed: AppPalette.accent700,
    accentSubtle: AppPalette.accent50,

    success: SemanticColor(
      fg: AppPalette.successFg,
      bg: AppPalette.successBg,
      border: AppPalette.successBorder,
    ),
    danger: SemanticColor(
      fg: AppPalette.dangerFg,
      bg: AppPalette.dangerBg,
      border: AppPalette.dangerBorder,
    ),
    warning: SemanticColor(
      fg: AppPalette.warningFg,
      bg: AppPalette.warningBg,
      border: AppPalette.warningBorder,
    ),
    info: SemanticColor(
      fg: AppPalette.infoFg,
      bg: AppPalette.infoBg,
      border: AppPalette.infoBorder,
    ),

    domainSales: AppPalette.domainSales,
    domainInventory: AppPalette.domainInventory,
    domainFinance: AppPalette.domainFinance,
    domainPurchase: AppPalette.domainPurchase,

    // Status stok memakai trio semantik yang sama persis dengan
    // danger/warning/success. Disamakan dengan sengaja: kasir sudah membaca
    // merah sebagai "berhenti" di seluruh aplikasi, dan memberi stok habis
    // rona merah sendiri hanya akan melemahkan artinya.
    stockOut: SemanticColor(
      fg: AppPalette.dangerFg,
      bg: AppPalette.dangerBg,
      border: AppPalette.dangerBorder,
    ),
    stockLow: SemanticColor(
      fg: AppPalette.warningFg,
      bg: AppPalette.warningBg,
      border: AppPalette.warningBorder,
    ),
    stockOk: SemanticColor(
      fg: AppPalette.successFg,
      bg: AppPalette.successBg,
      border: AppPalette.successBorder,
    ),

    // Data tertunda itu normal pada aplikasi offline-first, jadi warnanya
    // informatif — bukan peringatan. Yang diberi warna waspada hanyalah
    // kegagalan sync, karena itu memang butuh tindakan.
    syncPending: SemanticColor(
      fg: AppPalette.infoFg,
      bg: AppPalette.infoBg,
      border: AppPalette.infoBorder,
    ),
    syncFailed: SemanticColor(
      fg: AppPalette.dangerFg,
      bg: AppPalette.dangerBg,
      border: AppPalette.dangerBorder,
    ),
    offline: SemanticColor(
      fg: AppPalette.n600,
      bg: AppPalette.n75,
      border: AppPalette.n200,
    ),
  );

  static final typography =
      AppTypography.standard(defaultColor: colors.textPrimary);

  static const elevation = AppElevation.light();
}
