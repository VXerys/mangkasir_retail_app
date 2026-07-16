import 'package:drift/drift.dart';

import '../../../../core/database/tables/transaction_table.dart';
import '../../domain/entities/transaction.dart';

class TransactionModel {
  final String id;
  final String guid;
  final String storeId;
  final double subTotal;
  final double discount;
  final double tax;
  final String paymentMethod;
  final String flag;
  final String? invoice;
  final String? customerName;
  final String? cashierId;
  final DateTime? date;
  final String syncStatus;
  final String? serverId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const TransactionModel({
    required this.id,
    required this.guid,
    required this.storeId,
    required this.subTotal,
    required this.discount,
    required this.tax,
    required this.paymentMethod,
    required this.flag,
    this.invoice,
    this.customerName,
    this.cashierId,
    this.date,
    required this.syncStatus,
    this.serverId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TransactionModel.fromDrift(TransactionTableData row) =>
      TransactionModel(
        id: row.id,
        guid: row.guid,
        storeId: row.storeId,
        subTotal: row.subTotal,
        discount: row.discount,
        tax: row.tax,
        paymentMethod: row.paymentMethod,
        flag: row.flag,
        invoice: row.invoice,
        customerName: row.customerName,
        cashierId: row.cashierId,
        date: row.date,
        syncStatus: row.syncStatus,
        serverId: row.serverId,
        createdAt: row.createdAt,
        updatedAt: row.updatedAt,
      );

  static TransactionModel fromEntity(Transaction e) => TransactionModel(
        id: e.id,
        guid: e.guid,
        storeId: e.storeId,
        subTotal: e.subTotal,
        discount: e.discount,
        tax: e.tax,
        paymentMethod: e.paymentMethod,
        flag: e.flag,
        invoice: e.invoice,
        customerName: e.customerName,
        cashierId: e.cashierId,
        date: e.date,
        syncStatus: e.syncStatus,
        serverId: e.serverId,
        createdAt: e.createdAt,
        updatedAt: e.updatedAt,
      );

  Transaction toEntity() => Transaction(
        id: id,
        guid: guid,
        storeId: storeId,
        subTotal: subTotal,
        discount: discount,
        tax: tax,
        paymentMethod: paymentMethod,
        flag: flag,
        invoice: invoice,
        customerName: customerName,
        cashierId: cashierId,
        date: date,
        syncStatus: syncStatus,
        serverId: serverId,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

  TransactionTableCompanion toDriftCompanion() => TransactionTableCompanion(
        id: Value(id),
        guid: Value(guid),
        storeId: Value(storeId),
        subTotal: Value(subTotal),
        discount: Value(discount),
        tax: Value(tax),
        paymentMethod: Value(paymentMethod),
        flag: Value(flag),
        invoice: Value(invoice),
        customerName: Value(customerName),
        cashierId: Value(cashierId),
        date: Value(date),
        syncStatus: Value(syncStatus),
        serverId: Value(serverId),
        createdAt: Value(createdAt),
        updatedAt: Value(updatedAt),
      );

  // Supabase: guid→guid, outlet_id (bigint), sub_total, invoice_discount, invoice_ppn
  Map<String, dynamic> toSupabaseJson() => {
        'guid': guid,
        'outlet_id': int.tryParse(storeId),
        'sub_total': subTotal,
        'invoice_discount': discount,
        'invoice_ppn': tax,
        'flag': flag,
        if (invoice != null) 'invoice': invoice,
        if (customerName != null) 'customer_name': customerName,
        if (cashierId != null) 'cashier_id': int.tryParse(cashierId!),
        if (date != null) 'date': date!.toIso8601String(),
      };
}
