import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/payment.dart';

abstract class PaymentRepository {
  Future<Either<Failure, Unit>> save(Payment payment);
  Future<Either<Failure, Unit>> syncPending();
}
