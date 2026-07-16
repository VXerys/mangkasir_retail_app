import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../features/products/domain/entities/product.dart';

part 'product_state.freezed.dart';

@freezed
sealed class ProductState with _$ProductState {
  const factory ProductState.initial() = ProductInitial;
  const factory ProductState.loading() = ProductLoading;
  const factory ProductState.loaded({required List<Product> products}) =
      ProductLoaded;
  const factory ProductState.error({required String message}) = ProductError;
}
