import 'package:flutter_test/flutter_test.dart';
import 'package:mangkasir_retail_app/core/constants/app_routes.dart';
import 'package:mangkasir_retail_app/core/design/design.dart';
import 'package:mangkasir_retail_app/core/session/app_role.dart';
import 'package:mangkasir_retail_app/features/products/domain/usecases/add_product_usecase.dart';
import 'package:mangkasir_retail_app/features/products/domain/usecases/update_product_usecase.dart';
import 'package:mangkasir_retail_app/features/products/domain/usecases/watch_products_usecase.dart';
import 'package:mangkasir_retail_app/features/products/presentation/bloc/product/product_bloc.dart';

import 'support/app_harness.dart';
import 'support/fake_product_repository.dart';

/// Uji asap **aplikasi**, bukan design system.
///
/// Sampai UI-5 berkas ini berisi uji galeri — yang sebenarnya tes design system
/// dan kini tinggal di `test/core/design/design_gallery_smoke_test.dart`.
/// Tempatnya yang benar adalah di sini: menaikkan rakitan yang sama dengan yang
/// dijalankan perangkat, lalu membuktikan aplikasinya benar-benar berdiri.
void main() {
  testWidgets('aplikasi berdiri dan mendarat sesuai peran', (tester) async {
    await pumpApp(tester, role: AppRole.owner);

    expect(find.byType(AppShell), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('rute produk terbuka tanpa galat', (tester) async {
    final repository = FakeProductRepository();
    addTearDown(repository.dispose);

    registerFake<ProductBloc>(
      () => ProductBloc(
        WatchProductsUseCase(repository),
        AddProductUseCase(repository),
        UpdateProductUseCase(repository),
      ),
    );

    await pumpApp(tester, role: AppRole.owner);
    await goTo(tester, AppRoutes.inventoryProducts);

    expect(find.byType(AppShell), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('aplikasi berdiri di ponsel', (tester) async {
    await pumpApp(tester, role: AppRole.kasir, surface: phoneSurface);

    expect(find.byType(AppShell), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('galeri sudah tidak punya alamat di dalam aplikasi',
      (tester) async {
    // Rute /dev/design dicabut di UI-5. Kalau seseorang memasangnya kembali,
    // tes ini yang memberi tahu — galeri dijalankan lewat entrypoint
    // tersendiri, `flutter run -t lib/design_gallery_main.dart`.
    await pumpApp(tester, role: AppRole.owner);
    await goTo(tester, '/dev/design');

    expect(find.text('Design System — MangRitel'), findsNothing);
  });
}
