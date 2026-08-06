import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangkasir_retail_app/core/design/design.dart';
import 'package:mangkasir_retail_app/core/error/failures.dart';
import 'package:mangkasir_retail_app/core/sync/sync_bloc/sync_bloc.dart';
import 'package:mangkasir_retail_app/core/sync/sync_bloc/sync_state.dart';
import 'package:mangkasir_retail_app/core/sync/sync_failure_listener.dart';
import 'package:mangkasir_retail_app/core/sync/sync_policy.dart';
import 'package:mangkasir_retail_app/core/sync/sync_worker.dart';

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
    final categories = FakeCategoryRepository();
    final products = FakeProductRepository();
    addTearDown(categories.dispose);
    addTearDown(products.dispose);

    final sync = SyncBloc(
      SyncWorker(
        categories,
        products,
        FakeTransactionRepository(),
        FakePaymentRepository(),
      ),
    );
    // addTearDown(sync.close) sengaja TIDAK dipakai: Bloc.close() menunggu
    // _eventController.close() lalu _stateController.close(), keduanya butuh
    // microtask FakeAsync yang hanya berjalan saat pump() dipanggil. Di dalam
    // teardown tidak ada pump, jadi Future-nya tidak pernah selesai → timeout
    // 10 menit. Sebagai gantinya, teardown ini membuang Future close() dan
    // memompa sendiri supaya microtask onDone terpropagasi bersih.
    addTearDown(() async {
      sync.close(); // ignore: discarded_futures
      await tester.pump(const Duration(seconds: 5));
    });

    // Harness minimal — MaterialApp memberi Navigator + Overlay.
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: SyncFailureListener(
          bloc: sync,
          child: const SizedBox.shrink(),
        ),
      ),
    );

    // emit() adalah @visibleForTesting di bloc 9.x — langsung tembak SyncFailed
    // ke BlocListener tanpa melewati async* emit.forEach yang menggantung di
    // FakeAsync (stream onDone tidak selalu menyala di dalam flushMicrotasks).
    // Unit test terpisah sudah memastikan SyncBloc mengeluarkan SyncFailed saat
    // push gagal; tes ini khusus memverifikasi SyncFailureListener menampilkan
    // toast.
    sync.emit(const SyncState.failed(
      failedAt: SyncEntity.product,
      message: 'outlet_id tidak ada di server',
    ));
    await tester.pump();

    expect(find.textContaining('Sinkronisasi berhenti di produk'),
        findsOneWidget);

    await tester.pump(const Duration(seconds: 5));
  });
}
