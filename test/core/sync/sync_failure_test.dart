import 'package:flutter_test/flutter_test.dart';
import 'package:mangkasir_retail_app/core/error/failures.dart';
import 'package:mangkasir_retail_app/core/session/app_role.dart';
import 'package:mangkasir_retail_app/core/sync/sync_bloc/sync_bloc.dart';
import 'package:mangkasir_retail_app/core/sync/sync_bloc/sync_event.dart';
import 'package:mangkasir_retail_app/core/sync/sync_bloc/sync_state.dart';
import 'package:mangkasir_retail_app/core/sync/sync_policy.dart';
import 'package:mangkasir_retail_app/core/sync/sync_worker.dart';
import 'package:mangkasir_retail_app/features/products/domain/usecases/add_product_usecase.dart';
import 'package:mangkasir_retail_app/features/products/domain/usecases/update_product_usecase.dart';
import 'package:mangkasir_retail_app/features/products/domain/usecases/watch_products_usecase.dart';
import 'package:mangkasir_retail_app/features/products/presentation/bloc/product/product_bloc.dart';

import '../../support/app_harness.dart';
import '../../support/fake_category_repository.dart';
import '../../support/fake_product_repository.dart';
import '../../support/fake_sync_repositories.dart';

void main() {
  test('fase ini belum mendorong apa pun ke server', () {
    // Sakelar ini yang membuat UI-5 lepas sepenuhnya dari BE-2. Kalau ia
    // dinyalakan sebelum outlet di-seed, setiap produk gagal FK dan seluruh
    // antrean sinkronisasi ikut tertahan tanpa gejala.
    expect(SyncPolicy.pushEnabled, isFalse);
  });

  test('produk yang gagal didorong menahan transaksi dan pembayaran', () async {
    final products = FakeProductRepository(
      pushFailure: SyncFailure('outlet_id tidak ada di server'),
    );
    final transactions = FakeTransactionRepository();
    final payments = FakePaymentRepository();
    addTearDown(products.dispose);

    final categories = FakeCategoryRepository();
    addTearDown(categories.dispose);

    final worker = SyncWorker(categories, products, transactions, payments);

    final seen = <String>[];
    Object? thrown;
    try {
      await for (final progress in worker.run()) {
        seen.add('${progress.entity.name}:${progress.isDone}');
      }
    } catch (error) {
      thrown = error;
    }

    expect(thrown, isA<SyncAbortedException>());
    expect(seen, ['category:false', 'category:true', 'product:false']);

    // Inilah alasan kegagalan harus terlihat: dua entitas terakhir tidak pernah
    // dicoba, dan tanpa toast pengguna hanya tahu "data saya tidak naik".
    expect(transactions.syncCalled, isFalse);
    expect(payments.syncCalled, isFalse);
  });

  testWidgets('kegagalan sinkronisasi muncul sebagai toast, bukan diam',
      (tester) async {
    final products = FakeProductRepository(
      pushFailure: SyncFailure('outlet_id tidak ada di server'),
    );
    final categories = FakeCategoryRepository();
    addTearDown(products.dispose);
    addTearDown(categories.dispose);

    final sync = SyncBloc(
      SyncWorker(
        categories,
        products,
        FakeTransactionRepository(),
        FakePaymentRepository(),
      ),
    );
    addTearDown(sync.close);

    registerFake<ProductBloc>(
      () => ProductBloc(
        WatchProductsUseCase(products),
        AddProductUseCase(products),
        UpdateProductUseCase(products),
      ),
    );

    await pumpApp(tester, role: AppRole.owner, sync: sync);

    sync.add(const SyncEvent.requested());
    await tester.pumpAndSettle();

    expect(sync.state, isA<SyncFailed>());
    expect(find.textContaining('Sinkronisasi berhenti di produk'),
        findsOneWidget);

    await settleToasts(tester);
  });
}
