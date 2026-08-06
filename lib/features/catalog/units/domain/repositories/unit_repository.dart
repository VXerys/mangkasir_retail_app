import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/unit.dart' as domain;

// Alias is needed because dartz exports `Unit` and the domain entity is also `Unit`.
abstract interface class UnitRepository {
  Future<Either<Failure, List<domain.Unit>>> getAll(int businessId);
  Future<Either<Failure, domain.Unit>> create(domain.Unit unit);
  Future<Either<Failure, domain.Unit>> update(domain.Unit unit);
  Future<Either<Failure, Unit>> delete(int id);
}
