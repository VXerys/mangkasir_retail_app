import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/stock.dart';
import '../../domain/entities/stock_movement.dart';
import '../../domain/repositories/inventory_repository.dart';
import '../datasources/inventory_remote_ds.dart';
import '../models/stock_movement_model.dart';

@LazySingleton(as: InventoryRepository)
class InventoryRepositoryImpl implements InventoryRepository {
  final InventoryRemoteDs _remoteDs;

  const InventoryRepositoryImpl(this._remoteDs);

  @override
  Future<Either<Failure, List<Stock>>> getStocks(int outletId, {int? warehouseId}) async {
    try {
      final models = await _remoteDs.getStocks(outletId, warehouseId: warehouseId);
      return Right(models.map((m) => m.toEntity()).toList());
    } on RemoteException catch (e) {
      return Left(RemoteFailure(e.message));
    } catch (e) {
      return Left(RemoteFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Stock>> getStockByProduct(int productId, int warehouseId) async {
    try {
      final model = await _remoteDs.getStockByProduct(productId, warehouseId);
      return Right(model.toEntity());
    } on RemoteException catch (e) {
      return Left(RemoteFailure(e.message));
    } catch (e) {
      return Left(RemoteFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<StockMovement>>> getMovements(
    int outletId, {
    int? productId,
    int? warehouseId,
    String? movementType,
  }) async {
    try {
      final models = await _remoteDs.getMovements(
        outletId,
        productId: productId,
        warehouseId: warehouseId,
        movementType: movementType,
      );
      return Right(models.map((m) => m.toEntity()).toList());
    } on RemoteException catch (e) {
      return Left(RemoteFailure(e.message));
    } catch (e) {
      return Left(RemoteFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, StockMovement>> recordMovement(StockMovement movement) async {
    try {
      final recorded = await _remoteDs.recordMovement(StockMovementModel.fromEntity(movement));
      return Right(recorded.toEntity());
    } on RemoteException catch (e) {
      return Left(RemoteFailure(e.message));
    } catch (e) {
      return Left(RemoteFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> createAdjustment({
    required int warehouseId,
    required String reason,
    required List<Map<String, dynamic>> items,
  }) async {
    try {
      await _remoteDs.createAdjustment(
        warehouseId: warehouseId,
        reason: reason,
        items: items,
      );
      return const Right(unit);
    } on RemoteException catch (e) {
      return Left(RemoteFailure(e.message));
    } catch (e) {
      return Left(RemoteFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> createTransfer({
    required int fromWarehouseId,
    required int toWarehouseId,
    required List<Map<String, dynamic>> items,
    String? notes,
  }) async {
    try {
      await _remoteDs.createTransfer(
        fromWarehouseId: fromWarehouseId,
        toWarehouseId: toWarehouseId,
        items: items,
        notes: notes,
      );
      return const Right(unit);
    } on RemoteException catch (e) {
      return Left(RemoteFailure(e.message));
    } catch (e) {
      return Left(RemoteFailure(e.toString()));
    }
  }
}
