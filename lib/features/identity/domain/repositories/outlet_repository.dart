import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/outlet.dart';

abstract interface class OutletRepository {
  Future<Either<Failure, List<Outlet>>> getOutlets(int businessId);

  Future<Either<Failure, Outlet>> createOutlet(Outlet outlet);

  Future<Either<Failure, Outlet>> updateOutlet(Outlet outlet);
}
