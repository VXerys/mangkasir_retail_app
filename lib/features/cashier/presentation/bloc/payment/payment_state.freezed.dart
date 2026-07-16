// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$PaymentState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function(
      CartTab tab,
      CartTotals totals,
      String selectedMethod,
      double amountPaid,
    )
    inputting,
    required TResult Function() processing,
    required TResult Function(
      double change,
      String invoice,
      String transactionId,
    )
    success,
    required TResult Function(String message) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function(
      CartTab tab,
      CartTotals totals,
      String selectedMethod,
      double amountPaid,
    )?
    inputting,
    TResult? Function()? processing,
    TResult? Function(double change, String invoice, String transactionId)?
    success,
    TResult? Function(String message)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function(
      CartTab tab,
      CartTotals totals,
      String selectedMethod,
      double amountPaid,
    )?
    inputting,
    TResult Function()? processing,
    TResult Function(double change, String invoice, String transactionId)?
    success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PaymentIdle value) idle,
    required TResult Function(PaymentInputting value) inputting,
    required TResult Function(PaymentProcessing value) processing,
    required TResult Function(PaymentSuccess value) success,
    required TResult Function(PaymentError value) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PaymentIdle value)? idle,
    TResult? Function(PaymentInputting value)? inputting,
    TResult? Function(PaymentProcessing value)? processing,
    TResult? Function(PaymentSuccess value)? success,
    TResult? Function(PaymentError value)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PaymentIdle value)? idle,
    TResult Function(PaymentInputting value)? inputting,
    TResult Function(PaymentProcessing value)? processing,
    TResult Function(PaymentSuccess value)? success,
    TResult Function(PaymentError value)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentStateCopyWith<$Res> {
  factory $PaymentStateCopyWith(
    PaymentState value,
    $Res Function(PaymentState) then,
  ) = _$PaymentStateCopyWithImpl<$Res, PaymentState>;
}

/// @nodoc
class _$PaymentStateCopyWithImpl<$Res, $Val extends PaymentState>
    implements $PaymentStateCopyWith<$Res> {
  _$PaymentStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaymentState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$PaymentIdleImplCopyWith<$Res> {
  factory _$$PaymentIdleImplCopyWith(
    _$PaymentIdleImpl value,
    $Res Function(_$PaymentIdleImpl) then,
  ) = __$$PaymentIdleImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$PaymentIdleImplCopyWithImpl<$Res>
    extends _$PaymentStateCopyWithImpl<$Res, _$PaymentIdleImpl>
    implements _$$PaymentIdleImplCopyWith<$Res> {
  __$$PaymentIdleImplCopyWithImpl(
    _$PaymentIdleImpl _value,
    $Res Function(_$PaymentIdleImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PaymentState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$PaymentIdleImpl implements PaymentIdle {
  const _$PaymentIdleImpl();

  @override
  String toString() {
    return 'PaymentState.idle()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$PaymentIdleImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function(
      CartTab tab,
      CartTotals totals,
      String selectedMethod,
      double amountPaid,
    )
    inputting,
    required TResult Function() processing,
    required TResult Function(
      double change,
      String invoice,
      String transactionId,
    )
    success,
    required TResult Function(String message) error,
  }) {
    return idle();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function(
      CartTab tab,
      CartTotals totals,
      String selectedMethod,
      double amountPaid,
    )?
    inputting,
    TResult? Function()? processing,
    TResult? Function(double change, String invoice, String transactionId)?
    success,
    TResult? Function(String message)? error,
  }) {
    return idle?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function(
      CartTab tab,
      CartTotals totals,
      String selectedMethod,
      double amountPaid,
    )?
    inputting,
    TResult Function()? processing,
    TResult Function(double change, String invoice, String transactionId)?
    success,
    TResult Function(String message)? error,
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
    required TResult Function(PaymentIdle value) idle,
    required TResult Function(PaymentInputting value) inputting,
    required TResult Function(PaymentProcessing value) processing,
    required TResult Function(PaymentSuccess value) success,
    required TResult Function(PaymentError value) error,
  }) {
    return idle(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PaymentIdle value)? idle,
    TResult? Function(PaymentInputting value)? inputting,
    TResult? Function(PaymentProcessing value)? processing,
    TResult? Function(PaymentSuccess value)? success,
    TResult? Function(PaymentError value)? error,
  }) {
    return idle?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PaymentIdle value)? idle,
    TResult Function(PaymentInputting value)? inputting,
    TResult Function(PaymentProcessing value)? processing,
    TResult Function(PaymentSuccess value)? success,
    TResult Function(PaymentError value)? error,
    required TResult orElse(),
  }) {
    if (idle != null) {
      return idle(this);
    }
    return orElse();
  }
}

