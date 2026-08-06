import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/warehouse.dart';
import '../../domain/repositories/warehouse_repository.dart';
import 'warehouse_state.dart';

@injectable
class WarehouseCubit extends Cubit<WarehouseState> {
  final WarehouseRepository _repository;

  WarehouseCubit(this._repository) : super(const WarehouseLoading());

  Future<void> load(int outletId) async {
    emit(const WarehouseLoading());
    final result = await _repository.getAll(outletId);
    if (isClosed) return;
    result.fold(
      (f) => emit(WarehouseError(f.message)),
      (warehouses) => emit(WarehouseLoaded(warehouses)),
    );
  }

  Future<void> create(Warehouse warehouse) async {
    final current = _current();
    if (current == null) return;
    emit(const WarehouseSaving());
    final result = await _repository.create(warehouse);
    if (isClosed) return;
    result.fold(
      (f) => emit(WarehouseError(f.message)),
      (created) => emit(WarehouseLoaded([...current, created])),
    );
  }

  Future<void> update(Warehouse warehouse) async {
    final current = _current();
    if (current == null) return;
    emit(const WarehouseSaving());
    final result = await _repository.update(warehouse);
    if (isClosed) return;
    result.fold(
      (f) => emit(WarehouseError(f.message)),
      (updated) => emit(
        WarehouseLoaded(
            current.map((w) => w.id == updated.id ? updated : w).toList()),
      ),
    );
  }

  Future<void> deactivate(int id) async {
    final current = _current();
    if (current == null) return;
    emit(const WarehouseSaving());
    final result = await _repository.deactivate(id);
    if (isClosed) return;
    result.fold(
      (f) => emit(WarehouseError(f.message)),
      (_) => emit(WarehouseLoaded(current.where((w) => w.id != id).toList())),
    );
  }

  List<Warehouse>? _current() {
    final s = state;
    return s is WarehouseLoaded ? s.warehouses : null;
  }
}
