import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/error/exceptions.dart';
import '../models/purchase_order_model.dart';

abstract class PurchaseRemoteDs {
  // Orders
  Future<List<PurchaseOrderModel>> getOrders(int outletId, {int? supplierId, String? status});
  Future<PurchaseOrderModel> getOrderById(int id);
  Future<PurchaseOrderModel> createOrder(PurchaseOrderModel model);
  Future<PurchaseOrderModel> updateOrderStatus(int id, String status);

  // Receiving
  Future<void> receiveItems({
    required int poId,
    required int warehouseId,
    required List<Map<String, dynamic>> items,
    String? notes,
  });

  // Returns
  Future<void> returnItems({
    required int poId,
    required int supplierId,
    required String reason,
    required List<Map<String, dynamic>> items,
  });
}

@LazySingleton(as: PurchaseRemoteDs)
class PurchaseRemoteDsImpl implements PurchaseRemoteDs {
  final SupabaseClient _client;

  PurchaseRemoteDsImpl(this._client);

  static const _poCols =
      'id, po_number, supplier_id, warehouse_id, status, subtotal, tax_amount, discount_amount, total_amount, notes, created_by, created_at, suppliers(name), warehouses(name), purchase_order_items(product_id, qty_ordered, qty_received, unit_price, total_price, products(name))';

  @override
  Future<List<PurchaseOrderModel>> getOrders(int outletId, {int? supplierId, String? status}) async {
    try {
      var query = _client.from('purchase_orders').select(_poCols);

      if (supplierId != null) query = query.eq('supplier_id', supplierId);
      if (status != null) query = query.eq('status', status);

      final data = await query.order('created_at', ascending: false);
      return (data as List).map((e) => PurchaseOrderModel.fromJson(e as Map<String, dynamic>)).toList();
    } on PostgrestException catch (e) {
      throw RemoteException('getOrders failed: ${e.message}');
    } catch (e) {
      throw RemoteException('getOrders failed: $e');
    }
  }

  @override
  Future<PurchaseOrderModel> getOrderById(int id) async {
    try {
      final data = await _client.from('purchase_orders').select(_poCols).eq('id', id).single();
      return PurchaseOrderModel.fromJson(data);
    } on PostgrestException catch (e) {
      throw RemoteException('getOrderById failed: ${e.message}');
    } catch (e) {
      throw RemoteException('getOrderById failed: $e');
    }
  }

  @override
  Future<PurchaseOrderModel> createOrder(PurchaseOrderModel model) async {
    try {
      final data = await _client
          .from('purchase_orders')
          .insert(model.toInsertJson())
          .select(_poCols)
          .single();
      final po = PurchaseOrderModel.fromJson(data);

      if (model.items.isNotEmpty) {
        final itemsData = model.items.map((i) => {
              'po_id': po.id,
              'product_id': i.productId,
              'qty_ordered': i.qtyOrdered,
              'unit_price': i.unitPrice,
              'total_price': i.totalPrice,
            }).toList();
        await _client.from('purchase_order_items').insert(itemsData);
      }

      return getOrderById(po.id);
    } on PostgrestException catch (e) {
      throw RemoteException('createOrder failed: ${e.message}');
    } catch (e) {
      throw RemoteException('createOrder failed: $e');
    }
  }

  @override
  Future<PurchaseOrderModel> updateOrderStatus(int id, String status) async {
    try {
      await _client.from('purchase_orders').update({'status': status}).eq('id', id);
      return getOrderById(id);
    } on PostgrestException catch (e) {
      throw RemoteException('updateOrderStatus failed: ${e.message}');
    } catch (e) {
      throw RemoteException('updateOrderStatus failed: $e');
    }
  }

  @override
  Future<void> receiveItems({
    required int poId,
    required int warehouseId,
    required List<Map<String, dynamic>> items,
    String? notes,
  }) async {
    try {
      for (final item in items) {
        final productId = item['product_id'] as int;
        final qtyReceived = (item['qty_received'] as num).toDouble();

        // Mutasi stok inbound
        await _client.from('stock_movements').insert({
          'product_id': productId,
          'warehouse_id': warehouseId,
          'movement_type': 'in',
          'qty': qtyReceived,
          'balance_after': 0.0,
          'reference_type': 'purchase',
          'reference_id': poId.toString(),
          'notes': notes ?? 'Penerimaan PO #$poId',
        });
      }

      await updateOrderStatus(poId, 'completed');
    } on PostgrestException catch (e) {
      throw RemoteException('receiveItems failed: ${e.message}');
    } catch (e) {
      throw RemoteException('receiveItems failed: $e');
    }
  }

  @override
  Future<void> returnItems({
    required int poId,
    required int supplierId,
    required String reason,
    required List<Map<String, dynamic>> items,
  }) async {
    try {
      for (final item in items) {
        final productId = item['product_id'] as int;
        final qtyReturned = (item['qty_returned'] as num).toDouble();

        // Mutasi stok outbound (retur)
        await _client.from('stock_movements').insert({
          'product_id': productId,
          'warehouse_id': 1,
          'movement_type': 'out',
          'qty': -qtyReturned,
          'balance_after': 0.0,
          'reference_type': 'return',
          'reference_id': poId.toString(),
          'notes': 'Retur PO #$poId: $reason',
        });
      }
    } on PostgrestException catch (e) {
      throw RemoteException('returnItems failed: ${e.message}');
    } catch (e) {
      throw RemoteException('returnItems failed: $e');
    }
  }
}
