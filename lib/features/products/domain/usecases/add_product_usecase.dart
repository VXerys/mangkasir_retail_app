import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

@injectable
class AddProductUseCase {
  final ProductRepository _repository;
  const AddProductUseCase(this._repository);

  Future<Either<Failure, Unit>> call(Product product) {
    return _repository.add(product);
  }
}
