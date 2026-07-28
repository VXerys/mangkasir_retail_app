import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:mangkasir_retail_app/core/error/failures.dart';
import 'package:mangkasir_retail_app/features/categories/domain/entities/category.dart';
import 'package:mangkasir_retail_app/features/categories/domain/repositories/category_repository.dart';

/// Daftar kategori di dalam memori.
class FakeCategoryRepository implements CategoryRepository {
  final List<Category> categories;
  final _controller = StreamController<List<Category>>.broadcast();

  FakeCategoryRepository({List<Category>? categories})
      : categories = List<Category>.of(categories ?? const []);

  @override
  Future<Either<Failure, List<Category>>> getAll() async => Right(categories);

  @override
  Stream<Either<Failure, List<Category>>> watchAll() async* {
    yield Right(categories);
    yield* _controller.stream.map(Right.new);
  }

  @override
  Future<Either<Failure, Unit>> add(Category category) async {
    categories.add(category);
    _controller.add(categories);
    return const Right(unit);
  }

  @override
  Future<Either<Failure, Unit>> update(Category category) async {
    final index = categories.indexWhere((c) => c.id == category.id);
    if (index >= 0) categories[index] = category;
    _controller.add(categories);
    return const Right(unit);
  }

  @override
  Future<Either<Failure, Unit>> syncPending() async => const Right(unit);

  void dispose() => _controller.close();
}

Category sampleCategory({
  required String id,
  required String name,
  String storeId = '1',
}) {
  final now = DateTime(2026, 7, 27);
  return Category(
    id: id,
    guid: 'guid-$id',
    name: name,
    storeId: storeId,
    createdAt: now,
    updatedAt: now,
  );
}
