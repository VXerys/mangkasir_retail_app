// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CartItemImpl _$$CartItemImplFromJson(Map<String, dynamic> json) =>
    _$CartItemImpl(
      productGuid: json['productGuid'] as String,
      productName: json['productName'] as String,
      price: (json['price'] as num).toDouble(),
      qty: (json['qty'] as num).toInt(),
      discount: (json['discount'] as num?)?.toDouble() ?? 0,
      ppn: (json['ppn'] as num?)?.toDouble() ?? 0,
    );

Map<String, dynamic> _$$CartItemImplToJson(_$CartItemImpl instance) =>
    <String, dynamic>{
      'productGuid': instance.productGuid,
      'productName': instance.productName,
      'price': instance.price,
      'qty': instance.qty,
      'discount': instance.discount,
      'ppn': instance.ppn,
    };
