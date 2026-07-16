import 'package:freezed_annotation/freezed_annotation.dart';

part 'sync_event.freezed.dart';

@freezed
sealed class SyncEvent with _$SyncEvent {
  /// Manually triggered from Settings screen.
  const factory SyncEvent.requested() = SyncRequested;

  /// Auto-triggered when device goes online.
  const factory SyncEvent.triggered() = SyncTriggered;
}
