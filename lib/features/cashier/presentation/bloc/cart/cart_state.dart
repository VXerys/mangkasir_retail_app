import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../features/cashier/domain/entities/cart_tab.dart';

part 'cart_state.freezed.dart';

@freezed
sealed class CartState with _$CartState {
  const factory CartState.loading() = CartLoading;
  const factory CartState.ready({
    required Map<String, CartTab> tabs,
    required String activeTabId,
  }) = CartReady;
  const factory CartState.error({required String message}) = CartError;
}
