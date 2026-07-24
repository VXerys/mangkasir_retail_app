import 'package:flutter/material.dart';

/// Ikon aplikasi, dinamai menurut **konsep domain**, bukan bentuk gambarnya.
///
/// [16_Design_System.md] meminta `Stock Adjustment` dan `Cash Session`, bukan
/// `Box` dan `Dollar`. Manfaatnya dua: kode terbaca sebagai bahasa bisnis, dan
/// penggantian seluruh set ikon nanti (misalnya ke icon font kustom) hanya
/// menyentuh berkas ini.
///
/// **Aturan:** tidak ada berkas di `lib/features/` yang boleh menulis `Icons.*`
/// secara langsung. Bila sebuah konsep belum ada di sini, tambahkan — jangan
/// mengambil jalan pintas.
abstract final class AppIcons {
  // --- Navigasi utama (mengikuti 13_Information_Architecture.md) ------------

  static const dashboard = Icons.space_dashboard_outlined;
  static const sales = Icons.point_of_sale;
  static const inventory = Icons.inventory_2_outlined;
  static const purchase = Icons.shopping_bag_outlined;
  static const crm = Icons.people_outline;
  static const finance = Icons.account_balance_wallet_outlined;
  static const reporting = Icons.bar_chart;
  static const settings = Icons.settings_outlined;
  static const account = Icons.person_outline;

  // --- Penjualan ------------------------------------------------------------

  /// Layar kasir.
  static const pos = Icons.storefront_outlined;

  /// Daftar transaksi yang sudah selesai.
  static const transaction = Icons.receipt_long_outlined;

  /// Retur penjualan.
  static const salesReturn = Icons.assignment_return_outlined;

  static const payment = Icons.payments_outlined;
  static const invoice = Icons.description_outlined;

  /// Diskon per baris maupun per transaksi.
  static const discount = Icons.discount_outlined;

  static const tax = Icons.percent;

  // --- Persediaan -----------------------------------------------------------

  static const product = Icons.inventory_2_outlined;
  static const category = Icons.category_outlined;
  static const brand = Icons.sell_outlined;

  /// Satuan ukur (pcs, box, kg).
  static const unit = Icons.straighten;

  static const warehouse = Icons.warehouse_outlined;
  static const outlet = Icons.store_outlined;

  /// Saldo stok saat ini.
  static const stock = Icons.inventory_outlined;

  /// Koreksi stok manual disertai alasan.
  static const stockAdjustment = Icons.tune;

  /// Perpindahan stok antar gudang atau outlet.
  static const stockTransfer = Icons.swap_horiz;

  /// Perhitungan fisik terhadap catatan sistem.
  static const stockOpname = Icons.fact_check_outlined;

  /// Jejak audit seluruh pergerakan stok.
  static const movementHistory = Icons.history;

  // --- Pembelian ------------------------------------------------------------

  static const supplier = Icons.local_shipping_outlined;
  static const purchaseOrder = Icons.shopping_bag_outlined;

  /// Penerimaan barang atas sebuah PO.
  static const receiving = Icons.move_to_inbox_outlined;

  static const purchaseReturn = Icons.assignment_return_outlined;

  // --- CRM ------------------------------------------------------------------

  static const customer = Icons.people_outline;
  static const employee = Icons.badge_outlined;

  // --- Keuangan -------------------------------------------------------------

  /// Sesi kas: buka laci, hitung akhir, tutup sesi.
  static const cashSession = Icons.savings_outlined;

  static const cashIn = Icons.arrow_downward;
  static const cashOut = Icons.arrow_upward;

  /// Pergerakan kas masuk dan keluar sepanjang periode.
  static const cashFlow = Icons.swap_vert;

  /// Selisih penjualan terhadap modal.
  static const profit = Icons.trending_up;

  // --- Setelan & organisasi -------------------------------------------------

  /// Identitas badan usaha: nama, NPWP, mata uang.
  static const business = Icons.business_outlined;

  /// Peran beserta izin yang melekat padanya.
  static const role = Icons.admin_panel_settings_outlined;

  /// Pengguna sebagai objek yang dikelola, berbeda dari [account] yang berarti
  /// "saya, yang sedang memakai aplikasi ini".
  static const user = Icons.manage_accounts_outlined;

  static const notification = Icons.notifications_outlined;
  static const backup = Icons.backup_outlined;

  /// Preferensi perangkat: tema, bahasa, kerapatan.
  static const preference = Icons.settings_suggest_outlined;

  static const help = Icons.help_outline;

  // --- Status sinkronisasi --------------------------------------------------
  //
  // Aplikasi ini offline-first, jadi status sync selalu terlihat dan ikonnya
  // harus punya arti yang konsisten di seluruh layar.

  /// Ada data lokal yang menunggu diunggah.
  static const syncPending = Icons.cloud_upload_outlined;

  /// Sinkronisasi sedang berjalan.
  static const syncRunning = Icons.sync;

  /// Sinkronisasi berhenti karena gagal.
  static const syncFailed = Icons.sync_problem;

  /// Semua data sudah sama dengan server.
  static const syncDone = Icons.cloud_done_outlined;

  /// Perangkat sedang tanpa koneksi. Informatif, bukan kesalahan.
  static const offline = Icons.cloud_off_outlined;

  // --- Perangkat keras ------------------------------------------------------

  static const scanBarcode = Icons.qr_code_scanner;
  static const printReceipt = Icons.print_outlined;

  // --- Aksi umum ------------------------------------------------------------

  static const add = Icons.add;
  static const edit = Icons.edit_outlined;
  static const delete = Icons.delete_outline;
  static const search = Icons.search;
  static const filter = Icons.filter_list;
  static const refresh = Icons.refresh;
  static const close = Icons.close;
  static const check = Icons.check;
  static const more = Icons.more_vert;
  static const menu = Icons.menu;
  static const back = Icons.arrow_back;
  static const forward = Icons.chevron_right;
  static const expand = Icons.expand_more;
  static const collapse = Icons.expand_less;
  static const export = Icons.download_outlined;
  static const import = Icons.upload_outlined;
  static const logout = Icons.logout;

  // --- Tampilan -------------------------------------------------------------

  /// Mengikuti tema sistem operasi.
  static const themeSystem = Icons.brightness_auto_outlined;

  static const themeLight = Icons.light_mode_outlined;
  static const themeDark = Icons.dark_mode_outlined;

  // --- Umpan balik ----------------------------------------------------------

  static const success = Icons.check_circle_outline;
  static const danger = Icons.error_outline;
  static const warning = Icons.warning_amber_rounded;
  static const info = Icons.info_outline;

  /// Ilustrasi untuk keadaan kosong.
  static const empty = Icons.inbox_outlined;
}
