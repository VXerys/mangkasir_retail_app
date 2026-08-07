import 'package:flutter_test/flutter_test.dart';
import 'package:mangkasir_retail_app/features/crm/data/models/customer_model.dart';
import 'package:mangkasir_retail_app/features/crm/data/models/employee_model.dart';
import 'package:mangkasir_retail_app/features/crm/data/models/supplier_model.dart';
import 'package:mangkasir_retail_app/features/crm/domain/entities/customer.dart';
import 'package:mangkasir_retail_app/features/crm/domain/entities/employee.dart';
import 'package:mangkasir_retail_app/features/crm/domain/entities/supplier.dart';

void main() {
  group('CRM Models JSON Serialization Tests', () {
    test('CustomerModel json conversion', () {
      final json = {
        'id': 1,
        'uuid': 'cust-uuid-123',
        'outlet_id': 10,
        'name': 'Budi Santoso',
        'phone': '08123456789',
        'email': 'budi@example.com',
        'address': 'Jl. Merdeka No. 5',
        'loyalty_points': 150.0,
        'credit_limit': 500000.0,
        'created_at': '2026-08-07T08:00:00Z',
      };

      final model = CustomerModel.fromJson(json);
      expect(model.id, equals(1));
      expect(model.name, equals('Budi Santoso'));
      expect(model.loyaltyPoints, equals(150.0));

      final entity = model.toEntity();
      expect(entity, isA<Customer>());
      expect(entity.phone, equals('08123456789'));

      final insertJson = model.toInsertJson();
      expect(insertJson['name'], equals('Budi Santoso'));
      expect(insertJson['outlet_id'], equals(10));
    });

    test('SupplierModel json conversion', () {
      final json = {
        'id': 2,
        'uuid': 'supp-uuid-456',
        'business_id': 5,
        'name': 'PT Distribusi Utama',
        'phone': '0215551234',
        'email': 'info@distribusi.com',
        'address': 'Kawasan Industri Block C',
        'tax_id': '01.234.567.8-901.000',
        'payment_terms': 'Net 30',
        'created_at': '2026-08-07T08:00:00Z',
      };

      final model = SupplierModel.fromJson(json);
      expect(model.id, equals(2));
      expect(model.name, equals('PT Distribusi Utama'));
      expect(model.taxId, equals('01.234.567.8-901.000'));

      final entity = model.toEntity();
      expect(entity, isA<Supplier>());
      expect(entity.paymentTerms, equals('Net 30'));

      final insertJson = model.toInsertJson();
      expect(insertJson['name'], equals('PT Distribusi Utama'));
      expect(insertJson['business_id'], equals(5));
    });

    test('EmployeeModel json conversion', () {
      final json = {
        'id': 'emp-001',
        'business_id': 5,
        'name': 'Siti Aminah',
        'email': 'siti@example.com',
        'phone': '08987654321',
        'role_name': 'Kasir Utama',
        'is_active': true,
      };

      final model = EmployeeModel.fromJson(json);
      expect(model.id, equals('emp-001'));
      expect(model.name, equals('Siti Aminah'));
      expect(model.roleName, equals('Kasir Utama'));

      final entity = model.toEntity();
      expect(entity, isA<Employee>());
      expect(entity.email, equals('siti@example.com'));
    });
  });
}
