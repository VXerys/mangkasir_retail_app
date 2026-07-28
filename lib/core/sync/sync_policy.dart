/// Kapan aplikasi boleh mendorong data ke Supabase.
///
/// Sakelar tunggal, sengaja bukan variabel lingkungan dan bukan setelan
/// pengguna: ini keputusan fase, bukan preferensi, dan tempatnya harus mudah
/// ditemukan orang yang bertanya "kenapa datanya tidak naik?".
abstract final class SyncPolicy {
  /// Mendorong data lokal ke server.
  ///
  /// **Masih dimatikan sejak UI-5.** Tiga hal harus benar lebih dulu, dan
  /// ketiganya ada di track backend:
  ///
  /// 1. `outlets` di server masih 0 baris, sedangkan `products.outlet_id`
  ///    menunjuk ke sana. Setiap produk yang didorong hari ini gagal FK.
  /// 2. `SyncWorker.run()` berurutan ketat dan berhenti di kegagalan pertama.
  ///    Jadi satu produk yang gagal ikut menahan transaksi dan pembayaran —
  ///    dan satu-satunya gejalanya adalah sinkronisasi yang tidak pernah
  ///    selesai, tanpa satu pun galat yang terlihat pengguna.
  /// 3. Delapan trigger di Supabase belum pernah dijalankan dengan data nyata.
  ///
  /// Sampai `be2-seed-master` selesai — dengan id outlet 1 dan 2, persis yang
  /// dibagikan `DevSessionRepository` — baris tetap menunggu di
  /// `syncStatus: 'pending'`. Itu bukan kegagalan; memang begitu cara aplikasi
  /// offline-first menyimpan pekerjaan yang belum sempat naik.
  static const pushEnabled = false;
}
