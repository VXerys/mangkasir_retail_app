import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/design/design.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/session/session_scope.dart';
import '../../domain/entities/purchase_order.dart';
import '../../domain/repositories/purchase_repository.dart';
import '../bloc/purchase_cubit.dart';
import '../bloc/purchase_state.dart';

class PurchaseOrderDetailPage extends StatelessWidget {
  final String orderId;

  const PurchaseOrderDetailPage({super.key, required this.orderId});

  static Widget pageBuilder(BuildContext context, GoRouterState state) {
    final id = state.pathParameters['id'] ?? '';
    return BlocProvider<PurchaseCubit>(
      create: (_) => getIt<PurchaseCubit>(),
      child: PurchaseOrderDetailPage(orderId: id),
    );
  }

  @override
  Widget build(BuildContext context) {
    final outletId = context.sessionOrNull?.activeOutlet?.id;
    if (outletId == null) {
      return const Center(child: Text('Pilih outlet terlebih dahulu.'));
    }
    return _PurchaseOrderDetailContent(orderId: orderId, outletId: outletId);
  }
}

class _PurchaseOrderDetailContent extends StatefulWidget {
  final String orderId;
  final int outletId;

  const _PurchaseOrderDetailContent({required this.orderId, required this.outletId});

  @override
  State<_PurchaseOrderDetailContent> createState() => _PurchaseOrderDetailContentState();
}

class _PurchaseOrderDetailContentState extends State<_PurchaseOrderDetailContent> {
  bool _isReceiving = false;

  @override
  void initState() {
    super.initState();
    context.read<PurchaseCubit>().load(widget.outletId);
  }

  void _approveOrder(PurchaseOrder po) {
    context.read<PurchaseCubit>().updateStatus(po.id, 'approved');
    AppToast.success(context, 'PO #${po.poNumber} berhasil disetujui');
  }

  void _receiveOrder(PurchaseOrder po) async {
    setState(() => _isReceiving = true);
    final repo = getIt<PurchaseRepository>();
    final result = await repo.receiveItems(
      poId: po.id,
      warehouseId: po.warehouseId,
      items: po.items.map((i) => {
        'product_id': i.productId,
        'qty_received': i.qtyOrdered,
      }).toList(),
      notes: 'Penerimaan otomatis PO #${po.poNumber}',
    );

    if (!mounted) return;
    setState(() => _isReceiving = false);

    result.fold(
      (f) => AppToast.danger(context, f.message),
      (_) {
        AppToast.success(context, 'Barang PO #${po.poNumber} berhasil diterima ke stok gudang');
        context.read<PurchaseCubit>().load(widget.outletId);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final density = context.space;
    final text = context.text;

    return Padding(
      padding: EdgeInsets.all(density.xl),
      child: BlocBuilder<PurchaseCubit, PurchaseState>(
        builder: (context, state) {
          if (state is PurchaseLoading) {
            return const Center(child: AppSkeleton(height: 250));
          }

          final idNum = int.tryParse(widget.orderId);
          final orders = state is PurchaseLoaded ? state.orders : <PurchaseOrder>[];
          final po = orders.where((p) => p.id == idNum).firstOrNull;

          if (po == null) {
            return AppEmptyState(
              title: 'Purchase Order tidak ditemukan',
              message: 'Data PO dengan ID #${widget.orderId} tidak tersedia.',
              icon: AppIcons.purchaseOrder,
              action: AppButton(
                label: 'Kembali ke daftar PO',
                icon: AppIcons.back,
                size: AppButtonSize.small,
                onPressed: () => context.go(AppRoutes.purchaseOrders),
              ),
            );
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    AppIconButton(
                      icon: AppIcons.back,
                      onPressed: () => context.go(AppRoutes.purchaseOrders),
                      tooltip: 'Kembali',
                    ),
                    SizedBox(width: density.md),
                    Expanded(
                      child: Text(po.poNumber, style: text.dialogTitle),
                    ),
                    AppBadge(
                      label: po.status.toUpperCase(),
                      color: po.status == 'completed'
                          ? context.colors.success
                          : (po.status == 'approved' ? context.colors.info : context.colors.offline),
                    ),
                  ],
                ),
                SizedBox(height: density.xl),

                // Action Buttons
                Row(
                  children: [
                    if (po.status == 'draft')
                      AppButton(
                        label: 'Setujui PO (Approve)',
                        icon: AppIcons.check,
                        size: AppButtonSize.small,
                        onPressed: () => _approveOrder(po),
                      ),
                    if (po.status == 'approved' || po.status == 'draft') ...[
                      if (po.status == 'draft') SizedBox(width: density.md),
                      AppButton(
                        label: _isReceiving ? 'Memproses Penerimaan…' : 'Terima Barang di Gudang',
                        icon: AppIcons.receiving,
                        variant: AppButtonVariant.secondary,
                        size: AppButtonSize.small,
                        onPressed: _isReceiving ? null : () => _receiveOrder(po),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: density.xl),

                // Detail Ringkasan PO
                AppPanel(
                  header: Text('Informasi PO & Supplier', style: text.toolbarTitle),
                  child: Column(
                    children: [
                      _DetailRow(label: 'ID PO', value: '#${po.id}'),
                      _DetailRow(label: 'Supplier', value: po.supplierName),
                      _DetailRow(label: 'Gudang Tujuan', value: po.warehouseName),
                      _DetailRow(label: 'Total Nilai PO', value: 'Rp ${po.totalAmount.toStringAsFixed(0)}'),
                      _DetailRow(label: 'Catatan', value: po.notes ?? '-'),
                    ],
                  ),
                ),
                SizedBox(height: density.xl),

                // Rincian Item PO
                AppPanel(
                  header: Text('Rincian Item Barang Dipesan', style: text.toolbarTitle),
                  child: Column(
                    children: po.items
                        .map(
                          (item) => Padding(
                            padding: EdgeInsets.symmetric(vertical: density.xs),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(item.productName, style: text.formLabel),
                                Text(
                                  '${item.qtyOrdered.toStringAsFixed(0)} x Rp ${item.unitPrice.toStringAsFixed(0)} = Rp ${item.totalPrice.toStringAsFixed(0)}',
                                  style: text.formHelper,
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final text = context.text;
    final density = context.space;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: density.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: text.formHelper),
          Flexible(
            child: Text(
              value,
              style: text.formLabel,
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
