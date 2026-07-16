import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../features/products/domain/entities/product.dart';

part 'product_event.freezed.dart';

@freezed
sealed class ProductEvent with _$ProductEvent {
  /// Start watching products stream, optionally filtered by category.
  const factory ProductEvent.watchStarted({String? categoryId}) =
      ProductWatchStarted;

  /// Save a new product to local DB (syncStatus='pending').
  const factory ProductEvent.added({required Product product}) = ProductAdded;

  /// Update an existing product (resets syncStatus to 'pending').
  const factory ProductEvent.updated({required Product product}) =
      ProductUpdated;
}
