// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cart_totals.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$CartTotals {
  double get subTotal => throw _privateConstructorUsedError;
  double get totalDiscount => throw _privateConstructorUsedError;
  double get totalPpn => throw _privateConstructorUsedError;
  double get grandTotal => throw _privateConstructorUsedError;

  /// Create a copy of CartTotals
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CartTotalsCopyWith<CartTotals> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CartTotalsCopyWith<$Res> {
  factory $CartTotalsCopyWith(
    CartTotals value,
    $Res Function(CartTotals) then,
  ) = _$CartTotalsCopyWithImpl<$Res, CartTotals>;
  @useResult
  $Res call({
    double subTotal,
    double totalDiscount,
    double totalPpn,
    double grandTotal,
  });
}

/// @nodoc
class _$CartTotalsCopyWithImpl<$Res, $Val extends CartTotals>
    implements $CartTotalsCopyWith<$Res> {
  _$CartTotalsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CartTotals
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? subTotal = null,
    Object? totalDiscount = null,
    Object? totalPpn = null,
    Object? grandTotal = null,
  }) {
    return _then(
      _value.copyWith(
            subTotal: null == subTotal
                ? _value.subTotal
                : subTotal // ignore: cast_nullable_to_non_nullable
                      as double,
            totalDiscount: null == totalDiscount
                ? _value.totalDiscount
                : totalDiscount // ignore: cast_nullable_to_non_nullable
                      as double,
            totalPpn: null == totalPpn
                ? _value.totalPpn
                : totalPpn // ignore: cast_nullable_to_non_nullable
                      as double,
            grandTotal: null == grandTotal
                ? _value.grandTotal
                : grandTotal // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CartTotalsImplCopyWith<$Res>
    implements $CartTotalsCopyWith<$Res> {
  factory _$$CartTotalsImplCopyWith(
    _$CartTotalsImpl value,
    $Res Function(_$CartTotalsImpl) then,
  ) = __$$CartTotalsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    double subTotal,
    double totalDiscount,
    double totalPpn,
    double grandTotal,
  });
}

/// @nodoc
class __$$CartTotalsImplCopyWithImpl<$Res>
    extends _$CartTotalsCopyWithImpl<$Res, _$CartTotalsImpl>
    implements _$$CartTotalsImplCopyWith<$Res> {
  __$$CartTotalsImplCopyWithImpl(
    _$CartTotalsImpl _value,
    $Res Function(_$CartTotalsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CartTotals
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? subTotal = null,
    Object? totalDiscount = null,
    Object? totalPpn = null,
    Object? grandTotal = null,
  }) {
    return _then(
      _$CartTotalsImpl(
        subTotal: null == subTotal
            ? _value.subTotal
            : subTotal // ignore: cast_nullable_to_non_nullable
                  as double,
        totalDiscount: null == totalDiscount
            ? _value.totalDiscount
            : totalDiscount // ignore: cast_nullable_to_non_nullable
                  as double,
        totalPpn: null == totalPpn
            ? _value.totalPpn
            : totalPpn // ignore: cast_nullable_to_non_nullable
                  as double,
        grandTotal: null == grandTotal
            ? _value.grandTotal
            : grandTotal // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc

class _$CartTotalsImpl implements _CartTotals {
  const _$CartTotalsImpl({
    required this.subTotal,
    required this.totalDiscount,
    required this.totalPpn,
    required this.grandTotal,
  });

  @override
  final double subTotal;
  @override
  final double totalDiscount;
  @override
  final double totalPpn;
  @override
  final double grandTotal;

  @override
  String toString() {
    return 'CartTotals(subTotal: $subTotal, totalDiscount: $totalDiscount, totalPpn: $totalPpn, grandTotal: $grandTotal)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CartTotalsImpl &&
            (identical(other.subTotal, subTotal) ||
                other.subTotal == subTotal) &&
            (identical(other.totalDiscount, totalDiscount) ||
                other.totalDiscount == totalDiscount) &&
            (identical(other.totalPpn, totalPpn) ||
                other.totalPpn == totalPpn) &&
            (identical(other.grandTotal, grandTotal) ||
                other.grandTotal == grandTotal));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, subTotal, totalDiscount, totalPpn, grandTotal);

  /// Create a copy of CartTotals
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CartTotalsImplCopyWith<_$CartTotalsImpl> get copyWith =>
      __$$CartTotalsImplCopyWithImpl<_$CartTotalsImpl>(this, _$identity);
}

abstract class _CartTotals implements CartTotals {
  const factory _CartTotals({
    required final double subTotal,
    required final double totalDiscount,
    required final double totalPpn,
    required final double grandTotal,
  }) = _$CartTotalsImpl;

  @override
  double get subTotal;
  @override
  double get totalDiscount;
  @override
  double get totalPpn;
  @override
  double get grandTotal;

  /// Create a copy of CartTotals
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CartTotalsImplCopyWith<_$CartTotalsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
