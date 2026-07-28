import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/design/design.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/session/session_scope.dart';
import '../../../../core/utils/id_generator.dart';
import '../../../categories/domain/entities/category.dart';
import '../../../categories/presentation/bloc/category/category_bloc.dart';
import '../../../categories/presentation/bloc/category/category_event.dart';
import '../../../categories/presentation/bloc/category/category_state.dart';
import '../../domain/entities/product.dart';
import '../bloc/product/product_bloc.dart';
import '../bloc/product/product_event.dart';
import '../bloc/product/product_state.dart';

/// Formulir tambah dan ubah produk.
///
/// Satu berkas untuk kedua alamat. Formulir tambah dan formulir ubah di aplikasi
/// ritel berbeda hanya pada nilai awalnya; memecahnya jadi dua halaman berarti
/// setiap kolom baru harus ditambahkan dua kali, dan yang satu pasti terlewat.
class ProductFormPage extends StatefulWidget {
  /// Produk yang sedang diubah. Null berarti formulir tambah.
  final String? productId;

  const ProductFormPage({super.key, this.productId});

  /// `/inventory/products/new`
  static Widget buildNew(BuildContext context, GoRouterState state) =>
      _provide(const ProductFormPage());

  /// `/inventory/products/:id`
  static Widget buildEdit(BuildContext context, GoRouterState state) =>
      _provide(ProductFormPage(productId: state.pathParameters['id']));

