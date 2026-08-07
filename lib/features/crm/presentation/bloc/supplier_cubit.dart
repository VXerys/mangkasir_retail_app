import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/supplier.dart';
import '../../domain/repositories/crm_repository.dart';
import 'supplier_state.dart';

@injectable
class SupplierCubit extends Cubit<SupplierState> {
  final CrmRepository _repository;

  SupplierCubit(this._repository) : super(const SupplierInitial());

  Future<void> load(int businessId) async {
    emit(const SupplierLoading());
    final result = await _repository.getSuppliers(businessId);
    if (isClosed) return;
    result.fold(
      (f) => emit(SupplierError(f.message)),
      (suppliers) => emit(SupplierLoaded(suppliers)),
    );
  }

  Future<void> create(Supplier supplier) async {
    final current = _current();
    emit(const SupplierSaving());
    final result = await _repository.createSupplier(supplier);
    if (isClosed) return;
    result.fold(
      (f) => emit(SupplierError(f.message)),
      (created) => emit(SupplierLoaded([...(current ?? []), created])),
    );
  }

  Future<void> update(Supplier supplier) async {
    final current = _current();
    emit(const SupplierSaving());
    final result = await _repository.updateSupplier(supplier);
    if (isClosed) return;
    result.fold(
      (f) => emit(SupplierError(f.message)),
      (updated) => emit(
        SupplierLoaded(
          (current ?? []).map((s) => s.id == updated.id ? updated : s).toList(),
        ),
      ),
    );
  }

  Future<void> deactivate(int id) async {
    final current = _current();
    emit(const SupplierSaving());
    final result = await _repository.deactivateSupplier(id);
    if (isClosed) return;
    result.fold(
      (f) => emit(SupplierError(f.message)),
      (_) => emit(
        SupplierLoaded((current ?? []).where((s) => s.id != id).toList()),
      ),
    );
  }

  List<Supplier>? _current() {
    final s = state;
    return s is SupplierLoaded ? s.suppliers : null;
  }
}
