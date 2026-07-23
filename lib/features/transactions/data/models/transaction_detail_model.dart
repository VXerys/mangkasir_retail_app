import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../domain/entities/transaction_detail.dart';

class TransactionDetailModel {
  final String id;
  final String guid;
  final String transactionGuid;
  final String? productGuid;
  final String productName;
  final String? productSku;
  final double price;
  final double cost;
  final double qty;
  final double discount;
  final double tax;
  final double totalPrice;
  final String syncStatus;
  final String? serverId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const TransactionDetailModel({
    required this.id,
    required this.guid,
    required this.transactionGuid,
    this.productGuid,
    required this.productName,
    this.productSku,
    required this.price,
    required this.cost,
    required this.qty,
    required this.discount,
    required this.tax,
    required this.totalPrice,
    required this.syncStatus,
    this.serverId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TransactionDetailModel.fromDrift(TransactionDetailTableData row) =>
      TransactionDetailModel(
        id: row.id,
        guid: row.guid,
        transactionGuid: row.transactionGuid,
        productGuid: row.productGuid,
        productName: row.productName,
        productSku: row.productSku,
        price: row.price,
        cost: row.cost,
        qty: row.qty,
        discount: row.discount,
        tax: row.tax,
        totalPrice: row.totalPrice,
        syncStatus: row.syncStatus,
        serverId: row.serverId,
        createdAt: row.createdAt,
        updatedAt: row.updatedAt,
      );

  static TransactionDetailModel fromEntity(TransactionDetail e) =>
      TransactionDetailModel(
        id: e.id,
        guid: e.guid,
        transactionGuid: e.transactionGuid,
        productGuid: e.productGuid,
        productName: e.productName,
        productSku: e.productSku,
        price: e.price,
        cost: e.cost,
        qty: e.qty,
        discount: e.discount,
        tax: e.tax,
        totalPrice: e.totalPrice,
        syncStatus: e.syncStatus,
        serverId: e.serverId,
        createdAt: e.createdAt,
        updatedAt: e.updatedAt,
      );

  TransactionDetail toEntity() => TransactionDetail(
        id: id,
        guid: guid,
        transactionGuid: transactionGuid,
        productGuid: productGuid,
        productName: productName,
        productSku: productSku,
        price: price,
        cost: cost,
        qty: qty,
        discount: discount,
        tax: tax,
        totalPrice: totalPrice,
        syncStatus: syncStatus,
        serverId: serverId,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

  TransactionDetailTableCompanion toDriftCompanion() =>
      TransactionDetailTableCompanion(
        id: Value(id),
        guid: Value(guid),
        transactionGuid: Value(transactionGuid),
        productGuid: Value(productGuid),
        productName: Value(productName),
        productSku: Value(productSku),
        price: Value(price),
        cost: Value(cost),
        qty: Value(qty),
        discount: Value(discount),
        tax: Value(tax),
        totalPrice: Value(totalPrice),
        syncStatus: Value(syncStatus),
        serverId: Value(serverId),
        createdAt: Value(createdAt),
        updatedAt: Value(updatedAt),
      );

  // product_guid is uuid type in Supabase — sent as-is (no int conversion)
  Map<String, dynamic> toSupabaseJson() => {
        'transaction_guid': transactionGuid,
        if (productGuid != null) 'product_guid': productGuid,
        'product_name': productName,
        if (productSku != null) 'product_sku': productSku,
        'price': price,
        'cost': cost,
        'qty': qty,
        'discount': discount,
        'ppn': tax,
        'total_price': totalPrice,
      };
}
