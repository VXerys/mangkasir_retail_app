import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

@injectable
class UpdateProductUseCase {
  final ProductRepository _repository;
  const UpdateProductUseCase(this._repository);

  Future<Either<Failure, Unit>> call(Product product) {
    return _repository.update(product);
  }
}
