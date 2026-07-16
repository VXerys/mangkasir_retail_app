// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cart_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$CartEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function() tabAdded,
    required TResult Function(String tabId) tabSwitched,
    required TResult Function(String tabId) tabClosed,
    required TResult Function(String tabId, String customerId, String name)
    customerAssigned,
    required TResult Function(CartItem item) itemAdded,
    required TResult Function(String productGuid, int qty) itemQtyChanged,
    required TResult Function(String productGuid) itemRemoved,
    required TResult Function(String productGuid, double discount)
    itemDiscountSet,
    required TResult Function(double discount) globalDiscountSet,
    required TResult Function(String tabId) cleared,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function()? tabAdded,
    TResult? Function(String tabId)? tabSwitched,
    TResult? Function(String tabId)? tabClosed,
    TResult? Function(String tabId, String customerId, String name)?
    customerAssigned,
    TResult? Function(CartItem item)? itemAdded,
    TResult? Function(String productGuid, int qty)? itemQtyChanged,
    TResult? Function(String productGuid)? itemRemoved,
    TResult? Function(String productGuid, double discount)? itemDiscountSet,
    TResult? Function(double discount)? globalDiscountSet,
    TResult? Function(String tabId)? cleared,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function()? tabAdded,
    TResult Function(String tabId)? tabSwitched,
    TResult Function(String tabId)? tabClosed,
    TResult Function(String tabId, String customerId, String name)?
    customerAssigned,
    TResult Function(CartItem item)? itemAdded,
    TResult Function(String productGuid, int qty)? itemQtyChanged,
    TResult Function(String productGuid)? itemRemoved,
    TResult Function(String productGuid, double discount)? itemDiscountSet,
    TResult Function(double discount)? globalDiscountSet,
    TResult Function(String tabId)? cleared,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CartStarted value) started,
    required TResult Function(CartTabAdded value) tabAdded,
    required TResult Function(CartTabSwitched value) tabSwitched,
    required TResult Function(CartTabClosed value) tabClosed,
    required TResult Function(CartCustomerAssigned value) customerAssigned,
    required TResult Function(CartItemAdded value) itemAdded,
    required TResult Function(CartItemQtyChanged value) itemQtyChanged,
    required TResult Function(CartItemRemoved value) itemRemoved,
    required TResult Function(CartItemDiscountSet value) itemDiscountSet,
    required TResult Function(CartGlobalDiscountSet value) globalDiscountSet,
    required TResult Function(CartCleared value) cleared,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CartStarted value)? started,
    TResult? Function(CartTabAdded value)? tabAdded,
    TResult? Function(CartTabSwitched value)? tabSwitched,
    TResult? Function(CartTabClosed value)? tabClosed,
    TResult? Function(CartCustomerAssigned value)? customerAssigned,
    TResult? Function(CartItemAdded value)? itemAdded,
    TResult? Function(CartItemQtyChanged value)? itemQtyChanged,
    TResult? Function(CartItemRemoved value)? itemRemoved,
    TResult? Function(CartItemDiscountSet value)? itemDiscountSet,
    TResult? Function(CartGlobalDiscountSet value)? globalDiscountSet,
    TResult? Function(CartCleared value)? cleared,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CartStarted value)? started,
    TResult Function(CartTabAdded value)? tabAdded,
    TResult Function(CartTabSwitched value)? tabSwitched,
    TResult Function(CartTabClosed value)? tabClosed,
    TResult Function(CartCustomerAssigned value)? customerAssigned,
    TResult Function(CartItemAdded value)? itemAdded,
    TResult Function(CartItemQtyChanged value)? itemQtyChanged,
    TResult Function(CartItemRemoved value)? itemRemoved,
    TResult Function(CartItemDiscountSet value)? itemDiscountSet,
    TResult Function(CartGlobalDiscountSet value)? globalDiscountSet,
    TResult Function(CartCleared value)? cleared,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CartEventCopyWith<$Res> {
  factory $CartEventCopyWith(CartEvent value, $Res Function(CartEvent) then) =
      _$CartEventCopyWithImpl<$Res, CartEvent>;
}

/// @nodoc
class _$CartEventCopyWithImpl<$Res, $Val extends CartEvent>
    implements $CartEventCopyWith<$Res> {
  _$CartEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CartEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$CartStartedImplCopyWith<$Res> {
  factory _$$CartStartedImplCopyWith(
    _$CartStartedImpl value,
    $Res Function(_$CartStartedImpl) then,
  ) = __$$CartStartedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$CartStartedImplCopyWithImpl<$Res>
    extends _$CartEventCopyWithImpl<$Res, _$CartStartedImpl>
    implements _$$CartStartedImplCopyWith<$Res> {
  __$$CartStartedImplCopyWithImpl(
    _$CartStartedImpl _value,
    $Res Function(_$CartStartedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CartEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$CartStartedImpl implements CartStarted {
  const _$CartStartedImpl();

  @override
  String toString() {
    return 'CartEvent.started()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$CartStartedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function() tabAdded,
    required TResult Function(String tabId) tabSwitched,
    required TResult Function(String tabId) tabClosed,
    required TResult Function(String tabId, String customerId, String name)
    customerAssigned,
    required TResult Function(CartItem item) itemAdded,
    required TResult Function(String productGuid, int qty) itemQtyChanged,
    required TResult Function(String productGuid) itemRemoved,
    required TResult Function(String productGuid, double discount)
    itemDiscountSet,
    required TResult Function(double discount) globalDiscountSet,
    required TResult Function(String tabId) cleared,
  }) {
    return started();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function()? tabAdded,
    TResult? Function(String tabId)? tabSwitched,
    TResult? Function(String tabId)? tabClosed,
    TResult? Function(String tabId, String customerId, String name)?
    customerAssigned,
    TResult? Function(CartItem item)? itemAdded,
    TResult? Function(String productGuid, int qty)? itemQtyChanged,
    TResult? Function(String productGuid)? itemRemoved,
    TResult? Function(String productGuid, double discount)? itemDiscountSet,
    TResult? Function(double discount)? globalDiscountSet,
    TResult? Function(String tabId)? cleared,
  }) {
    return started?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function()? tabAdded,
    TResult Function(String tabId)? tabSwitched,
    TResult Function(String tabId)? tabClosed,
    TResult Function(String tabId, String customerId, String name)?
    customerAssigned,
    TResult Function(CartItem item)? itemAdded,
    TResult Function(String productGuid, int qty)? itemQtyChanged,
    TResult Function(String productGuid)? itemRemoved,
    TResult Function(String productGuid, double discount)? itemDiscountSet,
    TResult Function(double discount)? globalDiscountSet,
    TResult Function(String tabId)? cleared,
    required TResult orElse(),
  }) {
    if (started != null) {
      return started();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CartStarted value) started,
    required TResult Function(CartTabAdded value) tabAdded,
    required TResult Function(CartTabSwitched value) tabSwitched,
    required TResult Function(CartTabClosed value) tabClosed,
    required TResult Function(CartCustomerAssigned value) customerAssigned,
    required TResult Function(CartItemAdded value) itemAdded,
    required TResult Function(CartItemQtyChanged value) itemQtyChanged,
    required TResult Function(CartItemRemoved value) itemRemoved,
    required TResult Function(CartItemDiscountSet value) itemDiscountSet,
    required TResult Function(CartGlobalDiscountSet value) globalDiscountSet,
    required TResult Function(CartCleared value) cleared,
  }) {
    return started(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CartStarted value)? started,
    TResult? Function(CartTabAdded value)? tabAdded,
    TResult? Function(CartTabSwitched value)? tabSwitched,
    TResult? Function(CartTabClosed value)? tabClosed,
    TResult? Function(CartCustomerAssigned value)? customerAssigned,
    TResult? Function(CartItemAdded value)? itemAdded,
    TResult? Function(CartItemQtyChanged value)? itemQtyChanged,
    TResult? Function(CartItemRemoved value)? itemRemoved,
    TResult? Function(CartItemDiscountSet value)? itemDiscountSet,
    TResult? Function(CartGlobalDiscountSet value)? globalDiscountSet,
    TResult? Function(CartCleared value)? cleared,
  }) {
    return started?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CartStarted value)? started,
    TResult Function(CartTabAdded value)? tabAdded,
    TResult Function(CartTabSwitched value)? tabSwitched,
    TResult Function(CartTabClosed value)? tabClosed,
    TResult Function(CartCustomerAssigned value)? customerAssigned,
    TResult Function(CartItemAdded value)? itemAdded,
    TResult Function(CartItemQtyChanged value)? itemQtyChanged,
    TResult Function(CartItemRemoved value)? itemRemoved,
    TResult Function(CartItemDiscountSet value)? itemDiscountSet,
    TResult Function(CartGlobalDiscountSet value)? globalDiscountSet,
    TResult Function(CartCleared value)? cleared,
    required TResult orElse(),
  }) {
    if (started != null) {
      return started(this);
    }
    return orElse();
  }
}

