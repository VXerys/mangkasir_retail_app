import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../features/categories/domain/usecases/add_category_usecase.dart';
import '../../../../../features/categories/domain/usecases/archive_category_usecase.dart';
import '../../../../../features/categories/domain/usecases/get_categories_usecase.dart';
import '../../../../../features/categories/domain/usecases/update_category_usecase.dart';
import 'category_event.dart';
import 'category_state.dart';

@injectable
class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final GetCategoriesUseCase _getCategories;
  final AddCategoryUseCase _addCategory;
  final UpdateCategoryUseCase _updateCategory;
  final ArchiveCategoryUseCase _archiveCategory;

  CategoryBloc(
    this._getCategories,
    this._addCategory,
    this._updateCategory,
    this._archiveCategory,
  ) : super(const CategoryState.initial()) {
    on<CategoryWatchStarted>(_onWatchStarted);
    on<CategoryAdded>(_onAdded);
    on<CategoryUpdated>(_onUpdated);
    on<CategoryArchived>(_onArchived);
  }

  Future<void> _onWatchStarted(
    CategoryWatchStarted event,
    Emitter<CategoryState> emit,
  ) async {
    emit(const CategoryState.loading());
    // GetCategoriesUseCase is a one-shot fetch; categories are small and static
    // enough that polling via watch stream is overkill for now.
    // Switch to WatchCategoriesUseCase if real-time updates are needed.
    final result = await _getCategories();
    result.fold(
      (failure) => emit(CategoryState.error(message: failure.message)),
      (categories) => emit(CategoryState.loaded(categories: categories)),
    );
  }

  Future<void> _onAdded(
    CategoryAdded event,
    Emitter<CategoryState> emit,
  ) async {
    final result = await _addCategory(event.category);
    result.fold(
      (failure) => emit(CategoryState.error(message: failure.message)),
      (_) => add(const CategoryEvent.watchStarted()),
    );
  }

  Future<void> _onUpdated(
    CategoryUpdated event,
    Emitter<CategoryState> emit,
  ) async {
    final result = await _updateCategory(event.category);
    result.fold(
      (failure) => emit(CategoryState.error(message: failure.message)),
      (_) => add(const CategoryEvent.watchStarted()),
    );
  }

  Future<void> _onArchived(
    CategoryArchived event,
    Emitter<CategoryState> emit,
  ) async {
    final result = await _archiveCategory(event.id);
    result.fold(
      (failure) => emit(CategoryState.error(message: failure.message)),
      (_) => add(const CategoryEvent.watchStarted()),
    );
  }
}
