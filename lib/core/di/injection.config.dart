// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:connectivity_plus/connectivity_plus.dart' as _i895;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:supabase_flutter/supabase_flutter.dart' as _i454;

import '../../features/cashier/data/datasources/cart_storage.dart' as _i669;
import '../../features/cashier/domain/usecases/calculate_cart_totals.dart'
    as _i561;
import '../../features/cashier/domain/usecases/checkout_usecase.dart' as _i997;
import '../../features/cashier/presentation/bloc/cart/cart_bloc.dart' as _i666;
import '../../features/cashier/presentation/bloc/payment/payment_cubit.dart'
    as _i384;
import '../../features/categories/data/datasources/category_local_ds.dart'
    as _i713;
import '../../features/categories/data/datasources/category_remote_ds.dart'
    as _i325;
import '../../features/categories/data/repositories/category_repository_impl.dart'
    as _i894;
import '../../features/categories/domain/repositories/category_repository.dart'
    as _i266;
import '../../features/categories/domain/usecases/add_category_usecase.dart'
    as _i374;
import '../../features/categories/domain/usecases/get_categories_usecase.dart'
    as _i76;
import '../../features/categories/domain/usecases/update_category_usecase.dart'
    as _i656;
import '../../features/categories/presentation/bloc/category/category_bloc.dart'
    as _i366;
import '../../features/payments/data/datasources/payment_local_ds.dart'
    as _i971;
import '../../features/payments/data/datasources/payment_remote_ds.dart'
    as _i710;
import '../../features/payments/data/repositories/payment_repository_impl.dart'
    as _i842;
import '../../features/payments/domain/repositories/payment_repository.dart'
    as _i315;
import '../../features/products/data/datasources/product_local_ds.dart'
    as _i214;
import '../../features/products/data/datasources/product_remote_ds.dart'
    as _i474;
import '../../features/products/data/repositories/product_repository_impl.dart'
    as _i764;
import '../../features/products/domain/repositories/product_repository.dart'
    as _i963;
import '../../features/products/domain/usecases/add_product_usecase.dart'
    as _i570;
import '../../features/products/domain/usecases/get_products_usecase.dart'
    as _i15;
import '../../features/products/domain/usecases/update_product_usecase.dart'
    as _i73;
import '../../features/products/domain/usecases/watch_products_usecase.dart'
    as _i622;
import '../../features/products/presentation/bloc/product/product_bloc.dart'
    as _i426;
import '../../features/transactions/data/datasources/transaction_local_ds.dart'
    as _i1013;
import '../../features/transactions/data/datasources/transaction_remote_ds.dart'
    as _i131;
import '../../features/transactions/data/repositories/transaction_repository_impl.dart'
    as _i443;
import '../../features/transactions/domain/repositories/transaction_repository.dart'
    as _i421;