abstract class CartStarted implements CartEvent {
  const factory CartStarted() = _$CartStartedImpl;
}

/// @nodoc
abstract class _$$CartTabAddedImplCopyWith<$Res> {
  factory _$$CartTabAddedImplCopyWith(
    _$CartTabAddedImpl value,
    $Res Function(_$CartTabAddedImpl) then,
  ) = __$$CartTabAddedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$CartTabAddedImplCopyWithImpl<$Res>
    extends _$CartEventCopyWithImpl<$Res, _$CartTabAddedImpl>
    implements _$$CartTabAddedImplCopyWith<$Res> {
  __$$CartTabAddedImplCopyWithImpl(
    _$CartTabAddedImpl _value,
    $Res Function(_$CartTabAddedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CartEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$CartTabAddedImpl implements CartTabAdded {
  const _$CartTabAddedImpl();

  @override
  String toString() {
    return 'CartEvent.tabAdded()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$CartTabAddedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function() tabAdded,
    required TResult Function(String tabId) tabSwitched,
    required TResult Function(String tabId) tabClosed,
    required TResult Function(String tabId, String customerId, String name)
    customerAssigned,
    required TResult Function(CartItem item) itemAdded,
    required TResult Function(String productGuid, int qty) itemQtyChanged,
    required TResult Function(String productGuid) itemRemoved,
    required TResult Function(String productGuid, double discount)
    itemDiscountSet,
    required TResult Function(double discount) globalDiscountSet,
    required TResult Function(String tabId) cleared,
  }) {
    return tabAdded();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function()? tabAdded,
    TResult? Function(String tabId)? tabSwitched,
    TResult? Function(String tabId)? tabClosed,
    TResult? Function(String tabId, String customerId, String name)?
    customerAssigned,
    TResult? Function(CartItem item)? itemAdded,
    TResult? Function(String productGuid, int qty)? itemQtyChanged,
    TResult? Function(String productGuid)? itemRemoved,
    TResult? Function(String productGuid, double discount)? itemDiscountSet,
    TResult? Function(double discount)? globalDiscountSet,
    TResult? Function(String tabId)? cleared,
  }) {
    return tabAdded?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function()? tabAdded,
    TResult Function(String tabId)? tabSwitched,
    TResult Function(String tabId)? tabClosed,
    TResult Function(String tabId, String customerId, String name)?
    customerAssigned,
    TResult Function(CartItem item)? itemAdded,
    TResult Function(String productGuid, int qty)? itemQtyChanged,
    TResult Function(String productGuid)? itemRemoved,
    TResult Function(String productGuid, double discount)? itemDiscountSet,
    TResult Function(double discount)? globalDiscountSet,
    TResult Function(String tabId)? cleared,
    required TResult orElse(),
  }) {
    if (tabAdded != null) {
      return tabAdded();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CartStarted value) started,
    required TResult Function(CartTabAdded value) tabAdded,
    required TResult Function(CartTabSwitched value) tabSwitched,
    required TResult Function(CartTabClosed value) tabClosed,
    required TResult Function(CartCustomerAssigned value) customerAssigned,
    required TResult Function(CartItemAdded value) itemAdded,
    required TResult Function(CartItemQtyChanged value) itemQtyChanged,
    required TResult Function(CartItemRemoved value) itemRemoved,
    required TResult Function(CartItemDiscountSet value) itemDiscountSet,
    required TResult Function(CartGlobalDiscountSet value) globalDiscountSet,
    required TResult Function(CartCleared value) cleared,
  }) {
    return tabAdded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CartStarted value)? started,
    TResult? Function(CartTabAdded value)? tabAdded,
    TResult? Function(CartTabSwitched value)? tabSwitched,
    TResult? Function(CartTabClosed value)? tabClosed,
    TResult? Function(CartCustomerAssigned value)? customerAssigned,
    TResult? Function(CartItemAdded value)? itemAdded,
    TResult? Function(CartItemQtyChanged value)? itemQtyChanged,
    TResult? Function(CartItemRemoved value)? itemRemoved,
    TResult? Function(CartItemDiscountSet value)? itemDiscountSet,
    TResult? Function(CartGlobalDiscountSet value)? globalDiscountSet,
    TResult? Function(CartCleared value)? cleared,
  }) {
    return tabAdded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CartStarted value)? started,
    TResult Function(CartTabAdded value)? tabAdded,
    TResult Function(CartTabSwitched value)? tabSwitched,
    TResult Function(CartTabClosed value)? tabClosed,
    TResult Function(CartCustomerAssigned value)? customerAssigned,
    TResult Function(CartItemAdded value)? itemAdded,
    TResult Function(CartItemQtyChanged value)? itemQtyChanged,
    TResult Function(CartItemRemoved value)? itemRemoved,
    TResult Function(CartItemDiscountSet value)? itemDiscountSet,
    TResult Function(CartGlobalDiscountSet value)? globalDiscountSet,
    TResult Function(CartCleared value)? cleared,
    required TResult orElse(),
  }) {
    if (tabAdded != null) {
      return tabAdded(this);
    }
    return orElse();
  }
}

abstract class CartTabAdded implements CartEvent {
  const factory CartTabAdded() = _$CartTabAddedImpl;
}

/// @nodoc
abstract class _$$CartTabSwitchedImplCopyWith<$Res> {
  factory _$$CartTabSwitchedImplCopyWith(
    _$CartTabSwitchedImpl value,
    $Res Function(_$CartTabSwitchedImpl) then,
  ) = __$$CartTabSwitchedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String tabId});
}

/// @nodoc
class __$$CartTabSwitchedImplCopyWithImpl<$Res>
    extends _$CartEventCopyWithImpl<$Res, _$CartTabSwitchedImpl>
    implements _$$CartTabSwitchedImplCopyWith<$Res> {
  __$$CartTabSwitchedImplCopyWithImpl(
    _$CartTabSwitchedImpl _value,
    $Res Function(_$CartTabSwitchedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CartEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? tabId = null}) {
    return _then(
      _$CartTabSwitchedImpl(
        tabId: null == tabId
            ? _value.tabId
            : tabId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$CartTabSwitchedImpl implements CartTabSwitched {
  const _$CartTabSwitchedImpl({required this.tabId});

  @override
  final String tabId;

  @override
  String toString() {
    return 'CartEvent.tabSwitched(tabId: $tabId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CartTabSwitchedImpl &&
            (identical(other.tabId, tabId) || other.tabId == tabId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, tabId);

  /// Create a copy of CartEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CartTabSwitchedImplCopyWith<_$CartTabSwitchedImpl> get copyWith =>
      __$$CartTabSwitchedImplCopyWithImpl<_$CartTabSwitchedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function() tabAdded,
    required TResult Function(String tabId) tabSwitched,
    required TResult Function(String tabId) tabClosed,
    required TResult Function(String tabId, String customerId, String name)
    customerAssigned,
    required TResult Function(CartItem item) itemAdded,
    required TResult Function(String productGuid, int qty) itemQtyChanged,
    required TResult Function(String productGuid) itemRemoved,
    required TResult Function(String productGuid, double discount)
    itemDiscountSet,
    required TResult Function(double discount) globalDiscountSet,
    required TResult Function(String tabId) cleared,
  }) {
    return tabSwitched(tabId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function()? tabAdded,
    TResult? Function(String tabId)? tabSwitched,
    TResult? Function(String tabId)? tabClosed,
    TResult? Function(String tabId, String customerId, String name)?
    customerAssigned,
    TResult? Function(CartItem item)? itemAdded,
    TResult? Function(String productGuid, int qty)? itemQtyChanged,
    TResult? Function(String productGuid)? itemRemoved,
    TResult? Function(String productGuid, double discount)? itemDiscountSet,
    TResult? Function(double discount)? globalDiscountSet,
    TResult? Function(String tabId)? cleared,
  }) {
    return tabSwitched?.call(tabId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function()? tabAdded,
    TResult Function(String tabId)? tabSwitched,
    TResult Function(String tabId)? tabClosed,
    TResult Function(String tabId, String customerId, String name)?
    customerAssigned,
    TResult Function(CartItem item)? itemAdded,
    TResult Function(String productGuid, int qty)? itemQtyChanged,
    TResult Function(String productGuid)? itemRemoved,
    TResult Function(String productGuid, double discount)? itemDiscountSet,
    TResult Function(double discount)? globalDiscountSet,
    TResult Function(String tabId)? cleared,
    required TResult orElse(),
  }) {
    if (tabSwitched != null) {
      return tabSwitched(tabId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CartStarted value) started,
    required TResult Function(CartTabAdded value) tabAdded,
    required TResult Function(CartTabSwitched value) tabSwitched,
    required TResult Function(CartTabClosed value) tabClosed,
    required TResult Function(CartCustomerAssigned value) customerAssigned,
    required TResult Function(CartItemAdded value) itemAdded,
    required TResult Function(CartItemQtyChanged value) itemQtyChanged,
    required TResult Function(CartItemRemoved value) itemRemoved,
    required TResult Function(CartItemDiscountSet value) itemDiscountSet,
    required TResult Function(CartGlobalDiscountSet value) globalDiscountSet,
    required TResult Function(CartCleared value) cleared,
  }) {
    return tabSwitched(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CartStarted value)? started,
    TResult? Function(CartTabAdded value)? tabAdded,
    TResult? Function(CartTabSwitched value)? tabSwitched,
    TResult? Function(CartTabClosed value)? tabClosed,
    TResult? Function(CartCustomerAssigned value)? customerAssigned,
    TResult? Function(CartItemAdded value)? itemAdded,
    TResult? Function(CartItemQtyChanged value)? itemQtyChanged,
    TResult? Function(CartItemRemoved value)? itemRemoved,
    TResult? Function(CartItemDiscountSet value)? itemDiscountSet,
    TResult? Function(CartGlobalDiscountSet value)? globalDiscountSet,
    TResult? Function(CartCleared value)? cleared,
  }) {
    return tabSwitched?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CartStarted value)? started,
    TResult Function(CartTabAdded value)? tabAdded,
    TResult Function(CartTabSwitched value)? tabSwitched,
    TResult Function(CartTabClosed value)? tabClosed,
    TResult Function(CartCustomerAssigned value)? customerAssigned,
    TResult Function(CartItemAdded value)? itemAdded,
    TResult Function(CartItemQtyChanged value)? itemQtyChanged,
    TResult Function(CartItemRemoved value)? itemRemoved,
    TResult Function(CartItemDiscountSet value)? itemDiscountSet,
    TResult Function(CartGlobalDiscountSet value)? globalDiscountSet,
    TResult Function(CartCleared value)? cleared,
    required TResult orElse(),
  }) {
    if (tabSwitched != null) {
      return tabSwitched(this);
    }
    return orElse();
  }
}

