import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/error/exceptions.dart';
import '../models/customer_model.dart';
import '../models/employee_model.dart';
import '../models/supplier_model.dart';

abstract class CrmRemoteDs {
  // Customers (Outlet Scope)
  Future<List<CustomerModel>> getCustomers(int outletId);
  Future<CustomerModel> getCustomerById(int id);
  Future<CustomerModel> createCustomer(CustomerModel model);
  Future<CustomerModel> updateCustomer(CustomerModel model);
  Future<void> deleteCustomer(int id);

  // Suppliers (Business Scope)
  Future<List<SupplierModel>> getSuppliers(int businessId);
  Future<SupplierModel> getSupplierById(int id);
  Future<SupplierModel> createSupplier(SupplierModel model);
  Future<SupplierModel> updateSupplier(SupplierModel model);
  Future<void> deactivateSupplier(int id);

  // Employees (Business Scope)
  Future<List<EmployeeModel>> getEmployees(int businessId);
  Future<EmployeeModel> createEmployee(EmployeeModel model);
  Future<EmployeeModel> updateEmployee(EmployeeModel model);
  Future<void> deactivateEmployee(String id);
}

@LazySingleton(as: CrmRemoteDs)
class CrmRemoteDsImpl implements CrmRemoteDs {
  final SupabaseClient _client;

  CrmRemoteDsImpl(this._client);

  static const _custCols =
      'id, uuid, outlet_id, name, phone, email, address, loyalty_points, credit_limit, created_at';
  static const _suppCols =
      'id, uuid, business_id, name, phone, email, address, tax_id, payment_terms, created_at';

  // ---------------------------------------------------------------------------
  // Customers
  // ---------------------------------------------------------------------------

