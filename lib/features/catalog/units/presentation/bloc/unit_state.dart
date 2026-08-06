import '../../domain/entities/unit.dart';

sealed class UnitState {
  const UnitState();
}

class UnitLoading extends UnitState {
  const UnitLoading();
}

class UnitLoaded extends UnitState {
  const UnitLoaded(this.units);
  final List<Unit> units;
}

class UnitSaving extends UnitState {
  const UnitSaving();
}

class UnitError extends UnitState {
  const UnitError(this.message);
  final String message;
}
