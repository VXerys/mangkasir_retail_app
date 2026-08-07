import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/customer.dart';
import '../../domain/entities/employee.dart';
import '../../domain/entities/supplier.dart';
import '../../domain/repositories/crm_repository.dart';
import '../datasources/crm_remote_ds.dart';
import '../models/customer_model.dart';
import '../models/employee_model.dart';
import '../models/supplier_model.dart';

@LazySingleton(as: CrmRepository)
class CrmRepositoryImpl implements CrmRepository {
  final CrmRemoteDs _remoteDs;

  const CrmRepositoryImpl(this._remoteDs);

  // ---------------------------------------------------------------------------
  // Customers
  // ---------------------------------------------------------------------------

  @override
  Future<Either<Failure, List<Customer>>> getCustomers(int outletId) async {
    try {
      final models = await _remoteDs.getCustomers(outletId);
      return Right(models.map((m) => m.toEntity()).toList());
    } on RemoteException catch (e) {
      return Left(RemoteFailure(e.message));
    } catch (e) {
      return Left(RemoteFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Customer>> getCustomerById(int id) async {
    try {
      final model = await _remoteDs.getCustomerById(id);
      return Right(model.toEntity());
    } on RemoteException catch (e) {
      return Left(RemoteFailure(e.message));
    } catch (e) {
      return Left(RemoteFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Customer>> createCustomer(Customer customer) async {
    try {
      final created = await _remoteDs.createCustomer(CustomerModel.fromEntity(customer));
      return Right(created.toEntity());
    } on RemoteException catch (e) {
      return Left(RemoteFailure(e.message));
    } catch (e) {
      return Left(RemoteFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Customer>> updateCustomer(Customer customer) async {
    try {
      final updated = await _remoteDs.updateCustomer(CustomerModel.fromEntity(customer));
      return Right(updated.toEntity());
    } on RemoteException catch (e) {
      return Left(RemoteFailure(e.message));
    } catch (e) {
      return Left(RemoteFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteCustomer(int id) async {
    try {
      await _remoteDs.deleteCustomer(id);
      return const Right(unit);
    } on RemoteException catch (e) {
      return Left(RemoteFailure(e.message));
    } catch (e) {
      return Left(RemoteFailure(e.toString()));
    }
  }

  // ---------------------------------------------------------------------------
  // Suppliers
  // ---------------------------------------------------------------------------

  @override
  Future<Either<Failure, List<Supplier>>> getSuppliers(int businessId) async {
    try {
      final models = await _remoteDs.getSuppliers(businessId);
      return Right(models.map((m) => m.toEntity()).toList());
    } on RemoteException catch (e) {
      return Left(RemoteFailure(e.message));
    } catch (e) {
      return Left(RemoteFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Supplier>> getSupplierById(int id) async {
    try {
      final model = await _remoteDs.getSupplierById(id);
      return Right(model.toEntity());
    } on RemoteException catch (e) {
      return Left(RemoteFailure(e.message));
    } catch (e) {
      return Left(RemoteFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Supplier>> createSupplier(Supplier supplier) async {
    try {
      final created = await _remoteDs.createSupplier(SupplierModel.fromEntity(supplier));
      return Right(created.toEntity());
    } on RemoteException catch (e) {
      return Left(RemoteFailure(e.message));
    } catch (e) {
      return Left(RemoteFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Supplier>> updateSupplier(Supplier supplier) async {
    try {
      final updated = await _remoteDs.updateSupplier(SupplierModel.fromEntity(supplier));
      return Right(updated.toEntity());
    } on RemoteException catch (e) {
      return Left(RemoteFailure(e.message));
    } catch (e) {
      return Left(RemoteFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deactivateSupplier(int id) async {
    try {
      await _remoteDs.deactivateSupplier(id);
      return const Right(unit);
    } on RemoteException catch (e) {
      return Left(RemoteFailure(e.message));
    } catch (e) {
      return Left(RemoteFailure(e.toString()));
    }
  }

  // ---------------------------------------------------------------------------
  // Employees
  // ---------------------------------------------------------------------------

  @override
  Future<Either<Failure, List<Employee>>> getEmployees(int businessId) async {
    try {
      final models = await _remoteDs.getEmployees(businessId);
      return Right(models.map((m) => m.toEntity()).toList());
    } on RemoteException catch (e) {
      return Left(RemoteFailure(e.message));
    } catch (e) {
      return Left(RemoteFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Employee>> createEmployee(Employee employee) async {
    try {
      final created = await _remoteDs.createEmployee(EmployeeModel.fromEntity(employee));
      return Right(created.toEntity());
    } on RemoteException catch (e) {
      return Left(RemoteFailure(e.message));
    } catch (e) {
      return Left(RemoteFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Employee>> updateEmployee(Employee employee) async {
    try {
      final updated = await _remoteDs.updateEmployee(EmployeeModel.fromEntity(employee));
      return Right(updated.toEntity());
    } on RemoteException catch (e) {
      return Left(RemoteFailure(e.message));
    } catch (e) {
      return Left(RemoteFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deactivateEmployee(String id) async {
    try {
      await _remoteDs.deactivateEmployee(id);
      return const Right(unit);
    } on RemoteException catch (e) {
      return Left(RemoteFailure(e.message));
    } catch (e) {
      return Left(RemoteFailure(e.toString()));
    }
  }
}
