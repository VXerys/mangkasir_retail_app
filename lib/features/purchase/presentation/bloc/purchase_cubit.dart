import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/purchase_order.dart';
import '../../domain/repositories/purchase_repository.dart';
import 'purchase_state.dart';

@injectable
class PurchaseCubit extends Cubit<PurchaseState> {
  final PurchaseRepository _repository;

  PurchaseCubit(this._repository) : super(const PurchaseInitial());

  Future<void> load(int outletId, {int? supplierId, String? status}) async {
    emit(const PurchaseLoading());
    final result = await _repository.getOrders(outletId, supplierId: supplierId, status: status);
    if (isClosed) return;
    result.fold(
      (f) => emit(PurchaseError(f.message)),
      (orders) => emit(PurchaseLoaded(orders)),
    );
  }

  Future<void> create(PurchaseOrder order) async {
    final current = _current();
    emit(const PurchaseSaving());
    final result = await _repository.createOrder(order);
    if (isClosed) return;
    result.fold(
      (f) => emit(PurchaseError(f.message)),
      (created) => emit(PurchaseLoaded([...(current ?? []), created])),
    );
  }

  Future<void> updateStatus(int id, String status) async {
    final current = _current();
    emit(const PurchaseSaving());
    final result = await _repository.updateOrderStatus(id, status);
    if (isClosed) return;
    result.fold(
      (f) => emit(PurchaseError(f.message)),
      (updated) => emit(
        PurchaseLoaded(
          (current ?? []).map((p) => p.id == updated.id ? updated : p).toList(),
        ),
      ),
    );
  }

  List<PurchaseOrder>? _current() {
    final s = state;
    return s is PurchaseLoaded ? s.orders : null;
  }
}