abstract class CartTabSwitched implements CartEvent {
  const factory CartTabSwitched({required final String tabId}) =
      _$CartTabSwitchedImpl;

  String get tabId;

  /// Create a copy of CartEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CartTabSwitchedImplCopyWith<_$CartTabSwitchedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CartTabClosedImplCopyWith<$Res> {
  factory _$$CartTabClosedImplCopyWith(
    _$CartTabClosedImpl value,
    $Res Function(_$CartTabClosedImpl) then,
  ) = __$$CartTabClosedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String tabId});
}

/// @nodoc
class __$$CartTabClosedImplCopyWithImpl<$Res>
    extends _$CartEventCopyWithImpl<$Res, _$CartTabClosedImpl>
    implements _$$CartTabClosedImplCopyWith<$Res> {
  __$$CartTabClosedImplCopyWithImpl(
    _$CartTabClosedImpl _value,
    $Res Function(_$CartTabClosedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CartEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? tabId = null}) {
    return _then(
      _$CartTabClosedImpl(
        tabId: null == tabId
            ? _value.tabId
            : tabId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$CartTabClosedImpl implements CartTabClosed {
  const _$CartTabClosedImpl({required this.tabId});

  @override
  final String tabId;

  @override
  String toString() {
    return 'CartEvent.tabClosed(tabId: $tabId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CartTabClosedImpl &&
            (identical(other.tabId, tabId) || other.tabId == tabId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, tabId);

  /// Create a copy of CartEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CartTabClosedImplCopyWith<_$CartTabClosedImpl> get copyWith =>
      __$$CartTabClosedImplCopyWithImpl<_$CartTabClosedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function() tabAdded,
    required TResult Function(String tabId) tabSwitched,
    required TResult Function(String tabId) tabClosed,
    required TResult Function(String tabId, String customerId, String name)
    customerAssigned,
    required TResult Function(CartItem item) itemAdded,
    required TResult Function(String productGuid, int qty) itemQtyChanged,
    required TResult Function(String productGuid) itemRemoved,
    required TResult Function(String productGuid, double discount)
    itemDiscountSet,
    required TResult Function(double discount) globalDiscountSet,
    required TResult Function(String tabId) cleared,
  }) {
    return tabClosed(tabId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function()? tabAdded,
    TResult? Function(String tabId)? tabSwitched,
    TResult? Function(String tabId)? tabClosed,
    TResult? Function(String tabId, String customerId, String name)?
    customerAssigned,
    TResult? Function(CartItem item)? itemAdded,
    TResult? Function(String productGuid, int qty)? itemQtyChanged,
    TResult? Function(String productGuid)? itemRemoved,
    TResult? Function(String productGuid, double discount)? itemDiscountSet,
    TResult? Function(double discount)? globalDiscountSet,
    TResult? Function(String tabId)? cleared,
  }) {
    return tabClosed?.call(tabId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function()? tabAdded,
    TResult Function(String tabId)? tabSwitched,
    TResult Function(String tabId)? tabClosed,
    TResult Function(String tabId, String customerId, String name)?
    customerAssigned,
    TResult Function(CartItem item)? itemAdded,
    TResult Function(String productGuid, int qty)? itemQtyChanged,
    TResult Function(String productGuid)? itemRemoved,
    TResult Function(String productGuid, double discount)? itemDiscountSet,
    TResult Function(double discount)? globalDiscountSet,
    TResult Function(String tabId)? cleared,
    required TResult orElse(),
  }) {
    if (tabClosed != null) {
      return tabClosed(tabId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CartStarted value) started,
    required TResult Function(CartTabAdded value) tabAdded,
    required TResult Function(CartTabSwitched value) tabSwitched,
    required TResult Function(CartTabClosed value) tabClosed,
    required TResult Function(CartCustomerAssigned value) customerAssigned,
    required TResult Function(CartItemAdded value) itemAdded,
    required TResult Function(CartItemQtyChanged value) itemQtyChanged,
    required TResult Function(CartItemRemoved value) itemRemoved,
    required TResult Function(CartItemDiscountSet value) itemDiscountSet,
    required TResult Function(CartGlobalDiscountSet value) globalDiscountSet,
    required TResult Function(CartCleared value) cleared,
  }) {
    return tabClosed(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CartStarted value)? started,
    TResult? Function(CartTabAdded value)? tabAdded,
    TResult? Function(CartTabSwitched value)? tabSwitched,
    TResult? Function(CartTabClosed value)? tabClosed,
    TResult? Function(CartCustomerAssigned value)? customerAssigned,
    TResult? Function(CartItemAdded value)? itemAdded,
    TResult? Function(CartItemQtyChanged value)? itemQtyChanged,
    TResult? Function(CartItemRemoved value)? itemRemoved,
    TResult? Function(CartItemDiscountSet value)? itemDiscountSet,
    TResult? Function(CartGlobalDiscountSet value)? globalDiscountSet,
    TResult? Function(CartCleared value)? cleared,
  }) {
    return tabClosed?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CartStarted value)? started,
    TResult Function(CartTabAdded value)? tabAdded,
    TResult Function(CartTabSwitched value)? tabSwitched,
    TResult Function(CartTabClosed value)? tabClosed,
    TResult Function(CartCustomerAssigned value)? customerAssigned,
    TResult Function(CartItemAdded value)? itemAdded,
    TResult Function(CartItemQtyChanged value)? itemQtyChanged,
    TResult Function(CartItemRemoved value)? itemRemoved,
    TResult Function(CartItemDiscountSet value)? itemDiscountSet,
    TResult Function(CartGlobalDiscountSet value)? globalDiscountSet,
    TResult Function(CartCleared value)? cleared,
    required TResult orElse(),
  }) {
    if (tabClosed != null) {
      return tabClosed(this);
    }
    return orElse();
  }
}

abstract class CartTabClosed implements CartEvent {
  const factory CartTabClosed({required final String tabId}) =
      _$CartTabClosedImpl;

  String get tabId;

  /// Create a copy of CartEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CartTabClosedImplCopyWith<_$CartTabClosedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CartCustomerAssignedImplCopyWith<$Res> {
  factory _$$CartCustomerAssignedImplCopyWith(
    _$CartCustomerAssignedImpl value,
    $Res Function(_$CartCustomerAssignedImpl) then,
  ) = __$$CartCustomerAssignedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String tabId, String customerId, String name});
}

