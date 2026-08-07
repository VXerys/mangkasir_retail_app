import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/stock.dart';
import '../entities/stock_movement.dart';

abstract class InventoryRepository {
  // Stocks
  Future<Either<Failure, List<Stock>>> getStocks(int outletId, {int? warehouseId});
  Future<Either<Failure, Stock>> getStockByProduct(int productId, int warehouseId);

  // Stock Movements (Ledger)
  Future<Either<Failure, List<StockMovement>>> getMovements(
    int outletId, {
    int? productId,
    int? warehouseId,
    String? movementType,
  });
  Future<Either<Failure, StockMovement>> recordMovement(StockMovement movement);

  // Stock Adjustment & Transfer
  Future<Either<Failure, Unit>> createAdjustment({
    required int warehouseId,
    required String reason,
    required List<Map<String, dynamic>> items,
  });
  Future<Either<Failure, Unit>> createTransfer({
    required int fromWarehouseId,
    required int toWarehouseId,
    required List<Map<String, dynamic>> items,
    String? notes,
  });
}
