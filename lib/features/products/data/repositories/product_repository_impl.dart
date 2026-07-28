import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_local_ds.dart';
import '../datasources/product_remote_ds.dart';

@LazySingleton(as: ProductRepository)
class ProductRepositoryImpl implements ProductRepository {
  final ProductLocalDs _localDs;
  final ProductRemoteDs _remoteDs;

  const ProductRepositoryImpl(this._localDs, this._remoteDs);

  @override
  Future<Either<Failure, List<Product>>> getAll({
    required String storeId,
    String? categoryId,
  }) async {
    try {
      final products = await _localDs.getAll(
        storeId: storeId,
        categoryId: categoryId,
      );
      return Right(products);
    } on LocalException catch (e) {
      return Left(LocalFailure(e.message));
    }
  }

  @override
  Stream<Either<Failure, List<Product>>> watchActiveByCategory({
    required String storeId,
    String? categoryId,
  }) {
    return _localDs
        .watchActiveByCategory(storeId: storeId, categoryId: categoryId)
        .map<Either<Failure, List<Product>>>(Right.new)
        .handleError(
          (e) => Left<Failure, List<Product>>(
            LocalFailure(e is LocalException ? e.message : e.toString()),
          ),
        );
  }

  @override
  Future<Either<Failure, Unit>> add(Product product) async {
    try {
      await _localDs.save(product);
      return const Right(unit);
    } on LocalException catch (e) {
      return Left(LocalFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> update(Product product) async {
    try {
      await _localDs.save(
        product.copyWith(
          syncStatus: 'pending',
          updatedAt: DateTime.now(),
        ),
      );
      return const Right(unit);
    } on LocalException catch (e) {
      return Left(LocalFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> syncPending() async {
    try {
      final pending = await _localDs.getPending();
      for (final product in pending) {
        try {
          final serverId = await _remoteDs.pushProduct(product);
          await _localDs.markSynced(product.id, serverId);
        } on RemoteException {
          // Log and continue — one failure should not block the rest
          continue;
        }
      }
      return const Right(unit);
    } on LocalException catch (e) {
      return Left(SyncFailure(e.message));
    }
  }
}