/// @nodoc
class __$$CartCustomerAssignedImplCopyWithImpl<$Res>
    extends _$CartEventCopyWithImpl<$Res, _$CartCustomerAssignedImpl>
    implements _$$CartCustomerAssignedImplCopyWith<$Res> {
  __$$CartCustomerAssignedImplCopyWithImpl(
    _$CartCustomerAssignedImpl _value,
    $Res Function(_$CartCustomerAssignedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CartEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tabId = null,
    Object? customerId = null,
    Object? name = null,
  }) {
    return _then(
      _$CartCustomerAssignedImpl(
        tabId: null == tabId
            ? _value.tabId
            : tabId // ignore: cast_nullable_to_non_nullable
                  as String,
        customerId: null == customerId
            ? _value.customerId
            : customerId // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$CartCustomerAssignedImpl implements CartCustomerAssigned {
  const _$CartCustomerAssignedImpl({
    required this.tabId,
    required this.customerId,
    required this.name,
  });

  @override
  final String tabId;
  @override
  final String customerId;
  @override
  final String name;

  @override
  String toString() {
    return 'CartEvent.customerAssigned(tabId: $tabId, customerId: $customerId, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CartCustomerAssignedImpl &&
            (identical(other.tabId, tabId) || other.tabId == tabId) &&
            (identical(other.customerId, customerId) ||
                other.customerId == customerId) &&
            (identical(other.name, name) || other.name == name));
  }

  @override
  int get hashCode => Object.hash(runtimeType, tabId, customerId, name);

  /// Create a copy of CartEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CartCustomerAssignedImplCopyWith<_$CartCustomerAssignedImpl>
  get copyWith =>
      __$$CartCustomerAssignedImplCopyWithImpl<_$CartCustomerAssignedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function() tabAdded,
    required TResult Function(String tabId) tabSwitched,
    required TResult Function(String tabId) tabClosed,
    required TResult Function(String tabId, String customerId, String name)
    customerAssigned,
    required TResult Function(CartItem item) itemAdded,
    required TResult Function(String productGuid, int qty) itemQtyChanged,
    required TResult Function(String productGuid) itemRemoved,
    required TResult Function(String productGuid, double discount)
    itemDiscountSet,
    required TResult Function(double discount) globalDiscountSet,
    required TResult Function(String tabId) cleared,
  }) {
    return customerAssigned(tabId, customerId, name);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function()? tabAdded,
    TResult? Function(String tabId)? tabSwitched,
    TResult? Function(String tabId)? tabClosed,
    TResult? Function(String tabId, String customerId, String name)?
    customerAssigned,
    TResult? Function(CartItem item)? itemAdded,
    TResult? Function(String productGuid, int qty)? itemQtyChanged,
    TResult? Function(String productGuid)? itemRemoved,
    TResult? Function(String productGuid, double discount)? itemDiscountSet,
    TResult? Function(double discount)? globalDiscountSet,
    TResult? Function(String tabId)? cleared,
  }) {
    return customerAssigned?.call(tabId, customerId, name);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function()? tabAdded,
    TResult Function(String tabId)? tabSwitched,
    TResult Function(String tabId)? tabClosed,
    TResult Function(String tabId, String customerId, String name)?
    customerAssigned,
    TResult Function(CartItem item)? itemAdded,
    TResult Function(String productGuid, int qty)? itemQtyChanged,
    TResult Function(String productGuid)? itemRemoved,
    TResult Function(String productGuid, double discount)? itemDiscountSet,
    TResult Function(double discount)? globalDiscountSet,
    TResult Function(String tabId)? cleared,
    required TResult orElse(),
  }) {
    if (customerAssigned != null) {
      return customerAssigned(tabId, customerId, name);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CartStarted value) started,
    required TResult Function(CartTabAdded value) tabAdded,
    required TResult Function(CartTabSwitched value) tabSwitched,
    required TResult Function(CartTabClosed value) tabClosed,
    required TResult Function(CartCustomerAssigned value) customerAssigned,
    required TResult Function(CartItemAdded value) itemAdded,
    required TResult Function(CartItemQtyChanged value) itemQtyChanged,
    required TResult Function(CartItemRemoved value) itemRemoved,
    required TResult Function(CartItemDiscountSet value) itemDiscountSet,
    required TResult Function(CartGlobalDiscountSet value) globalDiscountSet,
    required TResult Function(CartCleared value) cleared,
  }) {
    return customerAssigned(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CartStarted value)? started,
    TResult? Function(CartTabAdded value)? tabAdded,
    TResult? Function(CartTabSwitched value)? tabSwitched,
    TResult? Function(CartTabClosed value)? tabClosed,
    TResult? Function(CartCustomerAssigned value)? customerAssigned,
    TResult? Function(CartItemAdded value)? itemAdded,
    TResult? Function(CartItemQtyChanged value)? itemQtyChanged,
    TResult? Function(CartItemRemoved value)? itemRemoved,
    TResult? Function(CartItemDiscountSet value)? itemDiscountSet,
    TResult? Function(CartGlobalDiscountSet value)? globalDiscountSet,
    TResult? Function(CartCleared value)? cleared,
  }) {
    return customerAssigned?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CartStarted value)? started,
    TResult Function(CartTabAdded value)? tabAdded,
    TResult Function(CartTabSwitched value)? tabSwitched,
    TResult Function(CartTabClosed value)? tabClosed,
    TResult Function(CartCustomerAssigned value)? customerAssigned,
    TResult Function(CartItemAdded value)? itemAdded,
    TResult Function(CartItemQtyChanged value)? itemQtyChanged,
    TResult Function(CartItemRemoved value)? itemRemoved,
    TResult Function(CartItemDiscountSet value)? itemDiscountSet,
    TResult Function(CartGlobalDiscountSet value)? globalDiscountSet,
    TResult Function(CartCleared value)? cleared,
    required TResult orElse(),
  }) {
    if (customerAssigned != null) {
      return customerAssigned(this);
    }
    return orElse();
  }
}

abstract class CartCustomerAssigned implements CartEvent {
  const factory CartCustomerAssigned({
    required final String tabId,
    required final String customerId,
    required final String name,
  }) = _$CartCustomerAssignedImpl;

  String get tabId;
  String get customerId;
  String get name;

  /// Create a copy of CartEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CartCustomerAssignedImplCopyWith<_$CartCustomerAssignedImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CartItemAddedImplCopyWith<$Res> {
  factory _$$CartItemAddedImplCopyWith(
    _$CartItemAddedImpl value,
    $Res Function(_$CartItemAddedImpl) then,
  ) = __$$CartItemAddedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({CartItem item});

  $CartItemCopyWith<$Res> get item;
}

/// @nodoc
class __$$CartItemAddedImplCopyWithImpl<$Res>
    extends _$CartEventCopyWithImpl<$Res, _$CartItemAddedImpl>
    implements _$$CartItemAddedImplCopyWith<$Res> {
  __$$CartItemAddedImplCopyWithImpl(
    _$CartItemAddedImpl _value,
    $Res Function(_$CartItemAddedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CartEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? item = null}) {
    return _then(
      _$CartItemAddedImpl(
        item: null == item
            ? _value.item
            : item // ignore: cast_nullable_to_non_nullable
                  as CartItem,
      ),
    );
  }

  /// Create a copy of CartEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CartItemCopyWith<$Res> get item {
    return $CartItemCopyWith<$Res>(_value.item, (value) {
      return _then(_value.copyWith(item: value));
    });
  }
}

/// @nodoc

class _$CartItemAddedImpl implements CartItemAdded {
  const _$CartItemAddedImpl({required this.item});

  @override
  final CartItem item;

