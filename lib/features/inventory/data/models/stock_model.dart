import '../../domain/entities/stock.dart';

class StockModel {
  const StockModel({
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

  factory StockModel.fromJson(Map<String, dynamic> json) {
    final productObj = json['products'] as Map<String, dynamic>?;
    final warehouseObj = json['warehouses'] as Map<String, dynamic>?;

    return StockModel(
      id: (json['id'] as num).toInt(),
      productId: (json['product_id'] as num?)?.toInt() ?? 0,
      productName: (json['product_name'] as String?) ??
          (productObj?['name'] as String?) ??
          'Produk #${json['product_id']}',
      warehouseId: (json['warehouse_id'] as num?)?.toInt() ?? 0,
      warehouseName: (json['warehouse_name'] as String?) ??
          (warehouseObj?['name'] as String?) ??
          'Gudang Utama',
      qty: (json['qty'] as num?)?.toDouble() ?? 0.0,
      sku: json['sku'] as String? ?? productObj?['sku'] as String?,
      barcode: json['barcode'] as String? ?? productObj?['barcode'] as String?,
      unitName: (json['unit_name'] as String?) ?? 'Pcs',
      minStock: (json['min_stock'] as num?)?.toDouble() ?? 0.0,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'] as String)
          : null,
    );
  }

  static StockModel fromEntity(Stock s) => StockModel(
        id: s.id,
        productId: s.productId,
        productName: s.productName,
        warehouseId: s.warehouseId,
        warehouseName: s.warehouseName,
        qty: s.qty,
        sku: s.sku,
        barcode: s.barcode,
        unitName: s.unitName,
        minStock: s.minStock,
        updatedAt: s.updatedAt,
      );

  Stock toEntity() => Stock(
        id: id,
        productId: productId,
        productName: productName,
        warehouseId: warehouseId,
        warehouseName: warehouseName,
        qty: qty,
        sku: sku,
        barcode: barcode,
        unitName: unitName,
        minStock: minStock,
        updatedAt: updatedAt,
      );

  Map<String, dynamic> toJson() => {
        'product_id': productId,
        'warehouse_id': warehouseId,
        'qty': qty,
        'min_stock': minStock,
      };
}
