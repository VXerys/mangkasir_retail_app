// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'business_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$BusinessState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(Business business) loaded,
    required TResult Function() saving,
    required TResult Function(Business business) saved,
    required TResult Function(String message) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(Business business)? loaded,
    TResult? Function()? saving,
    TResult? Function(Business business)? saved,
    TResult? Function(String message)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(Business business)? loaded,
    TResult Function()? saving,
    TResult Function(Business business)? saved,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BusinessLoading value) loading,
    required TResult Function(BusinessLoaded value) loaded,
    required TResult Function(BusinessSaving value) saving,
    required TResult Function(BusinessSaved value) saved,
    required TResult Function(BusinessError value) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BusinessLoading value)? loading,
    TResult? Function(BusinessLoaded value)? loaded,
    TResult? Function(BusinessSaving value)? saving,
    TResult? Function(BusinessSaved value)? saved,
    TResult? Function(BusinessError value)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BusinessLoading value)? loading,
    TResult Function(BusinessLoaded value)? loaded,
    TResult Function(BusinessSaving value)? saving,
    TResult Function(BusinessSaved value)? saved,
    TResult Function(BusinessError value)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BusinessStateCopyWith<$Res> {
  factory $BusinessStateCopyWith(
    BusinessState value,
    $Res Function(BusinessState) then,
  ) = _$BusinessStateCopyWithImpl<$Res, BusinessState>;
}

