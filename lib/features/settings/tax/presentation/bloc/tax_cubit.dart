import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/tax_settings.dart';
import '../../domain/repositories/tax_repository.dart';
import 'tax_state.dart';

@injectable
class TaxCubit extends Cubit<TaxState> {
  final TaxRepository _repository;

  TaxCubit(this._repository) : super(const TaxLoading());

  Future<void> load(int outletId) async {
    emit(const TaxLoading());
    final result = await _repository.get(outletId);
    if (isClosed) return;
    result.fold(
      (f) => emit(TaxError(f.message)),
      (settings) => emit(TaxLoaded(settings)),
    );
  }

  Future<void> save(TaxSettings settings) async {
    emit(const TaxSaving());
    final result = await _repository.save(settings);
    if (isClosed) return;
    result.fold(
      (f) => emit(TaxError(f.message)),
      (saved) => emit(TaxLoaded(saved)),
    );
  }
}
