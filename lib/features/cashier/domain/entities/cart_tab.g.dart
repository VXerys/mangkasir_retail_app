// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_tab.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CartTabImpl _$$CartTabImplFromJson(Map<String, dynamic> json) =>
    _$CartTabImpl(
      id: json['id'] as String,
      customerId: json['customerId'] as String?,
      customerName: json['customerName'] as String?,
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => CartItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      globalDiscount: (json['globalDiscount'] as num?)?.toDouble() ?? 0,
    );

Map<String, dynamic> _$$CartTabImplToJson(_$CartTabImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'customerId': instance.customerId,
      'customerName': instance.customerName,
      'items': instance.items,
      'globalDiscount': instance.globalDiscount,
    };
