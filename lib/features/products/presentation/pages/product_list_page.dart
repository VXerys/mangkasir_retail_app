import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/design/design.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/session/app_permissions.dart';
import '../../../../core/session/session_scope.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../domain/entities/product.dart';
import '../bloc/product/product_bloc.dart';
import '../bloc/product/product_event.dart';
import '../bloc/product/product_state.dart';

/// Katalog produk satu outlet.
///
/// Halaman fitur nyata pertama di aplikasi ini. Tidak memakai [Scaffold]: ia
/// dirender ke slot `workspace` milik `AppShell`, yang sudah menyediakannya.
class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  /// Titik masuk yang didaftarkan di `AppPageRegistry`.
  ///
  /// Bloc dibuat di sini, bukan di tabel rute: `ProductBloc` adalah `@injectable`
  /// (pabrik), jadi tiap kali halaman dipasang ia mendapat instans baru dan
  /// [BlocProvider] yang menutupnya saat halaman dilepas. Router tidak boleh
  /// tahu apa-apa soal bloc fitur.
  static Widget build(BuildContext context, GoRouterState state) {
    return BlocProvider<ProductBloc>(
      create: (_) => getIt<ProductBloc>(),
      child: const ProductListPage(),
    );
  }

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  String _query = '';
  int _page = 1;
  int _pageSize = 25;
  AppSortState? _sort;

  /// Outlet yang alirannya sedang ditonton.
  ///
  /// Disimpan supaya ganti outlet benar-benar memulai ulang aliran. Tanpa ini
  /// katalog outlet lama tetap tampil sampai halaman dibuka ulang — persis bug
  /// yang membuat pengalih outlet terasa hanya mengganti label.
  String? _watchedStoreId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final storeId = context.sessionOrNull?.activeOutlet?.id.toString();
    if (storeId == null || storeId == _watchedStoreId) return;

    _watchedStoreId = storeId;
    _page = 1;
    context.read<ProductBloc>().add(ProductEvent.watchStarted(storeId: storeId));
  }

  // ── penyaringan, pengurutan, penomoran halaman ───────────────────────────
  //
  // Ketiganya dikerjakan di sini, bukan di kueri. Ini basis data lokal berisi
  // katalog satu outlet, dan perjalanan bolak-balik ke Drift untuk tiap ketukan
  // huruf lebih mahal daripada menyaring daftar yang sudah ada di memori.
  // Begitu katalog tumbuh sampai puluhan ribu baris, yang berpindah ke DAO
  // adalah ketiganya sekaligus — dan [AppDataTable] memang sudah melaporkan
  // pengurutan ke pemanggil alih-alih mengerjakannya sendiri.

  List<Product> _visible(List<Product> products) {
    final query = _query.trim().toLowerCase();

    final filtered = query.isEmpty
        ? products
        : products.where((product) {
            return product.name.toLowerCase().contains(query) ||
                (product.barcode?.toLowerCase().contains(query) ?? false) ||
                (product.sku?.toLowerCase().contains(query) ?? false);
          }).toList();

    final sort = _sort;
    if (sort == null) return filtered;

    final sorted = List<Product>.of(filtered)
      ..sort((a, b) => switch (sort.columnId) {
            'price' => a.price.compareTo(b.price),
            'cost' => a.cost.compareTo(b.cost),
            _ => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
          });

    return sort.ascending ? sorted : sorted.reversed.toList();
  }

  List<Product> _pageOf(List<Product> rows) {
    final start = (_page - 1) * _pageSize;
    if (start >= rows.length) return const [];
    final end = start + _pageSize;
    return rows.sublist(start, end > rows.length ? rows.length : end);
  }

  List<AppColumn<Product>> _columns() {
    return [
      AppColumn.text(
        id: 'name',
        label: 'Nama produk',
        value: (product) => product.name,
        priority: ColumnPriority.primary,
        sortable: true,
        emphasis: true,
        flex: 3,
      ),
      AppColumn.text(
        id: 'barcode',
        label: 'Barcode',
        value: (product) => product.barcode ?? '—',
        priority: ColumnPriority.detail,
        flex: 2,
      ),
      AppColumn.text(
        id: 'sku',
        label: 'SKU',
        value: (product) => product.sku ?? '—',
        priority: ColumnPriority.detail,
        flex: 2,
      ),
      AppColumn.number(
        id: 'price',
        label: 'Harga jual',
        value: (product) => CurrencyFormatter.format(product.price),
        sortable: true,
        flex: 2,
      ),
      AppColumn.number(
        id: 'cost',
        label: 'Modal',
        value: (product) => CurrencyFormatter.format(product.cost),
        priority: ColumnPriority.detail,
        sortable: true,
        flex: 2,
      ),
      AppColumn<Product>(
        id: 'sync',
        label: 'Sinkron',
        // Lebar tetap dan cukup longgar: AppBadge tidak memotong isinya dengan
        // elipsis, ia meluber. Kolom yang pas-pasan akan pecah begitu kerapatan
        // berpindah ke comfortable dan hurufnya membesar.
        width: 168,
        // Status sinkronisasi selalu terlihat karena aplikasi ini offline-first:
        // kasir berhak tahu mana yang sudah sampai di server dan mana yang belum.
        cell: (context, product) => _SyncBadge(status: product.syncStatus),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final canCreate = context.can(AppPermissions.productCreate);

    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        final products = switch (state) {
          ProductLoaded(:final products) => products,
          _ => const <Product>[],
        };
        final rows = _visible(products);

        return Padding(
          padding: EdgeInsets.all(context.space.xl),
          child: AppDataTable<Product>(
            rows: _pageOf(rows),
            columns: _columns(),
            rowId: (product) => product.id,
            isLoading: state is ProductLoading,
            error: state is ProductError ? state.message : null,
            onRetry: () {
              final storeId = _watchedStoreId;
              if (storeId == null) return;
              context
                  .read<ProductBloc>()
                  .add(ProductEvent.watchStarted(storeId: storeId));
            },
            sort: _sort,
            onSortChanged: (sort) => setState(() => _sort = sort),
            onRowTap: (product) =>
                context.go(AppRoutes.productDetail(product.id)),
            emptyTitle: _query.isEmpty ? 'Belum ada produk' : 'Tidak ditemukan',
            emptyMessage: _query.isEmpty
                ? 'Katalog outlet ini masih kosong. Tambahkan produk pertama '
                    'untuk mulai berjualan.'
                : 'Tidak ada produk yang cocok dengan "$_query".',
            emptyAction: _query.isEmpty && canCreate
                ? AppButton(
                    label: 'Tambah produk',
                    icon: AppIcons.add,
                    size: AppButtonSize.small,
                    onPressed: () => context.go(AppRoutes.inventoryProductNew),
                  )
                : null,
            toolbar: _Toolbar(
              canCreate: canCreate,
              onQueryChanged: (query) => setState(() {
                _query = query;
                _page = 1;
              }),
            ),
            footer: AppPagination(
              page: _page,
              pageSize: _pageSize,
              totalRows: rows.length,
              onPageChanged: (page) => setState(() => _page = page),
              onPageSizeChanged: (size) => setState(() {
                _pageSize = size;
                _page = 1;
              }),
            ),
          ),
        );
      },
    );
  }
}

