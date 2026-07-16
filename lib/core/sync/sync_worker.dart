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
  /// Throws SyncAbortedException if any step fails — downstream must stop.
  Stream<SyncProgress> run() async* {
    yield* _syncEntity(SyncEntity.category, _categoryRepo.syncPending);
    yield* _syncEntity(SyncEntity.product, _productRepo.syncPending);
    yield* _syncEntity(SyncEntity.transaction, _transactionRepo.syncPending);
    yield* _syncEntity(SyncEntity.payment, _paymentRepo.syncPending);
  }

  Stream<SyncProgress> _syncEntity(
    SyncEntity entity,
    Future<Either<Failure, Unit>> Function() sync,
  ) async* {
    yield SyncProgress.started(entity);
    final result = await sync();
    String? errorMessage;
    result.fold(
      (failure) => errorMessage = failure.message,
      (_) {},
    );
    if (errorMessage != null) {
      throw SyncAbortedException(entity, errorMessage!);
    }
    yield SyncProgress.done(entity);
  }
}
