import '../../domain/entities/warehouse.dart';

sealed class WarehouseState {
  const WarehouseState();
}

class WarehouseLoading extends WarehouseState {
  const WarehouseLoading();
}

class WarehouseLoaded extends WarehouseState {
  const WarehouseLoaded(this.warehouses);
  final List<Warehouse> warehouses;
}

class WarehouseSaving extends WarehouseState {
  const WarehouseSaving();
}

class WarehouseError extends WarehouseState {
  const WarehouseError(this.message);
  final String message;
}
