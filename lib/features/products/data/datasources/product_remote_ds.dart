import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/error/exceptions.dart';
import '../../domain/entities/product.dart';
import '../models/product_model.dart';

abstract class ProductRemoteDs {
  /// Upserts product to Supabase on conflict(uuid). Returns server bigint id as string.
  Future<String?> pushProduct(Product product);
}

@LazySingleton(as: ProductRemoteDs)
class ProductRemoteDsImpl implements ProductRemoteDs {
  final SupabaseClient _client;

  ProductRemoteDsImpl(this._client);

  @override
  Future<String?> pushProduct(Product product) async {
    try {
      final payload = ProductModel.fromEntity(product).toSupabaseJson();
      final response = await _client
          .from('products')
          .upsert(payload, onConflict: 'uuid')
          .select('id')
          .single();
      return response['id']?.toString();
    } on PostgrestException catch (e) {
      throw RemoteException('pushProduct failed: ${e.message}');
    } catch (e) {
      throw RemoteException('pushProduct failed: $e');
    }
  }
}