/// @nodoc
class _$BusinessStateCopyWithImpl<$Res, $Val extends BusinessState>
    implements $BusinessStateCopyWith<$Res> {
  _$BusinessStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BusinessState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$BusinessLoadingImplCopyWith<$Res> {
  factory _$$BusinessLoadingImplCopyWith(
    _$BusinessLoadingImpl value,
    $Res Function(_$BusinessLoadingImpl) then,
  ) = __$$BusinessLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$BusinessLoadingImplCopyWithImpl<$Res>
    extends _$BusinessStateCopyWithImpl<$Res, _$BusinessLoadingImpl>
    implements _$$BusinessLoadingImplCopyWith<$Res> {
  __$$BusinessLoadingImplCopyWithImpl(
    _$BusinessLoadingImpl _value,
    $Res Function(_$BusinessLoadingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BusinessState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$BusinessLoadingImpl implements BusinessLoading {
  const _$BusinessLoadingImpl();

  @override
  String toString() {
    return 'BusinessState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$BusinessLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(Business business) loaded,
    required TResult Function() saving,
    required TResult Function(Business business) saved,
    required TResult Function(String message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(Business business)? loaded,
    TResult? Function()? saving,
    TResult? Function(Business business)? saved,
    TResult? Function(String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(Business business)? loaded,
    TResult Function()? saving,
    TResult Function(Business business)? saved,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BusinessLoading value) loading,
    required TResult Function(BusinessLoaded value) loaded,
    required TResult Function(BusinessSaving value) saving,
    required TResult Function(BusinessSaved value) saved,
    required TResult Function(BusinessError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BusinessLoading value)? loading,
    TResult? Function(BusinessLoaded value)? loaded,
    TResult? Function(BusinessSaving value)? saving,
    TResult? Function(BusinessSaved value)? saved,
    TResult? Function(BusinessError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BusinessLoading value)? loading,
    TResult Function(BusinessLoaded value)? loaded,
    TResult Function(BusinessSaving value)? saving,
    TResult Function(BusinessSaved value)? saved,
    TResult Function(BusinessError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class BusinessLoading implements BusinessState {
  const factory BusinessLoading() = _$BusinessLoadingImpl;
}

/// @nodoc
abstract class _$$BusinessLoadedImplCopyWith<$Res> {
  factory _$$BusinessLoadedImplCopyWith(
    _$BusinessLoadedImpl value,
    $Res Function(_$BusinessLoadedImpl) then,
  ) = __$$BusinessLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Business business});

  $BusinessCopyWith<$Res> get business;
}

/// @nodoc
class __$$BusinessLoadedImplCopyWithImpl<$Res>
    extends _$BusinessStateCopyWithImpl<$Res, _$BusinessLoadedImpl>
    implements _$$BusinessLoadedImplCopyWith<$Res> {
  __$$BusinessLoadedImplCopyWithImpl(
    _$BusinessLoadedImpl _value,
    $Res Function(_$BusinessLoadedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BusinessState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? business = null}) {
    return _then(
      _$BusinessLoadedImpl(
        null == business
            ? _value.business
            : business // ignore: cast_nullable_to_non_nullable
                  as Business,
      ),
    );
  }

  /// Create a copy of BusinessState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BusinessCopyWith<$Res> get business {
    return $BusinessCopyWith<$Res>(_value.business, (value) {
      return _then(_value.copyWith(business: value));
    });
  }
}

/// @nodoc

class _$BusinessLoadedImpl implements BusinessLoaded {
  const _$BusinessLoadedImpl(this.business);

  @override
  final Business business;

  @override
  String toString() {
    return 'BusinessState.loaded(business: $business)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BusinessLoadedImpl &&
            (identical(other.business, business) ||
                other.business == business));
  }

  @override
  int get hashCode => Object.hash(runtimeType, business);

  /// Create a copy of BusinessState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BusinessLoadedImplCopyWith<_$BusinessLoadedImpl> get copyWith =>
      __$$BusinessLoadedImplCopyWithImpl<_$BusinessLoadedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(Business business) loaded,
    required TResult Function() saving,
    required TResult Function(Business business) saved,
    required TResult Function(String message) error,
  }) {
    return loaded(business);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(Business business)? loaded,
    TResult? Function()? saving,
    TResult? Function(Business business)? saved,
    TResult? Function(String message)? error,
  }) {
    return loaded?.call(business);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(Business business)? loaded,
    TResult Function()? saving,
    TResult Function(Business business)? saved,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(business);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BusinessLoading value) loading,
    required TResult Function(BusinessLoaded value) loaded,
    required TResult Function(BusinessSaving value) saving,
    required TResult Function(BusinessSaved value) saved,
    required TResult Function(BusinessError value) error,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BusinessLoading value)? loading,
    TResult? Function(BusinessLoaded value)? loaded,
    TResult? Function(BusinessSaving value)? saving,
    TResult? Function(BusinessSaved value)? saved,
    TResult? Function(BusinessError value)? error,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BusinessLoading value)? loading,
    TResult Function(BusinessLoaded value)? loaded,
    TResult Function(BusinessSaving value)? saving,
    TResult Function(BusinessSaved value)? saved,
    TResult Function(BusinessError value)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class BusinessLoaded implements BusinessState {
  const factory BusinessLoaded(final Business business) = _$BusinessLoadedImpl;

  Business get business;

  /// Create a copy of BusinessState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BusinessLoadedImplCopyWith<_$BusinessLoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$BusinessSavingImplCopyWith<$Res> {
  factory _$$BusinessSavingImplCopyWith(
    _$BusinessSavingImpl value,
    $Res Function(_$BusinessSavingImpl) then,
  ) = __$$BusinessSavingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$BusinessSavingImplCopyWithImpl<$Res>
    extends _$BusinessStateCopyWithImpl<$Res, _$BusinessSavingImpl>
    implements _$$BusinessSavingImplCopyWith<$Res> {
  __$$BusinessSavingImplCopyWithImpl(
    _$BusinessSavingImpl _value,
    $Res Function(_$BusinessSavingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BusinessState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$BusinessSavingImpl implements BusinessSaving {
  const _$BusinessSavingImpl();

  @override
  String toString() {
    return 'BusinessState.saving()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$BusinessSavingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(Business business) loaded,
    required TResult Function() saving,
    required TResult Function(Business business) saved,
    required TResult Function(String message) error,
  }) {
    return saving();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(Business business)? loaded,
    TResult? Function()? saving,
    TResult? Function(Business business)? saved,
    TResult? Function(String message)? error,
  }) {
    return saving?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(Business business)? loaded,
    TResult Function()? saving,
    TResult Function(Business business)? saved,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (saving != null) {
      return saving();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BusinessLoading value) loading,
    required TResult Function(BusinessLoaded value) loaded,
    required TResult Function(BusinessSaving value) saving,
    required TResult Function(BusinessSaved value) saved,
    required TResult Function(BusinessError value) error,
  }) {
    return saving(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BusinessLoading value)? loading,
    TResult? Function(BusinessLoaded value)? loaded,
    TResult? Function(BusinessSaving value)? saving,
    TResult? Function(BusinessSaved value)? saved,
    TResult? Function(BusinessError value)? error,
  }) {
    return saving?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BusinessLoading value)? loading,
    TResult Function(BusinessLoaded value)? loaded,
    TResult Function(BusinessSaving value)? saving,
    TResult Function(BusinessSaved value)? saved,
    TResult Function(BusinessError value)? error,
    required TResult orElse(),
  }) {
    if (saving != null) {
      return saving(this);
    }
    return orElse();
  }
}

abstract class BusinessSaving implements BusinessState {
  const factory BusinessSaving() = _$BusinessSavingImpl;
}

/// @nodoc
abstract class _$$BusinessSavedImplCopyWith<$Res> {
  factory _$$BusinessSavedImplCopyWith(
    _$BusinessSavedImpl value,
    $Res Function(_$BusinessSavedImpl) then,
  ) = __$$BusinessSavedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Business business});

  $BusinessCopyWith<$Res> get business;
}

