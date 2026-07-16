import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../entities/category.dart';
import '../repositories/category_repository.dart';

@injectable
class UpdateCategoryUseCase {
  final CategoryRepository _repository;
  const UpdateCategoryUseCase(this._repository);

  Future<Either<Failure, Unit>> call(Category category) {
    return _repository.update(category);
  }
}
