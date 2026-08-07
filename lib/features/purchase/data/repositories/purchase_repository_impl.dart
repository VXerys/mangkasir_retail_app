import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/purchase_order.dart';
import '../../domain/repositories/purchase_repository.dart';
import '../datasources/purchase_remote_ds.dart';
import '../models/purchase_order_model.dart';

@LazySingleton(as: PurchaseRepository)
class PurchaseRepositoryImpl implements PurchaseRepository {
  final PurchaseRemoteDs _remoteDs;

  const PurchaseRepositoryImpl(this._remoteDs);

  @override
  Future<Either<Failure, List<PurchaseOrder>>> getOrders(int outletId, {int? supplierId, String? status}) async {
    try {
      final models = await _remoteDs.getOrders(outletId, supplierId: supplierId, status: status);
      return Right(models.map((m) => m.toEntity()).toList());
    } on RemoteException catch (e) {
      return Left(RemoteFailure(e.message));
    } catch (e) {
      return Left(RemoteFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PurchaseOrder>> getOrderById(int id) async {
    try {
      final model = await _remoteDs.getOrderById(id);
      return Right(model.toEntity());
    } on RemoteException catch (e) {
      return Left(RemoteFailure(e.message));
    } catch (e) {
      return Left(RemoteFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PurchaseOrder>> createOrder(PurchaseOrder order) async {
    try {
      final created = await _remoteDs.createOrder(PurchaseOrderModel.fromEntity(order));
      return Right(created.toEntity());
    } on RemoteException catch (e) {
      return Left(RemoteFailure(e.message));
    } catch (e) {
      return Left(RemoteFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PurchaseOrder>> updateOrderStatus(int id, String status) async {
    try {
      final updated = await _remoteDs.updateOrderStatus(id, status);
      return Right(updated.toEntity());
    } on RemoteException catch (e) {
      return Left(RemoteFailure(e.message));
    } catch (e) {
      return Left(RemoteFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> receiveItems({
    required int poId,
    required int warehouseId,
    required List<Map<String, dynamic>> items,
    String? notes,
  }) async {
    try {
      await _remoteDs.receiveItems(poId: poId, warehouseId: warehouseId, items: items, notes: notes);
      return const Right(unit);
    } on RemoteException catch (e) {
      return Left(RemoteFailure(e.message));
    } catch (e) {
      return Left(RemoteFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> returnItems({
    required int poId,
    required int supplierId,
    required String reason,
    required List<Map<String, dynamic>> items,
  }) async {
    try {
      await _remoteDs.returnItems(poId: poId, supplierId: supplierId, reason: reason, items: items);
      return const Right(unit);
    } on RemoteException catch (e) {
      return Left(RemoteFailure(e.message));
    } catch (e) {
      return Left(RemoteFailure(e.toString()));
    }
  }
}
