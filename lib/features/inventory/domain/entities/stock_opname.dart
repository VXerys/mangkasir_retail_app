class StockOpnameItem {
  const StockOpnameItem({
    required this.productId,
    required this.productName,
    required this.systemQty,
    required this.physicalQty,
    required this.differenceQty,
    this.notes,
  });

  final int productId;
  final String productName;
  final double systemQty;
  final double physicalQty;
  final double differenceQty;
  final String? notes;
}

class StockOpname {
  const StockOpname({
    required this.id,
    required this.opnameNo,
    required this.warehouseId,
    this.status = 'in_progress', // 'in_progress', 'completed', 'cancelled'
    this.items = const [],
    this.notes,
    this.createdBy,
    this.createdAt,
  });

  final int id;
  final String opnameNo;
  final int warehouseId;
  final String status;
  final List<StockOpnameItem> items;
  final String? notes;
  final String? createdBy;
  final DateTime? createdAt;
}
