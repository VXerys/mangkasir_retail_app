import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/employee.dart';
import '../../domain/repositories/crm_repository.dart';
import 'employee_state.dart';

@injectable
class EmployeeCubit extends Cubit<EmployeeState> {
  final CrmRepository _repository;

  EmployeeCubit(this._repository) : super(const EmployeeInitial());

  Future<void> load(int businessId) async {
    emit(const EmployeeLoading());
    final result = await _repository.getEmployees(businessId);
    if (isClosed) return;
    result.fold(
      (f) => emit(EmployeeError(f.message)),
      (employees) => emit(EmployeeLoaded(employees)),
    );
  }

  Future<void> create(Employee employee) async {
    final current = _current();
    emit(const EmployeeSaving());
    final result = await _repository.createEmployee(employee);
    if (isClosed) return;
    result.fold(
      (f) => emit(EmployeeError(f.message)),
      (created) => emit(EmployeeLoaded([...(current ?? []), created])),
    );
  }

  Future<void> update(Employee employee) async {
    final current = _current();
    emit(const EmployeeSaving());
    final result = await _repository.updateEmployee(employee);
    if (isClosed) return;
    result.fold(
      (f) => emit(EmployeeError(f.message)),
      (updated) => emit(
        EmployeeLoaded(
          (current ?? []).map((e) => e.id == updated.id ? updated : e).toList(),
        ),
      ),
    );
  }

  Future<void> deactivate(String id) async {
    final current = _current();
    emit(const EmployeeSaving());
    final result = await _repository.deactivateEmployee(id);
    if (isClosed) return;
    result.fold(
      (f) => emit(EmployeeError(f.message)),
      (_) => emit(
        EmployeeLoaded((current ?? []).where((e) => e.id != id).toList()),
      ),
    );
  }

  List<Employee>? _current() {
    final s = state;
    return s is EmployeeLoaded ? s.employees : null;
  }
}
