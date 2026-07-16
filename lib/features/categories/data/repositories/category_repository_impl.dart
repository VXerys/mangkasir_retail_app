import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../products/data/datasources/product_local_ds.dart';
import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasources/category_local_ds.dart';
import '../datasources/category_remote_ds.dart';

@LazySingleton(as: CategoryRepository)
class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryLocalDs _localDs;
  final CategoryRemoteDs _remoteDs;
  final ProductLocalDs _productLocalDs;

  const CategoryRepositoryImpl(
    this._localDs,
    this._remoteDs,
    this._productLocalDs,
  );

  @override
  Future<Either<Failure, List<Category>>> getAll() async {
    try {
      return Right(await _localDs.getAll());
    } on LocalException catch (e) {
      return Left(LocalFailure(e.message));
    }
  }

  @override
  Stream<Either<Failure, List<Category>>> watchAll() {
    return _localDs
        .watchAll()
        .map<Either<Failure, List<Category>>>(Right.new)
        .handleError(
          (e) => Left<Failure, List<Category>>(
            LocalFailure(e is LocalException ? e.message : e.toString()),
          ),
        );
  }

  @override
  Future<Either<Failure, Unit>> add(Category category) async {
    try {
      await _localDs.save(category);
      return const Right(unit);
    } on LocalException catch (e) {
      return Left(LocalFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> update(Category category) async {
    try {
      await _localDs.save(
        category.copyWith(syncStatus: 'pending', updatedAt: DateTime.now()),
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
      for (final category in pending) {
        try {
          final serverId = await _remoteDs.pushCategory(category);
          await _localDs.markSynced(category.id, serverId);

          // Remap FK: products that reference this local category id must be
          // updated to use the server bigint before they are pushed.
          if (serverId != null) {
            await _productLocalDs.remapCategoryId(
              localCategoryId: category.id,
              serverCategoryId: serverId,
            );
          }
        } on RemoteException {
          continue;
        }
      }
      return const Right(unit);
    } on LocalException catch (e) {
      return Left(SyncFailure(e.message));
    }
  }
}
