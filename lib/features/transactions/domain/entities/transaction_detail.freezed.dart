// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$TransactionDetail {
  String get id => throw _privateConstructorUsedError;
  String get guid => throw _privateConstructorUsedError;
  String get transactionGuid => throw _privateConstructorUsedError;
  String? get productGuid => throw _privateConstructorUsedError;
  String get productName => throw _privateConstructorUsedError;
  String? get productSku => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  double get cost => throw _privateConstructorUsedError;
  double get qty => throw _privateConstructorUsedError;
  double get discount => throw _privateConstructorUsedError;
  double get tax => throw _privateConstructorUsedError;
  double get totalPrice => throw _privateConstructorUsedError;
  String get syncStatus => throw _privateConstructorUsedError;
  String? get serverId => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Create a copy of TransactionDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransactionDetailCopyWith<TransactionDetail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransactionDetailCopyWith<$Res> {
  factory $TransactionDetailCopyWith(
    TransactionDetail value,
    $Res Function(TransactionDetail) then,
  ) = _$TransactionDetailCopyWithImpl<$Res, TransactionDetail>;
  @useResult
  $Res call({
    String id,
    String guid,
    String transactionGuid,
    String? productGuid,
    String productName,
    String? productSku,
    double price,
    double cost,
    double qty,
    double discount,
    double tax,
    double totalPrice,
    String syncStatus,
    String? serverId,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class _$TransactionDetailCopyWithImpl<$Res, $Val extends TransactionDetail>
    implements $TransactionDetailCopyWith<$Res> {
  _$TransactionDetailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TransactionDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? guid = null,
    Object? transactionGuid = null,
    Object? productGuid = freezed,
    Object? productName = null,
    Object? productSku = freezed,
    Object? price = null,
    Object? cost = null,
    Object? qty = null,
    Object? discount = null,
    Object? tax = null,
    Object? totalPrice = null,
    Object? syncStatus = null,
    Object? serverId = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            guid: null == guid
                ? _value.guid
                : guid // ignore: cast_nullable_to_non_nullable
                      as String,
            transactionGuid: null == transactionGuid
                ? _value.transactionGuid
                : transactionGuid // ignore: cast_nullable_to_non_nullable
                      as String,
            productGuid: freezed == productGuid
                ? _value.productGuid
                : productGuid // ignore: cast_nullable_to_non_nullable
                      as String?,
            productName: null == productName
                ? _value.productName
                : productName // ignore: cast_nullable_to_non_nullable
                      as String,
            productSku: freezed == productSku
                ? _value.productSku
                : productSku // ignore: cast_nullable_to_non_nullable
                      as String?,
            price: null == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                      as double,
            cost: null == cost
                ? _value.cost
                : cost // ignore: cast_nullable_to_non_nullable
                      as double,
            qty: null == qty
                ? _value.qty
                : qty // ignore: cast_nullable_to_non_nullable
                      as double,
            discount: null == discount
                ? _value.discount
                : discount // ignore: cast_nullable_to_non_nullable
                      as double,
            tax: null == tax
                ? _value.tax
                : tax // ignore: cast_nullable_to_non_nullable
                      as double,
            totalPrice: null == totalPrice
                ? _value.totalPrice
                : totalPrice // ignore: cast_nullable_to_non_nullable
                      as double,
            syncStatus: null == syncStatus
                ? _value.syncStatus
                : syncStatus // ignore: cast_nullable_to_non_nullable
                      as String,
            serverId: freezed == serverId
                ? _value.serverId
                : serverId // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TransactionDetailImplCopyWith<$Res>
    implements $TransactionDetailCopyWith<$Res> {
  factory _$$TransactionDetailImplCopyWith(
    _$TransactionDetailImpl value,
    $Res Function(_$TransactionDetailImpl) then,
  ) = __$$TransactionDetailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String guid,
    String transactionGuid,
    String? productGuid,
    String productName,
    String? productSku,
    double price,
    double cost,
    double qty,
    double discount,
    double tax,
    double totalPrice,
    String syncStatus,
    String? serverId,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class __$$TransactionDetailImplCopyWithImpl<$Res>
    extends _$TransactionDetailCopyWithImpl<$Res, _$TransactionDetailImpl>
    implements _$$TransactionDetailImplCopyWith<$Res> {
  __$$TransactionDetailImplCopyWithImpl(
    _$TransactionDetailImpl _value,
    $Res Function(_$TransactionDetailImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TransactionDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? guid = null,
    Object? transactionGuid = null,
    Object? productGuid = freezed,
    Object? productName = null,
    Object? productSku = freezed,
    Object? price = null,
    Object? cost = null,
    Object? qty = null,
    Object? discount = null,
    Object? tax = null,
    Object? totalPrice = null,
    Object? syncStatus = null,
    Object? serverId = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$TransactionDetailImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        guid: null == guid
            ? _value.guid
            : guid // ignore: cast_nullable_to_non_nullable
                  as String,
        transactionGuid: null == transactionGuid
            ? _value.transactionGuid
            : transactionGuid // ignore: cast_nullable_to_non_nullable
                  as String,
        productGuid: freezed == productGuid
            ? _value.productGuid
            : productGuid // ignore: cast_nullable_to_non_nullable
                  as String?,
        productName: null == productName
            ? _value.productName
            : productName // ignore: cast_nullable_to_non_nullable
                  as String,
        productSku: freezed == productSku
            ? _value.productSku
            : productSku // ignore: cast_nullable_to_non_nullable
                  as String?,
        price: null == price
            ? _value.price
            : price // ignore: cast_nullable_to_non_nullable
                  as double,
        cost: null == cost
            ? _value.cost
            : cost // ignore: cast_nullable_to_non_nullable
                  as double,
        qty: null == qty
            ? _value.qty
            : qty // ignore: cast_nullable_to_non_nullable
                  as double,
        discount: null == discount
            ? _value.discount
            : discount // ignore: cast_nullable_to_non_nullable
                  as double,
        tax: null == tax
            ? _value.tax
            : tax // ignore: cast_nullable_to_non_nullable
                  as double,
        totalPrice: null == totalPrice
            ? _value.totalPrice
            : totalPrice // ignore: cast_nullable_to_non_nullable
                  as double,
        syncStatus: null == syncStatus
            ? _value.syncStatus
            : syncStatus // ignore: cast_nullable_to_non_nullable
                  as String,
        serverId: freezed == serverId
            ? _value.serverId
            : serverId // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc

class _$TransactionDetailImpl implements _TransactionDetail {
  const _$TransactionDetailImpl({
    required this.id,
    required this.guid,
    required this.transactionGuid,
    this.productGuid,
    required this.productName,
    this.productSku,
    required this.price,
    this.cost = 0,
    required this.qty,
    this.discount = 0,
    this.tax = 0,
    required this.totalPrice,
    this.syncStatus = 'pending',
    this.serverId,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  final String id;
  @override
  final String guid;
  @override
  final String transactionGuid;
  @override
  final String? productGuid;
  @override
  final String productName;
  @override
  final String? productSku;
  @override
  final double price;
  @override
  @JsonKey()
  final double cost;
  @override
  final double qty;
  @override
  @JsonKey()
  final double discount;
  @override
  @JsonKey()
  final double tax;
  @override
  final double totalPrice;
  @override
  @JsonKey()
  final String syncStatus;
  @override
  final String? serverId;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'TransactionDetail(id: $id, guid: $guid, transactionGuid: $transactionGuid, productGuid: $productGuid, productName: $productName, productSku: $productSku, price: $price, cost: $cost, qty: $qty, discount: $discount, tax: $tax, totalPrice: $totalPrice, syncStatus: $syncStatus, serverId: $serverId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionDetailImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.guid, guid) || other.guid == guid) &&
            (identical(other.transactionGuid, transactionGuid) ||
                other.transactionGuid == transactionGuid) &&
            (identical(other.productGuid, productGuid) ||
                other.productGuid == productGuid) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.productSku, productSku) ||
                other.productSku == productSku) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.cost, cost) || other.cost == cost) &&
            (identical(other.qty, qty) || other.qty == qty) &&
            (identical(other.discount, discount) ||
                other.discount == discount) &&
            (identical(other.tax, tax) || other.tax == tax) &&
            (identical(other.totalPrice, totalPrice) ||
                other.totalPrice == totalPrice) &&
            (identical(other.syncStatus, syncStatus) ||
                other.syncStatus == syncStatus) &&
            (identical(other.serverId, serverId) ||
                other.serverId == serverId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    guid,
    transactionGuid,
    productGuid,
    productName,
    productSku,
    price,
    cost,
    qty,
    discount,
    tax,
    totalPrice,
    syncStatus,
    serverId,
    createdAt,
    updatedAt,
  );

  /// Create a copy of TransactionDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransactionDetailImplCopyWith<_$TransactionDetailImpl> get copyWith =>
      __$$TransactionDetailImplCopyWithImpl<_$TransactionDetailImpl>(
        this,
        _$identity,
      );
}

abstract class _TransactionDetail implements TransactionDetail {
  const factory _TransactionDetail({
    required final String id,
    required final String guid,
    required final String transactionGuid,
    final String? productGuid,
    required final String productName,
    final String? productSku,
    required final double price,
    final double cost,
    required final double qty,
    final double discount,
    final double tax,
    required final double totalPrice,
    final String syncStatus,
    final String? serverId,
    required final DateTime createdAt,
    required final DateTime updatedAt,
  }) = _$TransactionDetailImpl;

  @override
  String get id;
  @override
  String get guid;
  @override
  String get transactionGuid;
  @override
  String? get productGuid;
  @override
  String get productName;
  @override
  String? get productSku;
  @override
  double get price;
  @override
  double get cost;
  @override
  double get qty;
  @override
  double get discount;
  @override
  double get tax;
  @override
  double get totalPrice;
  @override
  String get syncStatus;
  @override
  String? get serverId;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of TransactionDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransactionDetailImplCopyWith<_$TransactionDetailImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
