// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'category_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$CategoryEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() watchStarted,
    required TResult Function(Category category) added,
    required TResult Function(Category category) updated,
    required TResult Function(String id) archived,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? watchStarted,
    TResult? Function(Category category)? added,
    TResult? Function(Category category)? updated,
    TResult? Function(String id)? archived,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? watchStarted,
    TResult Function(Category category)? added,
    TResult Function(Category category)? updated,
    TResult Function(String id)? archived,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CategoryWatchStarted value) watchStarted,
    required TResult Function(CategoryAdded value) added,
    required TResult Function(CategoryUpdated value) updated,
    required TResult Function(CategoryArchived value) archived,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CategoryWatchStarted value)? watchStarted,
    TResult? Function(CategoryAdded value)? added,
    TResult? Function(CategoryUpdated value)? updated,
    TResult? Function(CategoryArchived value)? archived,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CategoryWatchStarted value)? watchStarted,
    TResult Function(CategoryAdded value)? added,
    TResult Function(CategoryUpdated value)? updated,
    TResult Function(CategoryArchived value)? archived,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CategoryEventCopyWith<$Res> {
  factory $CategoryEventCopyWith(
    CategoryEvent value,
    $Res Function(CategoryEvent) then,
  ) = _$CategoryEventCopyWithImpl<$Res, CategoryEvent>;
}

/// @nodoc
class _$CategoryEventCopyWithImpl<$Res, $Val extends CategoryEvent>
    implements $CategoryEventCopyWith<$Res> {
  _$CategoryEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CategoryEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$CategoryWatchStartedImplCopyWith<$Res> {
  factory _$$CategoryWatchStartedImplCopyWith(
    _$CategoryWatchStartedImpl value,
    $Res Function(_$CategoryWatchStartedImpl) then,
  ) = __$$CategoryWatchStartedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$CategoryWatchStartedImplCopyWithImpl<$Res>
    extends _$CategoryEventCopyWithImpl<$Res, _$CategoryWatchStartedImpl>
    implements _$$CategoryWatchStartedImplCopyWith<$Res> {
  __$$CategoryWatchStartedImplCopyWithImpl(
    _$CategoryWatchStartedImpl _value,
    $Res Function(_$CategoryWatchStartedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CategoryEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$CategoryWatchStartedImpl implements CategoryWatchStarted {
  const _$CategoryWatchStartedImpl();

  @override
  String toString() {
    return 'CategoryEvent.watchStarted()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CategoryWatchStartedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() watchStarted,
    required TResult Function(Category category) added,
    required TResult Function(Category category) updated,
    required TResult Function(String id) archived,
  }) {
    return watchStarted();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? watchStarted,
    TResult? Function(Category category)? added,
    TResult? Function(Category category)? updated,
    TResult? Function(String id)? archived,
  }) {
    return watchStarted?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? watchStarted,
    TResult Function(Category category)? added,
    TResult Function(Category category)? updated,
    TResult Function(String id)? archived,
    required TResult orElse(),
  }) {
    if (watchStarted != null) {
      return watchStarted();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CategoryWatchStarted value) watchStarted,
    required TResult Function(CategoryAdded value) added,
    required TResult Function(CategoryUpdated value) updated,
    required TResult Function(CategoryArchived value) archived,
  }) {
    return watchStarted(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CategoryWatchStarted value)? watchStarted,
    TResult? Function(CategoryAdded value)? added,
    TResult? Function(CategoryUpdated value)? updated,
    TResult? Function(CategoryArchived value)? archived,
  }) {
    return watchStarted?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CategoryWatchStarted value)? watchStarted,
    TResult Function(CategoryAdded value)? added,
    TResult Function(CategoryUpdated value)? updated,
    TResult Function(CategoryArchived value)? archived,
    required TResult orElse(),
  }) {
    if (watchStarted != null) {
      return watchStarted(this);
    }
    return orElse();
  }
}

abstract class CategoryWatchStarted implements CategoryEvent {
  const factory CategoryWatchStarted() = _$CategoryWatchStartedImpl;
}

/// @nodoc
abstract class _$$CategoryAddedImplCopyWith<$Res> {
  factory _$$CategoryAddedImplCopyWith(
    _$CategoryAddedImpl value,
    $Res Function(_$CategoryAddedImpl) then,
  ) = __$$CategoryAddedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Category category});

  $CategoryCopyWith<$Res> get category;
}

