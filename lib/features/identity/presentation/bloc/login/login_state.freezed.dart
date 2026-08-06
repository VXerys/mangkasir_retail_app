// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'login_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$LoginState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() loading,
    required TResult Function(String message) error,
    required TResult Function() forgotPasswordIdle,
    required TResult Function() forgotPasswordLoading,
    required TResult Function() forgotPasswordSent,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? loading,
    TResult? Function(String message)? error,
    TResult? Function()? forgotPasswordIdle,
    TResult? Function()? forgotPasswordLoading,
    TResult? Function()? forgotPasswordSent,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? loading,
    TResult Function(String message)? error,
    TResult Function()? forgotPasswordIdle,
    TResult Function()? forgotPasswordLoading,
    TResult Function()? forgotPasswordSent,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoginIdle value) idle,
    required TResult Function(LoginLoading value) loading,
    required TResult Function(LoginError value) error,
    required TResult Function(LoginForgotIdle value) forgotPasswordIdle,
    required TResult Function(LoginForgotLoading value) forgotPasswordLoading,
    required TResult Function(LoginForgotSent value) forgotPasswordSent,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoginIdle value)? idle,
    TResult? Function(LoginLoading value)? loading,
    TResult? Function(LoginError value)? error,
    TResult? Function(LoginForgotIdle value)? forgotPasswordIdle,
    TResult? Function(LoginForgotLoading value)? forgotPasswordLoading,
    TResult? Function(LoginForgotSent value)? forgotPasswordSent,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoginIdle value)? idle,
    TResult Function(LoginLoading value)? loading,
    TResult Function(LoginError value)? error,
    TResult Function(LoginForgotIdle value)? forgotPasswordIdle,
    TResult Function(LoginForgotLoading value)? forgotPasswordLoading,
    TResult Function(LoginForgotSent value)? forgotPasswordSent,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoginStateCopyWith<$Res> {
  factory $LoginStateCopyWith(
    LoginState value,
    $Res Function(LoginState) then,
  ) = _$LoginStateCopyWithImpl<$Res, LoginState>;
}

/// @nodoc
class _$LoginStateCopyWithImpl<$Res, $Val extends LoginState>
    implements $LoginStateCopyWith<$Res> {
  _$LoginStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LoginState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$LoginIdleImplCopyWith<$Res> {
  factory _$$LoginIdleImplCopyWith(
    _$LoginIdleImpl value,
    $Res Function(_$LoginIdleImpl) then,
  ) = __$$LoginIdleImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LoginIdleImplCopyWithImpl<$Res>
    extends _$LoginStateCopyWithImpl<$Res, _$LoginIdleImpl>
    implements _$$LoginIdleImplCopyWith<$Res> {
  __$$LoginIdleImplCopyWithImpl(
    _$LoginIdleImpl _value,
    $Res Function(_$LoginIdleImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LoginState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$LoginIdleImpl implements LoginIdle {
  const _$LoginIdleImpl();

  @override
  String toString() {
    return 'LoginState.idle()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LoginIdleImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() loading,
    required TResult Function(String message) error,
    required TResult Function() forgotPasswordIdle,
    required TResult Function() forgotPasswordLoading,
    required TResult Function() forgotPasswordSent,
  }) {
    return idle();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? loading,
    TResult? Function(String message)? error,
    TResult? Function()? forgotPasswordIdle,
    TResult? Function()? forgotPasswordLoading,
    TResult? Function()? forgotPasswordSent,
  }) {
    return idle?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? loading,
    TResult Function(String message)? error,
    TResult Function()? forgotPasswordIdle,
    TResult Function()? forgotPasswordLoading,
    TResult Function()? forgotPasswordSent,
    required TResult orElse(),
  }) {
    if (idle != null) {
      return idle();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoginIdle value) idle,
    required TResult Function(LoginLoading value) loading,
    required TResult Function(LoginError value) error,
    required TResult Function(LoginForgotIdle value) forgotPasswordIdle,
    required TResult Function(LoginForgotLoading value) forgotPasswordLoading,
    required TResult Function(LoginForgotSent value) forgotPasswordSent,
  }) {
    return idle(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoginIdle value)? idle,
    TResult? Function(LoginLoading value)? loading,
    TResult? Function(LoginError value)? error,
    TResult? Function(LoginForgotIdle value)? forgotPasswordIdle,
    TResult? Function(LoginForgotLoading value)? forgotPasswordLoading,
    TResult? Function(LoginForgotSent value)? forgotPasswordSent,
  }) {
    return idle?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoginIdle value)? idle,
    TResult Function(LoginLoading value)? loading,
    TResult Function(LoginError value)? error,
    TResult Function(LoginForgotIdle value)? forgotPasswordIdle,
    TResult Function(LoginForgotLoading value)? forgotPasswordLoading,
    TResult Function(LoginForgotSent value)? forgotPasswordSent,
    required TResult orElse(),
  }) {
    if (idle != null) {
      return idle(this);
    }
    return orElse();
  }
}

