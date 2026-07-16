import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_detail.freezed.dart';

@freezed
class TransactionDetail with _$TransactionDetail {
  const factory TransactionDetail({
    required String id,
    required String guid,
    required String transactionGuid,
    String? productGuid,
    required String productName,
    String? productSku,
    required double price,
    @Default(0) double cost,
    required double qty,
    @Default(0) double discount,
    @Default(0) double tax,
    required double totalPrice,
    @Default('pending') String syncStatus,
    String? serverId,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _TransactionDetail;
}
