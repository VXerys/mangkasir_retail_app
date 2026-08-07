import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/error/exceptions.dart';
import '../models/stock_model.dart';
import '../models/stock_movement_model.dart';

abstract class InventoryRemoteDs {
  // Stocks
  Future<List<StockModel>> getStocks(int outletId, {int? warehouseId});
  Future<StockModel> getStockByProduct(int productId, int warehouseId);

  // Movements (Immutable Stock Ledger)
  Future<List<StockMovementModel>> getMovements(
    int outletId, {
    int? productId,
    int? warehouseId,
    String? movementType,
  });
  Future<StockMovementModel> recordMovement(StockMovementModel model);

  // Adjustments & Transfers
  Future<void> createAdjustment({
    required int warehouseId,
    required String reason,
    required List<Map<String, dynamic>> items,
  });
  Future<void> createTransfer({
    required int fromWarehouseId,
    required int toWarehouseId,
    required List<Map<String, dynamic>> items,
    String? notes,
  });
}

@LazySingleton(as: InventoryRemoteDs)
class InventoryRemoteDsImpl implements InventoryRemoteDs {
  final SupabaseClient _client;

  InventoryRemoteDsImpl(this._client);

  static const _stockCols =
      'id, product_id, warehouse_id, qty, min_stock, updated_at, products(name, sku, barcode), warehouses(name)';
  static const _movementCols =
      'id, product_id, warehouse_id, movement_type, qty, balance_after, reference_type, reference_id, notes, created_by, created_at, products(name), warehouses(name)';

  // ---------------------------------------------------------------------------
  // Stocks
  // ---------------------------------------------------------------------------

  @override
  Future<List<StockModel>> getStocks(int outletId, {int? warehouseId}) async {
    try {
      var query = _client.from('stocks').select(_stockCols);
      if (warehouseId != null) {
        query = query.eq('warehouse_id', warehouseId);
      }
      final data = await query;
      return (data as List)
          .map((e) => StockModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on PostgrestException catch (e) {
      throw RemoteException('getStocks failed: ${e.message}');
    } catch (e) {
      throw RemoteException('getStocks failed: $e');
    }
  }

  @override
  Future<StockModel> getStockByProduct(int productId, int warehouseId) async {
    try {
      final data = await _client
          .from('stocks')
          .select(_stockCols)
          .eq('product_id', productId)
          .eq('warehouse_id', warehouseId)
          .single();
      return StockModel.fromJson(data);
    } on PostgrestException catch (e) {
      throw RemoteException('getStockByProduct failed: ${e.message}');
    } catch (e) {
      throw RemoteException('getStockByProduct failed: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // Movements
  // ---------------------------------------------------------------------------

  @override
  Future<List<StockMovementModel>> getMovements(
    int outletId, {
    int? productId,
    int? warehouseId,
    String? movementType,
  }) async {
    try {
      var query = _client
          .from('stock_movements')
          .select(_movementCols)
          .order('created_at', ascending: false);

      if (productId != null) query = query.eq('product_id', productId);
      if (warehouseId != null) query = query.eq('warehouse_id', warehouseId);
      if (movementType != null) query = query.eq('movement_type', movementType);

      final data = await query;
      return (data as List)
          .map((e) => StockMovementModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on PostgrestException catch (e) {
      throw RemoteException('getMovements failed: ${e.message}');
    } catch (e) {
      throw RemoteException('getMovements failed: $e');
    }
  }

  @override
  Future<StockMovementModel> recordMovement(StockMovementModel model) async {
    try {
      final data = await _client
          .from('stock_movements')
          .insert(model.toInsertJson())
          .select(_movementCols)
          .single();
      return StockMovementModel.fromJson(data);
    } on PostgrestException catch (e) {
      throw RemoteException('recordMovement failed: ${e.message}');
    } catch (e) {
      throw RemoteException('recordMovement failed: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // Adjustments & Transfers
  // ---------------------------------------------------------------------------

  @override
  Future<void> createAdjustment({
    required int warehouseId,
    required String reason,
    required List<Map<String, dynamic>> items,
  }) async {
    try {
      for (final item in items) {
        final productId = item['product_id'] as int;
        final actualQty = (item['actual_qty'] as num).toDouble();
        final currentQty = (item['current_qty'] as num).toDouble();
        final diff = actualQty - currentQty;

        if (diff != 0) {
          await recordMovement(StockMovementModel(
            id: 0,
            productId: productId,
            productName: '',
            warehouseId: warehouseId,
            warehouseName: '',
            movementType: 'adjustment',
            qty: diff,
            balanceAfter: actualQty,
            referenceType: 'adjustment',
            notes: reason,
          ));
        }
      }
    } on PostgrestException catch (e) {
      throw RemoteException('createAdjustment failed: ${e.message}');
    } catch (e) {
      throw RemoteException('createAdjustment failed: $e');
    }
  }

  @override
  Future<void> createTransfer({
    required int fromWarehouseId,
    required int toWarehouseId,
    required List<Map<String, dynamic>> items,
    String? notes,
  }) async {
    try {
      for (final item in items) {
        final productId = item['product_id'] as int;
        final qty = (item['qty'] as num).toDouble();

        // Mutasi keluar dari gudang asal
        await recordMovement(StockMovementModel(
          id: 0,
          productId: productId,
          productName: '',
          warehouseId: fromWarehouseId,
          warehouseName: '',
          movementType: 'transfer',
          qty: -qty,
          balanceAfter: 0.0,
          referenceType: 'transfer',
          notes: notes ?? 'Transfer keluar ke gudang #$toWarehouseId',
        ));

        // Mutasi masuk ke gudang tujuan
        await recordMovement(StockMovementModel(
          id: 0,
          productId: productId,
          productName: '',
          warehouseId: toWarehouseId,
          warehouseName: '',
          movementType: 'transfer',
          qty: qty,
          balanceAfter: 0.0,
          referenceType: 'transfer',
          notes: notes ?? 'Transfer masuk dari gudang #$fromWarehouseId',
        ));
      }
    } on PostgrestException catch (e) {
      throw RemoteException('createTransfer failed: ${e.message}');
    } catch (e) {
      throw RemoteException('createTransfer failed: $e');
    }
  }
}
