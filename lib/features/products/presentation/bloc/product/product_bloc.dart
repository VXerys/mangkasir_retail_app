import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../features/products/domain/usecases/add_product_usecase.dart';
import '../../../../../features/products/domain/usecases/update_product_usecase.dart';
import '../../../../../features/products/domain/usecases/watch_products_usecase.dart';
import 'product_event.dart';
import 'product_state.dart';

@injectable
class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final WatchProductsUseCase _watchProducts;
  final AddProductUseCase _addProduct;
  final UpdateProductUseCase _updateProduct;

  ProductBloc(
    this._watchProducts,
    this._addProduct,
    this._updateProduct,
  ) : super(const ProductState.initial()) {
    on<ProductWatchStarted>(_onWatchStarted);
    on<ProductAdded>(_onAdded);
    on<ProductUpdated>(_onUpdated);
  }

  Future<void> _onWatchStarted(
    ProductWatchStarted event,
    Emitter<ProductState> emit,
  ) async {
    emit(const ProductState.loading());
    // emit.forEach auto-cancels subscription when BLoC is closed.
    await emit.forEach(
      _watchProducts(categoryId: event.categoryId),
      onData: (result) => result.fold(
        (failure) => ProductState.error(message: failure.message),
        (products) => ProductState.loaded(products: products),
      ),
      onError: (e, _) => ProductState.error(message: e.toString()),
    );
  }

  Future<void> _onAdded(
    ProductAdded event,
    Emitter<ProductState> emit,
  ) async {
    final result = await _addProduct(event.product);
    // On success: watch stream auto-pushes updated list — no extra emit needed.
    result.fold(
      (failure) => emit(ProductState.error(message: failure.message)),
      (_) {},
    );
  }

  Future<void> _onUpdated(
    ProductUpdated event,
    Emitter<ProductState> emit,
  ) async {
    final result = await _updateProduct(event.product);
    result.fold(
      (failure) => emit(ProductState.error(message: failure.message)),
      (_) {},
    );
  }
}
