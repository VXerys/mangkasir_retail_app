// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$SessionState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() unknown,
    required TResult Function() signedOut,
    required TResult Function(AppSession session) active,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? unknown,
    TResult? Function()? signedOut,
    TResult? Function(AppSession session)? active,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? unknown,
    TResult Function()? signedOut,
    TResult Function(AppSession session)? active,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SessionUnknown value) unknown,
    required TResult Function(SessionSignedOut value) signedOut,
    required TResult Function(SessionActive value) active,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SessionUnknown value)? unknown,
    TResult? Function(SessionSignedOut value)? signedOut,
    TResult? Function(SessionActive value)? active,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SessionUnknown value)? unknown,
    TResult Function(SessionSignedOut value)? signedOut,
    TResult Function(SessionActive value)? active,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SessionStateCopyWith<$Res> {
  factory $SessionStateCopyWith(
    SessionState value,
    $Res Function(SessionState) then,
  ) = _$SessionStateCopyWithImpl<$Res, SessionState>;
}

/// @nodoc
class _$SessionStateCopyWithImpl<$Res, $Val extends SessionState>
    implements $SessionStateCopyWith<$Res> {
  _$SessionStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SessionState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$SessionUnknownImplCopyWith<$Res> {
  factory _$$SessionUnknownImplCopyWith(
    _$SessionUnknownImpl value,
    $Res Function(_$SessionUnknownImpl) then,
  ) = __$$SessionUnknownImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SessionUnknownImplCopyWithImpl<$Res>
    extends _$SessionStateCopyWithImpl<$Res, _$SessionUnknownImpl>
    implements _$$SessionUnknownImplCopyWith<$Res> {
  __$$SessionUnknownImplCopyWithImpl(
    _$SessionUnknownImpl _value,
    $Res Function(_$SessionUnknownImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SessionState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$SessionUnknownImpl implements SessionUnknown {
  const _$SessionUnknownImpl();

  @override
  String toString() {
    return 'SessionState.unknown()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$SessionUnknownImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() unknown,
    required TResult Function() signedOut,
    required TResult Function(AppSession session) active,
  }) {
    return unknown();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? unknown,
    TResult? Function()? signedOut,
    TResult? Function(AppSession session)? active,
  }) {
    return unknown?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? unknown,
    TResult Function()? signedOut,
    TResult Function(AppSession session)? active,
    required TResult orElse(),
  }) {
    if (unknown != null) {
      return unknown();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SessionUnknown value) unknown,
    required TResult Function(SessionSignedOut value) signedOut,
    required TResult Function(SessionActive value) active,
  }) {
    return unknown(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SessionUnknown value)? unknown,
    TResult? Function(SessionSignedOut value)? signedOut,
    TResult? Function(SessionActive value)? active,
  }) {
    return unknown?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SessionUnknown value)? unknown,
    TResult Function(SessionSignedOut value)? signedOut,
    TResult Function(SessionActive value)? active,
    required TResult orElse(),
  }) {
    if (unknown != null) {
      return unknown(this);
    }
    return orElse();
  }
}

abstract class SessionUnknown implements SessionState {
  const factory SessionUnknown() = _$SessionUnknownImpl;
}

/// @nodoc
abstract class _$$SessionSignedOutImplCopyWith<$Res> {
  factory _$$SessionSignedOutImplCopyWith(
    _$SessionSignedOutImpl value,
    $Res Function(_$SessionSignedOutImpl) then,
  ) = __$$SessionSignedOutImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SessionSignedOutImplCopyWithImpl<$Res>
    extends _$SessionStateCopyWithImpl<$Res, _$SessionSignedOutImpl>
    implements _$$SessionSignedOutImplCopyWith<$Res> {
  __$$SessionSignedOutImplCopyWithImpl(
    _$SessionSignedOutImpl _value,
    $Res Function(_$SessionSignedOutImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SessionState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$SessionSignedOutImpl implements SessionSignedOut {
  const _$SessionSignedOutImpl();

  @override
  String toString() {
    return 'SessionState.signedOut()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$SessionSignedOutImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() unknown,
    required TResult Function() signedOut,
    required TResult Function(AppSession session) active,
  }) {
    return signedOut();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? unknown,
    TResult? Function()? signedOut,
    TResult? Function(AppSession session)? active,
  }) {
    return signedOut?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? unknown,
    TResult Function()? signedOut,
    TResult Function(AppSession session)? active,
    required TResult orElse(),
  }) {
    if (signedOut != null) {
      return signedOut();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SessionUnknown value) unknown,
    required TResult Function(SessionSignedOut value) signedOut,
    required TResult Function(SessionActive value) active,
  }) {
    return signedOut(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SessionUnknown value)? unknown,
    TResult? Function(SessionSignedOut value)? signedOut,
    TResult? Function(SessionActive value)? active,
  }) {
    return signedOut?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SessionUnknown value)? unknown,
    TResult Function(SessionSignedOut value)? signedOut,
    TResult Function(SessionActive value)? active,
    required TResult orElse(),
  }) {
    if (signedOut != null) {
      return signedOut(this);
    }
    return orElse();
  }
}