  @override
  Future<List<CustomerModel>> getCustomers(int outletId) async {
    try {
      final data = await _client
          .from('customers')
          .select(_custCols)
          .eq('outlet_id', outletId)
          .isFilter('deleted_at', null)
          .order('name');
      return (data as List)
          .map((e) => CustomerModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on PostgrestException catch (e) {
      throw RemoteException('getCustomers failed: ${e.message}');
    } catch (e) {
      throw RemoteException('getCustomers failed: $e');
    }
  }

  @override
  Future<CustomerModel> getCustomerById(int id) async {
    try {
      final data = await _client
          .from('customers')
          .select(_custCols)
          .eq('id', id)
          .single();
      return CustomerModel.fromJson(data);
    } on PostgrestException catch (e) {
      throw RemoteException('getCustomerById failed: ${e.message}');
    } catch (e) {
      throw RemoteException('getCustomerById failed: $e');
    }
  }

  @override
  Future<CustomerModel> createCustomer(CustomerModel model) async {
    try {
      final data = await _client
          .from('customers')
          .insert(model.toInsertJson())
          .select(_custCols)
          .single();
      return CustomerModel.fromJson(data);
    } on PostgrestException catch (e) {
      throw RemoteException('createCustomer failed: ${e.message}');
    } catch (e) {
      throw RemoteException('createCustomer failed: $e');
    }
  }

  @override
  Future<CustomerModel> updateCustomer(CustomerModel model) async {
    try {
      final data = await _client
          .from('customers')
          .update(model.toUpdateJson())
          .eq('id', model.id)
          .select(_custCols)
          .single();
      return CustomerModel.fromJson(data);
    } on PostgrestException catch (e) {
      throw RemoteException('updateCustomer failed: ${e.message}');
    } catch (e) {
      throw RemoteException('updateCustomer failed: $e');
    }
  }

  @override
  Future<void> deleteCustomer(int id) async {
    try {
      await _client
          .from('customers')
          .update({'deleted_at': DateTime.now().toIso8601String()})
          .eq('id', id);
    } on PostgrestException catch (e) {
      throw RemoteException('deleteCustomer failed: ${e.message}');
    } catch (e) {
      throw RemoteException('deleteCustomer failed: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // Suppliers
  // ---------------------------------------------------------------------------

  @override
  Future<List<SupplierModel>> getSuppliers(int businessId) async {
    try {
      final data = await _client
          .from('suppliers')
          .select(_suppCols)
          .eq('business_id', businessId)
          .isFilter('deleted_at', null)
          .order('name');
      return (data as List)
          .map((e) => SupplierModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on PostgrestException catch (e) {
      throw RemoteException('getSuppliers failed: ${e.message}');
    } catch (e) {
      throw RemoteException('getSuppliers failed: $e');
    }
  }

  @override
  Future<SupplierModel> getSupplierById(int id) async {
    try {
      final data = await _client
          .from('suppliers')
          .select(_suppCols)
          .eq('id', id)
          .single();
      return SupplierModel.fromJson(data);
    } on PostgrestException catch (e) {
      throw RemoteException('getSupplierById failed: ${e.message}');
    } catch (e) {
      throw RemoteException('getSupplierById failed: $e');
    }
  }

  @override
  Future<SupplierModel> createSupplier(SupplierModel model) async {
    try {
      final data = await _client
          .from('suppliers')
          .insert(model.toInsertJson())
          .select(_suppCols)
          .single();
      return SupplierModel.fromJson(data);
    } on PostgrestException catch (e) {
      throw RemoteException('createSupplier failed: ${e.message}');
    } catch (e) {
      throw RemoteException('createSupplier failed: $e');
    }
  }

  @override
  Future<SupplierModel> updateSupplier(SupplierModel model) async {
    try {
      final data = await _client
          .from('suppliers')
          .update(model.toUpdateJson())
          .eq('id', model.id)
          .select(_suppCols)
          .single();
      return SupplierModel.fromJson(data);
    } on PostgrestException catch (e) {
      throw RemoteException('updateSupplier failed: ${e.message}');
    } catch (e) {
      throw RemoteException('updateSupplier failed: $e');
    }
  }

  @override
  Future<void> deactivateSupplier(int id) async {
    try {
      await _client
          .from('suppliers')
          .update({'deleted_at': DateTime.now().toIso8601String()})
          .eq('id', id);
    } on PostgrestException catch (e) {
      throw RemoteException('deactivateSupplier failed: ${e.message}');
    } catch (e) {
      throw RemoteException('deactivateSupplier failed: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // Employees
  // ---------------------------------------------------------------------------

  @override
  Future<List<EmployeeModel>> getEmployees(int businessId) async {
    try {
      // Ambil pengguna bisnis dari users
      final data = await _client
          .from('users')
          .select('id, name, email, phone, is_active, created_at')
          .eq('business_id', businessId)
          .order('name');
      return (data as List)
          .map((e) => EmployeeModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on PostgrestException catch (e) {
      throw RemoteException('getEmployees failed: ${e.message}');
    } catch (e) {
      throw RemoteException('getEmployees failed: $e');
    }
  }

  @override
  Future<EmployeeModel> createEmployee(EmployeeModel model) async {
    try {
      final data = await _client
          .from('users')
          .insert(model.toInsertJson())
          .select('id, name, email, phone, is_active, created_at')
          .single();
      return EmployeeModel.fromJson(data);
    } on PostgrestException catch (e) {
      throw RemoteException('createEmployee failed: ${e.message}');
    } catch (e) {
      throw RemoteException('createEmployee failed: $e');
    }
  }

  @override
  Future<EmployeeModel> updateEmployee(EmployeeModel model) async {
    try {
      final data = await _client
          .from('users')
          .update(model.toUpdateJson())
          .eq('id', model.id)
          .select('id, name, email, phone, is_active, created_at')
          .single();
      return EmployeeModel.fromJson(data);
    } on PostgrestException catch (e) {
      throw RemoteException('updateEmployee failed: ${e.message}');
    } catch (e) {
      throw RemoteException('updateEmployee failed: $e');
    }
  }

  @override
  Future<void> deactivateEmployee(String id) async {
    try {
      await _client.from('users').update({'is_active': false}).eq('id', id);
    } on PostgrestException catch (e) {
      throw RemoteException('deactivateEmployee failed: ${e.message}');
    } catch (e) {
      throw RemoteException('deactivateEmployee failed: $e');
    }
  }
}
