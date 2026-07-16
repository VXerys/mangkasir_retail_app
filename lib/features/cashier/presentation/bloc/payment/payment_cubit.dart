import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../features/cashier/domain/entities/cart_tab.dart';
import '../../../../../features/cashier/domain/entities/cart_totals.dart';
import '../../../../../features/cashier/domain/usecases/calculate_cart_totals.dart';
import '../../../../../features/cashier/domain/usecases/checkout_usecase.dart';
import '../cart/cart_bloc.dart';
import '../cart/cart_event.dart';
import 'payment_state.dart';

@injectable
class PaymentCubit extends Cubit<PaymentState> {
  final CheckoutUseCase _checkout;
  final CalculateCartTotals _calcTotals;
  final CartBloc _cartBloc;

  PaymentCubit(this._checkout, this._calcTotals, this._cartBloc)
      : super(const PaymentState.idle());

  void start(CartTab tab) {
    final totals = _calcTotals(tab);
    emit(PaymentState.inputting(tab: tab, totals: totals));
  }

  void setMethod(String method) {
    final s = state;
    if (s is! PaymentInputting) return;
    emit(s.copyWith(selectedMethod: method));
  }

  void setAmountPaid(double amount) {
    final s = state;
    if (s is! PaymentInputting) return;
    emit(s.copyWith(amountPaid: amount));
  }

  Future<void> confirm({required String storeId, String? cashierId}) async {
    final s = state;
    if (s is! PaymentInputting) return;

    emit(const PaymentState.processing());

    final result = await _checkout(CheckoutParams(
      tab: s.tab,
      paymentMethod: s.selectedMethod,
      amountPaid: s.amountPaid,
      storeId: storeId,
      cashierId: cashierId,
    ));

    result.fold(
      (failure) => emit(PaymentState.error(message: failure.message)),
      (checkoutResult) {
        _cartBloc.add(CartEvent.cleared(tabId: s.tab.id));
        emit(PaymentState.success(
          change: checkoutResult.change,
          invoice: checkoutResult.invoice,
          transactionId: checkoutResult.transactionId,
        ));
      },
    );
  }

  void reset() => emit(const PaymentState.idle());
}
