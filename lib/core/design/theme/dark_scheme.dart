import 'package:flutter/painting.dart';

import '../tokens/app_elevation.dart';
import '../tokens/app_palette.dart';
import '../tokens/app_semantic_colors.dart';
import '../tokens/app_typography.dart';

/// Pemetaan ramp gelap ke peran semantik.
///
/// Kembarannya `light_scheme.dart`: hanya berkas ini dan berkas itu yang boleh
/// memutuskan "teks utama itu d900". Karena setiap widget membaca warna lewat
/// `context.colors` dan tidak pernah menulis `Colors.white`, seluruh mode gelap
/// aplikasi ditentukan di sini — tanpa satu pun widget ikut berubah.
///
/// Tiga jebakan tema gelap POS yang sengaja dihindari di sini:
///
/// 1. **Ramp tidak dibalik begitu saja.** Permukaan gelap memakai selisih
///    terang yang lebih rapat; lihat catatan pada ramp `d` di `AppPalette`.
/// 2. **Saturasi warna semantik diturunkan.** Merah dan hijau penuh di atas
///    permukaan gelap tampak menyala dan melelahkan mata.
/// 3. **Yang benar-benar terbalik hanyalah sorotan.** Susunan lapisan
///    (kanvas di belakang, permukaan melayang lebih terang) berlaku sama di
///    kedua tema — panel putih di atas kanvas keabuan mengikuti aturan yang
///    persis sama. Yang berbeda adalah `surfaceHover`: tema terang
///    menggelapkan baris tersorot, tema gelap menerangkannya.
abstract final class DarkScheme {
  static const colors = AppSemanticColors(
    // Susunan lapisan dari belakang ke depan:
    // canvas (d0) < surfaceSubtle (d50) < surface (d100) < surfaceRaised (d200).
    // Selisih antar lapisan hanya beberapa langkah — cukup untuk terbaca
    // sebagai lapisan terpisah, tidak sampai membuat panel terlihat melayang
    // dengan sendirinya.
    canvas: AppPalette.d0,
    surface: AppPalette.d100,
    surfaceSubtle: AppPalette.d50,
    surfaceHover: AppPalette.d150,
    surfaceRaised: AppPalette.d200,

    // Lebih pekat daripada tirai tema terang. Di atas kanvas yang sudah gelap,
    // tirai transparan tipis tidak terbaca sebagai lapisan baru — dialog jadi
    // terlihat menempel pada halaman di belakangnya.
    overlay: Color(0xCC05080B),

    borderSubtle: AppPalette.d300,
    borderDefault: AppPalette.d400,
    borderStrong: AppPalette.d500,
    borderFocus: AppPalette.accent500Dark,

    textPrimary: AppPalette.d900,
    textSecondary: AppPalette.d800,
    textTertiary: AppPalette.d700,
    textDisabled: AppPalette.d600,
    textOnAccent: AppPalette.onAccentDark,

    accent: AppPalette.accent500Dark,
    accentHover: AppPalette.accent600Dark,
    accentPressed: AppPalette.accent700Dark,
    accentSubtle: AppPalette.accent50Dark,

    success: SemanticColor(
      fg: AppPalette.successFgDark,
      bg: AppPalette.successBgDark,
      border: AppPalette.successBorderDark,
    ),
    danger: SemanticColor(
      fg: AppPalette.dangerFgDark,
      bg: AppPalette.dangerBgDark,
      border: AppPalette.dangerBorderDark,
    ),
    warning: SemanticColor(
      fg: AppPalette.warningFgDark,
      bg: AppPalette.warningBgDark,
      border: AppPalette.warningBorderDark,
    ),
    info: SemanticColor(
      fg: AppPalette.infoFgDark,
      bg: AppPalette.infoBgDark,
      border: AppPalette.infoBorderDark,
    ),

    domainSales: AppPalette.domainSalesDark,
    domainInventory: AppPalette.domainInventoryDark,
    domainFinance: AppPalette.domainFinanceDark,
    domainPurchase: AppPalette.domainPurchaseDark,

    // Status stok tetap meminjam trio danger/warning/success persis seperti
    // tema terang. Mode gelap bukan alasan memperkenalkan rona baru — kasir
    // yang berpindah shift pagi ke malam harus membaca warna yang sama.
    stockOut: SemanticColor(
      fg: AppPalette.dangerFgDark,
      bg: AppPalette.dangerBgDark,
      border: AppPalette.dangerBorderDark,
    ),
    stockLow: SemanticColor(
      fg: AppPalette.warningFgDark,
      bg: AppPalette.warningBgDark,
      border: AppPalette.warningBorderDark,
    ),
    stockOk: SemanticColor(
      fg: AppPalette.successFgDark,
      bg: AppPalette.successBgDark,
      border: AppPalette.successBorderDark,
    ),

    // Data tertunda tetap informatif, bukan peringatan; hanya kegagalan sync
    // yang berhak memakai warna waspada.
    syncPending: SemanticColor(
      fg: AppPalette.infoFgDark,
      bg: AppPalette.infoBgDark,
      border: AppPalette.infoBorderDark,
    ),
    syncFailed: SemanticColor(
      fg: AppPalette.dangerFgDark,
      bg: AppPalette.dangerBgDark,
      border: AppPalette.dangerBorderDark,
    ),
    offline: SemanticColor(
      fg: AppPalette.d800,
      bg: AppPalette.d150,
      border: AppPalette.d400,
    ),
  );

  /// Metrik huruf identik dengan tema terang — hanya warna dasarnya berbeda.
  /// Pabrik yang sama dipakai keduanya supaya tata letak tidak pernah bergeser
  /// saat tema ditukar.
  static final typography =
      AppTypography.standard(defaultColor: colors.textPrimary);

  static const elevation = AppElevation.dark();
}
