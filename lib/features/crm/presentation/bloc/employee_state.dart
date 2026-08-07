import '../../domain/entities/employee.dart';

sealed class EmployeeState {
  const EmployeeState();
}

class EmployeeInitial extends EmployeeState {
  const EmployeeInitial();
}

class EmployeeLoading extends EmployeeState {
  const EmployeeLoading();
}

class EmployeeLoaded extends EmployeeState {
  const EmployeeLoaded(this.employees);
  final List<Employee> employees;
}

class EmployeeSaving extends EmployeeState {
  const EmployeeSaving();
}

class EmployeeError extends EmployeeState {
  const EmployeeError(this.message);
  final String message;
}
