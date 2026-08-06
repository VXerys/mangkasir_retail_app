// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$AppUser {
  int get id => throw _privateConstructorUsedError;
  String get uuid => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get username => throw _privateConstructorUsedError;
  int get businessId => throw _privateConstructorUsedError;
  List<AppUserRole> get roles => throw _privateConstructorUsedError;

  /// Create a copy of AppUser
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppUserCopyWith<AppUser> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppUserCopyWith<$Res> {
  factory $AppUserCopyWith(AppUser value, $Res Function(AppUser) then) =
      _$AppUserCopyWithImpl<$Res, AppUser>;
  @useResult
  $Res call({
    int id,
    String uuid,
    String email,
    String username,
    int businessId,
    List<AppUserRole> roles,
  });
}

/// @nodoc
class _$AppUserCopyWithImpl<$Res, $Val extends AppUser>
    implements $AppUserCopyWith<$Res> {
  _$AppUserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppUser
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? uuid = null,
    Object? email = null,
    Object? username = null,
    Object? businessId = null,
    Object? roles = null,
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
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            username: null == username
                ? _value.username
                : username // ignore: cast_nullable_to_non_nullable
                      as String,
            businessId: null == businessId
                ? _value.businessId
                : businessId // ignore: cast_nullable_to_non_nullable
                      as int,
            roles: null == roles
                ? _value.roles
                : roles // ignore: cast_nullable_to_non_nullable
                      as List<AppUserRole>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AppUserImplCopyWith<$Res> implements $AppUserCopyWith<$Res> {
  factory _$$AppUserImplCopyWith(
    _$AppUserImpl value,
    $Res Function(_$AppUserImpl) then,
  ) = __$$AppUserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String uuid,
    String email,
    String username,
    int businessId,
    List<AppUserRole> roles,
  });
}

/// @nodoc
class __$$AppUserImplCopyWithImpl<$Res>
    extends _$AppUserCopyWithImpl<$Res, _$AppUserImpl>
    implements _$$AppUserImplCopyWith<$Res> {
  __$$AppUserImplCopyWithImpl(
    _$AppUserImpl _value,
    $Res Function(_$AppUserImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AppUser
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? uuid = null,
    Object? email = null,
    Object? username = null,
    Object? businessId = null,
    Object? roles = null,
  }) {
    return _then(
      _$AppUserImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        uuid: null == uuid
            ? _value.uuid
            : uuid // ignore: cast_nullable_to_non_nullable
                  as String,
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        username: null == username
            ? _value.username
            : username // ignore: cast_nullable_to_non_nullable
                  as String,
        businessId: null == businessId
            ? _value.businessId
            : businessId // ignore: cast_nullable_to_non_nullable
                  as int,
        roles: null == roles
            ? _value._roles
            : roles // ignore: cast_nullable_to_non_nullable
                  as List<AppUserRole>,
      ),
    );
  }
}

/// @nodoc

class _$AppUserImpl implements _AppUser {
  const _$AppUserImpl({
    required this.id,
    required this.uuid,
    required this.email,
    required this.username,
    required this.businessId,
    final List<AppUserRole> roles = const [],
  }) : _roles = roles;

  @override
  final int id;
  @override
  final String uuid;
  @override
  final String email;
  @override
  final String username;
  @override
  final int businessId;
  final List<AppUserRole> _roles;
  @override
  @JsonKey()
  List<AppUserRole> get roles {
    if (_roles is EqualUnmodifiableListView) return _roles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_roles);
  }

  @override
  String toString() {
    return 'AppUser(id: $id, uuid: $uuid, email: $email, username: $username, businessId: $businessId, roles: $roles)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppUserImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.uuid, uuid) || other.uuid == uuid) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.businessId, businessId) ||
                other.businessId == businessId) &&
            const DeepCollectionEquality().equals(other._roles, _roles));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    uuid,
    email,
    username,
    businessId,
    const DeepCollectionEquality().hash(_roles),
  );

  /// Create a copy of AppUser
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppUserImplCopyWith<_$AppUserImpl> get copyWith =>
      __$$AppUserImplCopyWithImpl<_$AppUserImpl>(this, _$identity);
}

abstract class _AppUser implements AppUser {
  const factory _AppUser({
    required final int id,
    required final String uuid,
    required final String email,
    required final String username,
    required final int businessId,
    final List<AppUserRole> roles,
  }) = _$AppUserImpl;

  @override
  int get id;
  @override
  String get uuid;
  @override
  String get email;
  @override
  String get username;
  @override
  int get businessId;
  @override
  List<AppUserRole> get roles;

