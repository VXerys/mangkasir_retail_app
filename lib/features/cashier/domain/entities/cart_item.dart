import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cart_item.freezed.dart';
part 'cart_item.g.dart';

@freezed
class CartItem with _$CartItem {
  const factory CartItem({
    required String productGuid,
    required String productName,   // snapshot — tidak boleh berubah walau produk di-edit
    required double price,         // snapshot harga saat masuk cart
    required int qty,
    @Default(0) double discount,   // per-item, nominal
    @Default(0) double ppn,        // persen (0–100)
  }) = _CartItem;

  factory CartItem.fromJson(Map<String, dynamic> json) =>
      _$CartItemFromJson(json);
}
