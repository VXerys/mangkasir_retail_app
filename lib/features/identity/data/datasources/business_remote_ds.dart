import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/error/exceptions.dart';
import '../models/business_model.dart';

abstract class BusinessRemoteDs {
  Future<BusinessModel> getBusiness(int businessId);
  Future<BusinessModel> updateBusiness(BusinessModel model);
}

@LazySingleton(as: BusinessRemoteDs)
class BusinessRemoteDsImpl implements BusinessRemoteDs {
  final SupabaseClient _client;

  BusinessRemoteDsImpl(this._client);

  @override
  Future<BusinessModel> getBusiness(int businessId) async {
    try {
      final data = await _client
          .from('businesses')
          .select('id, uuid, name, currency, phone, address, email, tax_number, logo_url')
          .eq('id', businessId)
          .single();
      return BusinessModel.fromJson(data);
    } on PostgrestException catch (e) {
      throw RemoteException('getBusiness failed: ${e.message}');
    } catch (e) {
      throw RemoteException('getBusiness failed: $e');
    }
  }

  @override
  Future<BusinessModel> updateBusiness(BusinessModel model) async {
    try {
      final data = await _client
          .from('businesses')
          .update(model.toUpdateJson())
          .eq('id', model.id)
          .select('id, uuid, name, currency, phone, address, email, tax_number, logo_url')
          .single();
      return BusinessModel.fromJson(data);
    } on PostgrestException catch (e) {
      throw RemoteException('updateBusiness failed: ${e.message}');
    } catch (e) {
      throw RemoteException('updateBusiness failed: $e');
    }
  }
}
