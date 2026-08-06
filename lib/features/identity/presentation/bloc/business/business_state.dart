import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entities/business.dart';

part 'business_state.freezed.dart';

@freezed
sealed class BusinessState with _$BusinessState {
  const factory BusinessState.loading() = BusinessLoading;
  const factory BusinessState.loaded(Business business) = BusinessLoaded;
  const factory BusinessState.saving() = BusinessSaving;
  const factory BusinessState.saved(Business business) = BusinessSaved;
  const factory BusinessState.error(String message) = BusinessError;
}
