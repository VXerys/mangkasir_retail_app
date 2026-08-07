import '../../domain/entities/supplier.dart';

sealed class SupplierState {
  const SupplierState();
}

class SupplierInitial extends SupplierState {
  const SupplierInitial();
}

class SupplierLoading extends SupplierState {
  const SupplierLoading();
}

class SupplierLoaded extends SupplierState {
  const SupplierLoaded(this.suppliers);
  final List<Supplier> suppliers;
}

class SupplierSaving extends SupplierState {
  const SupplierSaving();
}

class SupplierError extends SupplierState {
  const SupplierError(this.message);
  final String message;
}
