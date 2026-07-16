import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../entities/category.dart';
import '../repositories/category_repository.dart';

@injectable
class AddCategoryUseCase {
  final CategoryRepository _repository;
  const AddCategoryUseCase(this._repository);

  Future<Either<Failure, Unit>> call(Category category) {
    return _repository.add(category);
  }
}
