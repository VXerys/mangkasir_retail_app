import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/brand.dart';
import '../../domain/repositories/brand_repository.dart';
import 'brand_state.dart';

@injectable
class BrandCubit extends Cubit<BrandState> {
  final BrandRepository _repository;

  BrandCubit(this._repository) : super(const BrandLoading());

  Future<void> load(int businessId) async {
    emit(const BrandLoading());
    final result = await _repository.getAll(businessId);
    if (isClosed) return;
    result.fold(
      (f) => emit(BrandError(f.message)),
      (brands) => emit(BrandLoaded(brands)),
    );
  }

  Future<void> create(Brand brand) async {
    final current = _current();
    if (current == null) return;
    emit(const BrandSaving());
    final result = await _repository.create(brand);
    if (isClosed) return;
    result.fold(
      (f) => emit(BrandError(f.message)),
      (created) => emit(BrandLoaded([...current, created])),
    );
  }

  Future<void> update(Brand brand) async {
    final current = _current();
    if (current == null) return;
    emit(const BrandSaving());
    final result = await _repository.update(brand);
    if (isClosed) return;
    result.fold(
      (f) => emit(BrandError(f.message)),
      (updated) => emit(
        BrandLoaded(current.map((b) => b.id == updated.id ? updated : b).toList()),
      ),
    );
  }

  Future<void> deactivate(int id) async {
    final current = _current();
    if (current == null) return;
    emit(const BrandSaving());
    final result = await _repository.deactivate(id);
    if (isClosed) return;
    result.fold(
      (f) => emit(BrandError(f.message)),
      (_) => emit(BrandLoaded(current.where((b) => b.id != id).toList())),
    );
  }

  List<Brand>? _current() {
    final s = state;
    return s is BrandLoaded ? s.brands : null;
  }
}
