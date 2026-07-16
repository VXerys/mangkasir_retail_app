import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../sync_worker.dart';
import 'sync_event.dart';
import 'sync_state.dart';

@lazySingleton
class SyncBloc extends Bloc<SyncEvent, SyncState> {
  final SyncWorker _worker;

  SyncBloc(this._worker) : super(const SyncState.idle()) {
    // Manual trigger: runs immediately, no drop.
    on<SyncRequested>(_onSync);
    // Auto trigger: drop if sync already running — prevents concurrent syncs.
    on<SyncTriggered>(_onSync, transformer: droppable());
  }

  Future<void> _onSync(SyncEvent event, Emitter<SyncState> emit) async {
    if (state is Syncing) return;

    bool failed = false;

    await emit.forEach<SyncProgress>(
      _worker.run(),
      onData: (progress) => SyncState.syncing(current: progress.entity),
      onError: (e, _) {
        failed = true;
        if (e is SyncAbortedException) {
          return SyncState.failed(failedAt: e.entity, message: e.message);
        }
        return SyncState.failed(
          failedAt: SyncEntity.category,
          message: e.toString(),
        );
      },
    );

    if (!failed) emit(const SyncState.completed());
  }
}
