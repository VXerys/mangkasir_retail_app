import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:mangkasir_retail_app/core/error/failures.dart';
import 'package:mangkasir_retail_app/features/products/domain/entities/product.dart';
import 'package:mangkasir_retail_app/features/products/domain/repositories/product_repository.dart';

/// Katalog di dalam memori, berperilaku seperti Drift.
///
/// Yang ditiru bukan hanya bentuk jawabannya melainkan sifat **reaktifnya**:
/// [watchActiveByCategory] mengalirkan ulang setiap kali [add] dipanggil,
/// sama seperti `Stream` milik Drift. Ganda yang hanya menjawab sekali akan
/// membuat halaman terlihat benar di tes padahal di perangkat ia tidak pernah
/// memperbarui diri setelah produk disimpan.
///
/// Penyaringan outlet juga ditiru sungguhan — itu justru perilaku yang paling
/// perlu dibuktikan sejak `ui5-store-id`.
class FakeProductRepository implements ProductRepository {
  final List<Product> products;
  final Failure? failure;

  /// Kegagalan yang muncul saat baris menunggu didorong ke server.
  ///
  /// Dipisah dari [failure]: membaca katalog dan mendorongnya adalah dua jalur
  /// yang gagal karena sebab berbeda, dan yang paling perlu diuji justru
  /// kombinasi "katalog terbaca baik-baik saja tetapi push-nya ditolak FK".
  final Failure? pushFailure;

  final _controller = StreamController<List<Product>>.broadcast();

  FakeProductRepository({
    List<Product>? products,
    this.failure,
    this.pushFailure,
  }) : products = List<Product>.of(products ?? const []);

  List<Product> _match({required String storeId, String? categoryId}) {
    return products
        .where((product) => product.storeId == storeId)
        .where((product) => product.status == 'active')
        .where((product) =>
            categoryId == null || product.categoryId == categoryId)
        .toList();
  }

  @override
  Future<Either<Failure, List<Product>>> getAll({
    required String storeId,
    String? categoryId,
  }) async {
    final error = failure;
    if (error != null) return Left(error);
    return Right(_match(storeId: storeId, categoryId: categoryId));
  }

  @override
  Stream<Either<Failure, List<Product>>> watchActiveByCategory({
    required String storeId,
    String? categoryId,
  }) async* {
    final error = failure;
    if (error != null) {
      yield Left(error);
      return;
    }

    // Keadaan sekarang lebih dulu, baru perubahan berikutnya — persis urutan
    // yang dipakai `Stream` milik Drift.
    yield Right(_match(storeId: storeId, categoryId: categoryId));
    yield* _controller.stream
        .map((_) => Right(_match(storeId: storeId, categoryId: categoryId)));
  }

  @override
  Future<Either<Failure, Unit>> add(Product product) async {
    products.add(product);
    _controller.add(products);
    return const Right(unit);
  }

  @override
  Future<Either<Failure, Unit>> update(Product product) async {
    final index = products.indexWhere((p) => p.id == product.id);
    if (index >= 0) products[index] = product;
    _controller.add(products);
    return const Right(unit);
  }

  @override
  Future<Either<Failure, Unit>> syncPending() async {
    final error = pushFailure;
    return error == null ? const Right(unit) : Left(error);
  }

  void dispose() => _controller.close();
}

/// Produk contoh dengan nilai yang masuk akal untuk katalog ritel.
Product sampleProduct({
  required String id,
  required String name,
  String storeId = '1',
  double price = 5000,
  double cost = 3500,
  String? barcode,
  String? sku,
  String syncStatus = 'pending',
}) {
  final now = DateTime(2026, 7, 27);
  return Product(
    id: id,
    guid: 'guid-$id',
    name: name,
    price: price,
    cost: cost,
    barcode: barcode,
    sku: sku,
    storeId: storeId,
    syncStatus: syncStatus,
    createdAt: now,
    updatedAt: now,
  );
}
