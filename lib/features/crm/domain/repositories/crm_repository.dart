import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/customer.dart';
import '../entities/employee.dart';
import '../entities/supplier.dart';

abstract class CrmRepository {
  // Customers
  Future<Either<Failure, List<Customer>>> getCustomers(int outletId);
  Future<Either<Failure, Customer>> getCustomerById(int id);
  Future<Either<Failure, Customer>> createCustomer(Customer customer);
  Future<Either<Failure, Customer>> updateCustomer(Customer customer);
  Future<Either<Failure, Unit>> deleteCustomer(int id);

  // Suppliers
  Future<Either<Failure, List<Supplier>>> getSuppliers(int businessId);
  Future<Either<Failure, Supplier>> getSupplierById(int id);
  Future<Either<Failure, Supplier>> createSupplier(Supplier supplier);
  Future<Either<Failure, Supplier>> updateSupplier(Supplier supplier);
  Future<Either<Failure, Unit>> deactivateSupplier(int id);

  // Employees
  Future<Either<Failure, List<Employee>>> getEmployees(int businessId);
  Future<Either<Failure, Employee>> createEmployee(Employee employee);
  Future<Either<Failure, Employee>> updateEmployee(Employee employee);
  Future<Either<Failure, Unit>> deactivateEmployee(String id);
}
