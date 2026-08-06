import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/error/exceptions.dart';
import '../models/warehouse_model.dart';

abstract class WarehouseRemoteDs {
  Future<List<WarehouseModel>> getAll(int outletId);
  Future<WarehouseModel> create(WarehouseModel model);
  Future<WarehouseModel> update(WarehouseModel model);
  Future<void> deactivate(int id);
}

@LazySingleton(as: WarehouseRemoteDs)
class WarehouseRemoteDsImpl implements WarehouseRemoteDs {
  final SupabaseClient _client;

  WarehouseRemoteDsImpl(this._client);

  static const _cols = 'id, name, outlet_id, is_default, is_active';

  @override
  Future<List<WarehouseModel>> getAll(int outletId) async {
    try {
      final data = await _client
          .from('warehouses')
          .select(_cols)
          .eq('outlet_id', outletId)
          .eq('is_active', true)
          .order('is_default', ascending: false)
          .order('name');
      return (data as List)
          .map((e) => WarehouseModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on PostgrestException catch (e) {
      throw RemoteException('getWarehouses failed: ${e.message}');
    } catch (e) {
      throw RemoteException('getWarehouses failed: $e');
    }
  }

  @override
  Future<WarehouseModel> create(WarehouseModel model) async {
    try {
      final data = await _client
          .from('warehouses')
          .insert(model.toInsertJson())
          .select(_cols)
          .single();
      return WarehouseModel.fromJson(data);
    } on PostgrestException catch (e) {
      throw RemoteException('createWarehouse failed: ${e.message}');
    } catch (e) {
      throw RemoteException('createWarehouse failed: $e');
    }
  }

  @override
  Future<WarehouseModel> update(WarehouseModel model) async {
    try {
      final data = await _client
          .from('warehouses')
          .update(model.toUpdateJson())
          .eq('id', model.id)
          .select(_cols)
          .single();
      return WarehouseModel.fromJson(data);
    } on PostgrestException catch (e) {
      throw RemoteException('updateWarehouse failed: ${e.message}');
    } catch (e) {
      throw RemoteException('updateWarehouse failed: $e');
    }
  }

  @override
  Future<void> deactivate(int id) async {
    try {
      await _client.from('warehouses').update({'is_active': false}).eq('id', id);
    } on PostgrestException catch (e) {
      throw RemoteException('deactivateWarehouse failed: ${e.message}');
    } catch (e) {
      throw RemoteException('deactivateWarehouse failed: $e');
    }
  }
}
