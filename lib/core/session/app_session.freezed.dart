// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$SessionUser {
  int get id => throw _privateConstructorUsedError;
  String get uuid => throw _privateConstructorUsedError;
  String get username => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;

  /// Create a copy of SessionUser
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SessionUserCopyWith<SessionUser> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SessionUserCopyWith<$Res> {
  factory $SessionUserCopyWith(
    SessionUser value,
    $Res Function(SessionUser) then,
  ) = _$SessionUserCopyWithImpl<$Res, SessionUser>;
  @useResult
  $Res call({int id, String uuid, String username, String email});
}

/// @nodoc
class _$SessionUserCopyWithImpl<$Res, $Val extends SessionUser>
    implements $SessionUserCopyWith<$Res> {
  _$SessionUserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SessionUser
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? uuid = null,
    Object? username = null,
    Object? email = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            uuid: null == uuid
                ? _value.uuid
                : uuid // ignore: cast_nullable_to_non_nullable
                      as String,
            username: null == username
                ? _value.username
                : username // ignore: cast_nullable_to_non_nullable
                      as String,
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SessionUserImplCopyWith<$Res>
    implements $SessionUserCopyWith<$Res> {
  factory _$$SessionUserImplCopyWith(
    _$SessionUserImpl value,
    $Res Function(_$SessionUserImpl) then,
  ) = __$$SessionUserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String uuid, String username, String email});
}

