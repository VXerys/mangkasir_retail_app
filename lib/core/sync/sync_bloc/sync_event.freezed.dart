// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sync_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$SyncEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() requested,
    required TResult Function() triggered,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? requested,
    TResult? Function()? triggered,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? requested,
    TResult Function()? triggered,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SyncRequested value) requested,
    required TResult Function(SyncTriggered value) triggered,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SyncRequested value)? requested,
    TResult? Function(SyncTriggered value)? triggered,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SyncRequested value)? requested,
    TResult Function(SyncTriggered value)? triggered,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SyncEventCopyWith<$Res> {
  factory $SyncEventCopyWith(SyncEvent value, $Res Function(SyncEvent) then) =
      _$SyncEventCopyWithImpl<$Res, SyncEvent>;
}

/// @nodoc
class _$SyncEventCopyWithImpl<$Res, $Val extends SyncEvent>
    implements $SyncEventCopyWith<$Res> {
  _$SyncEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SyncEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$SyncRequestedImplCopyWith<$Res> {
  factory _$$SyncRequestedImplCopyWith(
    _$SyncRequestedImpl value,
    $Res Function(_$SyncRequestedImpl) then,
  ) = __$$SyncRequestedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SyncRequestedImplCopyWithImpl<$Res>
    extends _$SyncEventCopyWithImpl<$Res, _$SyncRequestedImpl>
    implements _$$SyncRequestedImplCopyWith<$Res> {
  __$$SyncRequestedImplCopyWithImpl(
    _$SyncRequestedImpl _value,
    $Res Function(_$SyncRequestedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SyncEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$SyncRequestedImpl implements SyncRequested {
  const _$SyncRequestedImpl();

  @override
  String toString() {
    return 'SyncEvent.requested()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$SyncRequestedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() requested,
    required TResult Function() triggered,
  }) {
    return requested();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? requested,
    TResult? Function()? triggered,
  }) {
    return requested?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? requested,
    TResult Function()? triggered,
    required TResult orElse(),
  }) {
    if (requested != null) {
      return requested();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SyncRequested value) requested,
    required TResult Function(SyncTriggered value) triggered,
  }) {
    return requested(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SyncRequested value)? requested,
    TResult? Function(SyncTriggered value)? triggered,
  }) {
    return requested?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SyncRequested value)? requested,
    TResult Function(SyncTriggered value)? triggered,
    required TResult orElse(),
  }) {
    if (requested != null) {
      return requested(this);
    }
    return orElse();
  }
}

abstract class SyncRequested implements SyncEvent {
  const factory SyncRequested() = _$SyncRequestedImpl;
}

/// @nodoc
abstract class _$$SyncTriggeredImplCopyWith<$Res> {
  factory _$$SyncTriggeredImplCopyWith(
    _$SyncTriggeredImpl value,
    $Res Function(_$SyncTriggeredImpl) then,
  ) = __$$SyncTriggeredImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SyncTriggeredImplCopyWithImpl<$Res>
    extends _$SyncEventCopyWithImpl<$Res, _$SyncTriggeredImpl>
    implements _$$SyncTriggeredImplCopyWith<$Res> {
  __$$SyncTriggeredImplCopyWithImpl(
    _$SyncTriggeredImpl _value,
    $Res Function(_$SyncTriggeredImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SyncEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$SyncTriggeredImpl implements SyncTriggered {
  const _$SyncTriggeredImpl();

  @override
  String toString() {
    return 'SyncEvent.triggered()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$SyncTriggeredImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() requested,
    required TResult Function() triggered,
  }) {
    return triggered();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? requested,
    TResult? Function()? triggered,
  }) {
    return triggered?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? requested,
    TResult Function()? triggered,
    required TResult orElse(),
  }) {
    if (triggered != null) {
      return triggered();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SyncRequested value) requested,
    required TResult Function(SyncTriggered value) triggered,
  }) {
    return triggered(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SyncRequested value)? requested,
    TResult? Function(SyncTriggered value)? triggered,
  }) {
    return triggered?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SyncRequested value)? requested,
    TResult Function(SyncTriggered value)? triggered,
    required TResult orElse(),
  }) {
    if (triggered != null) {
      return triggered(this);
    }
    return orElse();
  }
}

abstract class SyncTriggered implements SyncEvent {
  const factory SyncTriggered() = _$SyncTriggeredImpl;
}
