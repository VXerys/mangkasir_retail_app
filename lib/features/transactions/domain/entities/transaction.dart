import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction.freezed.dart';

@freezed
class Transaction with _$Transaction {
  const factory Transaction({
    required String id,
    required String guid,
    required String storeId,
    required double subTotal,
    @Default(0) double discount,
    @Default(0) double tax,
    required String paymentMethod,
    @Default('done') String flag,
    String? invoice,
    String? customerName,
    String? cashierId,
    DateTime? date,
    @Default('pending') String syncStatus,
    String? serverId,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Transaction;
}
