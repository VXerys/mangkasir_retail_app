import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/business.dart';

abstract interface class BusinessRepository {
  Future<Either<Failure, Business>> getBusiness(int businessId);

  Future<Either<Failure, Business>> updateBusiness(Business business);
}
