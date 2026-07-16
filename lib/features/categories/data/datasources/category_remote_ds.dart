import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/error/exceptions.dart';
import '../../domain/entities/category.dart';
import '../models/category_model.dart';

abstract class CategoryRemoteDs {
  /// Upserts category to Supabase on conflict(uuid). Returns server bigint id as string.
  Future<String?> pushCategory(Category category);
}

@LazySingleton(as: CategoryRemoteDs)
class CategoryRemoteDsImpl implements CategoryRemoteDs {
  final SupabaseClient _client;

  CategoryRemoteDsImpl(this._client);

  @override
  Future<String?> pushCategory(Category category) async {
    try {
      final payload = CategoryModel.fromEntity(category).toSupabaseJson();
      final response = await _client
          .from('categories')
          .upsert(payload, onConflict: 'uuid')
          .select('id')
          .single();
      return response['id']?.toString();
    } on PostgrestException catch (e) {
      throw RemoteException('pushCategory failed: ${e.message}');
    } catch (e) {
      throw RemoteException('pushCategory failed: $e');
    }
  }
}
