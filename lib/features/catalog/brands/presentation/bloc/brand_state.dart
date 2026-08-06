import '../../domain/entities/brand.dart';

sealed class BrandState {
  const BrandState();
}

class BrandLoading extends BrandState {
  const BrandLoading();
}

class BrandLoaded extends BrandState {
  const BrandLoaded(this.brands);
  final List<Brand> brands;
}

class BrandSaving extends BrandState {
  const BrandSaving();
}

class BrandError extends BrandState {
  const BrandError(this.message);
  final String message;
}
