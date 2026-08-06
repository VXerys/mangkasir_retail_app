import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/error/exceptions.dart';
import '../models/outlet_model.dart';

abstract class OutletRemoteDs {
  Future<List<OutletModel>> getOutlets(int businessId);
  Future<OutletModel> createOutlet(OutletModel model);
  Future<OutletModel> updateOutlet(OutletModel model);
}

@LazySingleton(as: OutletRemoteDs)
class OutletRemoteDsImpl implements OutletRemoteDs {
  final SupabaseClient _client;

  OutletRemoteDsImpl(this._client);

  static const _cols =
      'id, uuid, business_id, name, currency, is_active, address, phone';

  @override
  Future<List<OutletModel>> getOutlets(int businessId) async {
    try {
      final data = await _client
          .from('outlets')
          .select(_cols)
          .eq('business_id', businessId)
          .order('name');
      return (data as List)
          .map((e) => OutletModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on PostgrestException catch (e) {
      throw RemoteException('getOutlets failed: ${e.message}');
    } catch (e) {
      throw RemoteException('getOutlets failed: $e');
    }
  }

  @override
  Future<OutletModel> createOutlet(OutletModel model) async {
    try {
      final data = await _client
          .from('outlets')
          .insert(model.toInsertJson())
          .select(_cols)
          .single();
      return OutletModel.fromJson(data);
    } on PostgrestException catch (e) {
      throw RemoteException('createOutlet failed: ${e.message}');
    } catch (e) {
      throw RemoteException('createOutlet failed: $e');
    }
  }

  @override
  Future<OutletModel> updateOutlet(OutletModel model) async {
    try {
      final data = await _client
          .from('outlets')
          .update(model.toUpdateJson())
          .eq('id', model.id)
          .select(_cols)
          .single();
      return OutletModel.fromJson(data);
    } on PostgrestException catch (e) {
      throw RemoteException('updateOutlet failed: ${e.message}');
    } catch (e) {
      throw RemoteException('updateOutlet failed: $e');
    }
  }
}
