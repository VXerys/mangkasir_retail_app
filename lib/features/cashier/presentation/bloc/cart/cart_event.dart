import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../features/cashier/domain/entities/cart_item.dart';

part 'cart_event.freezed.dart';

@freezed
sealed class CartEvent with _$CartEvent {
  const factory CartEvent.started() = CartStarted;
  const factory CartEvent.tabAdded() = CartTabAdded;
  const factory CartEvent.tabSwitched({required String tabId}) = CartTabSwitched;
  const factory CartEvent.tabClosed({required String tabId}) = CartTabClosed;
  const factory CartEvent.customerAssigned({
    required String tabId,
    required String customerId,
    required String name,
  }) = CartCustomerAssigned;

  /// Adds item to active tab. If same productGuid exists, increments qty.
  const factory CartEvent.itemAdded({required CartItem item}) = CartItemAdded;
  const factory CartEvent.itemQtyChanged({
    required String productGuid,
    required int qty,
  }) = CartItemQtyChanged;
  const factory CartEvent.itemRemoved({required String productGuid}) =
      CartItemRemoved;
  const factory CartEvent.itemDiscountSet({
    required String productGuid,
    required double discount,
  }) = CartItemDiscountSet;
  const factory CartEvent.globalDiscountSet({required double discount}) =
      CartGlobalDiscountSet;

  /// Clear tab after successful checkout.
  const factory CartEvent.cleared({required String tabId}) = CartCleared;
}
