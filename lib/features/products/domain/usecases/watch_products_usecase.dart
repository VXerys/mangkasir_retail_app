import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

@injectable
class WatchProductsUseCase {
  final ProductRepository _repository;
  const WatchProductsUseCase(this._repository);

  Stream<Either<Failure, List<Product>>> call({String? categoryId}) {
    return _repository.watchActiveByCategory(categoryId: categoryId);
  }
}
