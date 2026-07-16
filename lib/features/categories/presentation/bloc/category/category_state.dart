import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../features/categories/domain/entities/category.dart';

part 'category_state.freezed.dart';

@freezed
sealed class CategoryState with _$CategoryState {
  const factory CategoryState.initial() = CategoryInitial;
  const factory CategoryState.loading() = CategoryLoading;
  const factory CategoryState.loaded({required List<Category> categories}) =
      CategoryLoaded;
  const factory CategoryState.error({required String message}) = CategoryError;
}
