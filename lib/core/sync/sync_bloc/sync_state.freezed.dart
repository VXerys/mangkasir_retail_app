// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sync_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$SyncState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function(SyncEntity current) syncing,
    required TResult Function() completed,
    required TResult Function(SyncEntity failedAt, String message) failed,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function(SyncEntity current)? syncing,
    TResult? Function()? completed,
    TResult? Function(SyncEntity failedAt, String message)? failed,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function(SyncEntity current)? syncing,
    TResult Function()? completed,
    TResult Function(SyncEntity failedAt, String message)? failed,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SyncIdle value) idle,
    required TResult Function(Syncing value) syncing,
    required TResult Function(SyncCompleted value) completed,
    required TResult Function(SyncFailed value) failed,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SyncIdle value)? idle,
    TResult? Function(Syncing value)? syncing,
    TResult? Function(SyncCompleted value)? completed,
    TResult? Function(SyncFailed value)? failed,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SyncIdle value)? idle,
    TResult Function(Syncing value)? syncing,
    TResult Function(SyncCompleted value)? completed,
    TResult Function(SyncFailed value)? failed,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SyncStateCopyWith<$Res> {
  factory $SyncStateCopyWith(SyncState value, $Res Function(SyncState) then) =
      _$SyncStateCopyWithImpl<$Res, SyncState>;
}

/// @nodoc
class _$SyncStateCopyWithImpl<$Res, $Val extends SyncState>
    implements $SyncStateCopyWith<$Res> {
  _$SyncStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SyncState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$SyncIdleImplCopyWith<$Res> {
  factory _$$SyncIdleImplCopyWith(
    _$SyncIdleImpl value,
    $Res Function(_$SyncIdleImpl) then,
  ) = __$$SyncIdleImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SyncIdleImplCopyWithImpl<$Res>
    extends _$SyncStateCopyWithImpl<$Res, _$SyncIdleImpl>
    implements _$$SyncIdleImplCopyWith<$Res> {
  __$$SyncIdleImplCopyWithImpl(
    _$SyncIdleImpl _value,
    $Res Function(_$SyncIdleImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SyncState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$SyncIdleImpl implements SyncIdle {
  const _$SyncIdleImpl();

  @override
  String toString() {
    return 'SyncState.idle()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$SyncIdleImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function(SyncEntity current) syncing,
    required TResult Function() completed,
    required TResult Function(SyncEntity failedAt, String message) failed,
  }) {
    return idle();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function(SyncEntity current)? syncing,
    TResult? Function()? completed,
    TResult? Function(SyncEntity failedAt, String message)? failed,
  }) {
    return idle?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function(SyncEntity current)? syncing,
    TResult Function()? completed,
    TResult Function(SyncEntity failedAt, String message)? failed,
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
    required TResult Function(SyncIdle value) idle,
    required TResult Function(Syncing value) syncing,
    required TResult Function(SyncCompleted value) completed,
    required TResult Function(SyncFailed value) failed,
  }) {
    return idle(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SyncIdle value)? idle,
    TResult? Function(Syncing value)? syncing,
    TResult? Function(SyncCompleted value)? completed,
    TResult? Function(SyncFailed value)? failed,
  }) {
    return idle?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SyncIdle value)? idle,
    TResult Function(Syncing value)? syncing,
    TResult Function(SyncCompleted value)? completed,
    TResult Function(SyncFailed value)? failed,
    required TResult orElse(),
  }) {
    if (idle != null) {
      return idle(this);
    }
    return orElse();
  }
}

abstract class SyncIdle implements SyncState {
  const factory SyncIdle() = _$SyncIdleImpl;
}

/// @nodoc
abstract class _$$SyncingImplCopyWith<$Res> {
  factory _$$SyncingImplCopyWith(
    _$SyncingImpl value,
    $Res Function(_$SyncingImpl) then,
  ) = __$$SyncingImplCopyWithImpl<$Res>;
  @useResult
  $Res call({SyncEntity current});
}