/// @nodoc
class __$$CategoryAddedImplCopyWithImpl<$Res>
    extends _$CategoryEventCopyWithImpl<$Res, _$CategoryAddedImpl>
    implements _$$CategoryAddedImplCopyWith<$Res> {
  __$$CategoryAddedImplCopyWithImpl(
    _$CategoryAddedImpl _value,
    $Res Function(_$CategoryAddedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CategoryEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? category = null}) {
    return _then(
      _$CategoryAddedImpl(
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as Category,
      ),
    );
  }

  /// Create a copy of CategoryEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CategoryCopyWith<$Res> get category {
    return $CategoryCopyWith<$Res>(_value.category, (value) {
      return _then(_value.copyWith(category: value));
    });
  }
}

/// @nodoc

class _$CategoryAddedImpl implements CategoryAdded {
  const _$CategoryAddedImpl({required this.category});

  @override
  final Category category;

  @override
  String toString() {
    return 'CategoryEvent.added(category: $category)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CategoryAddedImpl &&
            (identical(other.category, category) ||
                other.category == category));
  }

  @override
  int get hashCode => Object.hash(runtimeType, category);

  /// Create a copy of CategoryEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CategoryAddedImplCopyWith<_$CategoryAddedImpl> get copyWith =>
      __$$CategoryAddedImplCopyWithImpl<_$CategoryAddedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() watchStarted,
    required TResult Function(Category category) added,
    required TResult Function(Category category) updated,
    required TResult Function(String id) archived,
  }) {
    return added(category);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? watchStarted,
    TResult? Function(Category category)? added,
    TResult? Function(Category category)? updated,
    TResult? Function(String id)? archived,
  }) {
    return added?.call(category);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? watchStarted,
    TResult Function(Category category)? added,
    TResult Function(Category category)? updated,
    TResult Function(String id)? archived,
    required TResult orElse(),
  }) {
    if (added != null) {
      return added(category);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CategoryWatchStarted value) watchStarted,
    required TResult Function(CategoryAdded value) added,
    required TResult Function(CategoryUpdated value) updated,
    required TResult Function(CategoryArchived value) archived,
  }) {
    return added(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CategoryWatchStarted value)? watchStarted,
    TResult? Function(CategoryAdded value)? added,
    TResult? Function(CategoryUpdated value)? updated,
    TResult? Function(CategoryArchived value)? archived,
  }) {
    return added?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CategoryWatchStarted value)? watchStarted,
    TResult Function(CategoryAdded value)? added,
    TResult Function(CategoryUpdated value)? updated,
    TResult Function(CategoryArchived value)? archived,
    required TResult orElse(),
  }) {
    if (added != null) {
      return added(this);
    }
    return orElse();
  }
}

abstract class CategoryAdded implements CategoryEvent {
  const factory CategoryAdded({required final Category category}) =
      _$CategoryAddedImpl;

  Category get category;

  /// Create a copy of CategoryEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CategoryAddedImplCopyWith<_$CategoryAddedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CategoryUpdatedImplCopyWith<$Res> {
  factory _$$CategoryUpdatedImplCopyWith(
    _$CategoryUpdatedImpl value,
    $Res Function(_$CategoryUpdatedImpl) then,
  ) = __$$CategoryUpdatedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Category category});

  $CategoryCopyWith<$Res> get category;
}

/// @nodoc
class __$$CategoryUpdatedImplCopyWithImpl<$Res>
    extends _$CategoryEventCopyWithImpl<$Res, _$CategoryUpdatedImpl>
    implements _$$CategoryUpdatedImplCopyWith<$Res> {
  __$$CategoryUpdatedImplCopyWithImpl(
    _$CategoryUpdatedImpl _value,
    $Res Function(_$CategoryUpdatedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CategoryEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? category = null}) {
    return _then(
      _$CategoryUpdatedImpl(
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as Category,
      ),
    );
  }

  /// Create a copy of CategoryEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CategoryCopyWith<$Res> get category {
    return $CategoryCopyWith<$Res>(_value.category, (value) {
      return _then(_value.copyWith(category: value));
    });
  }
}

/// @nodoc

class _$CategoryUpdatedImpl implements CategoryUpdated {
  const _$CategoryUpdatedImpl({required this.category});

  @override
  final Category category;

