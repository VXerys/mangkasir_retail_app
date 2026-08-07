import '../../domain/entities/stock_movement.dart';

class StockMovementModel {
  const StockMovementModel({
    required this.id,
    required this.productId,
    required this.productName,
    required this.warehouseId,
    required this.warehouseName,
    required this.movementType,
    required this.qty,
    required this.balanceAfter,
    this.referenceType,
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

  factory StockMovementModel.fromJson(Map<String, dynamic> json) {
    final productObj = json['products'] as Map<String, dynamic>?;
    final warehouseObj = json['warehouses'] as Map<String, dynamic>?;

    return StockMovementModel(
      id: (json['id'] as num).toInt(),
      productId: (json['product_id'] as num?)?.toInt() ?? 0,
      productName: (json['product_name'] as String?) ??
          (productObj?['name'] as String?) ??
          'Produk #${json['product_id']}',
      warehouseId: (json['warehouse_id'] as num?)?.toInt() ?? 0,
      warehouseName: (json['warehouse_name'] as String?) ??
          (warehouseObj?['name'] as String?) ??
          'Gudang Utama',
      movementType: (json['movement_type'] as String?) ?? 'in',
      qty: (json['qty'] as num?)?.toDouble() ?? 0.0,
      balanceAfter: (json['balance_after'] as num?)?.toDouble() ?? 0.0,
      referenceType: json['reference_type'] as String?,
      referenceId: json['reference_id']?.toString(),
      notes: json['notes'] as String?,
      createdBy: json['created_by'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
    );
  }

  static StockMovementModel fromEntity(StockMovement m) => StockMovementModel(
        id: m.id,
        productId: m.productId,
        productName: m.productName,
        warehouseId: m.warehouseId,
        warehouseName: m.warehouseName,
        movementType: m.movementType,
        qty: m.qty,
        balanceAfter: m.balanceAfter,
        referenceType: m.referenceType,
        referenceId: m.referenceId,
        notes: m.notes,
        createdBy: m.createdBy,
        createdAt: m.createdAt,
      );

  StockMovement toEntity() => StockMovement(
        id: id,
        productId: productId,
        productName: productName,
        warehouseId: warehouseId,
        warehouseName: warehouseName,
        movementType: movementType,
        qty: qty,
        balanceAfter: balanceAfter,
        referenceType: referenceType,
        referenceId: referenceId,
        notes: notes,
        createdBy: createdBy,
        createdAt: createdAt,
      );

  Map<String, dynamic> toInsertJson() => {
        'product_id': productId,
        'warehouse_id': warehouseId,
        'movement_type': movementType,
        'qty': qty,
        'balance_after': balanceAfter,
        if (referenceType != null) 'reference_type': referenceType,
        if (referenceId != null) 'reference_id': referenceId,
        if (notes != null) 'notes': notes,
      };
}
