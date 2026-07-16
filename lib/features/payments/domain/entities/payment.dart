import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment.freezed.dart';

@freezed
class Payment with _$Payment {
  const factory Payment({
    required String id,
    required String guid,
    required String transactionGuid,
    required double amount,
    @Default(0) double changeAmount,
    required double subTotal,
    required String method,
    String? notes,
    DateTime? date,
    @Default('pending') String syncStatus,
    String? serverId,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Payment;
}
