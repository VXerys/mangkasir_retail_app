import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangkasir_retail_app/core/error/failures.dart';
import 'package:mangkasir_retail_app/features/purchase/domain/entities/purchase_order.dart';
import 'package:mangkasir_retail_app/features/purchase/domain/repositories/purchase_repository.dart';
import 'package:mangkasir_retail_app/features/purchase/presentation/bloc/purchase_cubit.dart';
import 'package:mangkasir_retail_app/features/purchase/presentation/bloc/purchase_state.dart';

class FakePurchaseRepository implements PurchaseRepository {
  final List<PurchaseOrder> orders = [];

  @override
  Future<Either<Failure, List<PurchaseOrder>>> getOrders(int outletId, {int? supplierId, String? status}) async {
    return Right(List.from(orders));
  }

  @override
  Future<Either<Failure, PurchaseOrder>> getOrderById(int id) async {
    final po = orders.where((x) => x.id == id).firstOrNull;
    if (po == null) return const Left(RemoteFailure('PO not found'));
    return Right(po);
  }

  @override
  Future<Either<Failure, PurchaseOrder>> createOrder(PurchaseOrder order) async {
    final created = order.copyWith(id: orders.length + 1);
    orders.add(created);
    return Right(created);
  }

  @override
  Future<Either<Failure, PurchaseOrder>> updateOrderStatus(int id, String status) async {
    final idx = orders.indexWhere((x) => x.id == id);
    if (idx != -1) {
      orders[idx] = orders[idx].copyWith(status: status);
      return Right(orders[idx]);
    }
    return const Left(RemoteFailure('PO not found'));
  }

  @override
  Future<Either<Failure, Unit>> receiveItems({
    required int poId,
    required int warehouseId,
    required List<Map<String, dynamic>> items,
    String? notes,
  }) async {
    return const Right(unit);
  }

  @override
  Future<Either<Failure, Unit>> returnItems({
    required int poId,
    required int supplierId,
    required String reason,
    required List<Map<String, dynamic>> items,
  }) async {
    return const Right(unit);
  }
}

void main() {
  group('PurchaseCubit Tests', () {
    late FakePurchaseRepository repo;
    late PurchaseCubit cubit;

    setUp(() {
      repo = FakePurchaseRepository();
      cubit = PurchaseCubit(repo);
    });

    tearDown(() {
      cubit.close();
    });

    test('load emits PurchaseLoaded', () async {
      await cubit.load(1);
      expect(cubit.state, isA<PurchaseLoaded>());
      expect((cubit.state as PurchaseLoaded).orders, isEmpty);
    });

    test('create adds purchase order', () async {
      await cubit.load(1);
      await cubit.create(const PurchaseOrder(
        id: 0,
        poNumber: 'PO-001',
        supplierId: 1,
        supplierName: 'PT Supplier',
        warehouseId: 1,
        warehouseName: 'Gudang Utama',
      ));

      expect(cubit.state, isA<PurchaseLoaded>());
      final list = (cubit.state as PurchaseLoaded).orders;
      expect(list.length, equals(1));
      expect(list.first.poNumber, equals('PO-001'));
    });
  });
}
