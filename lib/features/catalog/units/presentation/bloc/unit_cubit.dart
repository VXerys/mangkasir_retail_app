import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/unit.dart';
import '../../domain/repositories/unit_repository.dart';
import 'unit_state.dart';

@injectable
class UnitCubit extends Cubit<UnitState> {
  final UnitRepository _repository;

  UnitCubit(this._repository) : super(const UnitLoading());

  Future<void> load(int businessId) async {
    emit(const UnitLoading());
    final result = await _repository.getAll(businessId);
    if (isClosed) return;
    result.fold(
      (f) => emit(UnitError(f.message)),
      (units) => emit(UnitLoaded(units)),
    );
  }

  Future<void> create(Unit unit) async {
    final current = _current();
    if (current == null) return;
    emit(const UnitSaving());
    final result = await _repository.create(unit);
    if (isClosed) return;
    result.fold(
      (f) => emit(UnitError(f.message)),
      (created) => emit(UnitLoaded([...current, created])),
    );
  }

  Future<void> update(Unit unit) async {
    final current = _current();
    if (current == null) return;
    emit(const UnitSaving());
    final result = await _repository.update(unit);
    if (isClosed) return;
    result.fold(
      (f) => emit(UnitError(f.message)),
      (updated) => emit(
        UnitLoaded(current.map((u) => u.id == updated.id ? updated : u).toList()),
      ),
    );
  }

  Future<void> delete(int id) async {
    final current = _current();
    if (current == null) return;
    emit(const UnitSaving());
    final result = await _repository.delete(id);
    if (isClosed) return;
    result.fold(
      (f) => emit(UnitError(f.message)),
      (_) => emit(UnitLoaded(current.where((u) => u.id != id).toList())),
    );
  }

  List<Unit>? _current() {
    final s = state;
    return s is UnitLoaded ? s.units : null;
  }
}
