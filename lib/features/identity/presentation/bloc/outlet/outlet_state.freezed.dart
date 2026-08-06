// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'outlet_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$OutletState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(List<Outlet> outlets) loaded,
    required TResult Function() saving,
    required TResult Function(String message) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(List<Outlet> outlets)? loaded,
    TResult? Function()? saving,
    TResult? Function(String message)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(List<Outlet> outlets)? loaded,
    TResult Function()? saving,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OutletLoading value) loading,
    required TResult Function(OutletLoaded value) loaded,
    required TResult Function(OutletSaving value) saving,
    required TResult Function(OutletError value) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(OutletLoading value)? loading,
    TResult? Function(OutletLoaded value)? loaded,
    TResult? Function(OutletSaving value)? saving,
    TResult? Function(OutletError value)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OutletLoading value)? loading,
    TResult Function(OutletLoaded value)? loaded,
    TResult Function(OutletSaving value)? saving,
    TResult Function(OutletError value)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OutletStateCopyWith<$Res> {
  factory $OutletStateCopyWith(
    OutletState value,
    $Res Function(OutletState) then,
  ) = _$OutletStateCopyWithImpl<$Res, OutletState>;
}

/// @nodoc
class _$OutletStateCopyWithImpl<$Res, $Val extends OutletState>
    implements $OutletStateCopyWith<$Res> {
  _$OutletStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OutletState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$OutletLoadingImplCopyWith<$Res> {
  factory _$$OutletLoadingImplCopyWith(
    _$OutletLoadingImpl value,
    $Res Function(_$OutletLoadingImpl) then,
  ) = __$$OutletLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$OutletLoadingImplCopyWithImpl<$Res>
    extends _$OutletStateCopyWithImpl<$Res, _$OutletLoadingImpl>
    implements _$$OutletLoadingImplCopyWith<$Res> {
  __$$OutletLoadingImplCopyWithImpl(
    _$OutletLoadingImpl _value,
    $Res Function(_$OutletLoadingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OutletState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$OutletLoadingImpl implements OutletLoading {
  const _$OutletLoadingImpl();

  @override
  String toString() {
    return 'OutletState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$OutletLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(List<Outlet> outlets) loaded,
    required TResult Function() saving,
    required TResult Function(String message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(List<Outlet> outlets)? loaded,
    TResult? Function()? saving,
    TResult? Function(String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(List<Outlet> outlets)? loaded,
    TResult Function()? saving,
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
    required TResult Function(OutletLoading value) loading,
    required TResult Function(OutletLoaded value) loaded,
    required TResult Function(OutletSaving value) saving,
    required TResult Function(OutletError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(OutletLoading value)? loading,
    TResult? Function(OutletLoaded value)? loaded,
    TResult? Function(OutletSaving value)? saving,
    TResult? Function(OutletError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OutletLoading value)? loading,
    TResult Function(OutletLoaded value)? loaded,
    TResult Function(OutletSaving value)? saving,
    TResult Function(OutletError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class OutletLoading implements OutletState {
  const factory OutletLoading() = _$OutletLoadingImpl;
}

/// @nodoc
abstract class _$$OutletLoadedImplCopyWith<$Res> {
  factory _$$OutletLoadedImplCopyWith(
    _$OutletLoadedImpl value,
    $Res Function(_$OutletLoadedImpl) then,
  ) = __$$OutletLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<Outlet> outlets});
}

/// @nodoc
class __$$OutletLoadedImplCopyWithImpl<$Res>
    extends _$OutletStateCopyWithImpl<$Res, _$OutletLoadedImpl>
    implements _$$OutletLoadedImplCopyWith<$Res> {
  __$$OutletLoadedImplCopyWithImpl(
    _$OutletLoadedImpl _value,
    $Res Function(_$OutletLoadedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OutletState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? outlets = null}) {
    return _then(
      _$OutletLoadedImpl(
        null == outlets
            ? _value._outlets
            : outlets // ignore: cast_nullable_to_non_nullable
                  as List<Outlet>,
      ),
    );
  }
}

/// @nodoc

class _$OutletLoadedImpl implements OutletLoaded {
  const _$OutletLoadedImpl(final List<Outlet> outlets) : _outlets = outlets;

  final List<Outlet> _outlets;
  @override
  List<Outlet> get outlets {
    if (_outlets is EqualUnmodifiableListView) return _outlets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_outlets);
  }

  @override
  String toString() {
    return 'OutletState.loaded(outlets: $outlets)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OutletLoadedImpl &&
            const DeepCollectionEquality().equals(other._outlets, _outlets));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_outlets));

  /// Create a copy of OutletState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OutletLoadedImplCopyWith<_$OutletLoadedImpl> get copyWith =>
      __$$OutletLoadedImplCopyWithImpl<_$OutletLoadedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(List<Outlet> outlets) loaded,
    required TResult Function() saving,
    required TResult Function(String message) error,
  }) {
    return loaded(outlets);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(List<Outlet> outlets)? loaded,
    TResult? Function()? saving,
    TResult? Function(String message)? error,
  }) {
    return loaded?.call(outlets);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(List<Outlet> outlets)? loaded,
    TResult Function()? saving,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(outlets);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OutletLoading value) loading,
    required TResult Function(OutletLoaded value) loaded,
    required TResult Function(OutletSaving value) saving,
    required TResult Function(OutletError value) error,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(OutletLoading value)? loading,
    TResult? Function(OutletLoaded value)? loaded,
    TResult? Function(OutletSaving value)? saving,
    TResult? Function(OutletError value)? error,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OutletLoading value)? loading,
    TResult Function(OutletLoaded value)? loaded,
    TResult Function(OutletSaving value)? saving,
    TResult Function(OutletError value)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class OutletLoaded implements OutletState {
  const factory OutletLoaded(final List<Outlet> outlets) = _$OutletLoadedImpl;

  List<Outlet> get outlets;

  /// Create a copy of OutletState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OutletLoadedImplCopyWith<_$OutletLoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$OutletSavingImplCopyWith<$Res> {
  factory _$$OutletSavingImplCopyWith(
    _$OutletSavingImpl value,
    $Res Function(_$OutletSavingImpl) then,
  ) = __$$OutletSavingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$OutletSavingImplCopyWithImpl<$Res>
    extends _$OutletStateCopyWithImpl<$Res, _$OutletSavingImpl>
    implements _$$OutletSavingImplCopyWith<$Res> {
  __$$OutletSavingImplCopyWithImpl(
    _$OutletSavingImpl _value,
    $Res Function(_$OutletSavingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OutletState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$OutletSavingImpl implements OutletSaving {
  const _$OutletSavingImpl();

  @override
  String toString() {
    return 'OutletState.saving()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$OutletSavingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(List<Outlet> outlets) loaded,
    required TResult Function() saving,
    required TResult Function(String message) error,
  }) {
    return saving();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(List<Outlet> outlets)? loaded,
    TResult? Function()? saving,
    TResult? Function(String message)? error,
  }) {
    return saving?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(List<Outlet> outlets)? loaded,
    TResult Function()? saving,
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
    required TResult Function(OutletLoading value) loading,
    required TResult Function(OutletLoaded value) loaded,
    required TResult Function(OutletSaving value) saving,
    required TResult Function(OutletError value) error,
  }) {
    return saving(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(OutletLoading value)? loading,
    TResult? Function(OutletLoaded value)? loaded,
    TResult? Function(OutletSaving value)? saving,
    TResult? Function(OutletError value)? error,
  }) {
    return saving?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OutletLoading value)? loading,
    TResult Function(OutletLoaded value)? loaded,
    TResult Function(OutletSaving value)? saving,
    TResult Function(OutletError value)? error,
    required TResult orElse(),
  }) {
    if (saving != null) {
      return saving(this);
    }
    return orElse();
  }
}

abstract class OutletSaving implements OutletState {
  const factory OutletSaving() = _$OutletSavingImpl;
}

/// @nodoc
abstract class _$$OutletErrorImplCopyWith<$Res> {
  factory _$$OutletErrorImplCopyWith(
    _$OutletErrorImpl value,
    $Res Function(_$OutletErrorImpl) then,
  ) = __$$OutletErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$OutletErrorImplCopyWithImpl<$Res>
    extends _$OutletStateCopyWithImpl<$Res, _$OutletErrorImpl>
    implements _$$OutletErrorImplCopyWith<$Res> {
  __$$OutletErrorImplCopyWithImpl(
    _$OutletErrorImpl _value,
    $Res Function(_$OutletErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OutletState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$OutletErrorImpl(
        null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$OutletErrorImpl implements OutletError {
  const _$OutletErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'OutletState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OutletErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of OutletState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OutletErrorImplCopyWith<_$OutletErrorImpl> get copyWith =>
      __$$OutletErrorImplCopyWithImpl<_$OutletErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(List<Outlet> outlets) loaded,
    required TResult Function() saving,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(List<Outlet> outlets)? loaded,
    TResult? Function()? saving,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(List<Outlet> outlets)? loaded,
    TResult Function()? saving,
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
    required TResult Function(OutletLoading value) loading,
    required TResult Function(OutletLoaded value) loaded,
    required TResult Function(OutletSaving value) saving,
    required TResult Function(OutletError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(OutletLoading value)? loading,
    TResult? Function(OutletLoaded value)? loaded,
    TResult? Function(OutletSaving value)? saving,
    TResult? Function(OutletError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OutletLoading value)? loading,
    TResult Function(OutletLoaded value)? loaded,
    TResult Function(OutletSaving value)? saving,
    TResult Function(OutletError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class OutletError implements OutletState {
  const factory OutletError(final String message) = _$OutletErrorImpl;

  String get message;

  /// Create a copy of OutletState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OutletErrorImplCopyWith<_$OutletErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
