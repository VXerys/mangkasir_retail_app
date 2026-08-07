import 'package:flutter_test/flutter_test.dart';
import 'package:mangkasir_retail_app/features/purchase/data/models/purchase_order_model.dart';
import 'package:mangkasir_retail_app/features/purchase/domain/entities/purchase_order.dart';

void main() {
  group('Purchase Models Tests', () {
    test('PurchaseOrderModel json conversion and entity mapping', () {
      final json = {
        'id': 10,
        'po_number': 'PO-2026-001',
        'supplier_id': 1,
        'warehouse_id': 2,
        'status': 'draft',
        'subtotal': 1500000.0,
        'tax_amount': 150000.0,
        'discount_amount': 50000.0,
        'total_amount': 1600000.0,
        'suppliers': {'name': 'PT Supplier Utama'},
        'warehouses': {'name': 'Gudang Pusat'},
        'purchase_order_items': [
          {
            'product_id': 101,
            'product_name': 'Kopi Arabika',
            'qty_ordered': 100.0,
            'qty_received': 0.0,
            'unit_price': 15000.0,
            'total_price': 1500000.0,
          }
        ],
      };

      final model = PurchaseOrderModel.fromJson(json);
      expect(model.id, equals(10));
      expect(model.poNumber, equals('PO-2026-001'));
      expect(model.supplierName, equals('PT Supplier Utama'));
      expect(model.warehouseName, equals('Gudang Pusat'));
      expect(model.totalAmount, equals(1600000.0));
      expect(model.items.length, equals(1));

      final entity = model.toEntity();
      expect(entity, isA<PurchaseOrder>());
      expect(entity.status, equals('draft'));
      expect(entity.items.first.productName, equals('Kopi Arabika'));
    });
  });
}
