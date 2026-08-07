import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangkasir_retail_app/core/error/failures.dart';
import 'package:mangkasir_retail_app/features/inventory/domain/entities/stock.dart';
import 'package:mangkasir_retail_app/features/inventory/domain/entities/stock_movement.dart';
import 'package:mangkasir_retail_app/features/inventory/domain/repositories/inventory_repository.dart';
import 'package:mangkasir_retail_app/features/inventory/presentation/bloc/movement_cubit.dart';
import 'package:mangkasir_retail_app/features/inventory/presentation/bloc/movement_state.dart';
import 'package:mangkasir_retail_app/features/inventory/presentation/bloc/stock_cubit.dart';
import 'package:mangkasir_retail_app/features/inventory/presentation/bloc/stock_state.dart';

class FakeInventoryRepository implements InventoryRepository {
  final List<Stock> stocks = [];
  final List<StockMovement> movements = [];

  @override
  Future<Either<Failure, List<Stock>>> getStocks(int outletId, {int? warehouseId}) async {
    return Right(stocks);
  }

  @override
  Future<Either<Failure, Stock>> getStockByProduct(int productId, int warehouseId) async {
    final s = stocks.where((x) => x.productId == productId && x.warehouseId == warehouseId).firstOrNull;
    if (s == null) return const Left(RemoteFailure('Stock not found'));
    return Right(s);
  }

  @override
  Future<Either<Failure, List<StockMovement>>> getMovements(
    int outletId, {
    int? productId,
    int? warehouseId,
    String? movementType,
  }) async {
    return Right(movements);
  }

  @override
  Future<Either<Failure, StockMovement>> recordMovement(StockMovement movement) async {
    movements.add(movement);
    return Right(movement);
  }

  @override
  Future<Either<Failure, Unit>> createAdjustment({
    required int warehouseId,
    required String reason,
    required List<Map<String, dynamic>> items,
  }) async {
    return const Right(unit);
  }

  @override
  Future<Either<Failure, Unit>> createTransfer({
    required int fromWarehouseId,
    required int toWarehouseId,
    required List<Map<String, dynamic>> items,
    String? notes,
  }) async {
    return const Right(unit);
  }
}

void main() {
  group('StockCubit Tests', () {
    late FakeInventoryRepository repo;
    late StockCubit cubit;

    setUp(() {
      repo = FakeInventoryRepository();
      cubit = StockCubit(repo);
    });

    tearDown(() {
      cubit.close();
    });

    test('load emits StockLoaded', () async {
      await cubit.load(1);
      expect(cubit.state, isA<StockLoaded>());
      expect((cubit.state as StockLoaded).stocks, isEmpty);
    });
  });

  group('MovementCubit Tests', () {
    late FakeInventoryRepository repo;
    late MovementCubit cubit;

    setUp(() {
      repo = FakeInventoryRepository();
      cubit = MovementCubit(repo);
    });

    tearDown(() {
      cubit.close();
    });

    test('load emits MovementLoaded', () async {
      await cubit.load(1);
      expect(cubit.state, isA<MovementLoaded>());
      expect((cubit.state as MovementLoaded).movements, isEmpty);
    });
  });
}