  @override
  String toString() {
    return 'CartEvent.itemAdded(item: $item)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CartItemAddedImpl &&
            (identical(other.item, item) || other.item == item));
  }

  @override
  int get hashCode => Object.hash(runtimeType, item);

  /// Create a copy of CartEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CartItemAddedImplCopyWith<_$CartItemAddedImpl> get copyWith =>
      __$$CartItemAddedImplCopyWithImpl<_$CartItemAddedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function() tabAdded,
    required TResult Function(String tabId) tabSwitched,
    required TResult Function(String tabId) tabClosed,
    required TResult Function(String tabId, String customerId, String name)
    customerAssigned,
    required TResult Function(CartItem item) itemAdded,
    required TResult Function(String productGuid, int qty) itemQtyChanged,
    required TResult Function(String productGuid) itemRemoved,
    required TResult Function(String productGuid, double discount)
    itemDiscountSet,
    required TResult Function(double discount) globalDiscountSet,
    required TResult Function(String tabId) cleared,
  }) {
    return itemAdded(item);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function()? tabAdded,
    TResult? Function(String tabId)? tabSwitched,
    TResult? Function(String tabId)? tabClosed,
    TResult? Function(String tabId, String customerId, String name)?
    customerAssigned,
    TResult? Function(CartItem item)? itemAdded,
    TResult? Function(String productGuid, int qty)? itemQtyChanged,
    TResult? Function(String productGuid)? itemRemoved,
    TResult? Function(String productGuid, double discount)? itemDiscountSet,
    TResult? Function(double discount)? globalDiscountSet,
    TResult? Function(String tabId)? cleared,
  }) {
    return itemAdded?.call(item);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function()? tabAdded,
    TResult Function(String tabId)? tabSwitched,
    TResult Function(String tabId)? tabClosed,
    TResult Function(String tabId, String customerId, String name)?
    customerAssigned,
    TResult Function(CartItem item)? itemAdded,
    TResult Function(String productGuid, int qty)? itemQtyChanged,
    TResult Function(String productGuid)? itemRemoved,
    TResult Function(String productGuid, double discount)? itemDiscountSet,
    TResult Function(double discount)? globalDiscountSet,
    TResult Function(String tabId)? cleared,
    required TResult orElse(),
  }) {
    if (itemAdded != null) {
      return itemAdded(item);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CartStarted value) started,
    required TResult Function(CartTabAdded value) tabAdded,
    required TResult Function(CartTabSwitched value) tabSwitched,
    required TResult Function(CartTabClosed value) tabClosed,
    required TResult Function(CartCustomerAssigned value) customerAssigned,
    required TResult Function(CartItemAdded value) itemAdded,
    required TResult Function(CartItemQtyChanged value) itemQtyChanged,
    required TResult Function(CartItemRemoved value) itemRemoved,
    required TResult Function(CartItemDiscountSet value) itemDiscountSet,
    required TResult Function(CartGlobalDiscountSet value) globalDiscountSet,
    required TResult Function(CartCleared value) cleared,
  }) {
    return itemAdded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CartStarted value)? started,
    TResult? Function(CartTabAdded value)? tabAdded,
    TResult? Function(CartTabSwitched value)? tabSwitched,
    TResult? Function(CartTabClosed value)? tabClosed,
    TResult? Function(CartCustomerAssigned value)? customerAssigned,
    TResult? Function(CartItemAdded value)? itemAdded,
    TResult? Function(CartItemQtyChanged value)? itemQtyChanged,
    TResult? Function(CartItemRemoved value)? itemRemoved,
    TResult? Function(CartItemDiscountSet value)? itemDiscountSet,
    TResult? Function(CartGlobalDiscountSet value)? globalDiscountSet,
    TResult? Function(CartCleared value)? cleared,
  }) {
    return itemAdded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CartStarted value)? started,
    TResult Function(CartTabAdded value)? tabAdded,
    TResult Function(CartTabSwitched value)? tabSwitched,
    TResult Function(CartTabClosed value)? tabClosed,
    TResult Function(CartCustomerAssigned value)? customerAssigned,
    TResult Function(CartItemAdded value)? itemAdded,
    TResult Function(CartItemQtyChanged value)? itemQtyChanged,
    TResult Function(CartItemRemoved value)? itemRemoved,
    TResult Function(CartItemDiscountSet value)? itemDiscountSet,
    TResult Function(CartGlobalDiscountSet value)? globalDiscountSet,
    TResult Function(CartCleared value)? cleared,
    required TResult orElse(),
  }) {
    if (itemAdded != null) {
      return itemAdded(this);
    }
    return orElse();
  }
}

abstract class CartItemAdded implements CartEvent {
  const factory CartItemAdded({required final CartItem item}) =
      _$CartItemAddedImpl;

  CartItem get item;

  /// Create a copy of CartEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CartItemAddedImplCopyWith<_$CartItemAddedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CartItemQtyChangedImplCopyWith<$Res> {
  factory _$$CartItemQtyChangedImplCopyWith(
    _$CartItemQtyChangedImpl value,
    $Res Function(_$CartItemQtyChangedImpl) then,
  ) = __$$CartItemQtyChangedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String productGuid, int qty});
}

/// @nodoc
class __$$CartItemQtyChangedImplCopyWithImpl<$Res>
    extends _$CartEventCopyWithImpl<$Res, _$CartItemQtyChangedImpl>
    implements _$$CartItemQtyChangedImplCopyWith<$Res> {
  __$$CartItemQtyChangedImplCopyWithImpl(
    _$CartItemQtyChangedImpl _value,
    $Res Function(_$CartItemQtyChangedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CartEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? productGuid = null, Object? qty = null}) {
    return _then(
      _$CartItemQtyChangedImpl(
        productGuid: null == productGuid
            ? _value.productGuid
            : productGuid // ignore: cast_nullable_to_non_nullable
                  as String,
        qty: null == qty
            ? _value.qty
            : qty // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$CartItemQtyChangedImpl implements CartItemQtyChanged {
  const _$CartItemQtyChangedImpl({
    required this.productGuid,
    required this.qty,
  });

  @override
  final String productGuid;
  @override
  final int qty;

  @override
  String toString() {
    return 'CartEvent.itemQtyChanged(productGuid: $productGuid, qty: $qty)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CartItemQtyChangedImpl &&
            (identical(other.productGuid, productGuid) ||
                other.productGuid == productGuid) &&
            (identical(other.qty, qty) || other.qty == qty));
  }

  @override
  int get hashCode => Object.hash(runtimeType, productGuid, qty);

  /// Create a copy of CartEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CartItemQtyChangedImplCopyWith<_$CartItemQtyChangedImpl> get copyWith =>
      __$$CartItemQtyChangedImplCopyWithImpl<_$CartItemQtyChangedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function() tabAdded,
    required TResult Function(String tabId) tabSwitched,
    required TResult Function(String tabId) tabClosed,
    required TResult Function(String tabId, String customerId, String name)
    customerAssigned,
    required TResult Function(CartItem item) itemAdded,
    required TResult Function(String productGuid, int qty) itemQtyChanged,
    required TResult Function(String productGuid) itemRemoved,
    required TResult Function(String productGuid, double discount)
    itemDiscountSet,
    required TResult Function(double discount) globalDiscountSet,
    required TResult Function(String tabId) cleared,
  }) {
    return itemQtyChanged(productGuid, qty);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function()? tabAdded,
    TResult? Function(String tabId)? tabSwitched,
    TResult? Function(String tabId)? tabClosed,
    TResult? Function(String tabId, String customerId, String name)?
    customerAssigned,
    TResult? Function(CartItem item)? itemAdded,
    TResult? Function(String productGuid, int qty)? itemQtyChanged,
    TResult? Function(String productGuid)? itemRemoved,
    TResult? Function(String productGuid, double discount)? itemDiscountSet,
    TResult? Function(double discount)? globalDiscountSet,
    TResult? Function(String tabId)? cleared,
  }) {
    return itemQtyChanged?.call(productGuid, qty);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function()? tabAdded,
    TResult Function(String tabId)? tabSwitched,
    TResult Function(String tabId)? tabClosed,
    TResult Function(String tabId, String customerId, String name)?
    customerAssigned,
    TResult Function(CartItem item)? itemAdded,
    TResult Function(String productGuid, int qty)? itemQtyChanged,
    TResult Function(String productGuid)? itemRemoved,
    TResult Function(String productGuid, double discount)? itemDiscountSet,
    TResult Function(double discount)? globalDiscountSet,
    TResult Function(String tabId)? cleared,
    required TResult orElse(),
  }) {
    if (itemQtyChanged != null) {
      return itemQtyChanged(productGuid, qty);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CartStarted value) started,
    required TResult Function(CartTabAdded value) tabAdded,
    required TResult Function(CartTabSwitched value) tabSwitched,
    required TResult Function(CartTabClosed value) tabClosed,
    required TResult Function(CartCustomerAssigned value) customerAssigned,
    required TResult Function(CartItemAdded value) itemAdded,
    required TResult Function(CartItemQtyChanged value) itemQtyChanged,
    required TResult Function(CartItemRemoved value) itemRemoved,
    required TResult Function(CartItemDiscountSet value) itemDiscountSet,
    required TResult Function(CartGlobalDiscountSet value) globalDiscountSet,
    required TResult Function(CartCleared value) cleared,
  }) {
    return itemQtyChanged(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CartStarted value)? started,
    TResult? Function(CartTabAdded value)? tabAdded,
    TResult? Function(CartTabSwitched value)? tabSwitched,
    TResult? Function(CartTabClosed value)? tabClosed,
    TResult? Function(CartCustomerAssigned value)? customerAssigned,
    TResult? Function(CartItemAdded value)? itemAdded,
    TResult? Function(CartItemQtyChanged value)? itemQtyChanged,
    TResult? Function(CartItemRemoved value)? itemRemoved,
    TResult? Function(CartItemDiscountSet value)? itemDiscountSet,
    TResult? Function(CartGlobalDiscountSet value)? globalDiscountSet,
    TResult? Function(CartCleared value)? cleared,
  }) {
    return itemQtyChanged?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CartStarted value)? started,
    TResult Function(CartTabAdded value)? tabAdded,
    TResult Function(CartTabSwitched value)? tabSwitched,
    TResult Function(CartTabClosed value)? tabClosed,
    TResult Function(CartCustomerAssigned value)? customerAssigned,
    TResult Function(CartItemAdded value)? itemAdded,
    TResult Function(CartItemQtyChanged value)? itemQtyChanged,
    TResult Function(CartItemRemoved value)? itemRemoved,
    TResult Function(CartItemDiscountSet value)? itemDiscountSet,
    TResult Function(CartGlobalDiscountSet value)? globalDiscountSet,
    TResult Function(CartCleared value)? cleared,
    required TResult orElse(),
  }) {
    if (itemQtyChanged != null) {
      return itemQtyChanged(this);
    }
    return orElse();
  }
}

