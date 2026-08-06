import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/entities/business.dart';
import '../../../domain/repositories/business_repository.dart';
import 'business_state.dart';

@injectable
class BusinessCubit extends Cubit<BusinessState> {
  final BusinessRepository _repository;

  BusinessCubit(this._repository) : super(const BusinessState.loading());

  Future<void> load(int businessId) async {
    emit(const BusinessState.loading());
    final result = await _repository.getBusiness(businessId);
    result.fold(
      (f) => emit(BusinessState.error(f.message)),
      (business) => emit(BusinessState.loaded(business)),
    );
  }

  Future<void> save(Business business) async {
    emit(const BusinessState.saving());
    final result = await _repository.updateBusiness(business);
    if (isClosed) return;
    result.fold(
      (f) => emit(BusinessState.error(f.message)),
      (updated) => emit(BusinessState.saved(updated)),
    );
  }
}
