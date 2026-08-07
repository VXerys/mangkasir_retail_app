import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/design/design.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/session/session_scope.dart';
import '../../domain/entities/stock.dart';
import '../bloc/stock_cubit.dart';
import '../bloc/stock_state.dart';

class StockListPage extends StatelessWidget {
  const StockListPage({super.key});

  static Widget pageBuilder(BuildContext context, GoRouterState state) {
    return BlocProvider<StockCubit>(
      create: (_) => getIt<StockCubit>(),
      child: const StockListPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final outletId = context.sessionOrNull?.activeOutlet?.id;
    if (outletId == null) {
      return const Center(child: Text('Pilih outlet terlebih dahulu.'));
    }
    return _StockListContent(outletId: outletId);
  }
}

class _StockListContent extends StatefulWidget {
  final int outletId;
  const _StockListContent({required this.outletId});

  @override
  State<_StockListContent> createState() => _StockListContentState();
}

class _StockListContentState extends State<_StockListContent> {
  String _query = '';
  String _filter = 'all'; // 'all', 'low', 'out'

  @override
  void initState() {
    super.initState();
    context.read<StockCubit>().load(widget.outletId);
  }

  List<Stock> _filtered(List<Stock> list) {
    final q = _query.trim().toLowerCase();
    var filtered = list;

    if (_filter == 'low') {
      filtered = filtered.where((s) => s.isLowStock).toList();
    } else if (_filter == 'out') {
      filtered = filtered.where((s) => s.isOutOfStock).toList();
    }

    if (q.isEmpty) return filtered;
    return filtered.where((s) {
      final matchName = s.productName.toLowerCase().contains(q);
      final matchSku = s.sku?.toLowerCase().contains(q) ?? false;
      final matchBarcode = s.barcode?.toLowerCase().contains(q) ?? false;
      return matchName || matchSku || matchBarcode;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final density = context.space;

    return BlocListener<StockCubit, StockState>(
      listener: (context, state) {
        if (state is StockError) AppToast.danger(context, state.message);
      },
      child: Padding(
        padding: EdgeInsets.all(density.xl),
        child: BlocBuilder<StockCubit, StockState>(
          builder: (context, state) {
            final stocks = state is StockLoaded ? state.stocks : <Stock>[];
            final rows = _filtered(stocks);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: AppSearchField(
                        hint: 'Cari nama produk, SKU, barcode…',
                        onChanged: (q) => setState(() => _query = q),
                        onSubmitted: (q) => setState(() => _query = q),
                      ),
                    ),
                    SizedBox(width: density.md),
                    DropdownButton<String>(
                      value: _filter,
                      items: const [
                        DropdownMenuItem(value: 'all', child: Text('Semua Stok')),
                        DropdownMenuItem(value: 'low', child: Text('Stok Menipis')),
                        DropdownMenuItem(value: 'out', child: Text('Stok Habis')),
                      ],
                      onChanged: (v) {
                        if (v != null) setState(() => _filter = v);
                      },
                    ),
                  ],
                ),
                SizedBox(height: density.md),
                if (state is StockLoading)
                  const Expanded(child: Center(child: AppSkeleton(height: 200)))
                else if (rows.isEmpty)
                  Expanded(
                    child: AppEmptyState(
                      title: _query.isEmpty ? 'Belum ada saldo stok' : 'Tidak ditemukan',
                      message: _query.isEmpty
                          ? 'Saldo stok akan muncul otomatis dari penerimaan PO atau adjustment.'
                          : 'Tidak ada stok produk yang cocok dengan "$_query".',
                      icon: AppIcons.stock,
                    ),
                  )
                else
                  Expanded(
                    child: ListView.separated(
                      itemCount: rows.length,
                      separatorBuilder: (_, i) => SizedBox(height: density.sm),
                      itemBuilder: (ctx, i) => _StockTile(
                        stock: rows[i],
                        onTapDrillDown: () => context.go(AppRoutes.inventoryMovements),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _StockTile extends StatelessWidget {
  final Stock stock;
  final VoidCallback onTapDrillDown;

  const _StockTile({required this.stock, required this.onTapDrillDown});

  @override
  Widget build(BuildContext context) {
    final text = context.text;
    final density = context.space;

    return AppPanel(
      onTap: onTapDrillDown,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(stock.productName, style: text.formLabel),
                SizedBox(height: density.xs),
                Text(
                  'Gudang: ${stock.warehouseName} • SKU: ${stock.sku ?? '-'}',
                  style: text.caption,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${stock.qty.toStringAsFixed(0)} ${stock.unitName}',
                style: text.sectionHeading,
              ),
              SizedBox(height: density.xs),
              if (stock.isOutOfStock)
                const AppBadge(label: 'Habis', variant: AppBadgeVariant.danger)
              else if (stock.isLowStock)
                const AppBadge(label: 'Menipis', variant: AppBadgeVariant.warning)
              else
                const AppBadge(label: 'Tersedia', variant: AppBadgeVariant.success),
            ],
          ),
        ],
      ),
    );
  }
}
