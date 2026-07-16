import 'package:freezed_annotation/freezed_annotation.dart';

part 'cart_totals.freezed.dart';

@freezed
class CartTotals with _$CartTotals {
  const factory CartTotals({
    required double subTotal,
    required double totalDiscount,
    required double totalPpn,
    required double grandTotal,
  }) = _CartTotals;
}
