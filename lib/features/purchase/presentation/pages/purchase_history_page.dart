import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/design/design.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/session/session_scope.dart';
import '../../domain/entities/purchase_order.dart';
import '../bloc/purchase_cubit.dart';
import '../bloc/purchase_state.dart';

class PurchaseHistoryPage extends StatelessWidget {
  const PurchaseHistoryPage({super.key});

  static Widget pageBuilder(BuildContext context, GoRouterState state) {
    return BlocProvider<PurchaseCubit>(
      create: (_) => getIt<PurchaseCubit>(),
      child: const PurchaseHistoryPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final outletId = context.sessionOrNull?.activeOutlet?.id;
    if (outletId == null) {
      return const Center(child: Text('Pilih outlet terlebih dahulu.'));
    }
    return _PurchaseHistoryContent(outletId: outletId);
  }
}

class _PurchaseHistoryContent extends StatefulWidget {
  final int outletId;
  const _PurchaseHistoryContent({required this.outletId});

  @override
  State<_PurchaseHistoryContent> createState() => _PurchaseHistoryContentState();
}

class _PurchaseHistoryContentState extends State<_PurchaseHistoryContent> {
  String _query = '';

  @override
  void initState() {
    super.initState();
    context.read<PurchaseCubit>().load(widget.outletId);
  }

  List<PurchaseOrder> _filtered(List<PurchaseOrder> list) {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return list;
    return list.where((p) {
      final matchNo = p.poNumber.toLowerCase().contains(q);
      final matchSupp = p.supplierName.toLowerCase().contains(q);
      return matchNo || matchSupp;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final density = context.space;

    return BlocListener<PurchaseCubit, PurchaseState>(
      listener: (context, state) {
        if (state is PurchaseError) AppToast.danger(context, state.message);
      },
      child: Padding(
        padding: EdgeInsets.all(density.xl),
        child: BlocBuilder<PurchaseCubit, PurchaseState>(
          builder: (context, state) {
            final orders = state is PurchaseLoaded ? state.orders : <PurchaseOrder>[];
            final rows = _filtered(orders);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSearchField(
                  hint: 'Cari histori PO, supplier…',
                  onChanged: (q) => setState(() => _query = q),
                  onSubmitted: (q) => setState(() => _query = q),
                ),
                SizedBox(height: density.md),
                if (state is PurchaseLoading)
                  const Expanded(child: Center(child: AppSkeleton(height: 200)))
                else if (rows.isEmpty)
                  Expanded(
                    child: AppEmptyState(
                      title: 'Belum ada histori pengadaan',
                      message: 'Histori transaksi pembelian lintas PO dan receiving akan tampil di sini.',
                      icon: AppIcons.movementHistory,
                    ),
                  )
                else
                  Expanded(
                    child: ListView.separated(
                      itemCount: rows.length,
                      separatorBuilder: (_, i) => SizedBox(height: density.sm),
                      itemBuilder: (ctx, i) {
                        final po = rows[i];
                        return GestureDetector(
                          onTap: () => context.go(AppRoutes.purchaseOrder(po.id.toString())),
                          child: AppPanel(
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(po.poNumber, style: ctx.text.formLabel),
                                    Text('Supplier: ${po.supplierName} • Tanggal: ${po.createdAt?.toIso8601String().substring(0, 10) ?? '-'}', style: ctx.text.formHelper),
                                  ],
                                ),
                              ),
                              Text('Rp ${po.totalAmount.toStringAsFixed(0)}', style: ctx.text.dialogTitle),
                            ],
                          ),
                          ),
                        );
                      },
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
