import 'package:dartz/dartz.dart';
import 'package:mangkasir_retail_app/core/error/failures.dart';
import 'package:mangkasir_retail_app/features/payments/domain/entities/payment.dart';
import 'package:mangkasir_retail_app/features/payments/domain/repositories/payment_repository.dart';
import 'package:mangkasir_retail_app/features/transactions/domain/entities/transaction.dart';
import 'package:mangkasir_retail_app/features/transactions/domain/entities/transaction_detail.dart';
import 'package:mangkasir_retail_app/features/transactions/domain/repositories/transaction_repository.dart';

/// Dua repositori terakhir dalam urutan [SyncWorker].
///
/// Sengaja mencatat apakah dirinya sempat dipanggil. Justru itu yang diuji:
/// `SyncWorker` berurutan ketat dan berhenti di langkah pertama yang gagal,
/// jadi produk yang ditolak server berarti transaksi dan pembayaran tidak
/// pernah dicoba sama sekali — sifat yang mudah hilang tanpa disadari.
class FakeTransactionRepository implements TransactionRepository {
  bool syncCalled = false;

  @override
  Future<Either<Failure, Unit>> save({
    required Transaction transaction,
    required List<TransactionDetail> details,
  }) async =>
      const Right(unit);

  @override
  Future<Either<Failure, Unit>> syncPending() async {
    syncCalled = true;
    return const Right(unit);
  }
}

class FakePaymentRepository implements PaymentRepository {
  bool syncCalled = false;

  @override
  Future<Either<Failure, Unit>> save(Payment payment) async => const Right(unit);

  @override
  Future<Either<Failure, Unit>> syncPending() async {
    syncCalled = true;
    return const Right(unit);
  }
}