abstract class LoginIdle implements LoginState {
  const factory LoginIdle() = _$LoginIdleImpl;
}

/// @nodoc
abstract class _$$LoginLoadingImplCopyWith<$Res> {
  factory _$$LoginLoadingImplCopyWith(
    _$LoginLoadingImpl value,
    $Res Function(_$LoginLoadingImpl) then,
  ) = __$$LoginLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LoginLoadingImplCopyWithImpl<$Res>
    extends _$LoginStateCopyWithImpl<$Res, _$LoginLoadingImpl>
    implements _$$LoginLoadingImplCopyWith<$Res> {
  __$$LoginLoadingImplCopyWithImpl(
    _$LoginLoadingImpl _value,
    $Res Function(_$LoginLoadingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LoginState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$LoginLoadingImpl implements LoginLoading {
  const _$LoginLoadingImpl();

  @override
  String toString() {
    return 'LoginState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LoginLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() loading,
    required TResult Function(String message) error,
    required TResult Function() forgotPasswordIdle,
    required TResult Function() forgotPasswordLoading,
    required TResult Function() forgotPasswordSent,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? loading,
    TResult? Function(String message)? error,
    TResult? Function()? forgotPasswordIdle,
    TResult? Function()? forgotPasswordLoading,
    TResult? Function()? forgotPasswordSent,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? loading,
    TResult Function(String message)? error,
    TResult Function()? forgotPasswordIdle,
    TResult Function()? forgotPasswordLoading,
    TResult Function()? forgotPasswordSent,
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
    required TResult Function(LoginIdle value) idle,
    required TResult Function(LoginLoading value) loading,
    required TResult Function(LoginError value) error,
    required TResult Function(LoginForgotIdle value) forgotPasswordIdle,
    required TResult Function(LoginForgotLoading value) forgotPasswordLoading,
    required TResult Function(LoginForgotSent value) forgotPasswordSent,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoginIdle value)? idle,
    TResult? Function(LoginLoading value)? loading,
    TResult? Function(LoginError value)? error,
    TResult? Function(LoginForgotIdle value)? forgotPasswordIdle,
    TResult? Function(LoginForgotLoading value)? forgotPasswordLoading,
    TResult? Function(LoginForgotSent value)? forgotPasswordSent,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoginIdle value)? idle,
    TResult Function(LoginLoading value)? loading,
    TResult Function(LoginError value)? error,
    TResult Function(LoginForgotIdle value)? forgotPasswordIdle,
    TResult Function(LoginForgotLoading value)? forgotPasswordLoading,
    TResult Function(LoginForgotSent value)? forgotPasswordSent,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class LoginLoading implements LoginState {
  const factory LoginLoading() = _$LoginLoadingImpl;
}

/// @nodoc
abstract class _$$LoginErrorImplCopyWith<$Res> {
  factory _$$LoginErrorImplCopyWith(
    _$LoginErrorImpl value,
    $Res Function(_$LoginErrorImpl) then,
  ) = __$$LoginErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$LoginErrorImplCopyWithImpl<$Res>
    extends _$LoginStateCopyWithImpl<$Res, _$LoginErrorImpl>
    implements _$$LoginErrorImplCopyWith<$Res> {
  __$$LoginErrorImplCopyWithImpl(
    _$LoginErrorImpl _value,
    $Res Function(_$LoginErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LoginState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$LoginErrorImpl(
        null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$LoginErrorImpl implements LoginError {
  const _$LoginErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'LoginState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoginErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of LoginState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoginErrorImplCopyWith<_$LoginErrorImpl> get copyWith =>
      __$$LoginErrorImplCopyWithImpl<_$LoginErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() loading,
    required TResult Function(String message) error,
    required TResult Function() forgotPasswordIdle,
    required TResult Function() forgotPasswordLoading,
    required TResult Function() forgotPasswordSent,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? loading,
    TResult? Function(String message)? error,
    TResult? Function()? forgotPasswordIdle,
    TResult? Function()? forgotPasswordLoading,
    TResult? Function()? forgotPasswordSent,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? loading,
    TResult Function(String message)? error,
    TResult Function()? forgotPasswordIdle,
    TResult Function()? forgotPasswordLoading,
    TResult Function()? forgotPasswordSent,
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
    required TResult Function(LoginIdle value) idle,
    required TResult Function(LoginLoading value) loading,
    required TResult Function(LoginError value) error,
    required TResult Function(LoginForgotIdle value) forgotPasswordIdle,
    required TResult Function(LoginForgotLoading value) forgotPasswordLoading,
    required TResult Function(LoginForgotSent value) forgotPasswordSent,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoginIdle value)? idle,
    TResult? Function(LoginLoading value)? loading,
    TResult? Function(LoginError value)? error,
    TResult? Function(LoginForgotIdle value)? forgotPasswordIdle,
    TResult? Function(LoginForgotLoading value)? forgotPasswordLoading,
    TResult? Function(LoginForgotSent value)? forgotPasswordSent,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoginIdle value)? idle,
    TResult Function(LoginLoading value)? loading,
    TResult Function(LoginError value)? error,
    TResult Function(LoginForgotIdle value)? forgotPasswordIdle,
    TResult Function(LoginForgotLoading value)? forgotPasswordLoading,
    TResult Function(LoginForgotSent value)? forgotPasswordSent,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class LoginError implements LoginState {
  const factory LoginError(final String message) = _$LoginErrorImpl;

  String get message;

  /// Create a copy of LoginState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoginErrorImplCopyWith<_$LoginErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$LoginForgotIdleImplCopyWith<$Res> {
  factory _$$LoginForgotIdleImplCopyWith(
    _$LoginForgotIdleImpl value,
    $Res Function(_$LoginForgotIdleImpl) then,
  ) = __$$LoginForgotIdleImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LoginForgotIdleImplCopyWithImpl<$Res>
    extends _$LoginStateCopyWithImpl<$Res, _$LoginForgotIdleImpl>
    implements _$$LoginForgotIdleImplCopyWith<$Res> {
  __$$LoginForgotIdleImplCopyWithImpl(
    _$LoginForgotIdleImpl _value,
    $Res Function(_$LoginForgotIdleImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LoginState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$LoginForgotIdleImpl implements LoginForgotIdle {
  const _$LoginForgotIdleImpl();

  @override
  String toString() {
    return 'LoginState.forgotPasswordIdle()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LoginForgotIdleImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() loading,
    required TResult Function(String message) error,
    required TResult Function() forgotPasswordIdle,
    required TResult Function() forgotPasswordLoading,
    required TResult Function() forgotPasswordSent,
  }) {
    return forgotPasswordIdle();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? loading,
    TResult? Function(String message)? error,
    TResult? Function()? forgotPasswordIdle,
    TResult? Function()? forgotPasswordLoading,
    TResult? Function()? forgotPasswordSent,
  }) {
    return forgotPasswordIdle?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? loading,
    TResult Function(String message)? error,
    TResult Function()? forgotPasswordIdle,
    TResult Function()? forgotPasswordLoading,
    TResult Function()? forgotPasswordSent,
    required TResult orElse(),
  }) {
    if (forgotPasswordIdle != null) {
      return forgotPasswordIdle();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoginIdle value) idle,
    required TResult Function(LoginLoading value) loading,
    required TResult Function(LoginError value) error,
    required TResult Function(LoginForgotIdle value) forgotPasswordIdle,
    required TResult Function(LoginForgotLoading value) forgotPasswordLoading,
    required TResult Function(LoginForgotSent value) forgotPasswordSent,
  }) {
    return forgotPasswordIdle(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoginIdle value)? idle,
    TResult? Function(LoginLoading value)? loading,
    TResult? Function(LoginError value)? error,
    TResult? Function(LoginForgotIdle value)? forgotPasswordIdle,
    TResult? Function(LoginForgotLoading value)? forgotPasswordLoading,
    TResult? Function(LoginForgotSent value)? forgotPasswordSent,
  }) {
    return forgotPasswordIdle?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoginIdle value)? idle,
    TResult Function(LoginLoading value)? loading,
    TResult Function(LoginError value)? error,
    TResult Function(LoginForgotIdle value)? forgotPasswordIdle,
    TResult Function(LoginForgotLoading value)? forgotPasswordLoading,
    TResult Function(LoginForgotSent value)? forgotPasswordSent,
    required TResult orElse(),
  }) {
    if (forgotPasswordIdle != null) {
      return forgotPasswordIdle(this);
    }
    return orElse();
  }
}

abstract class LoginForgotIdle implements LoginState {
  const factory LoginForgotIdle() = _$LoginForgotIdleImpl;
}

/// @nodoc
abstract class _$$LoginForgotLoadingImplCopyWith<$Res> {
  factory _$$LoginForgotLoadingImplCopyWith(
    _$LoginForgotLoadingImpl value,
    $Res Function(_$LoginForgotLoadingImpl) then,
  ) = __$$LoginForgotLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LoginForgotLoadingImplCopyWithImpl<$Res>
    extends _$LoginStateCopyWithImpl<$Res, _$LoginForgotLoadingImpl>
    implements _$$LoginForgotLoadingImplCopyWith<$Res> {
  __$$LoginForgotLoadingImplCopyWithImpl(
    _$LoginForgotLoadingImpl _value,
    $Res Function(_$LoginForgotLoadingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LoginState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$LoginForgotLoadingImpl implements LoginForgotLoading {
  const _$LoginForgotLoadingImpl();

  @override
  String toString() {
    return 'LoginState.forgotPasswordLoading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LoginForgotLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() loading,
    required TResult Function(String message) error,
    required TResult Function() forgotPasswordIdle,
    required TResult Function() forgotPasswordLoading,
    required TResult Function() forgotPasswordSent,
  }) {
    return forgotPasswordLoading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? loading,
    TResult? Function(String message)? error,
    TResult? Function()? forgotPasswordIdle,
    TResult? Function()? forgotPasswordLoading,
    TResult? Function()? forgotPasswordSent,
  }) {
    return forgotPasswordLoading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? loading,
    TResult Function(String message)? error,
    TResult Function()? forgotPasswordIdle,
    TResult Function()? forgotPasswordLoading,
    TResult Function()? forgotPasswordSent,
    required TResult orElse(),
  }) {
    if (forgotPasswordLoading != null) {
      return forgotPasswordLoading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoginIdle value) idle,
    required TResult Function(LoginLoading value) loading,
    required TResult Function(LoginError value) error,
    required TResult Function(LoginForgotIdle value) forgotPasswordIdle,
    required TResult Function(LoginForgotLoading value) forgotPasswordLoading,
    required TResult Function(LoginForgotSent value) forgotPasswordSent,
  }) {
    return forgotPasswordLoading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoginIdle value)? idle,
    TResult? Function(LoginLoading value)? loading,
    TResult? Function(LoginError value)? error,
    TResult? Function(LoginForgotIdle value)? forgotPasswordIdle,
    TResult? Function(LoginForgotLoading value)? forgotPasswordLoading,
    TResult? Function(LoginForgotSent value)? forgotPasswordSent,
  }) {
    return forgotPasswordLoading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoginIdle value)? idle,
    TResult Function(LoginLoading value)? loading,
    TResult Function(LoginError value)? error,
    TResult Function(LoginForgotIdle value)? forgotPasswordIdle,
    TResult Function(LoginForgotLoading value)? forgotPasswordLoading,
    TResult Function(LoginForgotSent value)? forgotPasswordSent,
    required TResult orElse(),
  }) {
    if (forgotPasswordLoading != null) {
      return forgotPasswordLoading(this);
    }
    return orElse();
  }
}

abstract class LoginForgotLoading implements LoginState {
  const factory LoginForgotLoading() = _$LoginForgotLoadingImpl;
}

/// @nodoc
abstract class _$$LoginForgotSentImplCopyWith<$Res> {
  factory _$$LoginForgotSentImplCopyWith(
    _$LoginForgotSentImpl value,
    $Res Function(_$LoginForgotSentImpl) then,
  ) = __$$LoginForgotSentImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LoginForgotSentImplCopyWithImpl<$Res>
    extends _$LoginStateCopyWithImpl<$Res, _$LoginForgotSentImpl>
    implements _$$LoginForgotSentImplCopyWith<$Res> {
  __$$LoginForgotSentImplCopyWithImpl(
    _$LoginForgotSentImpl _value,
    $Res Function(_$LoginForgotSentImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LoginState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$LoginForgotSentImpl implements LoginForgotSent {
  const _$LoginForgotSentImpl();

  @override
  String toString() {
    return 'LoginState.forgotPasswordSent()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LoginForgotSentImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() loading,
    required TResult Function(String message) error,
    required TResult Function() forgotPasswordIdle,
    required TResult Function() forgotPasswordLoading,
    required TResult Function() forgotPasswordSent,
  }) {
    return forgotPasswordSent();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? loading,
    TResult? Function(String message)? error,
    TResult? Function()? forgotPasswordIdle,
    TResult? Function()? forgotPasswordLoading,
    TResult? Function()? forgotPasswordSent,
  }) {
    return forgotPasswordSent?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? loading,
    TResult Function(String message)? error,
    TResult Function()? forgotPasswordIdle,
    TResult Function()? forgotPasswordLoading,
    TResult Function()? forgotPasswordSent,
    required TResult orElse(),
  }) {
    if (forgotPasswordSent != null) {
      return forgotPasswordSent();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoginIdle value) idle,
    required TResult Function(LoginLoading value) loading,
    required TResult Function(LoginError value) error,
    required TResult Function(LoginForgotIdle value) forgotPasswordIdle,
    required TResult Function(LoginForgotLoading value) forgotPasswordLoading,
    required TResult Function(LoginForgotSent value) forgotPasswordSent,
  }) {
    return forgotPasswordSent(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoginIdle value)? idle,
    TResult? Function(LoginLoading value)? loading,
    TResult? Function(LoginError value)? error,
    TResult? Function(LoginForgotIdle value)? forgotPasswordIdle,
    TResult? Function(LoginForgotLoading value)? forgotPasswordLoading,
    TResult? Function(LoginForgotSent value)? forgotPasswordSent,
  }) {
    return forgotPasswordSent?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoginIdle value)? idle,
    TResult Function(LoginLoading value)? loading,
    TResult Function(LoginError value)? error,
    TResult Function(LoginForgotIdle value)? forgotPasswordIdle,
    TResult Function(LoginForgotLoading value)? forgotPasswordLoading,
    TResult Function(LoginForgotSent value)? forgotPasswordSent,
    required TResult orElse(),
  }) {
    if (forgotPasswordSent != null) {
      return forgotPasswordSent(this);
    }
    return orElse();
  }
}

abstract class LoginForgotSent implements LoginState {
  const factory LoginForgotSent() = _$LoginForgotSentImpl;
}
