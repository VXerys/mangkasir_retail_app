import '../../domain/entities/stock.dart';

sealed class StockState {
  const StockState();
}

class StockInitial extends StockState {
  const StockInitial();
}

class StockLoading extends StockState {
  const StockLoading();
}

class StockLoaded extends StockState {
  const StockLoaded(this.stocks);
  final List<Stock> stocks;
}

class StockError extends StockState {
  const StockError(this.message);
  final String message;
}
