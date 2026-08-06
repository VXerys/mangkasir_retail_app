import '../../domain/entities/unit.dart';

class UnitModel {
  const UnitModel({
    required this.id,
    required this.name,
    required this.symbol,
    required this.businessId,
    required this.decimalPlaces,
  });

  final int id;
  final String name;
  final String symbol;
  final int businessId;
  final int decimalPlaces;

  factory UnitModel.fromJson(Map<String, dynamic> json) => UnitModel(
        id: json['id'] as int,
        name: json['name'] as String,
        symbol: json['symbol'] as String,
        businessId: json['business_id'] as int,
        decimalPlaces: (json['decimal_places'] as int?) ?? 0,
      );

  static UnitModel fromEntity(Unit unit) => UnitModel(
        id: unit.id,
        name: unit.name,
        symbol: unit.symbol,
        businessId: unit.businessId,
        decimalPlaces: unit.decimalPlaces,
      );

  Unit toEntity() => Unit(
        id: id,
        name: name,
        symbol: symbol,
        businessId: businessId,
        decimalPlaces: decimalPlaces,
      );

  Map<String, dynamic> toInsertJson() => {
        'name': name,
        'symbol': symbol,
        'business_id': businessId,
        'decimal_places': decimalPlaces,
      };

  Map<String, dynamic> toUpdateJson() => {
        'name': name,
        'symbol': symbol,
        'decimal_places': decimalPlaces,
      };
}
