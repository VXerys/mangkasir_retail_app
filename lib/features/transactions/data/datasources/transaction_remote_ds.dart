import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/error/exceptions.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/entities/transaction_detail.dart';
import '../models/transaction_detail_model.dart';
import '../models/transaction_model.dart';

abstract class TransactionRemoteDs {
  /// Pushes transaction header + details. Returns server transaction bigint id.
  Future<String?> pushTransaction(
    Transaction transaction,
    List<TransactionDetail> details,
  );
}

@LazySingleton(as: TransactionRemoteDs)
class TransactionRemoteDsImpl implements TransactionRemoteDs {
  final SupabaseClient _client;

  TransactionRemoteDsImpl(this._client);

  @override
  Future<String?> pushTransaction(
    Transaction transaction,
    List<TransactionDetail> details,
  ) async {
    try {
      // Upsert transaction header on conflict(guid)
      final trxResponse = await _client
          .from('transactions')
          .upsert(
            TransactionModel.fromEntity(transaction).toSupabaseJson(),
            onConflict: 'guid',
          )
          .select('id')
          .single();
      final serverId = trxResponse['id']?.toString();

      // Push details (transaction must exist first since Supabase FK on guid)
      if (details.isNotEmpty) {
        final detailPayloads = details
            .map((d) => TransactionDetailModel.fromEntity(d).toSupabaseJson())
            .toList();
        await _client.from('transaction_details').upsert(
              detailPayloads,
              onConflict: 'transaction_guid,product_guid',
            );
      }

      return serverId;
    } on PostgrestException catch (e) {
      throw RemoteException('pushTransaction failed: ${e.message}');
    } catch (e) {
      throw RemoteException('pushTransaction failed: $e');
    }
  }
}
