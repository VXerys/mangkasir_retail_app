class PurchaseReturnItem {
  const PurchaseReturnItem({
    required this.productId,
    required this.productName,
    required this.qtyReturned,
    required this.unitPrice,
    this.totalPrice = 0.0,
  });

  final int productId;
  final String productName;
  final double qtyReturned;
  final double unitPrice;
  final double totalPrice;
}

class PurchaseReturn {
  const PurchaseReturn({
    required this.id,
    required this.returnNo,
    required this.poId,
    required this.poNumber,
    required this.supplierId,
    required this.supplierName,
    required this.reason,
    this.items = const [],
    this.totalAmount = 0.0,
    this.createdBy,
    this.createdAt,
  });

  final int id;
  final String returnNo;
  final int poId;
  final String poNumber;
  final int supplierId;
  final String supplierName;
  final String reason;
  final List<PurchaseReturnItem> items;
  final double totalAmount;
  final String? createdBy;
  final DateTime? createdAt;
}
