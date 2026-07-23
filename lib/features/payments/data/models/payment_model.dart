import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../domain/entities/payment.dart';

class PaymentModel {
  final String id;
  final String guid;
  final String transactionGuid;
  final double amount;
  final double changeAmount;
  final double subTotal;
  final String method;
  final String? notes;
  final DateTime? date;
  final String syncStatus;
  final String? serverId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PaymentModel({
    required this.id,
    required this.guid,
    required this.transactionGuid,
    required this.amount,
    required this.changeAmount,
    required this.subTotal,
    required this.method,
    this.notes,
    this.date,
    required this.syncStatus,
    this.serverId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PaymentModel.fromDrift(PaymentTableData row) => PaymentModel(
        id: row.id,
        guid: row.guid,
        transactionGuid: row.transactionGuid,
        amount: row.amount,
        changeAmount: row.changeAmount,
        subTotal: row.subTotal,
        method: row.method,
        notes: row.notes,
        date: row.date,
        syncStatus: row.syncStatus,
        serverId: row.serverId,
        createdAt: row.createdAt,
        updatedAt: row.updatedAt,
      );

  static PaymentModel fromEntity(Payment e) => PaymentModel(
        id: e.id,
        guid: e.guid,
        transactionGuid: e.transactionGuid,
        amount: e.amount,
        changeAmount: e.changeAmount,
        subTotal: e.subTotal,
        method: e.method,
        notes: e.notes,
        date: e.date,
        syncStatus: e.syncStatus,
        serverId: e.serverId,
        createdAt: e.createdAt,
        updatedAt: e.updatedAt,
      );

  Payment toEntity() => Payment(
        id: id,
        guid: guid,
        transactionGuid: transactionGuid,
        amount: amount,
        changeAmount: changeAmount,
        subTotal: subTotal,
        method: method,
        notes: notes,
        date: date,
        syncStatus: syncStatus,
        serverId: serverId,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

  PaymentTableCompanion toDriftCompanion() => PaymentTableCompanion(
        id: Value(id),
        guid: Value(guid),
        transactionGuid: Value(transactionGuid),
        amount: Value(amount),
        changeAmount: Value(changeAmount),
        subTotal: Value(subTotal),
        method: Value(method),
        notes: Value(notes),
        date: Value(date),
        syncStatus: Value(syncStatus),
        serverId: Value(serverId),
        createdAt: Value(createdAt),
        updatedAt: Value(updatedAt),
      );

  // payment_methode is Supabase typo — intentional server column name
  Map<String, dynamic> toSupabaseJson() => {
        'guid': guid,
        'transaction_guid': transactionGuid,
        'paid': amount,
        'change_amount': changeAmount,
        'sub_total': subTotal,
        'payment_methode': method,
        if (notes != null) 'notes': notes,
        if (date != null) 'date': date!.toIso8601String(),
      };
}
