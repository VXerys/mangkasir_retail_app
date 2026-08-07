import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/customer.dart';
import '../../domain/repositories/crm_repository.dart';
import 'customer_state.dart';

@injectable
class CustomerCubit extends Cubit<CustomerState> {
  final CrmRepository _repository;

  CustomerCubit(this._repository) : super(const CustomerInitial());

  Future<void> load(int outletId) async {
    emit(const CustomerLoading());
    final result = await _repository.getCustomers(outletId);
    if (isClosed) return;
    result.fold(
      (f) => emit(CustomerError(f.message)),
      (customers) => emit(CustomerLoaded(customers)),
    );
  }

  Future<void> create(Customer customer) async {
    final current = _current();
    emit(const CustomerSaving());
    final result = await _repository.createCustomer(customer);
    if (isClosed) return;
    result.fold(
      (f) => emit(CustomerError(f.message)),
      (created) => emit(CustomerLoaded([...(current ?? []), created])),
    );
  }

  Future<void> update(Customer customer) async {
    final current = _current();
    emit(const CustomerSaving());
    final result = await _repository.updateCustomer(customer);
    if (isClosed) return;
    result.fold(
      (f) => emit(CustomerError(f.message)),
      (updated) => emit(
        CustomerLoaded(
          (current ?? []).map((c) => c.id == updated.id ? updated : c).toList(),
        ),
      ),
    );
  }

  Future<void> delete(int id) async {
    final current = _current();
    emit(const CustomerSaving());
    final result = await _repository.deleteCustomer(id);
    if (isClosed) return;
    result.fold(
      (f) => emit(CustomerError(f.message)),
      (_) => emit(
        CustomerLoaded((current ?? []).where((c) => c.id != id).toList()),
      ),
    );
  }

  List<Customer>? _current() {
    final s = state;
    return s is CustomerLoaded ? s.customers : null;
  }
}
