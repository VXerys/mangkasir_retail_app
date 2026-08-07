import 'package:flutter_test/flutter_test.dart';
import 'package:mangkasir_retail_app/features/inventory/data/models/stock_model.dart';
import 'package:mangkasir_retail_app/features/inventory/data/models/stock_movement_model.dart';
import 'package:mangkasir_retail_app/features/inventory/domain/entities/stock.dart';
import 'package:mangkasir_retail_app/features/inventory/domain/entities/stock_movement.dart';

void main() {
  group('Inventory Core Models Tests', () {
    test('StockModel json conversion and entity mapping', () {
      final json = {
        'id': 100,
        'product_id': 12,
        'warehouse_id': 1,
        'qty': 45.0,
        'min_stock': 10.0,
        'products': {
          'name': 'Kopi Arabika 250g',
          'sku': 'KPA-250',
          'barcode': '899123456789',
        },
        'warehouses': {
          'name': 'Gudang Utama',
        },
      };

      final model = StockModel.fromJson(json);
      expect(model.id, equals(100));
      expect(model.productName, equals('Kopi Arabika 250g'));
      expect(model.warehouseName, equals('Gudang Utama'));
      expect(model.qty, equals(45.0));

      final entity = model.toEntity();
      expect(entity, isA<Stock>());
      expect(entity.isLowStock, isFalse);
      expect(entity.isOutOfStock, isFalse);

      final lowStock = entity.copyWith(qty: 5.0);
      expect(lowStock.isLowStock, isTrue);

      final outStock = entity.copyWith(qty: 0.0);
      expect(outStock.isOutOfStock, isTrue);
    });

    test('StockMovementModel json conversion and entity mapping', () {
      final json = {
        'id': 500,
        'product_id': 12,
        'warehouse_id': 1,
        'movement_type': 'in',
        'qty': 20.0,
        'balance_after': 65.0,
        'reference_type': 'purchase',
        'reference_id': 'PO-2026-001',
        'notes': 'Penerimaan PO #1',
        'products': {
          'name': 'Kopi Arabika 250g',
        },
        'warehouses': {
          'name': 'Gudang Utama',
        },
      };

      final model = StockMovementModel.fromJson(json);
      expect(model.id, equals(500));
      expect(model.movementType, equals('in'));
      expect(model.qty, equals(20.0));
      expect(model.balanceAfter, equals(65.0));

      final entity = model.toEntity();
      expect(entity, isA<StockMovement>());
      expect(entity.isInbound, isTrue);
      expect(entity.isOutbound, isFalse);
    });
  });
}
