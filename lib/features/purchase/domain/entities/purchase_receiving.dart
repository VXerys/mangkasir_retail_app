class PurchaseReceivingItem {
  const PurchaseReceivingItem({
    required this.productId,
    required this.productName,
    required this.qtyReceived,
    this.batchNo,
    this.expiryDate,
  });

  final int productId;
  final String productName;
  final double qtyReceived;
  final String? batchNo;
  final DateTime? expiryDate;
}

class PurchaseReceiving {
  const PurchaseReceiving({
    required this.id,
    required this.receivingNo,
    required this.poId,
    required this.poNumber,
    required this.warehouseId,
    required this.warehouseName,
    this.items = const [],
    this.notes,
    this.createdBy,
    this.receivedAt,
  });

  final int id;
  final String receivingNo;
  final int poId;
  final String poNumber;
  final int warehouseId;
  final String warehouseName;
  final List<PurchaseReceivingItem> items;
  final String? notes;
  final String? createdBy;
  final DateTime? receivedAt;
}
