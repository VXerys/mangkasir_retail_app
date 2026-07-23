import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/id_generator.dart';
import '../../../payments/domain/entities/payment.dart';
import '../../../payments/domain/repositories/payment_repository.dart';
import '../../../transactions/domain/entities/transaction.dart';
import '../../../transactions/domain/entities/transaction_detail.dart';
import '../../../transactions/domain/repositories/transaction_repository.dart';
import '../entities/cart_tab.dart';
import 'calculate_cart_totals.dart';

class CheckoutParams {
  final CartTab tab;
  final String paymentMethod;
  final double amountPaid;
  final String storeId;
  final String? cashierId;

  const CheckoutParams({
    required this.tab,
    required this.paymentMethod,
    required this.amountPaid,
    required this.storeId,
    this.cashierId,
  });
}

class CheckoutResult {
  final String transactionId;
  final String invoice;
  final double change;

  const CheckoutResult({
    required this.transactionId,
    required this.invoice,
    required this.change,
  });
}

@injectable
class CheckoutUseCase {
  final TransactionRepository _transactionRepo;
  final PaymentRepository _paymentRepo;
  final CalculateCartTotals _calculateTotals;

  const CheckoutUseCase(
    this._transactionRepo,
    this._paymentRepo,
    this._calculateTotals,
  );

  Future<Either<Failure, CheckoutResult>> call(CheckoutParams params) async {
    final totals = _calculateTotals(params.tab);

    if (params.amountPaid < totals.grandTotal) {
      return Left(LocalFailure('Jumlah bayar kurang dari total transaksi'));
    }

    final now = DateTime.now();
    final trxGuid = generateId();
    final trxId = generateId();
    final invoice = _generateInvoice(now);

    final transaction = Transaction(
      id: trxId,
      guid: trxGuid,
      storeId: params.storeId,
      subTotal: totals.subTotal,
      discount: totals.totalDiscount,
      tax: totals.totalPpn,
      paymentMethod: params.paymentMethod,
      invoice: invoice,
      customerName: params.tab.customerName,
      cashierId: params.cashierId,
      date: now,
      createdAt: now,
      updatedAt: now,
    );

    final details = params.tab.items
        .map(
          (item) => TransactionDetail(
            id: generateId(),
            guid: generateId(),
            transactionGuid: trxGuid,
            productGuid: item.productGuid,
            productName: item.productName,
            price: item.price,
            qty: item.qty.toDouble(),
            discount: item.discount,
            tax: item.ppn,
            totalPrice: (item.price * item.qty) - item.discount,
            createdAt: now,
            updatedAt: now,
          ),
        )
        .toList();

    final payment = Payment(
      id: generateId(),
      guid: generateId(),
      transactionGuid: trxGuid,
      amount: params.amountPaid,
      changeAmount: params.amountPaid - totals.grandTotal,
      subTotal: totals.grandTotal,
      method: params.paymentMethod,
      date: now,
      createdAt: now,
      updatedAt: now,
    );

    // Save transaction + details atomically, then payment separately
    final trxResult = await _transactionRepo.save(
      transaction: transaction,
      details: details,
    );

    return trxResult.fold(
      Left.new,
      (_) async {
        final payResult = await _paymentRepo.save(payment);
        return payResult.fold(
          Left.new,
          (_) => Right(
            CheckoutResult(
              transactionId: trxId,
              invoice: invoice,
              change: payment.changeAmount,
            ),
          ),
        );
      },
    );
  }

  String _generateInvoice(DateTime now) {
    final date =
        '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
    final seq = now.millisecondsSinceEpoch % 10000;
    return 'INV-POS-$date-${seq.toString().padLeft(4, '0')}';
  }
}
