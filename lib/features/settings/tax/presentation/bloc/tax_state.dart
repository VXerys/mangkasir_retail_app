import '../../domain/entities/tax_settings.dart';

sealed class TaxState {
  const TaxState();
}

class TaxLoading extends TaxState {
  const TaxLoading();
}

class TaxLoaded extends TaxState {
  const TaxLoaded(this.settings);
  final TaxSettings settings;
}

class TaxSaving extends TaxState {
  const TaxSaving();
}

class TaxError extends TaxState {
  const TaxError(this.message);
  final String message;
}
