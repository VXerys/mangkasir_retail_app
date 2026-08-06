import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../core/error/exceptions.dart';
import '../models/brand_model.dart';

abstract class BrandRemoteDs {
  Future<List<BrandModel>> getAll(int businessId);
  Future<BrandModel> create(BrandModel model);
  Future<BrandModel> update(BrandModel model);
  Future<void> deactivate(int id);
}

@LazySingleton(as: BrandRemoteDs)
class BrandRemoteDsImpl implements BrandRemoteDs {
  final SupabaseClient _client;

  BrandRemoteDsImpl(this._client);

  static const _cols = 'id, name, business_id, is_active';

  @override
  Future<List<BrandModel>> getAll(int businessId) async {
    try {
      final data = await _client
          .from('brands')
          .select(_cols)
          .eq('business_id', businessId)
          .eq('is_active', true)
          .order('name');
      return (data as List)
          .map((e) => BrandModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on PostgrestException catch (e) {
      throw RemoteException('getBrands failed: ${e.message}');
    } catch (e) {
      throw RemoteException('getBrands failed: $e');
    }
  }

  @override
  Future<BrandModel> create(BrandModel model) async {
    try {
      final data = await _client
          .from('brands')
          .insert(model.toInsertJson())
          .select(_cols)
          .single();
      return BrandModel.fromJson(data);
    } on PostgrestException catch (e) {
      throw RemoteException('createBrand failed: ${e.message}');
    } catch (e) {
      throw RemoteException('createBrand failed: $e');
    }
  }

  @override
  Future<BrandModel> update(BrandModel model) async {
    try {
      final data = await _client
          .from('brands')
          .update(model.toUpdateJson())
          .eq('id', model.id)
          .select(_cols)
          .single();
      return BrandModel.fromJson(data);
    } on PostgrestException catch (e) {
      throw RemoteException('updateBrand failed: ${e.message}');
    } catch (e) {
      throw RemoteException('updateBrand failed: $e');
    }
  }

  @override
  Future<void> deactivate(int id) async {
    try {
      await _client.from('brands').update({'is_active': false}).eq('id', id);
    } on PostgrestException catch (e) {
      throw RemoteException('deactivateBrand failed: ${e.message}');
    } catch (e) {
      throw RemoteException('deactivateBrand failed: $e');
    }
  }
}
