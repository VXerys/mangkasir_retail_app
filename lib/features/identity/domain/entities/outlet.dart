import 'package:freezed_annotation/freezed_annotation.dart';

part 'outlet.freezed.dart';

/// Cabang/toko satu bisnis.
@freezed
class Outlet with _$Outlet {
  const factory Outlet({
    required int id,
    required String uuid,
    required int businessId,
    required String name,
    @Default('IDR') String currency,
    @Default(true) bool isActive,
    String? address,
    String? phone,
  }) = _Outlet;
}
