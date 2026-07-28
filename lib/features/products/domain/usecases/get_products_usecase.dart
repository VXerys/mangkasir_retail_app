import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

@injectable
class GetProductsUseCase {
  final ProductRepository _repository;
  const GetProductsUseCase(this._repository);

  Future<Either<Failure, List<Product>>> call({
    required String storeId,
    String? categoryId,
  }) {
    return _repository.getAll(storeId: storeId, categoryId: categoryId);
  }
}
