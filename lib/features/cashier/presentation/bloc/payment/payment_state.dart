import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../features/cashier/domain/entities/cart_tab.dart';
import '../../../../../features/cashier/domain/entities/cart_totals.dart';

part 'payment_state.freezed.dart';

@freezed
sealed class PaymentState with _$PaymentState {
  const factory PaymentState.idle() = PaymentIdle;

  const factory PaymentState.inputting({
    required CartTab tab,
    required CartTotals totals,
    @Default('cash') String selectedMethod,
    @Default(0) double amountPaid,
  }) = PaymentInputting;

  const factory PaymentState.processing() = PaymentProcessing;

  const factory PaymentState.success({
    required double change,
    required String invoice,
    required String transactionId,
  }) = PaymentSuccess;

  const factory PaymentState.error({required String message}) = PaymentError;
}
