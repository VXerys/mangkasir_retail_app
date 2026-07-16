import 'package:injectable/injectable.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/payment.dart';
import '../models/payment_model.dart';

abstract class PaymentLocalDs {
  Future<void> save(Payment payment);
  Future<List<Payment>> getPending();
  Future<void> markSynced(String id, String? serverId);
}

@LazySingleton(as: PaymentLocalDs)
class PaymentLocalDsImpl implements PaymentLocalDs {
  final AppDatabase _db;

  PaymentLocalDsImpl(this._db);

  @override
  Future<void> save(Payment payment) async {
    try {
      await _db.paymentDao.insert(
        PaymentModel.fromEntity(payment).toDriftCompanion(),
      );
    } catch (e) {
      throw LocalException('save failed: $e');
    }
  }

  @override
  Future<List<Payment>> getPending() async {
    try {
      final rows = await _db.paymentDao.getPending();
      return rows.map((r) => PaymentModel.fromDrift(r).toEntity()).toList();
    } catch (e) {
      throw LocalException('getPending failed: $e');
    }
  }

  @override
  Future<void> markSynced(String id, String? serverId) async {
    try {
      await _db.paymentDao.markSynced(id, serverId);
    } catch (e) {
      throw LocalException('markSynced failed: $e');
    }
  }
}
