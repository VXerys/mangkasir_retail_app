import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../features/products/domain/entities/product.dart';

part 'product_event.freezed.dart';

@freezed
sealed class ProductEvent with _$ProductEvent {
  /// Start watching products stream for one outlet, optionally filtered by
  /// category.
  ///
  /// [storeId] is the active outlet id from `AppSession`, stringified. It is
  /// required rather than read from the session inside the bloc: the bloc must
  /// stay testable without a session, and a stream that silently spans outlets
  /// is worse than one that refuses to start.
  const factory ProductEvent.watchStarted({
    required String storeId,
    String? categoryId,
  }) = ProductWatchStarted;

  /// Save a new product to local DB (syncStatus='pending').
  const factory ProductEvent.added({required Product product}) = ProductAdded;

  /// Update an existing product (resets syncStatus to 'pending').
  const factory ProductEvent.updated({required Product product}) =
      ProductUpdated;
}
