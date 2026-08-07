import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangkasir_retail_app/core/error/failures.dart';
import 'package:mangkasir_retail_app/features/crm/domain/entities/customer.dart';
import 'package:mangkasir_retail_app/features/crm/domain/entities/employee.dart';
import 'package:mangkasir_retail_app/features/crm/domain/entities/supplier.dart';
import 'package:mangkasir_retail_app/features/crm/domain/repositories/crm_repository.dart';
import 'package:mangkasir_retail_app/features/crm/presentation/bloc/customer_cubit.dart';
import 'package:mangkasir_retail_app/features/crm/presentation/bloc/customer_state.dart';
import 'package:mangkasir_retail_app/features/crm/presentation/bloc/employee_cubit.dart';
import 'package:mangkasir_retail_app/features/crm/presentation/bloc/employee_state.dart';
import 'package:mangkasir_retail_app/features/crm/presentation/bloc/supplier_cubit.dart';
import 'package:mangkasir_retail_app/features/crm/presentation/bloc/supplier_state.dart';

class FakeCrmRepository implements CrmRepository {
  final List<Customer> customers = [];
  final List<Supplier> suppliers = [];
  final List<Employee> employees = [];

  @override
  Future<Either<Failure, List<Customer>>> getCustomers(int outletId) async {
    return Right(customers.where((c) => c.outletId == outletId).toList());
  }

  @override
  Future<Either<Failure, Customer>> getCustomerById(int id) async {
    final c = customers.where((x) => x.id == id).firstOrNull;
    if (c == null) return const Left(RemoteFailure('Customer not found'));
    return Right(c);
  }

  @override
  Future<Either<Failure, Customer>> createCustomer(Customer customer) async {
    final created = customer.copyWith(id: customers.length + 1);
    customers.add(created);
    return Right(created);
  }

  @override
  Future<Either<Failure, Customer>> updateCustomer(Customer customer) async {
    final idx = customers.indexWhere((x) => x.id == customer.id);
    if (idx != -1) customers[idx] = customer;
    return Right(customer);
  }

  @override
  Future<Either<Failure, Unit>> deleteCustomer(int id) async {
    customers.removeWhere((x) => x.id == id);
    return const Right(unit);
  }

  @override
  Future<Either<Failure, List<Supplier>>> getSuppliers(int businessId) async {
    return Right(suppliers.where((s) => s.businessId == businessId).toList());
  }

  @override
  Future<Either<Failure, Supplier>> getSupplierById(int id) async {
    final s = suppliers.where((x) => x.id == id).firstOrNull;
    if (s == null) return const Left(RemoteFailure('Supplier not found'));
    return Right(s);
  }

  @override
  Future<Either<Failure, Supplier>> createSupplier(Supplier supplier) async {
    final created = supplier.copyWith(id: suppliers.length + 1);
    suppliers.add(created);
    return Right(created);
  }

  @override
  Future<Either<Failure, Supplier>> updateSupplier(Supplier supplier) async {
    final idx = suppliers.indexWhere((x) => x.id == supplier.id);
    if (idx != -1) suppliers[idx] = supplier;
    return Right(supplier);
  }

  @override
  Future<Either<Failure, Unit>> deactivateSupplier(int id) async {
    suppliers.removeWhere((x) => x.id == id);
    return const Right(unit);
  }

  @override
  Future<Either<Failure, List<Employee>>> getEmployees(int businessId) async {
    return Right(employees.where((e) => e.businessId == businessId).toList());
  }

  @override
  Future<Either<Failure, Employee>> createEmployee(Employee employee) async {
    final created = employee.copyWith(id: 'emp-${employees.length + 1}');
    employees.add(created);
    return Right(created);
  }

  @override
  Future<Either<Failure, Employee>> updateEmployee(Employee employee) async {
    final idx = employees.indexWhere((x) => x.id == employee.id);
    if (idx != -1) employees[idx] = employee;
    return Right(employee);
  }

  @override
  Future<Either<Failure, Unit>> deactivateEmployee(String id) async {
    employees.removeWhere((x) => x.id == id);
    return const Right(unit);
  }
}

void main() {
  group('CustomerCubit Tests', () {
    late FakeCrmRepository repo;
    late CustomerCubit cubit;

    setUp(() {
      repo = FakeCrmRepository();
      cubit = CustomerCubit(repo);
    });

    tearDown(() {
      cubit.close();
    });

    test('load emits CustomerLoaded', () async {
      await cubit.load(1);
      expect(cubit.state, isA<CustomerLoaded>());
      expect((cubit.state as CustomerLoaded).customers, isEmpty);
    });

    test('create adds customer', () async {
      await cubit.load(1);
      await cubit.create(const Customer(
        id: 0,
        uuid: '',
        outletId: 1,
        name: 'Andi',
        phone: '0812345',
      ));

      expect(cubit.state, isA<CustomerLoaded>());
      final list = (cubit.state as CustomerLoaded).customers;
      expect(list.length, equals(1));
      expect(list.first.name, equals('Andi'));
    });
  });

  group('SupplierCubit Tests', () {
    late FakeCrmRepository repo;
    late SupplierCubit cubit;

    setUp(() {
      repo = FakeCrmRepository();
      cubit = SupplierCubit(repo);
    });

    tearDown(() {
      cubit.close();
    });

    test('load emits SupplierLoaded', () async {
      await cubit.load(10);
      expect(cubit.state, isA<SupplierLoaded>());
      expect((cubit.state as SupplierLoaded).suppliers, isEmpty);
    });

    test('create adds supplier', () async {
      await cubit.load(10);
      await cubit.create(const Supplier(
        id: 0,
        uuid: '',
        businessId: 10,
        name: 'Supplier A',
      ));

      expect(cubit.state, isA<SupplierLoaded>());
      final list = (cubit.state as SupplierLoaded).suppliers;
      expect(list.length, equals(1));
      expect(list.first.name, equals('Supplier A'));
    });
  });

  group('EmployeeCubit Tests', () {
    late FakeCrmRepository repo;
    late EmployeeCubit cubit;

    setUp(() {
      repo = FakeCrmRepository();
      cubit = EmployeeCubit(repo);
    });

    tearDown(() {
      cubit.close();
    });

    test('load emits EmployeeLoaded', () async {
      await cubit.load(10);
      expect(cubit.state, isA<EmployeeLoaded>());
      expect((cubit.state as EmployeeLoaded).employees, isEmpty);
    });

    test('create adds employee', () async {
      await cubit.load(10);
      await cubit.create(const Employee(
        id: '',
        businessId: 10,
        name: 'Dewi',
        roleName: 'Kasir',
      ));

      expect(cubit.state, isA<EmployeeLoaded>());
      final list = (cubit.state as EmployeeLoaded).employees;
      expect(list.length, equals(1));
      expect(list.first.name, equals('Dewi'));
    });
  });
}