/// @nodoc
class __$$SyncingImplCopyWithImpl<$Res>
    extends _$SyncStateCopyWithImpl<$Res, _$SyncingImpl>
    implements _$$SyncingImplCopyWith<$Res> {
  __$$SyncingImplCopyWithImpl(
    _$SyncingImpl _value,
    $Res Function(_$SyncingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SyncState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? current = null}) {
    return _then(
      _$SyncingImpl(
        current: null == current
            ? _value.current
            : current // ignore: cast_nullable_to_non_nullable
                  as SyncEntity,
      ),
    );
  }
}

/// @nodoc

class _$SyncingImpl implements Syncing {
  const _$SyncingImpl({required this.current});

  @override
  final SyncEntity current;

  @override
  String toString() {
    return 'SyncState.syncing(current: $current)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SyncingImpl &&
            (identical(other.current, current) || other.current == current));
  }

  @override
  int get hashCode => Object.hash(runtimeType, current);

  /// Create a copy of SyncState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SyncingImplCopyWith<_$SyncingImpl> get copyWith =>
      __$$SyncingImplCopyWithImpl<_$SyncingImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function(SyncEntity current) syncing,
    required TResult Function() completed,
    required TResult Function(SyncEntity failedAt, String message) failed,
  }) {
    return syncing(current);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function(SyncEntity current)? syncing,
    TResult? Function()? completed,
    TResult? Function(SyncEntity failedAt, String message)? failed,
  }) {
    return syncing?.call(current);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function(SyncEntity current)? syncing,
    TResult Function()? completed,
    TResult Function(SyncEntity failedAt, String message)? failed,
    required TResult orElse(),
  }) {
    if (syncing != null) {
      return syncing(current);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SyncIdle value) idle,
    required TResult Function(Syncing value) syncing,
    required TResult Function(SyncCompleted value) completed,
    required TResult Function(SyncFailed value) failed,
  }) {
    return syncing(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SyncIdle value)? idle,
    TResult? Function(Syncing value)? syncing,
    TResult? Function(SyncCompleted value)? completed,
    TResult? Function(SyncFailed value)? failed,
  }) {
    return syncing?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SyncIdle value)? idle,
    TResult Function(Syncing value)? syncing,
    TResult Function(SyncCompleted value)? completed,
    TResult Function(SyncFailed value)? failed,
    required TResult orElse(),
  }) {
    if (syncing != null) {
      return syncing(this);
    }
    return orElse();
  }
}

abstract class Syncing implements SyncState {
  const factory Syncing({required final SyncEntity current}) = _$SyncingImpl;

  SyncEntity get current;

  /// Create a copy of SyncState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SyncingImplCopyWith<_$SyncingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SyncCompletedImplCopyWith<$Res> {
  factory _$$SyncCompletedImplCopyWith(
    _$SyncCompletedImpl value,
    $Res Function(_$SyncCompletedImpl) then,
  ) = __$$SyncCompletedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SyncCompletedImplCopyWithImpl<$Res>
    extends _$SyncStateCopyWithImpl<$Res, _$SyncCompletedImpl>
    implements _$$SyncCompletedImplCopyWith<$Res> {
  __$$SyncCompletedImplCopyWithImpl(
    _$SyncCompletedImpl _value,
    $Res Function(_$SyncCompletedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SyncState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$SyncCompletedImpl implements SyncCompleted {
  const _$SyncCompletedImpl();

  @override
  String toString() {
    return 'SyncState.completed()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$SyncCompletedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function(SyncEntity current) syncing,
    required TResult Function() completed,
    required TResult Function(SyncEntity failedAt, String message) failed,
  }) {
    return completed();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function(SyncEntity current)? syncing,
    TResult? Function()? completed,
    TResult? Function(SyncEntity failedAt, String message)? failed,
  }) {
    return completed?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function(SyncEntity current)? syncing,
    TResult Function()? completed,
    TResult Function(SyncEntity failedAt, String message)? failed,
    required TResult orElse(),
  }) {
    if (completed != null) {
      return completed();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SyncIdle value) idle,
    required TResult Function(Syncing value) syncing,
    required TResult Function(SyncCompleted value) completed,
    required TResult Function(SyncFailed value) failed,
  }) {
    return completed(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SyncIdle value)? idle,
    TResult? Function(Syncing value)? syncing,
    TResult? Function(SyncCompleted value)? completed,
    TResult? Function(SyncFailed value)? failed,
  }) {
    return completed?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SyncIdle value)? idle,
    TResult Function(Syncing value)? syncing,
    TResult Function(SyncCompleted value)? completed,
    TResult Function(SyncFailed value)? failed,
    required TResult orElse(),
  }) {
    if (completed != null) {
      return completed(this);
    }
    return orElse();
  }
}

