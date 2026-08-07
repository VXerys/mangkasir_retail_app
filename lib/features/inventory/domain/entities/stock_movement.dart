class StockMovement {
  const StockMovement({
    required this.id,
    required this.productId,
    required this.productName,
    required this.warehouseId,
    required this.warehouseName,
    required this.movementType, // 'in', 'out', 'adjustment', 'transfer'
    required this.qty,
    required this.balanceAfter,
    this.referenceType, // 'purchase', 'sale', 'adjustment', 'opname', 'transfer', 'return'
    this.referenceId,
    this.notes,
    this.createdBy,
    this.createdAt,
  });

  final int id;
  final int productId;
  final String productName;
  final int warehouseId;
  final String warehouseName;
  final String movementType;
  final double qty;
  final double balanceAfter;
  final String? referenceType;
  final String? referenceId;
  final String? notes;
  final String? createdBy;
  final DateTime? createdAt;

  bool get isInbound => movementType == 'in' || qty > 0;
  bool get isOutbound => movementType == 'out' || qty < 0;

  StockMovement copyWith({
    int? id,
    int? productId,
    String? productName,
    int? warehouseId,
    String? warehouseName,
    String? movementType,
    double? qty,
    double? balanceAfter,
    String? referenceType,
    String? referenceId,
    String? notes,
    String? createdBy,
    DateTime? createdAt,
  }) {
    return StockMovement(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      warehouseId: warehouseId ?? this.warehouseId,
      warehouseName: warehouseName ?? this.warehouseName,
      movementType: movementType ?? this.movementType,
      qty: qty ?? this.qty,
      balanceAfter: balanceAfter ?? this.balanceAfter,
      referenceType: referenceType ?? this.referenceType,
      referenceId: referenceId ?? this.referenceId,
      notes: notes ?? this.notes,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
