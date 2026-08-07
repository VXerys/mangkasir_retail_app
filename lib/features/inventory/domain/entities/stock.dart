class Stock {
  const Stock({
    required this.id,
    required this.productId,
    required this.productName,
    required this.warehouseId,
    required this.warehouseName,
    required this.qty,
    this.sku,
    this.barcode,
    this.unitName = 'Pcs',
    this.minStock = 0.0,
    this.updatedAt,
  });

  final int id;
  final int productId;
  final String productName;
  final int warehouseId;
  final String warehouseName;
  final double qty;
  final String? sku;
  final String? barcode;
  final String unitName;
  final double minStock;
  final DateTime? updatedAt;

  bool get isLowStock => qty <= minStock && qty > 0;
  bool get isOutOfStock => qty <= 0;

  Stock copyWith({
    int? id,
    int? productId,
    String? productName,
    int? warehouseId,
    String? warehouseName,
    double? qty,
    String? sku,
    String? barcode,
    String? unitName,
    double? minStock,
    DateTime? updatedAt,
  }) {
    return Stock(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      warehouseId: warehouseId ?? this.warehouseId,
      warehouseName: warehouseName ?? this.warehouseName,
      qty: qty ?? this.qty,
      sku: sku ?? this.sku,
      barcode: barcode ?? this.barcode,
      unitName: unitName ?? this.unitName,
      minStock: minStock ?? this.minStock,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
