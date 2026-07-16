# sync

Folder ini menyimpan logika sinkronisasi data antara database lokal (Drift) dan server. `SyncWorker` mengatur urutan sync (kategori → produk → transaksi → pembayaran), `SyncQueue` membaca data dengan status `pending` dari Drift, dan `ConnectivityService` memantau koneksi internet untuk memicu sync otomatis.

Contoh file: `sync_worker.dart`
