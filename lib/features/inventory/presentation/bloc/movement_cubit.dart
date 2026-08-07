import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repositories/inventory_repository.dart';
import 'movement_state.dart';

@injectable
class MovementCubit extends Cubit<MovementState> {
  final InventoryRepository _repository;

  MovementCubit(this._repository) : super(const MovementInitial());

  Future<void> load(
    int outletId, {
    int? productId,
    int? warehouseId,
    String? movementType,
  }) async {
    emit(const MovementLoading());
    final result = await _repository.getMovements(
      outletId,
      productId: productId,
      warehouseId: warehouseId,
      movementType: movementType,
    );
    if (isClosed) return;
    result.fold(
      (f) => emit(MovementError(f.message)),
      (movements) => emit(MovementLoaded(movements)),
    );
  }
}