abstract class PaymentIdle implements PaymentState {
  const factory PaymentIdle() = _$PaymentIdleImpl;
}

/// @nodoc
abstract class _$$PaymentInputtingImplCopyWith<$Res> {
  factory _$$PaymentInputtingImplCopyWith(
    _$PaymentInputtingImpl value,
    $Res Function(_$PaymentInputtingImpl) then,
  ) = __$$PaymentInputtingImplCopyWithImpl<$Res>;
  @useResult
  $Res call({
    CartTab tab,
    CartTotals totals,
    String selectedMethod,
    double amountPaid,
  });

  $CartTabCopyWith<$Res> get tab;
  $CartTotalsCopyWith<$Res> get totals;
}

/// @nodoc
class __$$PaymentInputtingImplCopyWithImpl<$Res>
    extends _$PaymentStateCopyWithImpl<$Res, _$PaymentInputtingImpl>
    implements _$$PaymentInputtingImplCopyWith<$Res> {
  __$$PaymentInputtingImplCopyWithImpl(
    _$PaymentInputtingImpl _value,
    $Res Function(_$PaymentInputtingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PaymentState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tab = null,
    Object? totals = null,
    Object? selectedMethod = null,
    Object? amountPaid = null,
  }) {
    return _then(
      _$PaymentInputtingImpl(
        tab: null == tab
            ? _value.tab
            : tab // ignore: cast_nullable_to_non_nullable
                  as CartTab,
        totals: null == totals
            ? _value.totals
            : totals // ignore: cast_nullable_to_non_nullable
                  as CartTotals,
        selectedMethod: null == selectedMethod
            ? _value.selectedMethod
            : selectedMethod // ignore: cast_nullable_to_non_nullable
                  as String,
        amountPaid: null == amountPaid
            ? _value.amountPaid
            : amountPaid // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }

  /// Create a copy of PaymentState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CartTabCopyWith<$Res> get tab {
    return $CartTabCopyWith<$Res>(_value.tab, (value) {
      return _then(_value.copyWith(tab: value));
    });
  }

  /// Create a copy of PaymentState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CartTotalsCopyWith<$Res> get totals {
    return $CartTotalsCopyWith<$Res>(_value.totals, (value) {
      return _then(_value.copyWith(totals: value));
    });
  }
}

/// @nodoc

class _$PaymentInputtingImpl implements PaymentInputting {
  const _$PaymentInputtingImpl({
    required this.tab,
    required this.totals,
    this.selectedMethod = 'cash',
    this.amountPaid = 0,
  });

  @override
  final CartTab tab;
  @override
  final CartTotals totals;
  @override
  @JsonKey()
  final String selectedMethod;
  @override
  @JsonKey()
  final double amountPaid;

  @override
  String toString() {
    return 'PaymentState.inputting(tab: $tab, totals: $totals, selectedMethod: $selectedMethod, amountPaid: $amountPaid)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentInputtingImpl &&
            (identical(other.tab, tab) || other.tab == tab) &&
            (identical(other.totals, totals) || other.totals == totals) &&
            (identical(other.selectedMethod, selectedMethod) ||
                other.selectedMethod == selectedMethod) &&
            (identical(other.amountPaid, amountPaid) ||
                other.amountPaid == amountPaid));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, tab, totals, selectedMethod, amountPaid);

  /// Create a copy of PaymentState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentInputtingImplCopyWith<_$PaymentInputtingImpl> get copyWith =>
      __$$PaymentInputtingImplCopyWithImpl<_$PaymentInputtingImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function(
      CartTab tab,
      CartTotals totals,
      String selectedMethod,
      double amountPaid,
    )
    inputting,
    required TResult Function() processing,
    required TResult Function(
      double change,
      String invoice,
      String transactionId,
    )
    success,
    required TResult Function(String message) error,
  }) {
    return inputting(tab, totals, selectedMethod, amountPaid);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function(
      CartTab tab,
      CartTotals totals,
      String selectedMethod,
      double amountPaid,
    )?
    inputting,
    TResult? Function()? processing,
    TResult? Function(double change, String invoice, String transactionId)?
    success,
    TResult? Function(String message)? error,
  }) {
    return inputting?.call(tab, totals, selectedMethod, amountPaid);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function(
      CartTab tab,
      CartTotals totals,
      String selectedMethod,
      double amountPaid,
    )?
    inputting,
    TResult Function()? processing,
    TResult Function(double change, String invoice, String transactionId)?
    success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (inputting != null) {
      return inputting(tab, totals, selectedMethod, amountPaid);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PaymentIdle value) idle,
    required TResult Function(PaymentInputting value) inputting,
    required TResult Function(PaymentProcessing value) processing,
    required TResult Function(PaymentSuccess value) success,
    required TResult Function(PaymentError value) error,
  }) {
    return inputting(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PaymentIdle value)? idle,
    TResult? Function(PaymentInputting value)? inputting,
    TResult? Function(PaymentProcessing value)? processing,
    TResult? Function(PaymentSuccess value)? success,
    TResult? Function(PaymentError value)? error,
  }) {
    return inputting?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PaymentIdle value)? idle,
    TResult Function(PaymentInputting value)? inputting,
    TResult Function(PaymentProcessing value)? processing,
    TResult Function(PaymentSuccess value)? success,
    TResult Function(PaymentError value)? error,
    required TResult orElse(),
  }) {
    if (inputting != null) {
      return inputting(this);
    }
    return orElse();
  }
}

