import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../core/error/exceptions.dart';
import '../../domain/entities/tax_settings.dart';

abstract class TaxRemoteDs {
  Future<TaxSettings> get(int outletId);
  Future<TaxSettings> save(TaxSettings settings);
}

@LazySingleton(as: TaxRemoteDs)
class TaxRemoteDsImpl implements TaxRemoteDs {
  final SupabaseClient _client;

  TaxRemoteDsImpl(this._client);

  @override
  Future<TaxSettings> get(int outletId) async {
    try {
      final data = await _client
          .from('outlet_settings')
          .select('key, value')
          .eq('outlet_id', outletId)
          .inFilter('key', ['tax_name', 'tax_rate', 'tax_inclusive', 'tax_enabled']);
      final map = {for (final row in data as List) row['key'] as String: row['value'] as String?};

      return TaxSettings(
        outletId: outletId,
        taxName: map['tax_name'] ?? 'PPN',
        taxRate: double.tryParse(map['tax_rate'] ?? '') ?? 11.0,
        isInclusive: map['tax_inclusive'] == 'true',
        isEnabled: map['tax_enabled'] == 'true',
      );
    } on PostgrestException catch (e) {
      throw RemoteException('getTaxSettings failed: ${e.message}');
    } catch (e) {
      throw RemoteException('getTaxSettings failed: $e');
    }
  }

  @override
  Future<TaxSettings> save(TaxSettings settings) async {
    try {
      final rows = [
        {'outlet_id': settings.outletId, 'key': 'tax_name', 'value': settings.taxName},
        {'outlet_id': settings.outletId, 'key': 'tax_rate', 'value': settings.taxRate.toString()},
        {
          'outlet_id': settings.outletId,
          'key': 'tax_inclusive',
          'value': settings.isInclusive.toString()
        },
        {
          'outlet_id': settings.outletId,
          'key': 'tax_enabled',
          'value': settings.isEnabled.toString()
        },
      ];
      await _client
          .from('outlet_settings')
          .upsert(rows, onConflict: 'outlet_id,key');
      return settings;
    } on PostgrestException catch (e) {
      throw RemoteException('saveTaxSettings failed: ${e.message}');
    } catch (e) {
      throw RemoteException('saveTaxSettings failed: $e');
    }
  }
}