  /// Dua bloc, satu halaman: produk yang disimpan, dan kategori yang dipilih.
  ///
  /// [CategoryBloc] ikut dipasang di sini supaya kategori bisa dibuat dari dalam
  /// formulir. Tanpa itu produk pertama tidak punya kategori untuk dipilih, dan
  /// `category_id` yang kosong akan menghalanginya didorong ke server nanti.
  static Widget _provide(Widget child) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProductBloc>(create: (_) => getIt<ProductBloc>()),
        BlocProvider<CategoryBloc>(
          create: (_) =>
              getIt<CategoryBloc>()..add(const CategoryEvent.watchStarted()),
        ),
      ],
      child: child,
    );
  }

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _nameController = TextEditingController();
  final _barcodeController = TextEditingController();
  final _skuController = TextEditingController();

  double _price = 0;
  double _cost = 0;
  String? _categoryId;

  /// Produk yang sedang diubah, bila alamatnya membawa id.
  Product? _existing;
  bool _prefilled = false;

  /// Pesan galat per kolom. Kosong berarti kolom itu belum pernah salah.
  final _errors = <String, String>{};

  @override
  void dispose() {
    _nameController.dispose();
    _barcodeController.dispose();
    _skuController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final storeId = context.sessionOrNull?.activeOutlet?.id.toString();
    if (widget.productId == null || storeId == null || _prefilled) return;

    // Katalog sudah menjadi aliran; formulir ubah menumpang aliran yang sama
    // alih-alih menambah kueri satu-baris tersendiri.
    context.read<ProductBloc>().add(ProductEvent.watchStarted(storeId: storeId));
  }

  void _prefill(List<Product> products) {
    if (_prefilled || widget.productId == null) return;

    final match = products.where((p) => p.id == widget.productId).firstOrNull;
    if (match == null) return;

    _prefilled = true;
    _existing = match;
    _nameController.text = match.name;
    _barcodeController.text = match.barcode ?? '';
    _skuController.text = match.sku ?? '';
    _price = match.price;
    _cost = match.cost;
    _categoryId = match.categoryId;
  }

  // ── penyimpanan ──────────────────────────────────────────────────────────

  bool _validate() {
    final errors = <String, String>{};

    if (_nameController.text.trim().isEmpty) {
      errors['name'] = 'Nama produk wajib diisi';
    }
    if (_price <= 0) {
      errors['price'] = 'Harga jual harus lebih dari nol';
    }
    // Modal boleh nol — barang titipan dan hadiah memang bermodal nol — tapi
    // modal yang melebihi harga jual hampir selalu salah ketik, dan kesalahan
    // itu baru ketahuan berbulan-bulan kemudian di laporan laba.
    if (_cost > _price && _price > 0) {
      errors['cost'] = 'Modal melebihi harga jual';
    }

    setState(() {
      _errors
        ..clear()
        ..addAll(errors);
    });
    return errors.isEmpty;
  }

  void _save() {
    if (!_validate()) return;

    final storeId = context.session.activeOutlet?.id.toString();
    if (storeId == null) {
      AppToast.danger(context, 'Tidak ada outlet aktif');
      return;
    }

    final now = DateTime.now();
    final existing = _existing;

    final product = Product(
      id: existing?.id ?? generateId(),
      guid: existing?.guid ?? generateId(),
      name: _nameController.text.trim(),
      barcode: _barcodeController.text.trim().isEmpty
          ? null
          : _barcodeController.text.trim(),
      sku: _skuController.text.trim().isEmpty
          ? null
          : _skuController.text.trim(),
      price: _price,
      cost: _cost,
      storeId: storeId,
      categoryId: _categoryId,
      // Produk baru maupun yang diubah selalu kembali menunggu antrean unggah.
      // Ini yang membuat perubahan luring tidak pernah hilang diam-diam.
      syncStatus: 'pending',
      serverId: existing?.serverId,
      createdAt: existing?.createdAt ?? now,
      updatedAt: now,
    );

    final bloc = context.read<ProductBloc>();
    bloc.add(
      existing == null
          ? ProductEvent.added(product: product)
          : ProductEvent.updated(product: product),
    );

    AppToast.success(
      context,
      existing == null ? 'Produk ditambahkan' : 'Perubahan tersimpan',
    );
    context.go(AppRoutes.inventoryProducts);
  }

  Future<void> _createCategory() async {
    final storeId = context.session.activeOutlet?.id.toString();
    if (storeId == null) return;

    final bloc = context.read<CategoryBloc>();
    final name = await showAppDialog<String>(
      context: context,
      builder: (dialogContext) => const _CategoryDialog(),
    );
    if (name == null || name.trim().isEmpty || !mounted) return;

    final now = DateTime.now();
    final category = Category(
      id: generateId(),
      guid: generateId(),
      name: name.trim(),
      storeId: storeId,
      createdAt: now,
      updatedAt: now,
    );

    bloc.add(CategoryEvent.added(category: category));
    setState(() => _categoryId = category.id);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductBloc, ProductState>(
      listener: (context, state) {
        if (state is ProductLoaded) setState(() => _prefill(state.products));
        if (state is ProductError) AppToast.danger(context, state.message);
      },
      child: SingleChildScrollView(
        padding: EdgeInsets.all(context.space.xl),
        child: AppPanel(
          header: Text(
            widget.productId == null ? 'Produk baru' : 'Ubah produk',
            style: context.text.toolbarTitle,
          ),
          footer: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AppButton(
                label: 'Batal',
                variant: AppButtonVariant.ghost,
                size: AppButtonSize.small,
                onPressed: () => context.go(AppRoutes.inventoryProducts),
              ),
              SizedBox(width: context.space.sm),
              AppButton(
                label: 'Simpan',
                size: AppButtonSize.small,
                onPressed: _save,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppTextField(
                label: 'Nama produk',
                hint: 'Indomie Goreng',
                controller: _nameController,
                errorText: _errors['name'],
                autofocus: true,
              ),
              SizedBox(height: context.space.lg),
              AppTextField(
                label: 'Barcode',
                hint: 'Pindai atau ketik',
                controller: _barcodeController,
                isNumeric: true,
                helperText: 'Kosongkan bila produk tidak berbarcode.',
              ),
              SizedBox(height: context.space.lg),
              AppTextField(
                label: 'SKU',
                hint: 'Kode internal',
                controller: _skuController,
              ),
              SizedBox(height: context.space.lg),
              AppCurrencyInput(
                label: 'Harga jual',
                value: _price,
                errorText: _errors['price'],
                onChanged: (value) => _price = value,
              ),
              SizedBox(height: context.space.lg),
              AppCurrencyInput(
                label: 'Modal',
                value: _cost,
                errorText: _errors['cost'],
                onChanged: (value) => _cost = value,
              ),
              SizedBox(height: context.space.lg),
              _CategoryField(
                value: _categoryId,
                onChanged: (value) => setState(() => _categoryId = value),
                onCreate: _createCategory,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Pemilih kategori yang bisa membuat kategori baru di tempat.
class _CategoryField extends StatelessWidget {
  final String? value;
  final ValueChanged<String?> onChanged;
  final Future<void> Function() onCreate;

  const _CategoryField({
    required this.value,
    required this.onChanged,
    required this.onCreate,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        final categories = switch (state) {
          CategoryLoaded(:final categories) => categories,
          _ => const <Category>[],
        };

        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: AppSelect<String>(
                label: 'Kategori',
                hint: categories.isEmpty
                    ? 'Belum ada kategori'
                    : 'Pilih kategori',
                value: value,
                searchable: true,
                options: [
                  for (final category in categories)
                    AppSelectOption(value: category.id, label: category.name),
                ],
                onChanged: onChanged,
              ),
            ),
            SizedBox(width: context.space.sm),
            AppButton(
              label: 'Kategori baru',
              icon: AppIcons.add,
              variant: AppButtonVariant.secondary,
              size: AppButtonSize.small,
              onPressed: onCreate,
            ),
          ],
        );
      },
    );
  }
}

/// Dialog satu kolom untuk membuat kategori tanpa meninggalkan formulir.
class _CategoryDialog extends StatefulWidget {
  const _CategoryDialog();

  @override
  State<_CategoryDialog> createState() => _CategoryDialogState();
}

class _CategoryDialogState extends State<_CategoryDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() => Navigator.of(context).pop(_controller.text);

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      title: 'Kategori baru',
      maxWidth: 400,
      onSubmit: _submit,
      content: AppTextField(
        label: 'Nama kategori',
        hint: 'Makanan instan',
        controller: _controller,
        autofocus: true,
        onSubmitted: (_) => _submit(),
      ),
      actions: [
        AppButton(
          label: 'Batal',
          variant: AppButtonVariant.ghost,
          size: AppButtonSize.small,
          onPressed: () => Navigator.of(context).pop(),
        ),
        AppButton(
          label: 'Simpan',
          size: AppButtonSize.small,
          onPressed: _submit,
        ),
      ],
    );
  }
}
