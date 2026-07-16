// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$Transaction {
  String get id => throw _privateConstructorUsedError;
  String get guid => throw _privateConstructorUsedError;
  String get storeId => throw _privateConstructorUsedError;
  double get subTotal => throw _privateConstructorUsedError;
  double get discount => throw _privateConstructorUsedError;
  double get tax => throw _privateConstructorUsedError;
  String get paymentMethod => throw _privateConstructorUsedError;
  String get flag => throw _privateConstructorUsedError;
  String? get invoice => throw _privateConstructorUsedError;
  String? get customerName => throw _privateConstructorUsedError;
  String? get cashierId => throw _privateConstructorUsedError;
  DateTime? get date => throw _privateConstructorUsedError;
  String get syncStatus => throw _privateConstructorUsedError;
  String? get serverId => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransactionCopyWith<Transaction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransactionCopyWith<$Res> {
  factory $TransactionCopyWith(
    Transaction value,
    $Res Function(Transaction) then,
  ) = _$TransactionCopyWithImpl<$Res, Transaction>;
  @useResult
  $Res call({
    String id,
    String guid,
    String storeId,
    double subTotal,
    double discount,
    double tax,
    String paymentMethod,
    String flag,
    String? invoice,
    String? customerName,
    String? cashierId,
    DateTime? date,
    String syncStatus,
    String? serverId,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class _$TransactionCopyWithImpl<$Res, $Val extends Transaction>
    implements $TransactionCopyWith<$Res> {
  _$TransactionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? guid = null,
    Object? storeId = null,
    Object? subTotal = null,
    Object? discount = null,
    Object? tax = null,
    Object? paymentMethod = null,
    Object? flag = null,
    Object? invoice = freezed,
    Object? customerName = freezed,
    Object? cashierId = freezed,
    Object? date = freezed,
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
            storeId: null == storeId
                ? _value.storeId
                : storeId // ignore: cast_nullable_to_non_nullable
                      as String,
            subTotal: null == subTotal
                ? _value.subTotal
                : subTotal // ignore: cast_nullable_to_non_nullable
                      as double,
            discount: null == discount
                ? _value.discount
                : discount // ignore: cast_nullable_to_non_nullable
                      as double,
            tax: null == tax
                ? _value.tax
                : tax // ignore: cast_nullable_to_non_nullable
                      as double,
            paymentMethod: null == paymentMethod
                ? _value.paymentMethod
                : paymentMethod // ignore: cast_nullable_to_non_nullable
                      as String,
            flag: null == flag
                ? _value.flag
                : flag // ignore: cast_nullable_to_non_nullable
                      as String,
            invoice: freezed == invoice
                ? _value.invoice
                : invoice // ignore: cast_nullable_to_non_nullable
                      as String?,
            customerName: freezed == customerName
                ? _value.customerName
                : customerName // ignore: cast_nullable_to_non_nullable
                      as String?,
            cashierId: freezed == cashierId
                ? _value.cashierId
                : cashierId // ignore: cast_nullable_to_non_nullable
                      as String?,
            date: freezed == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
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
abstract class _$$TransactionImplCopyWith<$Res>
    implements $TransactionCopyWith<$Res> {
  factory _$$TransactionImplCopyWith(
    _$TransactionImpl value,
    $Res Function(_$TransactionImpl) then,
  ) = __$$TransactionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String guid,
    String storeId,
    double subTotal,
    double discount,
    double tax,
    String paymentMethod,
    String flag,
    String? invoice,
    String? customerName,
    String? cashierId,
    DateTime? date,
    String syncStatus,
    String? serverId,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class __$$TransactionImplCopyWithImpl<$Res>
    extends _$TransactionCopyWithImpl<$Res, _$TransactionImpl>
    implements _$$TransactionImplCopyWith<$Res> {
  __$$TransactionImplCopyWithImpl(
    _$TransactionImpl _value,
    $Res Function(_$TransactionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? guid = null,
    Object? storeId = null,
    Object? subTotal = null,
    Object? discount = null,
    Object? tax = null,
    Object? paymentMethod = null,
    Object? flag = null,
    Object? invoice = freezed,
    Object? customerName = freezed,
    Object? cashierId = freezed,
    Object? date = freezed,
    Object? syncStatus = null,
    Object? serverId = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$TransactionImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        guid: null == guid
            ? _value.guid
            : guid // ignore: cast_nullable_to_non_nullable
                  as String,
        storeId: null == storeId
            ? _value.storeId
            : storeId // ignore: cast_nullable_to_non_nullable
                  as String,
        subTotal: null == subTotal
            ? _value.subTotal
            : subTotal // ignore: cast_nullable_to_non_nullable
                  as double,
        discount: null == discount
            ? _value.discount
            : discount // ignore: cast_nullable_to_non_nullable
                  as double,
        tax: null == tax
            ? _value.tax
            : tax // ignore: cast_nullable_to_non_nullable
                  as double,
        paymentMethod: null == paymentMethod
            ? _value.paymentMethod
            : paymentMethod // ignore: cast_nullable_to_non_nullable
                  as String,
        flag: null == flag
            ? _value.flag
            : flag // ignore: cast_nullable_to_non_nullable
                  as String,
        invoice: freezed == invoice
            ? _value.invoice
            : invoice // ignore: cast_nullable_to_non_nullable
                  as String?,
        customerName: freezed == customerName
            ? _value.customerName
            : customerName // ignore: cast_nullable_to_non_nullable
                  as String?,
        cashierId: freezed == cashierId
            ? _value.cashierId
            : cashierId // ignore: cast_nullable_to_non_nullable
                  as String?,
        date: freezed == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
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

class _$TransactionImpl implements _Transaction {
  const _$TransactionImpl({
    required this.id,
    required this.guid,
    required this.storeId,
    required this.subTotal,
    this.discount = 0,
    this.tax = 0,
    required this.paymentMethod,
    this.flag = 'done',
    this.invoice,
    this.customerName,
    this.cashierId,
    this.date,
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
  final String storeId;
  @override
  final double subTotal;
  @override
  @JsonKey()
  final double discount;
  @override
  @JsonKey()
  final double tax;
  @override
  final String paymentMethod;
  @override
  @JsonKey()
  final String flag;
  @override
  final String? invoice;
  @override
  final String? customerName;
  @override
  final String? cashierId;
  @override
  final DateTime? date;
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
    return 'Transaction(id: $id, guid: $guid, storeId: $storeId, subTotal: $subTotal, discount: $discount, tax: $tax, paymentMethod: $paymentMethod, flag: $flag, invoice: $invoice, customerName: $customerName, cashierId: $cashierId, date: $date, syncStatus: $syncStatus, serverId: $serverId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.guid, guid) || other.guid == guid) &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.subTotal, subTotal) ||
                other.subTotal == subTotal) &&
            (identical(other.discount, discount) ||
                other.discount == discount) &&
            (identical(other.tax, tax) || other.tax == tax) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.flag, flag) || other.flag == flag) &&
            (identical(other.invoice, invoice) || other.invoice == invoice) &&
            (identical(other.customerName, customerName) ||
                other.customerName == customerName) &&
            (identical(other.cashierId, cashierId) ||
                other.cashierId == cashierId) &&
            (identical(other.date, date) || other.date == date) &&
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
    storeId,
    subTotal,
    discount,
    tax,
    paymentMethod,
    flag,
    invoice,
    customerName,
    cashierId,
    date,
    syncStatus,
    serverId,
    createdAt,
    updatedAt,
  );

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransactionImplCopyWith<_$TransactionImpl> get copyWith =>
      __$$TransactionImplCopyWithImpl<_$TransactionImpl>(this, _$identity);
}

abstract class _Transaction implements Transaction {
  const factory _Transaction({
    required final String id,
    required final String guid,
    required final String storeId,
    required final double subTotal,
    final double discount,
    final double tax,
    required final String paymentMethod,
    final String flag,
    final String? invoice,
    final String? customerName,
    final String? cashierId,
    final DateTime? date,
    final String syncStatus,
    final String? serverId,
    required final DateTime createdAt,
    required final DateTime updatedAt,
  }) = _$TransactionImpl;

  @override
  String get id;
  @override
  String get guid;
  @override
  String get storeId;
  @override
  double get subTotal;
  @override
  double get discount;
  @override
  double get tax;
  @override
  String get paymentMethod;
  @override
  String get flag;
  @override
  String? get invoice;
  @override
  String? get customerName;
  @override
  String? get cashierId;
  @override
  DateTime? get date;
  @override
  String get syncStatus;
  @override
  String? get serverId;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransactionImplCopyWith<_$TransactionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
