import 'package:flutter_test/flutter_test.dart';
import 'package:mangkasir_retail_app/core/constants/app_routes.dart';
import 'package:mangkasir_retail_app/core/design/design.dart';
import 'package:mangkasir_retail_app/core/session/app_role.dart';
import 'package:mangkasir_retail_app/features/categories/domain/usecases/add_category_usecase.dart';
import 'package:mangkasir_retail_app/features/categories/domain/usecases/get_categories_usecase.dart';
import 'package:mangkasir_retail_app/features/categories/domain/usecases/update_category_usecase.dart';
import 'package:mangkasir_retail_app/features/categories/presentation/bloc/category/category_bloc.dart';
import 'package:mangkasir_retail_app/features/products/domain/usecases/add_product_usecase.dart';
import 'package:mangkasir_retail_app/features/products/domain/usecases/update_product_usecase.dart';
import 'package:mangkasir_retail_app/features/products/domain/usecases/watch_products_usecase.dart';
import 'package:mangkasir_retail_app/features/products/presentation/bloc/product/product_bloc.dart';

import '../../support/app_harness.dart';
import '../../support/fake_category_repository.dart';
import '../../support/fake_product_repository.dart';

late FakeProductRepository products;
late FakeCategoryRepository categories;

Future<void> _pumpForm(
  WidgetTester tester, {
  String route = AppRoutes.inventoryProductNew,
  List<dynamic> seed = const [],
}) async {
  products = FakeProductRepository(products: seed.cast());
  categories = FakeCategoryRepository();
  addTearDown(products.dispose);
  addTearDown(categories.dispose);

  registerFake<ProductBloc>(
    () => ProductBloc(
      WatchProductsUseCase(products),
      AddProductUseCase(products),
      UpdateProductUseCase(products),
    ),
  );
  registerFake<CategoryBloc>(
    () => CategoryBloc(
      GetCategoriesUseCase(categories),
      AddCategoryUseCase(categories),
      UpdateCategoryUseCase(categories),
    ),
  );

  await pumpApp(tester, role: AppRole.owner);
  await goTo(tester, route);
}

void main() {
  testWidgets('produk tersimpan dengan outlet aktif sebagai pemiliknya',
      (tester) async {
    await _pumpForm(tester);

    await tester.enterText(find.byType(AppTextField).first, 'Indomie Goreng');
    await tester.enterText(find.byType(AppCurrencyInput).first, '3500');
    await tester.pumpAndSettle();

    await tester.tap(find.text('Simpan'));
    await tester.pumpAndSettle();
    await settleToasts(tester);

    expect(products.products, hasLength(1));
    expect(products.products.single.name, 'Indomie Goreng');
    expect(products.products.single.price, 3500);

    // Inti dari ui5-store-id: produk lahir milik outlet yang sedang aktif,
    // bukan tanpa pemilik. storeId yang salah membuat push ke Supabase gagal
    // pada FK outlet_id, dan itu baru ketahuan jauh belakangan.
    expect(products.products.single.storeId, '1');

    // Fase ini luring: barisnya menunggu, tidak didorong.
    expect(products.products.single.syncStatus, 'pending');
  });

  testWidgets('nama kosong menahan penyimpanan', (tester) async {
    await _pumpForm(tester);

    await tester.tap(find.text('Simpan'));
    await tester.pumpAndSettle();

    expect(find.text('Nama produk wajib diisi'), findsOneWidget);
    expect(products.products, isEmpty);
  });

  testWidgets('harga nol ditolak', (tester) async {
    await _pumpForm(tester);

    await tester.enterText(find.byType(AppTextField).first, 'Tanpa harga');
    await tester.pumpAndSettle();

    await tester.tap(find.text('Simpan'));
    await tester.pumpAndSettle();

    expect(find.text('Harga jual harus lebih dari nol'), findsOneWidget);
    expect(products.products, isEmpty);
  });

  testWidgets('modal di atas harga jual ditolak', (tester) async {
    await _pumpForm(tester);

    await tester.enterText(find.byType(AppTextField).first, 'Salah ketik');
    await tester.enterText(find.byType(AppCurrencyInput).at(0), '3000');
    await tester.enterText(find.byType(AppCurrencyInput).at(1), '9000');
    await tester.pumpAndSettle();

    await tester.tap(find.text('Simpan'));
    await tester.pumpAndSettle();

    expect(find.text('Modal melebihi harga jual'), findsOneWidget);
    expect(products.products, isEmpty);
  });

  testWidgets('kategori bisa dibuat tanpa meninggalkan formulir',
      (tester) async {
    await _pumpForm(tester);

    expect(find.text('Belum ada kategori'), findsOneWidget);

    await tester.tap(find.text('Kategori baru'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(AppTextField).last, 'Makanan instan');
    await tester.pumpAndSettle();

    await tester.tap(find.text('Simpan').last);
    await tester.pumpAndSettle();

    expect(categories.categories, hasLength(1));
    expect(categories.categories.single.name, 'Makanan instan');
    expect(categories.categories.single.storeId, '1');
  });

  testWidgets('formulir ubah terisi nilai produk yang dipilih', (tester) async {
    await _pumpForm(
      tester,
      route: AppRoutes.productDetail('p1'),
      seed: [
        sampleProduct(id: 'p1', name: 'Aqua 600ml', price: 4000, cost: 2800),
      ],
    );

    expect(find.text('Ubah produk'), findsOneWidget);
    expect(find.widgetWithText(AppTextField, 'Aqua 600ml'), findsOneWidget);
  });
}
