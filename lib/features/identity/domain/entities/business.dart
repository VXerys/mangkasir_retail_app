import 'package:freezed_annotation/freezed_annotation.dart';

part 'business.freezed.dart';

/// Badan usaha — puncak hierarki tenant.
///
/// Kolom yang ditampilkan di halaman /settings/business. Kolom yang tidak
/// diketahui skemanya (email, logo_url) ditandai nullable sehingga query yang
/// tidak menyertakannya tidak melempar.
@freezed
class Business with _$Business {
  const factory Business({
    required int id,
    required String uuid,
    required String name,
    @Default('IDR') String currency,
    String? phone,
    String? address,
    String? email,
    String? taxNumber,
    String? logoUrl,
  }) = _Business;
}
