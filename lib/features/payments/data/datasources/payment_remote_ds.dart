import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/error/exceptions.dart';
import '../../domain/entities/payment.dart';
import '../models/payment_model.dart';

abstract class PaymentRemoteDs {
  Future<String?> pushPayment(Payment payment);
}

@LazySingleton(as: PaymentRemoteDs)
class PaymentRemoteDsImpl implements PaymentRemoteDs {
  final SupabaseClient _client;

  PaymentRemoteDsImpl(this._client);

  @override
  Future<String?> pushPayment(Payment payment) async {
    try {
      final response = await _client
          .from('payments')
          .upsert(
            PaymentModel.fromEntity(payment).toSupabaseJson(),
            onConflict: 'guid',
          )
          .select('id')
          .single();
      return response['id']?.toString();
    } on PostgrestException catch (e) {
      throw RemoteException('pushPayment failed: ${e.message}');
    } catch (e) {
      throw RemoteException('pushPayment failed: $e');
    }
  }
}
