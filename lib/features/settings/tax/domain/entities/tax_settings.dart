class TaxSettings {
  const TaxSettings({
    required this.outletId,
    this.taxName = 'PPN',
    this.taxRate = 11.0,
    this.isInclusive = false,
    this.isEnabled = false,
  });

  final int outletId;
  final String taxName;
  final double taxRate;
  final bool isInclusive;
  final bool isEnabled;

  TaxSettings copyWith({
    String? taxName,
    double? taxRate,
    bool? isInclusive,
    bool? isEnabled,
  }) =>
      TaxSettings(
        outletId: outletId,
        taxName: taxName ?? this.taxName,
        taxRate: taxRate ?? this.taxRate,
        isInclusive: isInclusive ?? this.isInclusive,
        isEnabled: isEnabled ?? this.isEnabled,
      );
}