/// @nodoc
class __$$BusinessSavedImplCopyWithImpl<$Res>
    extends _$BusinessStateCopyWithImpl<$Res, _$BusinessSavedImpl>
    implements _$$BusinessSavedImplCopyWith<$Res> {
  __$$BusinessSavedImplCopyWithImpl(
    _$BusinessSavedImpl _value,
    $Res Function(_$BusinessSavedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BusinessState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? business = null}) {
    return _then(
      _$BusinessSavedImpl(
        null == business
            ? _value.business
            : business // ignore: cast_nullable_to_non_nullable
                  as Business,
      ),
    );
  }

  /// Create a copy of BusinessState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BusinessCopyWith<$Res> get business {
    return $BusinessCopyWith<$Res>(_value.business, (value) {
      return _then(_value.copyWith(business: value));
    });
  }
}

/// @nodoc

class _$BusinessSavedImpl implements BusinessSaved {
  const _$BusinessSavedImpl(this.business);

  @override
  final Business business;

  @override
  String toString() {
    return 'BusinessState.saved(business: $business)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BusinessSavedImpl &&
            (identical(other.business, business) ||
                other.business == business));
  }

  @override
  int get hashCode => Object.hash(runtimeType, business);

  /// Create a copy of BusinessState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BusinessSavedImplCopyWith<_$BusinessSavedImpl> get copyWith =>
      __$$BusinessSavedImplCopyWithImpl<_$BusinessSavedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(Business business) loaded,
    required TResult Function() saving,
    required TResult Function(Business business) saved,
    required TResult Function(String message) error,
  }) {
    return saved(business);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(Business business)? loaded,
    TResult? Function()? saving,
    TResult? Function(Business business)? saved,
    TResult? Function(String message)? error,
  }) {
    return saved?.call(business);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(Business business)? loaded,
    TResult Function()? saving,
    TResult Function(Business business)? saved,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (saved != null) {
      return saved(business);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BusinessLoading value) loading,
    required TResult Function(BusinessLoaded value) loaded,
    required TResult Function(BusinessSaving value) saving,
    required TResult Function(BusinessSaved value) saved,
    required TResult Function(BusinessError value) error,
  }) {
    return saved(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BusinessLoading value)? loading,
    TResult? Function(BusinessLoaded value)? loaded,
    TResult? Function(BusinessSaving value)? saving,
    TResult? Function(BusinessSaved value)? saved,
    TResult? Function(BusinessError value)? error,
  }) {
    return saved?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BusinessLoading value)? loading,
    TResult Function(BusinessLoaded value)? loaded,
    TResult Function(BusinessSaving value)? saving,
    TResult Function(BusinessSaved value)? saved,
    TResult Function(BusinessError value)? error,
    required TResult orElse(),
  }) {
    if (saved != null) {
      return saved(this);
    }
    return orElse();
  }
}

abstract class BusinessSaved implements BusinessState {
  const factory BusinessSaved(final Business business) = _$BusinessSavedImpl;

  Business get business;

  /// Create a copy of BusinessState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BusinessSavedImplCopyWith<_$BusinessSavedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$BusinessErrorImplCopyWith<$Res> {
  factory _$$BusinessErrorImplCopyWith(
    _$BusinessErrorImpl value,
    $Res Function(_$BusinessErrorImpl) then,
  ) = __$$BusinessErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$BusinessErrorImplCopyWithImpl<$Res>
    extends _$BusinessStateCopyWithImpl<$Res, _$BusinessErrorImpl>
    implements _$$BusinessErrorImplCopyWith<$Res> {
  __$$BusinessErrorImplCopyWithImpl(
    _$BusinessErrorImpl _value,
    $Res Function(_$BusinessErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BusinessState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$BusinessErrorImpl(
        null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$BusinessErrorImpl implements BusinessError {
  const _$BusinessErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'BusinessState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BusinessErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of BusinessState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BusinessErrorImplCopyWith<_$BusinessErrorImpl> get copyWith =>
      __$$BusinessErrorImplCopyWithImpl<_$BusinessErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(Business business) loaded,
    required TResult Function() saving,
    required TResult Function(Business business) saved,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(Business business)? loaded,
    TResult? Function()? saving,
    TResult? Function(Business business)? saved,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(Business business)? loaded,
    TResult Function()? saving,
    TResult Function(Business business)? saved,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BusinessLoading value) loading,
    required TResult Function(BusinessLoaded value) loaded,
    required TResult Function(BusinessSaving value) saving,
    required TResult Function(BusinessSaved value) saved,
    required TResult Function(BusinessError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BusinessLoading value)? loading,
    TResult? Function(BusinessLoaded value)? loaded,
    TResult? Function(BusinessSaving value)? saving,
    TResult? Function(BusinessSaved value)? saved,
    TResult? Function(BusinessError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BusinessLoading value)? loading,
    TResult Function(BusinessLoaded value)? loaded,
    TResult Function(BusinessSaving value)? saving,
    TResult Function(BusinessSaved value)? saved,
    TResult Function(BusinessError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class BusinessError implements BusinessState {
  const factory BusinessError(final String message) = _$BusinessErrorImpl;

  String get message;

  /// Create a copy of BusinessState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BusinessErrorImplCopyWith<_$BusinessErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
