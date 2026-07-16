import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/transaction.dart';
import '../entities/transaction_detail.dart';

abstract class TransactionRepository {
  Future<Either<Failure, Unit>> save({
    required Transaction transaction,
    required List<TransactionDetail> details,
  });
  Future<Either<Failure, Unit>> syncPending();
}