  /// Create a copy of AppUser
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppUserImplCopyWith<_$AppUserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$AppUserRole {
  int get userRoleId => throw _privateConstructorUsedError;
  String get roleName => throw _privateConstructorUsedError;
  int? get outletId => throw _privateConstructorUsedError;
  String? get outletName => throw _privateConstructorUsedError;

  /// Create a copy of AppUserRole
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppUserRoleCopyWith<AppUserRole> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppUserRoleCopyWith<$Res> {
  factory $AppUserRoleCopyWith(
    AppUserRole value,
    $Res Function(AppUserRole) then,
  ) = _$AppUserRoleCopyWithImpl<$Res, AppUserRole>;
  @useResult
  $Res call({
    int userRoleId,
    String roleName,
    int? outletId,
    String? outletName,
  });
}

/// @nodoc
class _$AppUserRoleCopyWithImpl<$Res, $Val extends AppUserRole>
    implements $AppUserRoleCopyWith<$Res> {
  _$AppUserRoleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppUserRole
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userRoleId = null,
    Object? roleName = null,
    Object? outletId = freezed,
    Object? outletName = freezed,
  }) {
    return _then(
      _value.copyWith(
            userRoleId: null == userRoleId
                ? _value.userRoleId
                : userRoleId // ignore: cast_nullable_to_non_nullable
                      as int,
            roleName: null == roleName
                ? _value.roleName
                : roleName // ignore: cast_nullable_to_non_nullable
                      as String,
            outletId: freezed == outletId
                ? _value.outletId
                : outletId // ignore: cast_nullable_to_non_nullable
                      as int?,
            outletName: freezed == outletName
                ? _value.outletName
                : outletName // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AppUserRoleImplCopyWith<$Res>
    implements $AppUserRoleCopyWith<$Res> {
  factory _$$AppUserRoleImplCopyWith(
    _$AppUserRoleImpl value,
    $Res Function(_$AppUserRoleImpl) then,
  ) = __$$AppUserRoleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int userRoleId,
    String roleName,
    int? outletId,
    String? outletName,
  });
}

/// @nodoc
class __$$AppUserRoleImplCopyWithImpl<$Res>
    extends _$AppUserRoleCopyWithImpl<$Res, _$AppUserRoleImpl>
    implements _$$AppUserRoleImplCopyWith<$Res> {
  __$$AppUserRoleImplCopyWithImpl(
    _$AppUserRoleImpl _value,
    $Res Function(_$AppUserRoleImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AppUserRole
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userRoleId = null,
    Object? roleName = null,
    Object? outletId = freezed,
    Object? outletName = freezed,
  }) {
    return _then(
      _$AppUserRoleImpl(
        userRoleId: null == userRoleId
            ? _value.userRoleId
            : userRoleId // ignore: cast_nullable_to_non_nullable
                  as int,
        roleName: null == roleName
            ? _value.roleName
            : roleName // ignore: cast_nullable_to_non_nullable
                  as String,
        outletId: freezed == outletId
            ? _value.outletId
            : outletId // ignore: cast_nullable_to_non_nullable
                  as int?,
        outletName: freezed == outletName
            ? _value.outletName
            : outletName // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$AppUserRoleImpl implements _AppUserRole {
  const _$AppUserRoleImpl({
    required this.userRoleId,
    required this.roleName,
    this.outletId,
    this.outletName,
  });

  @override
  final int userRoleId;
  @override
  final String roleName;
  @override
  final int? outletId;
  @override
  final String? outletName;

  @override
  String toString() {
    return 'AppUserRole(userRoleId: $userRoleId, roleName: $roleName, outletId: $outletId, outletName: $outletName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppUserRoleImpl &&
            (identical(other.userRoleId, userRoleId) ||
                other.userRoleId == userRoleId) &&
            (identical(other.roleName, roleName) ||
                other.roleName == roleName) &&
            (identical(other.outletId, outletId) ||
                other.outletId == outletId) &&
            (identical(other.outletName, outletName) ||
                other.outletName == outletName));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, userRoleId, roleName, outletId, outletName);

  /// Create a copy of AppUserRole
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppUserRoleImplCopyWith<_$AppUserRoleImpl> get copyWith =>
      __$$AppUserRoleImplCopyWithImpl<_$AppUserRoleImpl>(this, _$identity);
}

abstract class _AppUserRole implements AppUserRole {
  const factory _AppUserRole({
    required final int userRoleId,
    required final String roleName,
    final int? outletId,
    final String? outletName,
  }) = _$AppUserRoleImpl;

  @override
  int get userRoleId;
  @override
  String get roleName;
  @override
  int? get outletId;
  @override
  String? get outletName;

  /// Create a copy of AppUserRole
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppUserRoleImplCopyWith<_$AppUserRoleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
