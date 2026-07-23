import 'package:freezed_annotation/freezed_annotation.dart';

import 'cart_item.dart';

part 'cart_tab.freezed.dart';
part 'cart_tab.g.dart';

@freezed
class CartTab with _$CartTab {
  const factory CartTab({
    required String id,
    String? customerId,
    String? customerName,
    @Default([]) List<CartItem> items,
    @Default(0) double globalDiscount,
  }) = _CartTab;

  factory CartTab.fromJson(Map<String, dynamic> json) =>
      _$CartTabFromJson(json);
}