abstract class CartItemQtyChanged implements CartEvent {
  const factory CartItemQtyChanged({
    required final String productGuid,
    required final int qty,
  }) = _$CartItemQtyChangedImpl;

  String get productGuid;
  int get qty;

  /// Create a copy of CartEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CartItemQtyChangedImplCopyWith<_$CartItemQtyChangedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CartItemRemovedImplCopyWith<$Res> {
  factory _$$CartItemRemovedImplCopyWith(
    _$CartItemRemovedImpl value,
    $Res Function(_$CartItemRemovedImpl) then,
  ) = __$$CartItemRemovedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String productGuid});
}

/// @nodoc
class __$$CartItemRemovedImplCopyWithImpl<$Res>
    extends _$CartEventCopyWithImpl<$Res, _$CartItemRemovedImpl>
    implements _$$CartItemRemovedImplCopyWith<$Res> {
  __$$CartItemRemovedImplCopyWithImpl(
    _$CartItemRemovedImpl _value,
    $Res Function(_$CartItemRemovedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CartEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? productGuid = null}) {
    return _then(
      _$CartItemRemovedImpl(
        productGuid: null == productGuid
            ? _value.productGuid
            : productGuid // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$CartItemRemovedImpl implements CartItemRemoved {
  const _$CartItemRemovedImpl({required this.productGuid});

  @override
  final String productGuid;

  @override
  String toString() {
    return 'CartEvent.itemRemoved(productGuid: $productGuid)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CartItemRemovedImpl &&
            (identical(other.productGuid, productGuid) ||
                other.productGuid == productGuid));
  }

  @override
  int get hashCode => Object.hash(runtimeType, productGuid);

  /// Create a copy of CartEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CartItemRemovedImplCopyWith<_$CartItemRemovedImpl> get copyWith =>
      __$$CartItemRemovedImplCopyWithImpl<_$CartItemRemovedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function() tabAdded,
    required TResult Function(String tabId) tabSwitched,
    required TResult Function(String tabId) tabClosed,
    required TResult Function(String tabId, String customerId, String name)
    customerAssigned,
    required TResult Function(CartItem item) itemAdded,
    required TResult Function(String productGuid, int qty) itemQtyChanged,
    required TResult Function(String productGuid) itemRemoved,
    required TResult Function(String productGuid, double discount)
    itemDiscountSet,
    required TResult Function(double discount) globalDiscountSet,
    required TResult Function(String tabId) cleared,
  }) {
    return itemRemoved(productGuid);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function()? tabAdded,
    TResult? Function(String tabId)? tabSwitched,
    TResult? Function(String tabId)? tabClosed,
    TResult? Function(String tabId, String customerId, String name)?
    customerAssigned,
    TResult? Function(CartItem item)? itemAdded,
    TResult? Function(String productGuid, int qty)? itemQtyChanged,
    TResult? Function(String productGuid)? itemRemoved,
    TResult? Function(String productGuid, double discount)? itemDiscountSet,
    TResult? Function(double discount)? globalDiscountSet,
    TResult? Function(String tabId)? cleared,
  }) {
    return itemRemoved?.call(productGuid);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function()? tabAdded,
    TResult Function(String tabId)? tabSwitched,
    TResult Function(String tabId)? tabClosed,
    TResult Function(String tabId, String customerId, String name)?
    customerAssigned,
    TResult Function(CartItem item)? itemAdded,
    TResult Function(String productGuid, int qty)? itemQtyChanged,
    TResult Function(String productGuid)? itemRemoved,
    TResult Function(String productGuid, double discount)? itemDiscountSet,
    TResult Function(double discount)? globalDiscountSet,
    TResult Function(String tabId)? cleared,
    required TResult orElse(),
  }) {
    if (itemRemoved != null) {
      return itemRemoved(productGuid);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CartStarted value) started,
    required TResult Function(CartTabAdded value) tabAdded,
    required TResult Function(CartTabSwitched value) tabSwitched,
    required TResult Function(CartTabClosed value) tabClosed,
    required TResult Function(CartCustomerAssigned value) customerAssigned,
    required TResult Function(CartItemAdded value) itemAdded,
    required TResult Function(CartItemQtyChanged value) itemQtyChanged,
    required TResult Function(CartItemRemoved value) itemRemoved,
    required TResult Function(CartItemDiscountSet value) itemDiscountSet,
    required TResult Function(CartGlobalDiscountSet value) globalDiscountSet,
    required TResult Function(CartCleared value) cleared,
  }) {
    return itemRemoved(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CartStarted value)? started,
    TResult? Function(CartTabAdded value)? tabAdded,
    TResult? Function(CartTabSwitched value)? tabSwitched,
    TResult? Function(CartTabClosed value)? tabClosed,
    TResult? Function(CartCustomerAssigned value)? customerAssigned,
    TResult? Function(CartItemAdded value)? itemAdded,
    TResult? Function(CartItemQtyChanged value)? itemQtyChanged,
    TResult? Function(CartItemRemoved value)? itemRemoved,
    TResult? Function(CartItemDiscountSet value)? itemDiscountSet,
    TResult? Function(CartGlobalDiscountSet value)? globalDiscountSet,
    TResult? Function(CartCleared value)? cleared,
  }) {
    return itemRemoved?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CartStarted value)? started,
    TResult Function(CartTabAdded value)? tabAdded,
    TResult Function(CartTabSwitched value)? tabSwitched,
    TResult Function(CartTabClosed value)? tabClosed,
    TResult Function(CartCustomerAssigned value)? customerAssigned,
    TResult Function(CartItemAdded value)? itemAdded,
    TResult Function(CartItemQtyChanged value)? itemQtyChanged,
    TResult Function(CartItemRemoved value)? itemRemoved,
    TResult Function(CartItemDiscountSet value)? itemDiscountSet,
    TResult Function(CartGlobalDiscountSet value)? globalDiscountSet,
    TResult Function(CartCleared value)? cleared,
    required TResult orElse(),
  }) {
    if (itemRemoved != null) {
      return itemRemoved(this);
    }
    return orElse();
  }
}

abstract class CartItemRemoved implements CartEvent {
  const factory CartItemRemoved({required final String productGuid}) =
      _$CartItemRemovedImpl;

  String get productGuid;

  /// Create a copy of CartEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CartItemRemovedImplCopyWith<_$CartItemRemovedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CartItemDiscountSetImplCopyWith<$Res> {
  factory _$$CartItemDiscountSetImplCopyWith(
    _$CartItemDiscountSetImpl value,
    $Res Function(_$CartItemDiscountSetImpl) then,
  ) = __$$CartItemDiscountSetImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String productGuid, double discount});
}

