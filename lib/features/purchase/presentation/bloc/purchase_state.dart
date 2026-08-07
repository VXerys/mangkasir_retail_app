import '../../domain/entities/purchase_order.dart';

sealed class PurchaseState {
  const PurchaseState();
}

class PurchaseInitial extends PurchaseState {
  const PurchaseInitial();
}

class PurchaseLoading extends PurchaseState {
  const PurchaseLoading();
}

class PurchaseLoaded extends PurchaseState {
  const PurchaseLoaded(this.orders);
  final List<PurchaseOrder> orders;
}

class PurchaseSaving extends PurchaseState {
  const PurchaseSaving();
}

class PurchaseError extends PurchaseState {
  const PurchaseError(this.message);
  final String message;
}
