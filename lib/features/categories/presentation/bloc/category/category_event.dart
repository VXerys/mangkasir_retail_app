import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../features/categories/domain/entities/category.dart';

part 'category_event.freezed.dart';

@freezed
sealed class CategoryEvent with _$CategoryEvent {
  const factory CategoryEvent.watchStarted() = CategoryWatchStarted;
  const factory CategoryEvent.added({required Category category}) =
      CategoryAdded;
  const factory CategoryEvent.updated({required Category category}) =
      CategoryUpdated;
}