class _Toolbar extends StatelessWidget {
  final bool canCreate;
  final ValueChanged<String> onQueryChanged;

  const _Toolbar({required this.canCreate, required this.onQueryChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppSearchField(
            hint: 'Cari nama, barcode, atau SKU…',
            onChanged: onQueryChanged,
            // Enter melapor seketika. Pemindai HID mengirim seluruh barcode
            // lalu Enter, dan menunggu jeda 300 ms setelahnya terasa seperti
            // aplikasi yang tertinggal.
            onSubmitted: onQueryChanged,
          ),
        ),
        if (canCreate) ...[
          SizedBox(width: context.space.md),
          AppButton(
            label: 'Tambah produk',
            icon: AppIcons.add,
            size: AppButtonSize.small,
            onPressed: () => context.go(AppRoutes.inventoryProductNew),
          ),
        ],
      ],
    );
  }
}

class _SyncBadge extends StatelessWidget {
  final String status;

  const _SyncBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    // Titik, bukan ikon. Kolom status di tabel padat harus terbaca sekilas dari
    // warnanya; ikon di ukuran sekecil ini hanya menambah lebar tanpa menambah
    // informasi, dan pada kerapatan compact ia memaksa kolomnya melebar.
    return switch (status) {
      'synced' => AppBadge(
          label: 'Tersinkron',
          color: context.colors.success,
          showDot: true,
        ),
      _ => AppBadge(
          label: 'Menunggu',
          color: context.colors.syncPending,
          showDot: true,
        ),
    };
  }
}