  @override
  String toString() {
    return 'CategoryEvent.updated(category: $category)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CategoryUpdatedImpl &&
            (identical(other.category, category) ||
                other.category == category));
  }

  @override
  int get hashCode => Object.hash(runtimeType, category);

  /// Create a copy of CategoryEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CategoryUpdatedImplCopyWith<_$CategoryUpdatedImpl> get copyWith =>
      __$$CategoryUpdatedImplCopyWithImpl<_$CategoryUpdatedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() watchStarted,
    required TResult Function(Category category) added,
    required TResult Function(Category category) updated,
    required TResult Function(String id) archived,
  }) {
    return updated(category);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? watchStarted,
    TResult? Function(Category category)? added,
    TResult? Function(Category category)? updated,
    TResult? Function(String id)? archived,
  }) {
    return updated?.call(category);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? watchStarted,
    TResult Function(Category category)? added,
    TResult Function(Category category)? updated,
    TResult Function(String id)? archived,
    required TResult orElse(),
  }) {
    if (updated != null) {
      return updated(category);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CategoryWatchStarted value) watchStarted,
    required TResult Function(CategoryAdded value) added,
    required TResult Function(CategoryUpdated value) updated,
    required TResult Function(CategoryArchived value) archived,
  }) {
    return updated(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CategoryWatchStarted value)? watchStarted,
    TResult? Function(CategoryAdded value)? added,
    TResult? Function(CategoryUpdated value)? updated,
    TResult? Function(CategoryArchived value)? archived,
  }) {
    return updated?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CategoryWatchStarted value)? watchStarted,
    TResult Function(CategoryAdded value)? added,
    TResult Function(CategoryUpdated value)? updated,
    TResult Function(CategoryArchived value)? archived,
    required TResult orElse(),
  }) {
    if (updated != null) {
      return updated(this);
    }
    return orElse();
  }
}

abstract class CategoryUpdated implements CategoryEvent {
  const factory CategoryUpdated({required final Category category}) =
      _$CategoryUpdatedImpl;

  Category get category;

  /// Create a copy of CategoryEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CategoryUpdatedImplCopyWith<_$CategoryUpdatedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CategoryArchivedImplCopyWith<$Res> {
  factory _$$CategoryArchivedImplCopyWith(
    _$CategoryArchivedImpl value,
    $Res Function(_$CategoryArchivedImpl) then,
  ) = __$$CategoryArchivedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String id});
}

/// @nodoc
class __$$CategoryArchivedImplCopyWithImpl<$Res>
    extends _$CategoryEventCopyWithImpl<$Res, _$CategoryArchivedImpl>
    implements _$$CategoryArchivedImplCopyWith<$Res> {
  __$$CategoryArchivedImplCopyWithImpl(
    _$CategoryArchivedImpl _value,
    $Res Function(_$CategoryArchivedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CategoryEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null}) {
    return _then(
      _$CategoryArchivedImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$CategoryArchivedImpl implements CategoryArchived {
  const _$CategoryArchivedImpl({required this.id});

  @override
  final String id;

  @override
  String toString() {
    return 'CategoryEvent.archived(id: $id)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CategoryArchivedImpl &&
            (identical(other.id, id) || other.id == id));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id);

  /// Create a copy of CategoryEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CategoryArchivedImplCopyWith<_$CategoryArchivedImpl> get copyWith =>
      __$$CategoryArchivedImplCopyWithImpl<_$CategoryArchivedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() watchStarted,
    required TResult Function(Category category) added,
    required TResult Function(Category category) updated,
    required TResult Function(String id) archived,
  }) {
    return archived(id);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? watchStarted,
    TResult? Function(Category category)? added,
    TResult? Function(Category category)? updated,
    TResult? Function(String id)? archived,
  }) {
    return archived?.call(id);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? watchStarted,
    TResult Function(Category category)? added,
    TResult Function(Category category)? updated,
    TResult Function(String id)? archived,
    required TResult orElse(),
  }) {
    if (archived != null) {
      return archived(id);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CategoryWatchStarted value) watchStarted,
    required TResult Function(CategoryAdded value) added,
    required TResult Function(CategoryUpdated value) updated,
    required TResult Function(CategoryArchived value) archived,
  }) {
    return archived(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CategoryWatchStarted value)? watchStarted,
    TResult? Function(CategoryAdded value)? added,
    TResult? Function(CategoryUpdated value)? updated,
    TResult? Function(CategoryArchived value)? archived,
  }) {
    return archived?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CategoryWatchStarted value)? watchStarted,
    TResult Function(CategoryAdded value)? added,
    TResult Function(CategoryUpdated value)? updated,
    TResult Function(CategoryArchived value)? archived,
    required TResult orElse(),
  }) {
    if (archived != null) {
      return archived(this);
    }
    return orElse();
  }
}

abstract class CategoryArchived implements CategoryEvent {
  const factory CategoryArchived({required final String id}) =
      _$CategoryArchivedImpl;

  String get id;

  /// Create a copy of CategoryEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CategoryArchivedImplCopyWith<_$CategoryArchivedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
