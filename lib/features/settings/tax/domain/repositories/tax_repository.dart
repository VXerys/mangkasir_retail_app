import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/tax_settings.dart';

abstract interface class TaxRepository {
  Future<Either<Failure, TaxSettings>> get(int outletId);
  Future<Either<Failure, TaxSettings>> save(TaxSettings settings);
}
