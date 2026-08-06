import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/entities/outlet.dart';
import '../../../domain/repositories/outlet_repository.dart';
import 'outlet_state.dart';

@injectable
class OutletCubit extends Cubit<OutletState> {
  final OutletRepository _repository;

  OutletCubit(this._repository) : super(const OutletState.loading());

  Future<void> load(int businessId) async {
    emit(const OutletState.loading());
    final result = await _repository.getOutlets(businessId);
    if (isClosed) return;
    result.fold(
      (f) => emit(OutletState.error(f.message)),
      (outlets) => emit(OutletState.loaded(outlets)),
    );
  }

  Future<void> create(Outlet outlet) async {
    final current = _currentOutlets();
    if (current == null) return;

    emit(const OutletState.saving());
    final result = await _repository.createOutlet(outlet);
    if (isClosed) return;
    result.fold(
      (f) => emit(OutletState.error(f.message)),
      (created) => emit(OutletState.loaded([...current, created])),
    );
  }

  Future<void> update(Outlet outlet) async {
    final current = _currentOutlets();
    if (current == null) return;

    emit(const OutletState.saving());
    final result = await _repository.updateOutlet(outlet);
    if (isClosed) return;
    result.fold(
      (f) => emit(OutletState.error(f.message)),
      (updated) => emit(
        OutletState.loaded(
          current.map((o) => o.id == updated.id ? updated : o).toList(),
        ),
      ),
    );
  }

  List<Outlet>? _currentOutlets() {
    final s = state;
    return s is OutletLoaded ? s.outlets : null;
  }
}
