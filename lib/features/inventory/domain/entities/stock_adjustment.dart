class StockAdjustmentItem {
  const StockAdjustmentItem({
    required this.productId,
    required this.productName,
    required this.currentQty,
    required this.actualQty,
    required this.differenceQty,
    this.notes,
  });

  final int productId;
  final String productName;
  final double currentQty;
  final double actualQty;
  final double differenceQty;
  final String? notes;
}

class StockAdjustment {
  const StockAdjustment({
    required this.id,
    required this.adjustmentNo,
    required this.warehouseId,
    required this.reason,
    this.status = 'completed', // 'draft', 'completed', 'cancelled'
    this.items = const [],
    this.createdBy,
    this.createdAt,
  });

  final int id;
  final String adjustmentNo;
  final int warehouseId;
  final String reason;
  final String status;
  final List<StockAdjustmentItem> items;
  final String? createdBy;
  final DateTime? createdAt;
}
