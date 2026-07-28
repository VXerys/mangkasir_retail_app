import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../design/design.dart';
import 'sync_bloc/sync_bloc.dart';
import 'sync_bloc/sync_state.dart';

/// Menampilkan kegagalan sinkronisasi sebagai toast.
///
/// Tanpa ini `SyncWorker` gagal dalam senyap: ia berhenti di langkah pertama
/// yang gagal, seluruh entitas sesudahnya tidak pernah dicoba, dan pengguna
/// tidak melihat apa pun. Gejalanya cuma "data saya tidak naik-naik", yang
/// mustahil dilaporkan dengan berguna.
///
/// [bloc] diterima sebagai parameter, bukan dicari lewat `context.read`, supaya
/// widget ini bisa dipasang di rakitan yang belum punya `SyncBloc` — tes widget
/// menaikkan aplikasi tanpa DI penuh, dan `SyncBloc` menyeret empat repositori
/// beserta Drift di belakangnya.
class SyncFailureListener extends StatelessWidget {
  final SyncBloc? bloc;
  final Widget child;

  const SyncFailureListener({super.key, this.bloc, required this.child});

  @override
  Widget build(BuildContext context) {
    final syncBloc = bloc;
    if (syncBloc == null) return child;

    return BlocListener<SyncBloc, SyncState>(
      bloc: syncBloc,
      listenWhen: (previous, current) => current is SyncFailed,
      listener: (context, state) {
        if (state is! SyncFailed) return;

        AppToast.danger(
          context,
          'Sinkronisasi berhenti di ${_label(state.failedAt)}: ${state.message}',
        );
      },
      child: child,
    );
  }

  /// Nama entitas dalam bahasa yang dipakai pengguna, bukan nama tabel.
  static String _label(SyncEntity entity) => switch (entity) {
        SyncEntity.category => 'kategori',
        SyncEntity.product => 'produk',
        SyncEntity.transaction => 'transaksi',
        SyncEntity.payment => 'pembayaran',
      };
}