/// @nodoc
class __$$CartItemDiscountSetImplCopyWithImpl<$Res>
    extends _$CartEventCopyWithImpl<$Res, _$CartItemDiscountSetImpl>
    implements _$$CartItemDiscountSetImplCopyWith<$Res> {
  __$$CartItemDiscountSetImplCopyWithImpl(
    _$CartItemDiscountSetImpl _value,
    $Res Function(_$CartItemDiscountSetImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CartEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? productGuid = null, Object? discount = null}) {
    return _then(
      _$CartItemDiscountSetImpl(
        productGuid: null == productGuid
            ? _value.productGuid
            : productGuid // ignore: cast_nullable_to_non_nullable
                  as String,
        discount: null == discount
            ? _value.discount
            : discount // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc

class _$CartItemDiscountSetImpl implements CartItemDiscountSet {
  const _$CartItemDiscountSetImpl({
    required this.productGuid,
    required this.discount,
  });

  @override
  final String productGuid;
  @override
  final double discount;

  @override
  String toString() {
    return 'CartEvent.itemDiscountSet(productGuid: $productGuid, discount: $discount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CartItemDiscountSetImpl &&
            (identical(other.productGuid, productGuid) ||
                other.productGuid == productGuid) &&
            (identical(other.discount, discount) ||
                other.discount == discount));
  }

  @override
  int get hashCode => Object.hash(runtimeType, productGuid, discount);

  /// Create a copy of CartEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CartItemDiscountSetImplCopyWith<_$CartItemDiscountSetImpl> get copyWith =>
      __$$CartItemDiscountSetImplCopyWithImpl<_$CartItemDiscountSetImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function() tabAdded,
    required TResult Function(String tabId) tabSwitched,
    required TResult Function(String tabId) tabClosed,
    required TResult Function(String tabId, String customerId, String name)
    customerAssigned,
    required TResult Function(CartItem item) itemAdded,
    required TResult Function(String productGuid, int qty) itemQtyChanged,
    required TResult Function(String productGuid) itemRemoved,
    required TResult Function(String productGuid, double discount)
    itemDiscountSet,
    required TResult Function(double discount) globalDiscountSet,
    required TResult Function(String tabId) cleared,
  }) {
    return itemDiscountSet(productGuid, discount);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function()? tabAdded,
    TResult? Function(String tabId)? tabSwitched,
    TResult? Function(String tabId)? tabClosed,
    TResult? Function(String tabId, String customerId, String name)?
    customerAssigned,
    TResult? Function(CartItem item)? itemAdded,
    TResult? Function(String productGuid, int qty)? itemQtyChanged,
    TResult? Function(String productGuid)? itemRemoved,
    TResult? Function(String productGuid, double discount)? itemDiscountSet,
    TResult? Function(double discount)? globalDiscountSet,
    TResult? Function(String tabId)? cleared,
  }) {
    return itemDiscountSet?.call(productGuid, discount);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function()? tabAdded,
    TResult Function(String tabId)? tabSwitched,
    TResult Function(String tabId)? tabClosed,
    TResult Function(String tabId, String customerId, String name)?
    customerAssigned,
    TResult Function(CartItem item)? itemAdded,
    TResult Function(String productGuid, int qty)? itemQtyChanged,
    TResult Function(String productGuid)? itemRemoved,
    TResult Function(String productGuid, double discount)? itemDiscountSet,
    TResult Function(double discount)? globalDiscountSet,
    TResult Function(String tabId)? cleared,
    required TResult orElse(),
  }) {
    if (itemDiscountSet != null) {
      return itemDiscountSet(productGuid, discount);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CartStarted value) started,
    required TResult Function(CartTabAdded value) tabAdded,
    required TResult Function(CartTabSwitched value) tabSwitched,
    required TResult Function(CartTabClosed value) tabClosed,
    required TResult Function(CartCustomerAssigned value) customerAssigned,
    required TResult Function(CartItemAdded value) itemAdded,
    required TResult Function(CartItemQtyChanged value) itemQtyChanged,
    required TResult Function(CartItemRemoved value) itemRemoved,
    required TResult Function(CartItemDiscountSet value) itemDiscountSet,
    required TResult Function(CartGlobalDiscountSet value) globalDiscountSet,
    required TResult Function(CartCleared value) cleared,
  }) {
    return itemDiscountSet(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CartStarted value)? started,
    TResult? Function(CartTabAdded value)? tabAdded,
    TResult? Function(CartTabSwitched value)? tabSwitched,
    TResult? Function(CartTabClosed value)? tabClosed,
    TResult? Function(CartCustomerAssigned value)? customerAssigned,
    TResult? Function(CartItemAdded value)? itemAdded,
    TResult? Function(CartItemQtyChanged value)? itemQtyChanged,
    TResult? Function(CartItemRemoved value)? itemRemoved,
    TResult? Function(CartItemDiscountSet value)? itemDiscountSet,
    TResult? Function(CartGlobalDiscountSet value)? globalDiscountSet,
    TResult? Function(CartCleared value)? cleared,
  }) {
    return itemDiscountSet?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CartStarted value)? started,
    TResult Function(CartTabAdded value)? tabAdded,
    TResult Function(CartTabSwitched value)? tabSwitched,
    TResult Function(CartTabClosed value)? tabClosed,
    TResult Function(CartCustomerAssigned value)? customerAssigned,
    TResult Function(CartItemAdded value)? itemAdded,
    TResult Function(CartItemQtyChanged value)? itemQtyChanged,
    TResult Function(CartItemRemoved value)? itemRemoved,
    TResult Function(CartItemDiscountSet value)? itemDiscountSet,
    TResult Function(CartGlobalDiscountSet value)? globalDiscountSet,
    TResult Function(CartCleared value)? cleared,
    required TResult orElse(),
  }) {
    if (itemDiscountSet != null) {
      return itemDiscountSet(this);
    }
    return orElse();
  }
}

abstract class CartItemDiscountSet implements CartEvent {
  const factory CartItemDiscountSet({
    required final String productGuid,
    required final double discount,
  }) = _$CartItemDiscountSetImpl;

  String get productGuid;
  double get discount;

  /// Create a copy of CartEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CartItemDiscountSetImplCopyWith<_$CartItemDiscountSetImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CartGlobalDiscountSetImplCopyWith<$Res> {
  factory _$$CartGlobalDiscountSetImplCopyWith(
    _$CartGlobalDiscountSetImpl value,
    $Res Function(_$CartGlobalDiscountSetImpl) then,
  ) = __$$CartGlobalDiscountSetImplCopyWithImpl<$Res>;
  @useResult
  $Res call({double discount});
}

