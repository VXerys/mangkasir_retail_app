import '../../domain/entities/stock_movement.dart';

sealed class MovementState {
  const MovementState();
}

class MovementInitial extends MovementState {
  const MovementInitial();
}

class MovementLoading extends MovementState {
  const MovementLoading();
}

class MovementLoaded extends MovementState {
  const MovementLoaded(this.movements);
  final List<StockMovement> movements;
}

class MovementError extends MovementState {
  const MovementError(this.message);
  final String message;
}