abstract class SessionSignedOut implements SessionState {
  const factory SessionSignedOut() = _$SessionSignedOutImpl;
}

/// @nodoc
abstract class _$$SessionActiveImplCopyWith<$Res> {
  factory _$$SessionActiveImplCopyWith(
    _$SessionActiveImpl value,
    $Res Function(_$SessionActiveImpl) then,
  ) = __$$SessionActiveImplCopyWithImpl<$Res>;
  @useResult
  $Res call({AppSession session});

  $AppSessionCopyWith<$Res> get session;
}

/// @nodoc
class __$$SessionActiveImplCopyWithImpl<$Res>
    extends _$SessionStateCopyWithImpl<$Res, _$SessionActiveImpl>
    implements _$$SessionActiveImplCopyWith<$Res> {
  __$$SessionActiveImplCopyWithImpl(
    _$SessionActiveImpl _value,
    $Res Function(_$SessionActiveImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SessionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? session = null}) {
    return _then(
      _$SessionActiveImpl(
        null == session
            ? _value.session
            : session // ignore: cast_nullable_to_non_nullable
                  as AppSession,
      ),
    );
  }

  /// Create a copy of SessionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AppSessionCopyWith<$Res> get session {
    return $AppSessionCopyWith<$Res>(_value.session, (value) {
      return _then(_value.copyWith(session: value));
    });
  }
}

/// @nodoc

class _$SessionActiveImpl implements SessionActive {
  const _$SessionActiveImpl(this.session);

  @override
  final AppSession session;

  @override
  String toString() {
    return 'SessionState.active(session: $session)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SessionActiveImpl &&
            (identical(other.session, session) || other.session == session));
  }

  @override
  int get hashCode => Object.hash(runtimeType, session);

  /// Create a copy of SessionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SessionActiveImplCopyWith<_$SessionActiveImpl> get copyWith =>
      __$$SessionActiveImplCopyWithImpl<_$SessionActiveImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() unknown,
    required TResult Function() signedOut,
    required TResult Function(AppSession session) active,
  }) {
    return active(session);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? unknown,
    TResult? Function()? signedOut,
    TResult? Function(AppSession session)? active,
  }) {
    return active?.call(session);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? unknown,
    TResult Function()? signedOut,
    TResult Function(AppSession session)? active,
    required TResult orElse(),
  }) {
    if (active != null) {
      return active(session);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SessionUnknown value) unknown,
    required TResult Function(SessionSignedOut value) signedOut,
    required TResult Function(SessionActive value) active,
  }) {
    return active(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SessionUnknown value)? unknown,
    TResult? Function(SessionSignedOut value)? signedOut,
    TResult? Function(SessionActive value)? active,
  }) {
    return active?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SessionUnknown value)? unknown,
    TResult Function(SessionSignedOut value)? signedOut,
    TResult Function(SessionActive value)? active,
    required TResult orElse(),
  }) {
    if (active != null) {
      return active(this);
    }
    return orElse();
  }
}

abstract class SessionActive implements SessionState {
  const factory SessionActive(final AppSession session) = _$SessionActiveImpl;

  AppSession get session;

  /// Create a copy of SessionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SessionActiveImplCopyWith<_$SessionActiveImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
