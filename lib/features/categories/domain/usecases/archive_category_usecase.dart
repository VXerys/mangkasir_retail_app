import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../repositories/category_repository.dart';

@injectable
class ArchiveCategoryUseCase {
  final CategoryRepository _repository;
  const ArchiveCategoryUseCase(this._repository);

  Future<Either<Failure, Unit>> call(String id) {
    return _repository.archive(id);
  }
}
