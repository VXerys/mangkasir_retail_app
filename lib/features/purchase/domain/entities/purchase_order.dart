class PurchaseOrderItem {
  const PurchaseOrderItem({
    required this.productId,
    required this.productName,
    required this.qtyOrdered,
    this.qtyReceived = 0.0,
    required this.unitPrice,
    this.totalPrice = 0.0,
  });

  final int productId;
  final String productName;
  final double qtyOrdered;
  final double qtyReceived;
  final double unitPrice;
  final double totalPrice;

  PurchaseOrderItem copyWith({
    int? productId,
    String? productName,
    double? qtyOrdered,
    double? qtyReceived,
    double? unitPrice,
    double? totalPrice,
  }) {
    return PurchaseOrderItem(
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      qtyOrdered: qtyOrdered ?? this.qtyOrdered,
      qtyReceived: qtyReceived ?? this.qtyReceived,
      unitPrice: unitPrice ?? this.unitPrice,
      totalPrice: totalPrice ?? (qtyOrdered ?? this.qtyOrdered) * (unitPrice ?? this.unitPrice),
    );
  }
}

class PurchaseOrder {
  const PurchaseOrder({
    required this.id,
    required this.poNumber,
    required this.supplierId,
    required this.supplierName,
    required this.warehouseId,
    required this.warehouseName,
    this.status = 'draft', // 'draft', 'approved', 'partially_received', 'completed', 'cancelled'
    this.subtotal = 0.0,
    this.taxAmount = 0.0,
    this.discountAmount = 0.0,
    this.totalAmount = 0.0,
    this.items = const [],
    this.notes,
    this.createdBy,
    this.createdAt,
  });

  final int id;
  final String poNumber;
  final int supplierId;
  final String supplierName;
  final int warehouseId;
  final String warehouseName;
  final String status;
  final double subtotal;
  final double taxAmount;
  final double discountAmount;
  final double totalAmount;
  final List<PurchaseOrderItem> items;
  final String? notes;
  final String? createdBy;
  final DateTime? createdAt;

  PurchaseOrder copyWith({
    int? id,
    String? poNumber,
    int? supplierId,
    String? supplierName,
    int? warehouseId,
    String? warehouseName,
    String? status,
    double? subtotal,
    double? taxAmount,
    double? discountAmount,
    double? totalAmount,
    List<PurchaseOrderItem>? items,
    String? notes,
    String? createdBy,
    DateTime? createdAt,
  }) {
    return PurchaseOrder(
      id: id ?? this.id,
      poNumber: poNumber ?? this.poNumber,
      supplierId: supplierId ?? this.supplierId,
      supplierName: supplierName ?? this.supplierName,
      warehouseId: warehouseId ?? this.warehouseId,
      warehouseName: warehouseName ?? this.warehouseName,
      status: status ?? this.status,
      subtotal: subtotal ?? this.subtotal,
      taxAmount: taxAmount ?? this.taxAmount,
      discountAmount: discountAmount ?? this.discountAmount,
      totalAmount: totalAmount ?? this.totalAmount,
      items: items ?? this.items,
      notes: notes ?? this.notes,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
