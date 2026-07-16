import 'package:freezed_annotation/freezed_annotation.dart';

part 'sync_state.freezed.dart';

enum SyncEntity { category, product, transaction, payment }

@freezed
sealed class SyncState with _$SyncState {
  const factory SyncState.idle() = SyncIdle;

  const factory SyncState.syncing({required SyncEntity current}) = Syncing;

  const factory SyncState.completed() = SyncCompleted;

  const factory SyncState.failed({
    required SyncEntity failedAt,
    required String message,
  }) = SyncFailed;
}
