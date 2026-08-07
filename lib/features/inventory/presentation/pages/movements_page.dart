import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design/design.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/session/session_scope.dart';
import '../../domain/entities/stock_movement.dart';
import '../bloc/movement_cubit.dart';
import '../bloc/movement_state.dart';

class MovementsPage extends StatelessWidget {
  const MovementsPage({super.key});

  static Widget pageBuilder(BuildContext context, GoRouterState state) {
    return BlocProvider<MovementCubit>(
      create: (_) => getIt<MovementCubit>(),
      child: const MovementsPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final outletId = context.sessionOrNull?.activeOutlet?.id;
    if (outletId == null) {
      return const Center(child: Text('Pilih outlet terlebih dahulu.'));
    }
    return _MovementsContent(outletId: outletId);
  }
}

class _MovementsContent extends StatefulWidget {
  final int outletId;
  const _MovementsContent({required this.outletId});

  @override
  State<_MovementsContent> createState() => _MovementsContentState();
}

class _MovementsContentState extends State<_MovementsContent> {
  String _query = '';
  String _typeFilter = 'all';

  @override
  void initState() {
    super.initState();
    context.read<MovementCubit>().load(widget.outletId);
  }

  List<StockMovement> _filtered(List<StockMovement> list) {
    var filtered = list;
    if (_typeFilter != 'all') {
      filtered = filtered.where((m) => m.movementType == _typeFilter).toList();
    }

    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return filtered;
    return filtered.where((m) {
      final matchProduct = m.productName.toLowerCase().contains(q);
      final matchRef = m.referenceId?.toLowerCase().contains(q) ?? false;
      final matchNotes = m.notes?.toLowerCase().contains(q) ?? false;
      return matchProduct || matchRef || matchNotes;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final density = context.space;

    return BlocListener<MovementCubit, MovementState>(
      listener: (context, state) {
        if (state is MovementError) AppToast.danger(context, state.message);
      },
      child: Padding(
        padding: EdgeInsets.all(density.xl),
        child: BlocBuilder<MovementCubit, MovementState>(
          builder: (context, state) {
            final movements = state is MovementLoaded ? state.movements : <StockMovement>[];
            final rows = _filtered(movements);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: AppSearchField(
                        hint: 'Cari produk, No. referensi, catatan…',
                        onChanged: (q) => setState(() => _query = q),
                        onSubmitted: (q) => setState(() => _query = q),
                      ),
                    ),
                    SizedBox(width: density.md),
                    DropdownButton<String>(
                      value: _typeFilter,
                      items: const [
                        DropdownMenuItem(value: 'all', child: Text('Semua Mutasi')),
                        DropdownMenuItem(value: 'in', child: Text('Masuk (In)')),
                        DropdownMenuItem(value: 'out', child: Text('Keluar (Out)')),
                        DropdownMenuItem(value: 'adjustment', child: Text('Penyesuaian')),
                        DropdownMenuItem(value: 'transfer', child: Text('Transfer')),
                      ],
                      onChanged: (v) {
                        if (v != null) setState(() => _typeFilter = v);
                      },
                    ),
                  ],
                ),
                SizedBox(height: density.md),
                if (state is MovementLoading)
                  const Expanded(child: Center(child: AppSkeleton(height: 200)))
                else if (rows.isEmpty)
                  Expanded(
                    child: AppEmptyState(
                      title: _query.isEmpty ? 'Belum ada mutasi stok' : 'Tidak ditemukan',
                      message: _query.isEmpty
                          ? 'Setiap pergerakan barang (penjualan, pembelian, adjustment) akan tercatat di ledger ini.'
                          : 'Tidak ada mutasi yang cocok dengan "$_query".',
                      icon: AppIcons.movementHistory,
                    ),
                  )
                else
                  Expanded(
                    child: ListView.separated(
                      itemCount: rows.length,
                      separatorBuilder: (_, i) => SizedBox(height: density.sm),
                      itemBuilder: (ctx, i) => _MovementTile(movement: rows[i]),
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

class _MovementTile extends StatelessWidget {
  final StockMovement movement;

  const _MovementTile({required this.movement});

  @override
  Widget build(BuildContext context) {
    final text = context.text;
    final density = context.space;

    final isPositive = movement.qty > 0;
    final qtyPrefix = isPositive ? '+' : '';

    return AppPanel(
      child: Row(
        children: [
          Icon(
            isPositive ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
            color: isPositive ? Colors.green : Colors.red,
          ),
          SizedBox(width: density.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(movement.productName, style: text.formLabel),
                SizedBox(height: density.xs),
                Text(
                  'Gudang: ${movement.warehouseName} • Referensi: ${movement.referenceType ?? 'Manual'} ${movement.referenceId ?? ''}',
                  style: text.caption,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$qtyPrefix${movement.qty.toStringAsFixed(0)}',
                style: text.sectionHeading.copyWith(
                  color: isPositive ? Colors.green : Colors.red,
                ),
              ),
              SizedBox(height: density.xs),
              Text(
                'Saldo: ${movement.balanceAfter.toStringAsFixed(0)}',
                style: text.caption,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
