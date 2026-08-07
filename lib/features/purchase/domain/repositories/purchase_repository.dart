import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/purchase_order.dart';

abstract class PurchaseRepository {
  Future<Either<Failure, List<PurchaseOrder>>> getOrders(int outletId, {int? supplierId, String? status});
  Future<Either<Failure, PurchaseOrder>> getOrderById(int id);
  Future<Either<Failure, PurchaseOrder>> createOrder(PurchaseOrder order);
  Future<Either<Failure, PurchaseOrder>> updateOrderStatus(int id, String status);

  Future<Either<Failure, Unit>> receiveItems({
    required int poId,
    required int warehouseId,
    required List<Map<String, dynamic>> items,
    String? notes,
  });

  Future<Either<Failure, Unit>> returnItems({
    required int poId,
    required int supplierId,
    required String reason,
    required List<Map<String, dynamic>> items,
  });
}
