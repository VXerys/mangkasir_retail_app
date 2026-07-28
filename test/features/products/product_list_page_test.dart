import 'package:flutter_test/flutter_test.dart';
import 'package:mangkasir_retail_app/core/constants/app_routes.dart';
import 'package:mangkasir_retail_app/core/error/failures.dart';
import 'package:mangkasir_retail_app/core/session/app_role.dart';
import 'package:mangkasir_retail_app/features/products/domain/usecases/add_product_usecase.dart';
import 'package:mangkasir_retail_app/features/products/domain/usecases/update_product_usecase.dart';
import 'package:mangkasir_retail_app/features/products/domain/usecases/watch_products_usecase.dart';
import 'package:mangkasir_retail_app/features/products/presentation/bloc/product/product_bloc.dart';

import '../../support/app_harness.dart';
import '../../support/fake_product_repository.dart';

/// Memasang [ProductBloc] di atas [repository], lalu menaikkan aplikasi.
Future<void> _pumpProducts(
  WidgetTester tester,
  FakeProductRepository repository, {
  String role = AppRole.owner,
  int outletId = 1,
}) async {
  addTearDown(repository.dispose);

  // Usecase-nya yang asli, bukan ganda: yang perlu diganti hanya sumber
  // datanya. Usecase yang ikut dipalsukan berarti rantai bloc → usecase →
  // repository tidak pernah terbukti tersambung.
  registerFake<ProductBloc>(
    () => ProductBloc(
      WatchProductsUseCase(repository),
      AddProductUseCase(repository),
      UpdateProductUseCase(repository),
    ),
  );

  await pumpApp(tester, role: role, outletId: outletId);
  await goTo(tester, AppRoutes.inventoryProducts);
}

void main() {
  testWidgets('katalog kosong menawarkan produk pertama', (tester) async {
    await _pumpProducts(tester, FakeProductRepository());

    expect(find.text('Belum ada produk'), findsOneWidget);
    expect(find.text('Tambah produk'), findsWidgets);
  });

  testWidgets('produk yang ada tampil beserta harganya', (tester) async {
    await _pumpProducts(
      tester,
      FakeProductRepository(
        products: [
          sampleProduct(id: 'p1', name: 'Indomie Goreng', price: 3500, cost: 2500),
          sampleProduct(id: 'p2', name: 'Aqua 600ml', price: 4000, cost: 3000),
        ],
      ),
    );

    expect(find.text('Indomie Goreng'), findsOneWidget);
    expect(find.text('Aqua 600ml'), findsOneWidget);
    expect(find.text('Rp 3.500'), findsOneWidget);
    expect(find.text('Rp 2.500'), findsOneWidget);
  });

  testWidgets('katalog hanya memuat produk outlet aktif', (tester) async {
    // Inti dari ui5-store-id. Sebelum penyaring outlet dipasang, kedua produk
    // di bawah ini tampil bersamaan dan pengalih outlet hanya mengganti label.
    await _pumpProducts(
      tester,
      FakeProductRepository(
        products: [
          sampleProduct(id: 'p1', name: 'Milik Outlet Pusat', storeId: '1'),
          sampleProduct(id: 'p2', name: 'Milik Cabang Antang', storeId: '2'),
        ],
      ),
    );

    expect(find.text('Milik Outlet Pusat'), findsOneWidget);
    expect(find.text('Milik Cabang Antang'), findsNothing);
  });

  testWidgets('pencarian menyaring menurut nama dan barcode', (tester) async {
    await _pumpProducts(
      tester,
      FakeProductRepository(
        products: [
          sampleProduct(id: 'p1', name: 'Indomie Goreng', barcode: '899111'),
          sampleProduct(id: 'p2', name: 'Aqua 600ml', barcode: '899222'),
        ],
      ),
    );

    await search(tester, '899222');

    expect(find.text('Aqua 600ml'), findsOneWidget);
    expect(find.text('Indomie Goreng'), findsNothing);

    // Kata kunci yang tidak cocok punya keadaan kosongnya sendiri, berbeda dari
    // katalog yang memang belum berisi apa pun.
    await search(tester, 'sabun');

    expect(find.text('Tidak ditemukan'), findsOneWidget);
  });

  testWidgets('galat dari lapisan data tampil dengan jalan mencoba lagi',
      (tester) async {
    await _pumpProducts(
      tester,
      FakeProductRepository(failure: LocalFailure('Basis data terkunci')),
    );

    expect(find.textContaining('Basis data terkunci'), findsOneWidget);
  });

  testWidgets('status sinkronisasi terlihat di setiap baris', (tester) async {
    await _pumpProducts(
      tester,
      FakeProductRepository(
        products: [
          sampleProduct(id: 'p1', name: 'Belum naik', syncStatus: 'pending'),
          sampleProduct(id: 'p2', name: 'Sudah naik', syncStatus: 'synced'),
        ],
      ),
    );

    expect(find.text('Menunggu'), findsOneWidget);
    expect(find.text('Tersinkron'), findsOneWidget);
  });

  testWidgets('Kasir tidak ditawari menambah produk', (tester) async {
    // Kasir memegang PRODUCT_READ tetapi bukan PRODUCT_CREATE — dikoreksi di
    // UI-4 setelah matriks izin dokumen ternyata salah di empat sel.
    await _pumpProducts(
      tester,
      FakeProductRepository(),
      role: AppRole.kasir,
    );

    expect(find.text('Tambah produk'), findsNothing);
  });
}
