import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entities/outlet.dart';

part 'outlet_state.freezed.dart';

@freezed
sealed class OutletState with _$OutletState {
  const factory OutletState.loading() = OutletLoading;
  const factory OutletState.loaded(List<Outlet> outlets) = OutletLoaded;
  const factory OutletState.saving() = OutletSaving;
  const factory OutletState.error(String message) = OutletError;
}
