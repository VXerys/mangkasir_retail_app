import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../error/failures.dart';
import '../../features/categories/domain/repositories/category_repository.dart';
import '../../features/payments/domain/repositories/payment_repository.dart';
import '../../features/products/domain/repositories/product_repository.dart';
import '../../features/transactions/domain/repositories/transaction_repository.dart';
import 'sync_bloc/sync_state.dart';

class SyncProgress {
  final SyncEntity entity;
  final bool isDone;

  const SyncProgress.started(this.entity) : isDone = false;
  const SyncProgress.done(this.entity) : isDone = true;
}

class SyncAbortedException implements Exception {
  final SyncEntity entity;
  final String message;

  SyncAbortedException(this.entity, this.message);
}

@lazySingleton
class SyncWorker {
  final CategoryRepository _categoryRepo;
  final ProductRepository _productRepo;
  final TransactionRepository _transactionRepo;
  final PaymentRepository _paymentRepo;

  SyncWorker(
    this._categoryRepo,
    this._productRepo,
    this._transactionRepo,
    this._paymentRepo,
  );

  /// Yields progress per entity in strict order.
  ///
  /// Throws [SyncAbortedException] directly from this generator (not via
  /// yield* delegation) so that the outer stream terminates immediately on
  /// failure. With yield*, Dart forwards the inner error but then resumes the
  /// outer generator — meaning subsequent entities would still run despite the
  /// failure, and emit.forEach would not receive onDone until the whole stream
  /// finished naturally.
  Stream<SyncProgress> run() async* {
    final steps = [
      (SyncEntity.category, _categoryRepo.syncPending),
      (SyncEntity.product, _productRepo.syncPending),
      (SyncEntity.transaction, _transactionRepo.syncPending),
      (SyncEntity.payment, _paymentRepo.syncPending),
    ];

    for (final (entity, sync) in steps) {
      yield SyncProgress.started(entity);
      final result = await sync();
      final String? error = result.fold((f) => f.message, (_) => null);
      if (error != null) throw SyncAbortedException(entity, error);
      yield SyncProgress.done(entity);
    }
  }
}