abstract class SyncCompleted implements SyncState {
  const factory SyncCompleted() = _$SyncCompletedImpl;
}

/// @nodoc
abstract class _$$SyncFailedImplCopyWith<$Res> {
  factory _$$SyncFailedImplCopyWith(
    _$SyncFailedImpl value,
    $Res Function(_$SyncFailedImpl) then,
  ) = __$$SyncFailedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({SyncEntity failedAt, String message});
}

/// @nodoc
class __$$SyncFailedImplCopyWithImpl<$Res>
    extends _$SyncStateCopyWithImpl<$Res, _$SyncFailedImpl>
    implements _$$SyncFailedImplCopyWith<$Res> {
  __$$SyncFailedImplCopyWithImpl(
    _$SyncFailedImpl _value,
    $Res Function(_$SyncFailedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SyncState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? failedAt = null, Object? message = null}) {
    return _then(
      _$SyncFailedImpl(
        failedAt: null == failedAt
            ? _value.failedAt
            : failedAt // ignore: cast_nullable_to_non_nullable
                  as SyncEntity,
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$SyncFailedImpl implements SyncFailed {
  const _$SyncFailedImpl({required this.failedAt, required this.message});

  @override
  final SyncEntity failedAt;
  @override
  final String message;

  @override
  String toString() {
    return 'SyncState.failed(failedAt: $failedAt, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SyncFailedImpl &&
            (identical(other.failedAt, failedAt) ||
                other.failedAt == failedAt) &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, failedAt, message);

  /// Create a copy of SyncState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SyncFailedImplCopyWith<_$SyncFailedImpl> get copyWith =>
      __$$SyncFailedImplCopyWithImpl<_$SyncFailedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function(SyncEntity current) syncing,
    required TResult Function() completed,
    required TResult Function(SyncEntity failedAt, String message) failed,
  }) {
    return failed(failedAt, message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function(SyncEntity current)? syncing,
    TResult? Function()? completed,
    TResult? Function(SyncEntity failedAt, String message)? failed,
  }) {
    return failed?.call(failedAt, message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function(SyncEntity current)? syncing,
    TResult Function()? completed,
    TResult Function(SyncEntity failedAt, String message)? failed,
    required TResult orElse(),
  }) {
    if (failed != null) {
      return failed(failedAt, message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SyncIdle value) idle,
    required TResult Function(Syncing value) syncing,
    required TResult Function(SyncCompleted value) completed,
    required TResult Function(SyncFailed value) failed,
  }) {
    return failed(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SyncIdle value)? idle,
    TResult? Function(Syncing value)? syncing,
    TResult? Function(SyncCompleted value)? completed,
    TResult? Function(SyncFailed value)? failed,
  }) {
    return failed?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SyncIdle value)? idle,
    TResult Function(Syncing value)? syncing,
    TResult Function(SyncCompleted value)? completed,
    TResult Function(SyncFailed value)? failed,
    required TResult orElse(),
  }) {
    if (failed != null) {
      return failed(this);
    }
    return orElse();
  }
}

abstract class SyncFailed implements SyncState {
  const factory SyncFailed({
    required final SyncEntity failedAt,
    required final String message,
  }) = _$SyncFailedImpl;

  SyncEntity get failedAt;
  String get message;

  /// Create a copy of SyncState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SyncFailedImplCopyWith<_$SyncFailedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