/// @nodoc
class __$$SessionUserImplCopyWithImpl<$Res>
    extends _$SessionUserCopyWithImpl<$Res, _$SessionUserImpl>
    implements _$$SessionUserImplCopyWith<$Res> {
  __$$SessionUserImplCopyWithImpl(
    _$SessionUserImpl _value,
    $Res Function(_$SessionUserImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SessionUser
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? uuid = null,
    Object? username = null,
    Object? email = null,
  }) {
    return _then(
      _$SessionUserImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        uuid: null == uuid
            ? _value.uuid
            : uuid // ignore: cast_nullable_to_non_nullable
                  as String,
        username: null == username
            ? _value.username
            : username // ignore: cast_nullable_to_non_nullable
                  as String,
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$SessionUserImpl implements _SessionUser {
  const _$SessionUserImpl({
    required this.id,
    required this.uuid,
    required this.username,
    required this.email,
  });

  @override
  final int id;
  @override
  final String uuid;
  @override
  final String username;
  @override
  final String email;

  @override
  String toString() {
    return 'SessionUser(id: $id, uuid: $uuid, username: $username, email: $email)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SessionUserImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.uuid, uuid) || other.uuid == uuid) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.email, email) || other.email == email));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, uuid, username, email);

  /// Create a copy of SessionUser
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SessionUserImplCopyWith<_$SessionUserImpl> get copyWith =>
      __$$SessionUserImplCopyWithImpl<_$SessionUserImpl>(this, _$identity);
}

abstract class _SessionUser implements SessionUser {
  const factory _SessionUser({
    required final int id,
    required final String uuid,
    required final String username,
    required final String email,
  }) = _$SessionUserImpl;

  @override
  int get id;
  @override
  String get uuid;
  @override
  String get username;
  @override
  String get email;

  /// Create a copy of SessionUser
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SessionUserImplCopyWith<_$SessionUserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$SessionBusiness {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;

  /// Create a copy of SessionBusiness
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SessionBusinessCopyWith<SessionBusiness> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SessionBusinessCopyWith<$Res> {
  factory $SessionBusinessCopyWith(
    SessionBusiness value,
    $Res Function(SessionBusiness) then,
  ) = _$SessionBusinessCopyWithImpl<$Res, SessionBusiness>;
  @useResult
  $Res call({int id, String name});
}

/// @nodoc
class _$SessionBusinessCopyWithImpl<$Res, $Val extends SessionBusiness>
    implements $SessionBusinessCopyWith<$Res> {
  _$SessionBusinessCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SessionBusiness
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? name = null}) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SessionBusinessImplCopyWith<$Res>
    implements $SessionBusinessCopyWith<$Res> {
  factory _$$SessionBusinessImplCopyWith(
    _$SessionBusinessImpl value,
    $Res Function(_$SessionBusinessImpl) then,
  ) = __$$SessionBusinessImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String name});
}

/// @nodoc
class __$$SessionBusinessImplCopyWithImpl<$Res>
    extends _$SessionBusinessCopyWithImpl<$Res, _$SessionBusinessImpl>
    implements _$$SessionBusinessImplCopyWith<$Res> {
  __$$SessionBusinessImplCopyWithImpl(
    _$SessionBusinessImpl _value,
    $Res Function(_$SessionBusinessImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SessionBusiness
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? name = null}) {
    return _then(
      _$SessionBusinessImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$SessionBusinessImpl implements _SessionBusiness {
  const _$SessionBusinessImpl({required this.id, required this.name});

  @override
  final int id;
  @override
  final String name;

  @override
  String toString() {
    return 'SessionBusiness(id: $id, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SessionBusinessImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, name);

  /// Create a copy of SessionBusiness
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SessionBusinessImplCopyWith<_$SessionBusinessImpl> get copyWith =>
      __$$SessionBusinessImplCopyWithImpl<_$SessionBusinessImpl>(
        this,
        _$identity,
      );
}

abstract class _SessionBusiness implements SessionBusiness {
  const factory _SessionBusiness({
    required final int id,
    required final String name,
  }) = _$SessionBusinessImpl;

  @override
  int get id;
  @override
  String get name;

  /// Create a copy of SessionBusiness
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SessionBusinessImplCopyWith<_$SessionBusinessImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$SessionOutlet {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;

  /// Create a copy of SessionOutlet
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SessionOutletCopyWith<SessionOutlet> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SessionOutletCopyWith<$Res> {
  factory $SessionOutletCopyWith(
    SessionOutlet value,
    $Res Function(SessionOutlet) then,
  ) = _$SessionOutletCopyWithImpl<$Res, SessionOutlet>;
  @useResult
  $Res call({int id, String name});
}

/// @nodoc
class _$SessionOutletCopyWithImpl<$Res, $Val extends SessionOutlet>
    implements $SessionOutletCopyWith<$Res> {
  _$SessionOutletCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SessionOutlet
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? name = null}) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SessionOutletImplCopyWith<$Res>
    implements $SessionOutletCopyWith<$Res> {
  factory _$$SessionOutletImplCopyWith(
    _$SessionOutletImpl value,
    $Res Function(_$SessionOutletImpl) then,
  ) = __$$SessionOutletImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String name});
}

/// @nodoc
class __$$SessionOutletImplCopyWithImpl<$Res>
    extends _$SessionOutletCopyWithImpl<$Res, _$SessionOutletImpl>
    implements _$$SessionOutletImplCopyWith<$Res> {
  __$$SessionOutletImplCopyWithImpl(
    _$SessionOutletImpl _value,
    $Res Function(_$SessionOutletImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SessionOutlet
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? name = null}) {
    return _then(
      _$SessionOutletImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$SessionOutletImpl implements _SessionOutlet {
  const _$SessionOutletImpl({required this.id, required this.name});

  @override
  final int id;
  @override
  final String name;

  @override
  String toString() {
    return 'SessionOutlet(id: $id, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SessionOutletImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, name);

  /// Create a copy of SessionOutlet
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SessionOutletImplCopyWith<_$SessionOutletImpl> get copyWith =>
      __$$SessionOutletImplCopyWithImpl<_$SessionOutletImpl>(this, _$identity);
}

abstract class _SessionOutlet implements SessionOutlet {
  const factory _SessionOutlet({
    required final int id,
    required final String name,
  }) = _$SessionOutletImpl;

  @override
  int get id;
  @override
  String get name;

  /// Create a copy of SessionOutlet
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SessionOutletImplCopyWith<_$SessionOutletImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$AppSession {
  SessionUser get user => throw _privateConstructorUsedError;
  SessionBusiness get business => throw _privateConstructorUsedError;
  List<SessionOutlet> get outlets => throw _privateConstructorUsedError;
  SessionOutlet? get activeOutlet => throw _privateConstructorUsedError;
  Set<String> get roleNames => throw _privateConstructorUsedError;
  Set<String> get permissions => throw _privateConstructorUsedError;

  /// Create a copy of AppSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppSessionCopyWith<AppSession> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppSessionCopyWith<$Res> {
  factory $AppSessionCopyWith(
    AppSession value,
    $Res Function(AppSession) then,
  ) = _$AppSessionCopyWithImpl<$Res, AppSession>;
  @useResult
  $Res call({
    SessionUser user,
    SessionBusiness business,
    List<SessionOutlet> outlets,
    SessionOutlet? activeOutlet,
    Set<String> roleNames,
    Set<String> permissions,
  });

  $SessionUserCopyWith<$Res> get user;
  $SessionBusinessCopyWith<$Res> get business;
  $SessionOutletCopyWith<$Res>? get activeOutlet;
}

/// @nodoc
class _$AppSessionCopyWithImpl<$Res, $Val extends AppSession>
    implements $AppSessionCopyWith<$Res> {
  _$AppSessionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = null,
    Object? business = null,
    Object? outlets = null,
    Object? activeOutlet = freezed,
    Object? roleNames = null,
    Object? permissions = null,
  }) {
    return _then(
      _value.copyWith(
            user: null == user
                ? _value.user
                : user // ignore: cast_nullable_to_non_nullable
                      as SessionUser,
            business: null == business
                ? _value.business
                : business // ignore: cast_nullable_to_non_nullable
                      as SessionBusiness,
            outlets: null == outlets
                ? _value.outlets
                : outlets // ignore: cast_nullable_to_non_nullable
                      as List<SessionOutlet>,
            activeOutlet: freezed == activeOutlet
                ? _value.activeOutlet
                : activeOutlet // ignore: cast_nullable_to_non_nullable
                      as SessionOutlet?,
            roleNames: null == roleNames
                ? _value.roleNames
                : roleNames // ignore: cast_nullable_to_non_nullable
                      as Set<String>,
            permissions: null == permissions
                ? _value.permissions
                : permissions // ignore: cast_nullable_to_non_nullable
                      as Set<String>,
          )
          as $Val,
    );
  }

  /// Create a copy of AppSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SessionUserCopyWith<$Res> get user {
    return $SessionUserCopyWith<$Res>(_value.user, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }

  /// Create a copy of AppSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SessionBusinessCopyWith<$Res> get business {
    return $SessionBusinessCopyWith<$Res>(_value.business, (value) {
      return _then(_value.copyWith(business: value) as $Val);
    });
  }

  /// Create a copy of AppSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SessionOutletCopyWith<$Res>? get activeOutlet {
    if (_value.activeOutlet == null) {
      return null;
    }

    return $SessionOutletCopyWith<$Res>(_value.activeOutlet!, (value) {
      return _then(_value.copyWith(activeOutlet: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AppSessionImplCopyWith<$Res>
    implements $AppSessionCopyWith<$Res> {
  factory _$$AppSessionImplCopyWith(
    _$AppSessionImpl value,
    $Res Function(_$AppSessionImpl) then,
  ) = __$$AppSessionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    SessionUser user,
    SessionBusiness business,
    List<SessionOutlet> outlets,
    SessionOutlet? activeOutlet,
    Set<String> roleNames,
    Set<String> permissions,
  });

  @override
  $SessionUserCopyWith<$Res> get user;
  @override
  $SessionBusinessCopyWith<$Res> get business;
  @override
  $SessionOutletCopyWith<$Res>? get activeOutlet;
}

/// @nodoc
class __$$AppSessionImplCopyWithImpl<$Res>
    extends _$AppSessionCopyWithImpl<$Res, _$AppSessionImpl>
    implements _$$AppSessionImplCopyWith<$Res> {
  __$$AppSessionImplCopyWithImpl(
    _$AppSessionImpl _value,
    $Res Function(_$AppSessionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AppSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = null,
    Object? business = null,
    Object? outlets = null,
    Object? activeOutlet = freezed,
    Object? roleNames = null,
    Object? permissions = null,
  }) {
    return _then(
      _$AppSessionImpl(
        user: null == user
            ? _value.user
            : user // ignore: cast_nullable_to_non_nullable
                  as SessionUser,
        business: null == business
            ? _value.business
            : business // ignore: cast_nullable_to_non_nullable
                  as SessionBusiness,
        outlets: null == outlets
            ? _value._outlets
            : outlets // ignore: cast_nullable_to_non_nullable
                  as List<SessionOutlet>,
        activeOutlet: freezed == activeOutlet
            ? _value.activeOutlet
            : activeOutlet // ignore: cast_nullable_to_non_nullable
                  as SessionOutlet?,
        roleNames: null == roleNames
            ? _value._roleNames
            : roleNames // ignore: cast_nullable_to_non_nullable
                  as Set<String>,
        permissions: null == permissions
            ? _value._permissions
            : permissions // ignore: cast_nullable_to_non_nullable
                  as Set<String>,
      ),
    );
  }
}

/// @nodoc

class _$AppSessionImpl extends _AppSession {
  const _$AppSessionImpl({
    required this.user,
    required this.business,
    required final List<SessionOutlet> outlets,
    required this.activeOutlet,
    required final Set<String> roleNames,
    required final Set<String> permissions,
  }) : _outlets = outlets,
       _roleNames = roleNames,
       _permissions = permissions,
       super._();

  @override
  final SessionUser user;
  @override
  final SessionBusiness business;
  final List<SessionOutlet> _outlets;
  @override
  List<SessionOutlet> get outlets {
    if (_outlets is EqualUnmodifiableListView) return _outlets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_outlets);
  }

  @override
  final SessionOutlet? activeOutlet;
  final Set<String> _roleNames;
  @override
  Set<String> get roleNames {
    if (_roleNames is EqualUnmodifiableSetView) return _roleNames;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_roleNames);
  }

  final Set<String> _permissions;
  @override
  Set<String> get permissions {
    if (_permissions is EqualUnmodifiableSetView) return _permissions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_permissions);
  }

  @override
  String toString() {
    return 'AppSession(user: $user, business: $business, outlets: $outlets, activeOutlet: $activeOutlet, roleNames: $roleNames, permissions: $permissions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppSessionImpl &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.business, business) ||
                other.business == business) &&
            const DeepCollectionEquality().equals(other._outlets, _outlets) &&
            (identical(other.activeOutlet, activeOutlet) ||
                other.activeOutlet == activeOutlet) &&
            const DeepCollectionEquality().equals(
              other._roleNames,
              _roleNames,
            ) &&
            const DeepCollectionEquality().equals(
              other._permissions,
              _permissions,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    user,
    business,
    const DeepCollectionEquality().hash(_outlets),
    activeOutlet,
    const DeepCollectionEquality().hash(_roleNames),
    const DeepCollectionEquality().hash(_permissions),
  );

  /// Create a copy of AppSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppSessionImplCopyWith<_$AppSessionImpl> get copyWith =>
      __$$AppSessionImplCopyWithImpl<_$AppSessionImpl>(this, _$identity);
}

abstract class _AppSession extends AppSession {
  const factory _AppSession({
    required final SessionUser user,
    required final SessionBusiness business,
    required final List<SessionOutlet> outlets,
    required final SessionOutlet? activeOutlet,
    required final Set<String> roleNames,
    required final Set<String> permissions,
  }) = _$AppSessionImpl;
  const _AppSession._() : super._();

  @override
  SessionUser get user;
  @override
  SessionBusiness get business;
  @override
  List<SessionOutlet> get outlets;
  @override
  SessionOutlet? get activeOutlet;
  @override
  Set<String> get roleNames;
  @override
  Set<String> get permissions;

  /// Create a copy of AppSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppSessionImplCopyWith<_$AppSessionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
