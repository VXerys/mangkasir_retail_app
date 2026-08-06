import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/error/exceptions.dart';
import '../models/app_user_model.dart';

abstract class UserRemoteDs {
  Future<List<AppUserModel>> getUsers(int businessId);
}

@LazySingleton(as: UserRemoteDs)
class UserRemoteDsImpl implements UserRemoteDs {
  final SupabaseClient _client;

  UserRemoteDsImpl(this._client);

  @override
  Future<List<AppUserModel>> getUsers(int businessId) async {
    try {
      final data = await _client
          .from('users')
          .select('''
            id, uuid, email, username, business_id,
            user_roles(
              id, outlet_id,
              roles!inner(name),
              outlets(name)
            )
          ''')
          .eq('business_id', businessId)
          .order('username');
      return (data as List)
          .map((e) => AppUserModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on PostgrestException catch (e) {
      throw RemoteException('getUsers failed: ${e.message}');
    } catch (e) {
      throw RemoteException('getUsers failed: $e');
    }
  }
}
