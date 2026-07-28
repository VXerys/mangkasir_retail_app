// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ProductEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String storeId, String? categoryId) watchStarted,
    required TResult Function(Product product) added,
    required TResult Function(Product product) updated,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String storeId, String? categoryId)? watchStarted,
    TResult? Function(Product product)? added,
    TResult? Function(Product product)? updated,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String storeId, String? categoryId)? watchStarted,
    TResult Function(Product product)? added,
    TResult Function(Product product)? updated,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ProductWatchStarted value) watchStarted,
    required TResult Function(ProductAdded value) added,
    required TResult Function(ProductUpdated value) updated,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ProductWatchStarted value)? watchStarted,
    TResult? Function(ProductAdded value)? added,
    TResult? Function(ProductUpdated value)? updated,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ProductWatchStarted value)? watchStarted,
    TResult Function(ProductAdded value)? added,
    TResult Function(ProductUpdated value)? updated,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductEventCopyWith<$Res> {
  factory $ProductEventCopyWith(
    ProductEvent value,
    $Res Function(ProductEvent) then,
  ) = _$ProductEventCopyWithImpl<$Res, ProductEvent>;
}

/// @nodoc
class _$ProductEventCopyWithImpl<$Res, $Val extends ProductEvent>
    implements $ProductEventCopyWith<$Res> {
  _$ProductEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProductEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$ProductWatchStartedImplCopyWith<$Res> {
  factory _$$ProductWatchStartedImplCopyWith(
    _$ProductWatchStartedImpl value,
    $Res Function(_$ProductWatchStartedImpl) then,
  ) = __$$ProductWatchStartedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String storeId, String? categoryId});
}

/// @nodoc
class __$$ProductWatchStartedImplCopyWithImpl<$Res>
    extends _$ProductEventCopyWithImpl<$Res, _$ProductWatchStartedImpl>
    implements _$$ProductWatchStartedImplCopyWith<$Res> {
  __$$ProductWatchStartedImplCopyWithImpl(
    _$ProductWatchStartedImpl _value,
    $Res Function(_$ProductWatchStartedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProductEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? storeId = null, Object? categoryId = freezed}) {
    return _then(
      _$ProductWatchStartedImpl(
        storeId: null == storeId
            ? _value.storeId
            : storeId // ignore: cast_nullable_to_non_nullable
                  as String,
        categoryId: freezed == categoryId
            ? _value.categoryId
            : categoryId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$ProductWatchStartedImpl implements ProductWatchStarted {
  const _$ProductWatchStartedImpl({required this.storeId, this.categoryId});

  @override
  final String storeId;
  @override
  final String? categoryId;

  @override
  String toString() {
    return 'ProductEvent.watchStarted(storeId: $storeId, categoryId: $categoryId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductWatchStartedImpl &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, storeId, categoryId);

  /// Create a copy of ProductEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductWatchStartedImplCopyWith<_$ProductWatchStartedImpl> get copyWith =>
      __$$ProductWatchStartedImplCopyWithImpl<_$ProductWatchStartedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String storeId, String? categoryId) watchStarted,
    required TResult Function(Product product) added,
    required TResult Function(Product product) updated,
  }) {
    return watchStarted(storeId, categoryId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String storeId, String? categoryId)? watchStarted,
    TResult? Function(Product product)? added,
    TResult? Function(Product product)? updated,
  }) {
    return watchStarted?.call(storeId, categoryId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String storeId, String? categoryId)? watchStarted,
    TResult Function(Product product)? added,
    TResult Function(Product product)? updated,
    required TResult orElse(),
  }) {
    if (watchStarted != null) {
      return watchStarted(storeId, categoryId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ProductWatchStarted value) watchStarted,
    required TResult Function(ProductAdded value) added,
    required TResult Function(ProductUpdated value) updated,
  }) {
    return watchStarted(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ProductWatchStarted value)? watchStarted,
    TResult? Function(ProductAdded value)? added,
    TResult? Function(ProductUpdated value)? updated,
  }) {
    return watchStarted?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ProductWatchStarted value)? watchStarted,
    TResult Function(ProductAdded value)? added,
    TResult Function(ProductUpdated value)? updated,
    required TResult orElse(),
  }) {
    if (watchStarted != null) {
      return watchStarted(this);
    }
    return orElse();
  }
}

abstract class ProductWatchStarted implements ProductEvent {
  const factory ProductWatchStarted({
    required final String storeId,
    final String? categoryId,
  }) = _$ProductWatchStartedImpl;

  String get storeId;
  String? get categoryId;

  /// Create a copy of ProductEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductWatchStartedImplCopyWith<_$ProductWatchStartedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ProductAddedImplCopyWith<$Res> {
  factory _$$ProductAddedImplCopyWith(
    _$ProductAddedImpl value,
    $Res Function(_$ProductAddedImpl) then,
  ) = __$$ProductAddedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Product product});

  $ProductCopyWith<$Res> get product;
}

/// @nodoc
class __$$ProductAddedImplCopyWithImpl<$Res>
    extends _$ProductEventCopyWithImpl<$Res, _$ProductAddedImpl>
    implements _$$ProductAddedImplCopyWith<$Res> {
  __$$ProductAddedImplCopyWithImpl(
    _$ProductAddedImpl _value,
    $Res Function(_$ProductAddedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProductEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? product = null}) {
    return _then(
      _$ProductAddedImpl(
        product: null == product
            ? _value.product
            : product // ignore: cast_nullable_to_non_nullable
                  as Product,
      ),
    );
  }

  /// Create a copy of ProductEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProductCopyWith<$Res> get product {
    return $ProductCopyWith<$Res>(_value.product, (value) {
      return _then(_value.copyWith(product: value));
    });
  }
}

