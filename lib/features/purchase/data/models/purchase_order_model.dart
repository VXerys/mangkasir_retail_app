import '../../domain/entities/purchase_order.dart';

class PurchaseOrderItemModel {
  const PurchaseOrderItemModel({
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

  factory PurchaseOrderItemModel.fromJson(Map<String, dynamic> json) {
    final productObj = json['products'] as Map<String, dynamic>?;
    return PurchaseOrderItemModel(
      productId: (json['product_id'] as num?)?.toInt() ?? 0,
      productName: (json['product_name'] as String?) ??
          (productObj?['name'] as String?) ??
          'Produk #${json['product_id']}',
      qtyOrdered: (json['qty_ordered'] as num?)?.toDouble() ?? 0.0,
      qtyReceived: (json['qty_received'] as num?)?.toDouble() ?? 0.0,
      unitPrice: (json['unit_price'] as num?)?.toDouble() ?? 0.0,
      totalPrice: (json['total_price'] as num?)?.toDouble() ?? 0.0,
    );
  }

  PurchaseOrderItem toEntity() => PurchaseOrderItem(
        productId: productId,
        productName: productName,
        qtyOrdered: qtyOrdered,
        qtyReceived: qtyReceived,
        unitPrice: unitPrice,
        totalPrice: totalPrice,
      );

  Map<String, dynamic> toJson() => {
        'product_id': productId,
        'qty_ordered': qtyOrdered,
        'qty_received': qtyReceived,
        'unit_price': unitPrice,
        'total_price': totalPrice,
      };
}

class PurchaseOrderModel {
  const PurchaseOrderModel({
    required this.id,
    required this.poNumber,
    required this.supplierId,
    required this.supplierName,
    required this.warehouseId,
    required this.warehouseName,
    this.status = 'draft',
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
  final List<PurchaseOrderItemModel> items;
  final String? notes;
  final String? createdBy;
  final DateTime? createdAt;

  factory PurchaseOrderModel.fromJson(Map<String, dynamic> json) {
    final suppObj = json['suppliers'] as Map<String, dynamic>?;
    final whObj = json['warehouses'] as Map<String, dynamic>?;
    final itemsList = (json['purchase_order_items'] as List?)
            ?.map((e) => PurchaseOrderItemModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        <PurchaseOrderItemModel>[];

    return PurchaseOrderModel(
      id: (json['id'] as num).toInt(),
      poNumber: (json['po_number'] as String?) ?? 'PO-${json['id']}',
      supplierId: (json['supplier_id'] as num?)?.toInt() ?? 0,
      supplierName: (json['supplier_name'] as String?) ??
          (suppObj?['name'] as String?) ??
          'Supplier #${json['supplier_id']}',
      warehouseId: (json['warehouse_id'] as num?)?.toInt() ?? 0,
      warehouseName: (json['warehouse_name'] as String?) ??
          (whObj?['name'] as String?) ??
          'Gudang #${json['warehouse_id']}',
      status: (json['status'] as String?) ?? 'draft',
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
      taxAmount: (json['tax_amount'] as num?)?.toDouble() ?? 0.0,
      discountAmount: (json['discount_amount'] as num?)?.toDouble() ?? 0.0,
      totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0.0,
      items: itemsList,
      notes: json['notes'] as String?,
      createdBy: json['created_by'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
    );
  }

  static PurchaseOrderModel fromEntity(PurchaseOrder po) => PurchaseOrderModel(
        id: po.id,
        poNumber: po.poNumber,
        supplierId: po.supplierId,
        supplierName: po.supplierName,
        warehouseId: po.warehouseId,
        warehouseName: po.warehouseName,
        status: po.status,
        subtotal: po.subtotal,
        taxAmount: po.taxAmount,
        discountAmount: po.discountAmount,
        totalAmount: po.totalAmount,
        items: po.items
            .map((i) => PurchaseOrderItemModel(
                  productId: i.productId,
                  productName: i.productName,
                  qtyOrdered: i.qtyOrdered,
                  qtyReceived: i.qtyReceived,
                  unitPrice: i.unitPrice,
                  totalPrice: i.totalPrice,
                ))
            .toList(),
        notes: po.notes,
        createdBy: po.createdBy,
        createdAt: po.createdAt,
      );

  PurchaseOrder toEntity() => PurchaseOrder(
        id: id,
        poNumber: poNumber,
        supplierId: supplierId,
        supplierName: supplierName,
        warehouseId: warehouseId,
        warehouseName: warehouseName,
        status: status,
        subtotal: subtotal,
        taxAmount: taxAmount,
        discountAmount: discountAmount,
        totalAmount: totalAmount,
        items: items.map((i) => i.toEntity()).toList(),
        notes: notes,
        createdBy: createdBy,
        createdAt: createdAt,
      );

  Map<String, dynamic> toInsertJson() => {
        'po_number': poNumber,
        'supplier_id': supplierId,
        'warehouse_id': warehouseId,
        'status': status,
        'subtotal': subtotal,
        'tax_amount': taxAmount,
        'discount_amount': discountAmount,
        'total_amount': totalAmount,
        if (notes != null) 'notes': notes,
      };
}