import '../database/app_database.dart' as _i982;
import '../network/connectivity_module.dart' as _i154;
import '../network/supabase_module.dart' as _i374;
import '../sync/connectivity_service.dart' as _i312;
import '../sync/sync_bloc/sync_bloc.dart' as _i547;
import '../sync/sync_worker.dart' as _i987;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final connectivityModule = _$ConnectivityModule();
    final supabaseModule = _$SupabaseModule();
    gh.factory<_i561.CalculateCartTotals>(
      () => const _i561.CalculateCartTotals(),
    );
    gh.singleton<_i982.AppDatabase>(() => _i982.AppDatabase());
    gh.lazySingleton<_i895.Connectivity>(() => connectivityModule.connectivity);
    gh.lazySingleton<_i454.SupabaseClient>(() => supabaseModule.supabaseClient);
    gh.lazySingleton<_i669.CartStorage>(() => _i669.CartStorage());
    gh.lazySingleton<_i214.ProductLocalDs>(
      () => _i214.ProductLocalDsImpl(gh<_i982.AppDatabase>()),
    );
    gh.lazySingleton<_i713.CategoryLocalDs>(
      () => _i713.CategoryLocalDsImpl(gh<_i982.AppDatabase>()),
    );
    gh.lazySingleton<_i325.CategoryRemoteDs>(
      () => _i325.CategoryRemoteDsImpl(gh<_i454.SupabaseClient>()),
    );
    gh.lazySingleton<_i131.TransactionRemoteDs>(
      () => _i131.TransactionRemoteDsImpl(gh<_i454.SupabaseClient>()),
    );
    gh.lazySingleton<_i710.PaymentRemoteDs>(
      () => _i710.PaymentRemoteDsImpl(gh<_i454.SupabaseClient>()),
    );
    gh.lazySingleton<_i1013.TransactionLocalDs>(
      () => _i1013.TransactionLocalDsImpl(gh<_i982.AppDatabase>()),
    );
    gh.lazySingleton<_i312.ConnectivityService>(
      () => _i312.ConnectivityService(gh<_i895.Connectivity>()),
    );
    gh.lazySingleton<_i971.PaymentLocalDs>(
      () => _i971.PaymentLocalDsImpl(gh<_i982.AppDatabase>()),
    );
    gh.lazySingleton<_i474.ProductRemoteDs>(
      () => _i474.ProductRemoteDsImpl(gh<_i454.SupabaseClient>()),
    );
    gh.lazySingleton<_i666.CartBloc>(
      () => _i666.CartBloc(gh<_i669.CartStorage>()),
    );
    gh.lazySingleton<_i421.TransactionRepository>(
      () => _i443.TransactionRepositoryImpl(
        gh<_i1013.TransactionLocalDs>(),
        gh<_i131.TransactionRemoteDs>(),
      ),
    );
    gh.lazySingleton<_i315.PaymentRepository>(
      () => _i842.PaymentRepositoryImpl(
        gh<_i971.PaymentLocalDs>(),
        gh<_i710.PaymentRemoteDs>(),
      ),
    );
    gh.lazySingleton<_i266.CategoryRepository>(
      () => _i894.CategoryRepositoryImpl(
        gh<_i713.CategoryLocalDs>(),
        gh<_i325.CategoryRemoteDs>(),
        gh<_i214.ProductLocalDs>(),
      ),
    );
    gh.factory<_i997.CheckoutUseCase>(
      () => _i997.CheckoutUseCase(
        gh<_i421.TransactionRepository>(),
        gh<_i315.PaymentRepository>(),
        gh<_i561.CalculateCartTotals>(),
      ),
    );
    gh.lazySingleton<_i963.ProductRepository>(
      () => _i764.ProductRepositoryImpl(
        gh<_i214.ProductLocalDs>(),
        gh<_i474.ProductRemoteDs>(),
      ),
    );
    gh.factory<_i374.AddCategoryUseCase>(
      () => _i374.AddCategoryUseCase(gh<_i266.CategoryRepository>()),
    );
    gh.factory<_i76.GetCategoriesUseCase>(
      () => _i76.GetCategoriesUseCase(gh<_i266.CategoryRepository>()),
    );
    gh.factory<_i656.UpdateCategoryUseCase>(
      () => _i656.UpdateCategoryUseCase(gh<_i266.CategoryRepository>()),
    );
    gh.lazySingleton<_i987.SyncWorker>(
      () => _i987.SyncWorker(
        gh<_i266.CategoryRepository>(),
        gh<_i963.ProductRepository>(),
        gh<_i421.TransactionRepository>(),
        gh<_i315.PaymentRepository>(),
      ),
    );
    gh.factory<_i384.PaymentCubit>(
      () => _i384.PaymentCubit(
        gh<_i997.CheckoutUseCase>(),
        gh<_i561.CalculateCartTotals>(),
        gh<_i666.CartBloc>(),
      ),
    );
    gh.factory<_i366.CategoryBloc>(
      () => _i366.CategoryBloc(
        gh<_i76.GetCategoriesUseCase>(),
        gh<_i374.AddCategoryUseCase>(),
        gh<_i656.UpdateCategoryUseCase>(),
      ),
    );
    gh.factory<_i570.AddProductUseCase>(
      () => _i570.AddProductUseCase(gh<_i963.ProductRepository>()),
    );
    gh.factory<_i15.GetProductsUseCase>(
      () => _i15.GetProductsUseCase(gh<_i963.ProductRepository>()),
    );
    gh.factory<_i73.UpdateProductUseCase>(
      () => _i73.UpdateProductUseCase(gh<_i963.ProductRepository>()),
    );
    gh.factory<_i622.WatchProductsUseCase>(
      () => _i622.WatchProductsUseCase(gh<_i963.ProductRepository>()),
    );
    gh.lazySingleton<_i547.SyncBloc>(
      () => _i547.SyncBloc(gh<_i987.SyncWorker>()),
    );
    gh.factory<_i426.ProductBloc>(
      () => _i426.ProductBloc(
        gh<_i622.WatchProductsUseCase>(),
        gh<_i570.AddProductUseCase>(),
        gh<_i73.UpdateProductUseCase>(),
      ),
    );
    return this;
  }
}

class _$ConnectivityModule extends _i154.ConnectivityModule {}

class _$SupabaseModule extends _i374.SupabaseModule {}