/// @nodoc

class _$ProductAddedImpl implements ProductAdded {
  const _$ProductAddedImpl({required this.product});

  @override
  final Product product;

  @override
  String toString() {
    return 'ProductEvent.added(product: $product)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductAddedImpl &&
            (identical(other.product, product) || other.product == product));
  }

  @override
  int get hashCode => Object.hash(runtimeType, product);

  /// Create a copy of ProductEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductAddedImplCopyWith<_$ProductAddedImpl> get copyWith =>
      __$$ProductAddedImplCopyWithImpl<_$ProductAddedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String storeId, String? categoryId) watchStarted,
    required TResult Function(Product product) added,
    required TResult Function(Product product) updated,
  }) {
    return added(product);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String storeId, String? categoryId)? watchStarted,
    TResult? Function(Product product)? added,
    TResult? Function(Product product)? updated,
  }) {
    return added?.call(product);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String storeId, String? categoryId)? watchStarted,
    TResult Function(Product product)? added,
    TResult Function(Product product)? updated,
    required TResult orElse(),
  }) {
    if (added != null) {
      return added(product);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ProductWatchStarted value) watchStarted,
    required TResult Function(ProductAdded value) added,
    required TResult Function(ProductUpdated value) updated,
  }) {
    return added(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ProductWatchStarted value)? watchStarted,
    TResult? Function(ProductAdded value)? added,
    TResult? Function(ProductUpdated value)? updated,
  }) {
    return added?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ProductWatchStarted value)? watchStarted,
    TResult Function(ProductAdded value)? added,
    TResult Function(ProductUpdated value)? updated,
    required TResult orElse(),
  }) {
    if (added != null) {
      return added(this);
    }
    return orElse();
  }
}

abstract class ProductAdded implements ProductEvent {
  const factory ProductAdded({required final Product product}) =
      _$ProductAddedImpl;

  Product get product;

  /// Create a copy of ProductEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductAddedImplCopyWith<_$ProductAddedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ProductUpdatedImplCopyWith<$Res> {
  factory _$$ProductUpdatedImplCopyWith(
    _$ProductUpdatedImpl value,
    $Res Function(_$ProductUpdatedImpl) then,
  ) = __$$ProductUpdatedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Product product});

  $ProductCopyWith<$Res> get product;
}

/// @nodoc
class __$$ProductUpdatedImplCopyWithImpl<$Res>
    extends _$ProductEventCopyWithImpl<$Res, _$ProductUpdatedImpl>
    implements _$$ProductUpdatedImplCopyWith<$Res> {
  __$$ProductUpdatedImplCopyWithImpl(
    _$ProductUpdatedImpl _value,
    $Res Function(_$ProductUpdatedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProductEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? product = null}) {
    return _then(
      _$ProductUpdatedImpl(
        product: null == product
            ? _value.product
            : product // ignore: cast_nullable_to_non_nullable
                  as Product,
      ),
    );
  }

  /// Create a copy of ProductEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProductCopyWith<$Res> get product {
    return $ProductCopyWith<$Res>(_value.product, (value) {
      return _then(_value.copyWith(product: value));
    });
  }
}

/// @nodoc

class _$ProductUpdatedImpl implements ProductUpdated {
  const _$ProductUpdatedImpl({required this.product});

  @override
  final Product product;

  @override
  String toString() {
    return 'ProductEvent.updated(product: $product)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductUpdatedImpl &&
            (identical(other.product, product) || other.product == product));
  }

  @override
  int get hashCode => Object.hash(runtimeType, product);

  /// Create a copy of ProductEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductUpdatedImplCopyWith<_$ProductUpdatedImpl> get copyWith =>
      __$$ProductUpdatedImplCopyWithImpl<_$ProductUpdatedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String storeId, String? categoryId) watchStarted,
    required TResult Function(Product product) added,
    required TResult Function(Product product) updated,
  }) {
    return updated(product);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String storeId, String? categoryId)? watchStarted,
    TResult? Function(Product product)? added,
    TResult? Function(Product product)? updated,
  }) {
    return updated?.call(product);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String storeId, String? categoryId)? watchStarted,
    TResult Function(Product product)? added,
    TResult Function(Product product)? updated,
    required TResult orElse(),
  }) {
    if (updated != null) {
      return updated(product);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ProductWatchStarted value) watchStarted,
    required TResult Function(ProductAdded value) added,
    required TResult Function(ProductUpdated value) updated,
  }) {
    return updated(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ProductWatchStarted value)? watchStarted,
    TResult? Function(ProductAdded value)? added,
    TResult? Function(ProductUpdated value)? updated,
  }) {
    return updated?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ProductWatchStarted value)? watchStarted,
    TResult Function(ProductAdded value)? added,
    TResult Function(ProductUpdated value)? updated,
    required TResult orElse(),
  }) {
    if (updated != null) {
      return updated(this);
    }
    return orElse();
  }
}

abstract class ProductUpdated implements ProductEvent {
  const factory ProductUpdated({required final Product product}) =
      _$ProductUpdatedImpl;

  Product get product;

  /// Create a copy of ProductEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductUpdatedImplCopyWith<_$ProductUpdatedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