abstract class PaymentInputting implements PaymentState {
  const factory PaymentInputting({
    required final CartTab tab,
    required final CartTotals totals,
    final String selectedMethod,
    final double amountPaid,
  }) = _$PaymentInputtingImpl;

  CartTab get tab;
  CartTotals get totals;
  String get selectedMethod;
  double get amountPaid;

  /// Create a copy of PaymentState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaymentInputtingImplCopyWith<_$PaymentInputtingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PaymentProcessingImplCopyWith<$Res> {
  factory _$$PaymentProcessingImplCopyWith(
    _$PaymentProcessingImpl value,
    $Res Function(_$PaymentProcessingImpl) then,
  ) = __$$PaymentProcessingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$PaymentProcessingImplCopyWithImpl<$Res>
    extends _$PaymentStateCopyWithImpl<$Res, _$PaymentProcessingImpl>
    implements _$$PaymentProcessingImplCopyWith<$Res> {
  __$$PaymentProcessingImplCopyWithImpl(
    _$PaymentProcessingImpl _value,
    $Res Function(_$PaymentProcessingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PaymentState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$PaymentProcessingImpl implements PaymentProcessing {
  const _$PaymentProcessingImpl();

  @override
  String toString() {
    return 'PaymentState.processing()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$PaymentProcessingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function(
      CartTab tab,
      CartTotals totals,
      String selectedMethod,
      double amountPaid,
    )
    inputting,
    required TResult Function() processing,
    required TResult Function(
      double change,
      String invoice,
      String transactionId,
    )
    success,
    required TResult Function(String message) error,
  }) {
    return processing();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function(
      CartTab tab,
      CartTotals totals,
      String selectedMethod,
      double amountPaid,
    )?
    inputting,
    TResult? Function()? processing,
    TResult? Function(double change, String invoice, String transactionId)?
    success,
    TResult? Function(String message)? error,
  }) {
    return processing?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function(
      CartTab tab,
      CartTotals totals,
      String selectedMethod,
      double amountPaid,
    )?
    inputting,
    TResult Function()? processing,
    TResult Function(double change, String invoice, String transactionId)?
    success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (processing != null) {
      return processing();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PaymentIdle value) idle,
    required TResult Function(PaymentInputting value) inputting,
    required TResult Function(PaymentProcessing value) processing,
    required TResult Function(PaymentSuccess value) success,
    required TResult Function(PaymentError value) error,
  }) {
    return processing(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PaymentIdle value)? idle,
    TResult? Function(PaymentInputting value)? inputting,
    TResult? Function(PaymentProcessing value)? processing,
    TResult? Function(PaymentSuccess value)? success,
    TResult? Function(PaymentError value)? error,
  }) {
    return processing?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PaymentIdle value)? idle,
    TResult Function(PaymentInputting value)? inputting,
    TResult Function(PaymentProcessing value)? processing,
    TResult Function(PaymentSuccess value)? success,
    TResult Function(PaymentError value)? error,
    required TResult orElse(),
  }) {
    if (processing != null) {
      return processing(this);
    }
    return orElse();
  }
}

