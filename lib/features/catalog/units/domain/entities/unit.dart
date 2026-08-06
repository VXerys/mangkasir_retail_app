class Unit {
  const Unit({
    required this.id,
    required this.name,
    required this.symbol,
    required this.businessId,
    this.decimalPlaces = 0,
  });

  final int id;
  final String name;
  final String symbol;
  final int businessId;
  final int decimalPlaces;

  Unit copyWith({String? name, String? symbol, int? decimalPlaces}) => Unit(
        id: id,
        name: name ?? this.name,
        symbol: symbol ?? this.symbol,
        businessId: businessId,
        decimalPlaces: decimalPlaces ?? this.decimalPlaces,
      );
}
