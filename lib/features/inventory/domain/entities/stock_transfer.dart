class StockTransferItem {
  const StockTransferItem({
    required this.productId,
    required this.productName,
    required this.qty,
  });

  final int productId;
  final String productName;
  final double qty;
}

class StockTransfer {
  const StockTransfer({
    required this.id,
    required this.transferNo,
    required this.fromWarehouseId,
    required this.fromWarehouseName,
    required this.toWarehouseId,
    required this.toWarehouseName,
    this.status = 'draft', // 'draft', 'shipped', 'received', 'cancelled'
    this.items = const [],
    this.notes,
    this.createdBy,
    this.createdAt,
  });

  final int id;
  final String transferNo;
  final int fromWarehouseId;
  final String fromWarehouseName;
  final int toWarehouseId;
  final String toWarehouseName;
  final String status;
  final List<StockTransferItem> items;
  final String? notes;
  final String? createdBy;
  final DateTime? createdAt;
}
