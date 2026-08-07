import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repositories/inventory_repository.dart';
import 'stock_state.dart';

@injectable
class StockCubit extends Cubit<StockState> {
  final InventoryRepository _repository;

  StockCubit(this._repository) : super(const StockInitial());

  Future<void> load(int outletId, {int? warehouseId}) async {
    emit(const StockLoading());
    final result = await _repository.getStocks(outletId, warehouseId: warehouseId);
    if (isClosed) return;
    result.fold(
      (f) => emit(StockError(f.message)),
      (stocks) => emit(StockLoaded(stocks)),
    );
  }
}