/// @nodoc
class __$$CartGlobalDiscountSetImplCopyWithImpl<$Res>
    extends _$CartEventCopyWithImpl<$Res, _$CartGlobalDiscountSetImpl>
    implements _$$CartGlobalDiscountSetImplCopyWith<$Res> {
  __$$CartGlobalDiscountSetImplCopyWithImpl(
    _$CartGlobalDiscountSetImpl _value,
    $Res Function(_$CartGlobalDiscountSetImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CartEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? discount = null}) {
    return _then(
      _$CartGlobalDiscountSetImpl(
        discount: null == discount
            ? _value.discount
            : discount // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc

class _$CartGlobalDiscountSetImpl implements CartGlobalDiscountSet {
  const _$CartGlobalDiscountSetImpl({required this.discount});

  @override
  final double discount;

  @override
  String toString() {
    return 'CartEvent.globalDiscountSet(discount: $discount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CartGlobalDiscountSetImpl &&
            (identical(other.discount, discount) ||
                other.discount == discount));
  }

  @override
  int get hashCode => Object.hash(runtimeType, discount);

  /// Create a copy of CartEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CartGlobalDiscountSetImplCopyWith<_$CartGlobalDiscountSetImpl>
  get copyWith =>
      __$$CartGlobalDiscountSetImplCopyWithImpl<_$CartGlobalDiscountSetImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function() tabAdded,
    required TResult Function(String tabId) tabSwitched,
    required TResult Function(String tabId) tabClosed,
    required TResult Function(String tabId, String customerId, String name)
    customerAssigned,
    required TResult Function(CartItem item) itemAdded,
    required TResult Function(String productGuid, int qty) itemQtyChanged,
    required TResult Function(String productGuid) itemRemoved,
    required TResult Function(String productGuid, double discount)
    itemDiscountSet,
    required TResult Function(double discount) globalDiscountSet,
    required TResult Function(String tabId) cleared,
  }) {
    return globalDiscountSet(discount);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function()? tabAdded,
    TResult? Function(String tabId)? tabSwitched,
    TResult? Function(String tabId)? tabClosed,
    TResult? Function(String tabId, String customerId, String name)?
    customerAssigned,
    TResult? Function(CartItem item)? itemAdded,
    TResult? Function(String productGuid, int qty)? itemQtyChanged,
    TResult? Function(String productGuid)? itemRemoved,
    TResult? Function(String productGuid, double discount)? itemDiscountSet,
    TResult? Function(double discount)? globalDiscountSet,
    TResult? Function(String tabId)? cleared,
  }) {
    return globalDiscountSet?.call(discount);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function()? tabAdded,
    TResult Function(String tabId)? tabSwitched,
    TResult Function(String tabId)? tabClosed,
    TResult Function(String tabId, String customerId, String name)?
    customerAssigned,
    TResult Function(CartItem item)? itemAdded,
    TResult Function(String productGuid, int qty)? itemQtyChanged,
    TResult Function(String productGuid)? itemRemoved,
    TResult Function(String productGuid, double discount)? itemDiscountSet,
    TResult Function(double discount)? globalDiscountSet,
    TResult Function(String tabId)? cleared,
    required TResult orElse(),
  }) {
    if (globalDiscountSet != null) {
      return globalDiscountSet(discount);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CartStarted value) started,
    required TResult Function(CartTabAdded value) tabAdded,
    required TResult Function(CartTabSwitched value) tabSwitched,
    required TResult Function(CartTabClosed value) tabClosed,
    required TResult Function(CartCustomerAssigned value) customerAssigned,
    required TResult Function(CartItemAdded value) itemAdded,
    required TResult Function(CartItemQtyChanged value) itemQtyChanged,
    required TResult Function(CartItemRemoved value) itemRemoved,
    required TResult Function(CartItemDiscountSet value) itemDiscountSet,
    required TResult Function(CartGlobalDiscountSet value) globalDiscountSet,
    required TResult Function(CartCleared value) cleared,
  }) {
    return globalDiscountSet(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CartStarted value)? started,
    TResult? Function(CartTabAdded value)? tabAdded,
    TResult? Function(CartTabSwitched value)? tabSwitched,
    TResult? Function(CartTabClosed value)? tabClosed,
    TResult? Function(CartCustomerAssigned value)? customerAssigned,
    TResult? Function(CartItemAdded value)? itemAdded,
    TResult? Function(CartItemQtyChanged value)? itemQtyChanged,
    TResult? Function(CartItemRemoved value)? itemRemoved,
    TResult? Function(CartItemDiscountSet value)? itemDiscountSet,
    TResult? Function(CartGlobalDiscountSet value)? globalDiscountSet,
    TResult? Function(CartCleared value)? cleared,
  }) {
    return globalDiscountSet?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CartStarted value)? started,
    TResult Function(CartTabAdded value)? tabAdded,
    TResult Function(CartTabSwitched value)? tabSwitched,
    TResult Function(CartTabClosed value)? tabClosed,
    TResult Function(CartCustomerAssigned value)? customerAssigned,
    TResult Function(CartItemAdded value)? itemAdded,
    TResult Function(CartItemQtyChanged value)? itemQtyChanged,
    TResult Function(CartItemRemoved value)? itemRemoved,
    TResult Function(CartItemDiscountSet value)? itemDiscountSet,
    TResult Function(CartGlobalDiscountSet value)? globalDiscountSet,
    TResult Function(CartCleared value)? cleared,
    required TResult orElse(),
  }) {
    if (globalDiscountSet != null) {
      return globalDiscountSet(this);
    }
    return orElse();
  }
}

abstract class CartGlobalDiscountSet implements CartEvent {
  const factory CartGlobalDiscountSet({required final double discount}) =
      _$CartGlobalDiscountSetImpl;

  double get discount;

  /// Create a copy of CartEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CartGlobalDiscountSetImplCopyWith<_$CartGlobalDiscountSetImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CartClearedImplCopyWith<$Res> {
  factory _$$CartClearedImplCopyWith(
    _$CartClearedImpl value,
    $Res Function(_$CartClearedImpl) then,
  ) = __$$CartClearedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String tabId});
}

/// @nodoc
class __$$CartClearedImplCopyWithImpl<$Res>
    extends _$CartEventCopyWithImpl<$Res, _$CartClearedImpl>
    implements _$$CartClearedImplCopyWith<$Res> {
  __$$CartClearedImplCopyWithImpl(
    _$CartClearedImpl _value,
    $Res Function(_$CartClearedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CartEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? tabId = null}) {
    return _then(
      _$CartClearedImpl(
        tabId: null == tabId
            ? _value.tabId
            : tabId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$CartClearedImpl implements CartCleared {
  const _$CartClearedImpl({required this.tabId});

  @override
  final String tabId;

  @override
  String toString() {
    return 'CartEvent.cleared(tabId: $tabId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CartClearedImpl &&
            (identical(other.tabId, tabId) || other.tabId == tabId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, tabId);

  /// Create a copy of CartEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CartClearedImplCopyWith<_$CartClearedImpl> get copyWith =>
      __$$CartClearedImplCopyWithImpl<_$CartClearedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function() tabAdded,
    required TResult Function(String tabId) tabSwitched,
    required TResult Function(String tabId) tabClosed,
    required TResult Function(String tabId, String customerId, String name)
    customerAssigned,
    required TResult Function(CartItem item) itemAdded,
    required TResult Function(String productGuid, int qty) itemQtyChanged,
    required TResult Function(String productGuid) itemRemoved,
    required TResult Function(String productGuid, double discount)
    itemDiscountSet,
    required TResult Function(double discount) globalDiscountSet,
    required TResult Function(String tabId) cleared,
  }) {
    return cleared(tabId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function()? tabAdded,
    TResult? Function(String tabId)? tabSwitched,
    TResult? Function(String tabId)? tabClosed,
    TResult? Function(String tabId, String customerId, String name)?
    customerAssigned,
    TResult? Function(CartItem item)? itemAdded,
    TResult? Function(String productGuid, int qty)? itemQtyChanged,
    TResult? Function(String productGuid)? itemRemoved,
    TResult? Function(String productGuid, double discount)? itemDiscountSet,
    TResult? Function(double discount)? globalDiscountSet,
    TResult? Function(String tabId)? cleared,
  }) {
    return cleared?.call(tabId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function()? tabAdded,
    TResult Function(String tabId)? tabSwitched,
    TResult Function(String tabId)? tabClosed,
    TResult Function(String tabId, String customerId, String name)?
    customerAssigned,
    TResult Function(CartItem item)? itemAdded,
    TResult Function(String productGuid, int qty)? itemQtyChanged,
    TResult Function(String productGuid)? itemRemoved,
    TResult Function(String productGuid, double discount)? itemDiscountSet,
    TResult Function(double discount)? globalDiscountSet,
    TResult Function(String tabId)? cleared,
    required TResult orElse(),
  }) {
    if (cleared != null) {
      return cleared(tabId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CartStarted value) started,
    required TResult Function(CartTabAdded value) tabAdded,
    required TResult Function(CartTabSwitched value) tabSwitched,
    required TResult Function(CartTabClosed value) tabClosed,
    required TResult Function(CartCustomerAssigned value) customerAssigned,
    required TResult Function(CartItemAdded value) itemAdded,
    required TResult Function(CartItemQtyChanged value) itemQtyChanged,
    required TResult Function(CartItemRemoved value) itemRemoved,
    required TResult Function(CartItemDiscountSet value) itemDiscountSet,
    required TResult Function(CartGlobalDiscountSet value) globalDiscountSet,
    required TResult Function(CartCleared value) cleared,
  }) {
    return cleared(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CartStarted value)? started,
    TResult? Function(CartTabAdded value)? tabAdded,
    TResult? Function(CartTabSwitched value)? tabSwitched,
    TResult? Function(CartTabClosed value)? tabClosed,
    TResult? Function(CartCustomerAssigned value)? customerAssigned,
    TResult? Function(CartItemAdded value)? itemAdded,
    TResult? Function(CartItemQtyChanged value)? itemQtyChanged,
    TResult? Function(CartItemRemoved value)? itemRemoved,
    TResult? Function(CartItemDiscountSet value)? itemDiscountSet,
    TResult? Function(CartGlobalDiscountSet value)? globalDiscountSet,
    TResult? Function(CartCleared value)? cleared,
  }) {
    return cleared?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CartStarted value)? started,
    TResult Function(CartTabAdded value)? tabAdded,
    TResult Function(CartTabSwitched value)? tabSwitched,
    TResult Function(CartTabClosed value)? tabClosed,
    TResult Function(CartCustomerAssigned value)? customerAssigned,
    TResult Function(CartItemAdded value)? itemAdded,
    TResult Function(CartItemQtyChanged value)? itemQtyChanged,
    TResult Function(CartItemRemoved value)? itemRemoved,
    TResult Function(CartItemDiscountSet value)? itemDiscountSet,
    TResult Function(CartGlobalDiscountSet value)? globalDiscountSet,
    TResult Function(CartCleared value)? cleared,
    required TResult orElse(),
  }) {
    if (cleared != null) {
      return cleared(this);
    }
    return orElse();
  }
}

abstract class CartCleared implements CartEvent {
  const factory CartCleared({required final String tabId}) = _$CartClearedImpl;

  String get tabId;

  /// Create a copy of CartEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CartClearedImplCopyWith<_$CartClearedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