abstract class PaymentProcessing implements PaymentState {
  const factory PaymentProcessing() = _$PaymentProcessingImpl;
}

/// @nodoc
abstract class _$$PaymentSuccessImplCopyWith<$Res> {
  factory _$$PaymentSuccessImplCopyWith(
    _$PaymentSuccessImpl value,
    $Res Function(_$PaymentSuccessImpl) then,
  ) = __$$PaymentSuccessImplCopyWithImpl<$Res>;
  @useResult
  $Res call({double change, String invoice, String transactionId});
}

/// @nodoc
class __$$PaymentSuccessImplCopyWithImpl<$Res>
    extends _$PaymentStateCopyWithImpl<$Res, _$PaymentSuccessImpl>
    implements _$$PaymentSuccessImplCopyWith<$Res> {
  __$$PaymentSuccessImplCopyWithImpl(
    _$PaymentSuccessImpl _value,
    $Res Function(_$PaymentSuccessImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PaymentState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? change = null,
    Object? invoice = null,
    Object? transactionId = null,
  }) {
    return _then(
      _$PaymentSuccessImpl(
        change: null == change
            ? _value.change
            : change // ignore: cast_nullable_to_non_nullable
                  as double,
        invoice: null == invoice
            ? _value.invoice
            : invoice // ignore: cast_nullable_to_non_nullable
                  as String,
        transactionId: null == transactionId
            ? _value.transactionId
            : transactionId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$PaymentSuccessImpl implements PaymentSuccess {
  const _$PaymentSuccessImpl({
    required this.change,
    required this.invoice,
    required this.transactionId,
  });

  @override
  final double change;
  @override
  final String invoice;
  @override
  final String transactionId;

  @override
  String toString() {
    return 'PaymentState.success(change: $change, invoice: $invoice, transactionId: $transactionId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentSuccessImpl &&
            (identical(other.change, change) || other.change == change) &&
            (identical(other.invoice, invoice) || other.invoice == invoice) &&
            (identical(other.transactionId, transactionId) ||
                other.transactionId == transactionId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, change, invoice, transactionId);

  /// Create a copy of PaymentState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentSuccessImplCopyWith<_$PaymentSuccessImpl> get copyWith =>
      __$$PaymentSuccessImplCopyWithImpl<_$PaymentSuccessImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function(
      CartTab tab,
      CartTotals totals,
      String selectedMethod,
      double amountPaid,
    )
    inputting,
    required TResult Function() processing,
    required TResult Function(
      double change,
      String invoice,
      String transactionId,
    )
    success,
    required TResult Function(String message) error,
  }) {
    return success(change, invoice, transactionId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function(
      CartTab tab,
      CartTotals totals,
      String selectedMethod,
      double amountPaid,
    )?
    inputting,
    TResult? Function()? processing,
    TResult? Function(double change, String invoice, String transactionId)?
    success,
    TResult? Function(String message)? error,
  }) {
    return success?.call(change, invoice, transactionId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function(
      CartTab tab,
      CartTotals totals,
      String selectedMethod,
      double amountPaid,
    )?
    inputting,
    TResult Function()? processing,
    TResult Function(double change, String invoice, String transactionId)?
    success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(change, invoice, transactionId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PaymentIdle value) idle,
    required TResult Function(PaymentInputting value) inputting,
    required TResult Function(PaymentProcessing value) processing,
    required TResult Function(PaymentSuccess value) success,
    required TResult Function(PaymentError value) error,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PaymentIdle value)? idle,
    TResult? Function(PaymentInputting value)? inputting,
    TResult? Function(PaymentProcessing value)? processing,
    TResult? Function(PaymentSuccess value)? success,
    TResult? Function(PaymentError value)? error,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PaymentIdle value)? idle,
    TResult Function(PaymentInputting value)? inputting,
    TResult Function(PaymentProcessing value)? processing,
    TResult Function(PaymentSuccess value)? success,
    TResult Function(PaymentError value)? error,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class PaymentSuccess implements PaymentState {
  const factory PaymentSuccess({
    required final double change,
    required final String invoice,
    required final String transactionId,
  }) = _$PaymentSuccessImpl;

  double get change;
  String get invoice;
  String get transactionId;

  /// Create a copy of PaymentState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaymentSuccessImplCopyWith<_$PaymentSuccessImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PaymentErrorImplCopyWith<$Res> {
  factory _$$PaymentErrorImplCopyWith(
    _$PaymentErrorImpl value,
    $Res Function(_$PaymentErrorImpl) then,
  ) = __$$PaymentErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$PaymentErrorImplCopyWithImpl<$Res>
    extends _$PaymentStateCopyWithImpl<$Res, _$PaymentErrorImpl>
    implements _$$PaymentErrorImplCopyWith<$Res> {
  __$$PaymentErrorImplCopyWithImpl(
    _$PaymentErrorImpl _value,
    $Res Function(_$PaymentErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PaymentState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$PaymentErrorImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$PaymentErrorImpl implements PaymentError {
  const _$PaymentErrorImpl({required this.message});

  @override
  final String message;

  @override
  String toString() {
    return 'PaymentState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of PaymentState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentErrorImplCopyWith<_$PaymentErrorImpl> get copyWith =>
      __$$PaymentErrorImplCopyWithImpl<_$PaymentErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function(
      CartTab tab,
      CartTotals totals,
      String selectedMethod,
      double amountPaid,
    )
    inputting,
    required TResult Function() processing,
    required TResult Function(
      double change,
      String invoice,
      String transactionId,
    )
    success,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function(
      CartTab tab,
      CartTotals totals,
      String selectedMethod,
      double amountPaid,
    )?
    inputting,
    TResult? Function()? processing,
    TResult? Function(double change, String invoice, String transactionId)?
    success,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function(
      CartTab tab,
      CartTotals totals,
      String selectedMethod,
      double amountPaid,
    )?
    inputting,
    TResult Function()? processing,
    TResult Function(double change, String invoice, String transactionId)?
    success,
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
    required TResult Function(PaymentIdle value) idle,
    required TResult Function(PaymentInputting value) inputting,
    required TResult Function(PaymentProcessing value) processing,
    required TResult Function(PaymentSuccess value) success,
    required TResult Function(PaymentError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PaymentIdle value)? idle,
    TResult? Function(PaymentInputting value)? inputting,
    TResult? Function(PaymentProcessing value)? processing,
    TResult? Function(PaymentSuccess value)? success,
    TResult? Function(PaymentError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PaymentIdle value)? idle,
    TResult Function(PaymentInputting value)? inputting,
    TResult Function(PaymentProcessing value)? processing,
    TResult Function(PaymentSuccess value)? success,
    TResult Function(PaymentError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class PaymentError implements PaymentState {
  const factory PaymentError({required final String message}) =
      _$PaymentErrorImpl;

  String get message;

  /// Create a copy of PaymentState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaymentErrorImplCopyWith<_$PaymentErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
