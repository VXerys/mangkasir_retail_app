import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../core/error/exceptions.dart';
import '../models/unit_model.dart';

abstract class UnitRemoteDs {
  Future<List<UnitModel>> getAll(int businessId);
  Future<UnitModel> create(UnitModel model);
  Future<UnitModel> update(UnitModel model);
  Future<void> delete(int id);
}

@LazySingleton(as: UnitRemoteDs)
class UnitRemoteDsImpl implements UnitRemoteDs {
  final SupabaseClient _client;

  UnitRemoteDsImpl(this._client);

  static const _cols = 'id, name, symbol, business_id, decimal_places';

  @override
  Future<List<UnitModel>> getAll(int businessId) async {
    try {
      final data = await _client
          .from('units')
          .select(_cols)
          .eq('business_id', businessId)
          .order('name');
      return (data as List)
          .map((e) => UnitModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on PostgrestException catch (e) {
      throw RemoteException('getUnits failed: ${e.message}');
    } catch (e) {
      throw RemoteException('getUnits failed: $e');
    }
  }

  @override
  Future<UnitModel> create(UnitModel model) async {
    try {
      final data = await _client
          .from('units')
          .insert(model.toInsertJson())
          .select(_cols)
          .single();
      return UnitModel.fromJson(data);
    } on PostgrestException catch (e) {
      throw RemoteException('createUnit failed: ${e.message}');
    } catch (e) {
      throw RemoteException('createUnit failed: $e');
    }
  }

  @override
  Future<UnitModel> update(UnitModel model) async {
    try {
      final data = await _client
          .from('units')
          .update(model.toUpdateJson())
          .eq('id', model.id)
          .select(_cols)
          .single();
      return UnitModel.fromJson(data);
    } on PostgrestException catch (e) {
      throw RemoteException('updateUnit failed: ${e.message}');
    } catch (e) {
      throw RemoteException('updateUnit failed: $e');
    }
  }

  @override
  Future<void> delete(int id) async {
    try {
      await _client.from('units').delete().eq('id', id);
    } on PostgrestException catch (e) {
      throw RemoteException('deleteUnit failed: ${e.message}');
    } catch (e) {
      throw RemoteException('deleteUnit failed: $e');
    }
  }
}
