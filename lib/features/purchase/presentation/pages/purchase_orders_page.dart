import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/design/design.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/session/app_permissions.dart';
import '../../../../core/session/session_scope.dart';
import '../../domain/entities/purchase_order.dart';
import '../bloc/purchase_cubit.dart';
import '../bloc/purchase_state.dart';

class PurchaseOrdersPage extends StatelessWidget {
  const PurchaseOrdersPage({super.key});

  static Widget pageBuilder(BuildContext context, GoRouterState state) {
    return BlocProvider<PurchaseCubit>(
      create: (_) => getIt<PurchaseCubit>(),
      child: const PurchaseOrdersPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final outletId = context.sessionOrNull?.activeOutlet?.id;
    if (outletId == null) {
      return const Center(child: Text('Pilih outlet terlebih dahulu.'));
    }
    return _PurchaseOrdersContent(outletId: outletId);
  }
}

class _PurchaseOrdersContent extends StatefulWidget {
  final int outletId;
  const _PurchaseOrdersContent({required this.outletId});

  @override
  State<_PurchaseOrdersContent> createState() => _PurchaseOrdersContentState();
}

class _PurchaseOrdersContentState extends State<_PurchaseOrdersContent> {
  String _query = '';
  String _statusFilter = 'all';

  @override
  void initState() {
    super.initState();
    context.read<PurchaseCubit>().load(widget.outletId);
  }

  List<PurchaseOrder> _filtered(List<PurchaseOrder> list) {
    var filtered = list;
    if (_statusFilter != 'all') {
      filtered = filtered.where((p) => p.status == _statusFilter).toList();
    }

    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return filtered;
    return filtered.where((p) {
      final matchNo = p.poNumber.toLowerCase().contains(q);
      final matchSupp = p.supplierName.toLowerCase().contains(q);
      return matchNo || matchSupp;
    }).toList();
  }

  void _openForm() {
    final cubit = context.read<PurchaseCubit>();
    showAppDrawer(
      context: context,
      builder: (ctx) => AppDrawer(
        title: 'Buat Purchase Order Baru',
        content: BlocProvider.value(
          value: cubit,
          child: _PurchaseOrderForm(outletId: widget.outletId),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final canManage = context.can(AppPermissions.purchaseRead);
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
                Row(
                  children: [
                    Expanded(
                      child: AppSearchField(
                        hint: 'Cari No. PO, nama supplier…',
                        onChanged: (q) => setState(() => _query = q),
                        onSubmitted: (q) => setState(() => _query = q),
                      ),
                    ),
                    SizedBox(width: density.md),
                    DropdownButton<String>(
                      value: _statusFilter,
                      items: const [
                        DropdownMenuItem(value: 'all', child: Text('Semua Status')),
                        DropdownMenuItem(value: 'draft', child: Text('Draft')),
                        DropdownMenuItem(value: 'approved', child: Text('Disetujui')),
                        DropdownMenuItem(value: 'completed', child: Text('Selesai Diterima')),
                      ],
                      onChanged: (v) {
                        if (v != null) setState(() => _statusFilter = v);
                      },
                    ),
                    if (canManage) ...[
                      SizedBox(width: density.md),
                      AppButton(
                        label: 'Buat PO',
                        icon: AppIcons.add,
                        size: AppButtonSize.small,
                        onPressed: () => _openForm(),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: density.md),
                if (state is PurchaseLoading)
                  const Expanded(child: Center(child: AppSkeleton(height: 200)))
                else if (rows.isEmpty)
                  Expanded(
                    child: AppEmptyState(
                      title: _query.isEmpty ? 'Belum ada Purchase Order' : 'Tidak ditemukan',
                      message: _query.isEmpty
                          ? 'Buat pesanan barang baru ke supplier untuk pengadaan stok toko.'
                          : 'Tidak ada PO yang cocok dengan "$_query".',
                      icon: AppIcons.purchaseOrder,
                      action: _query.isEmpty && canManage
                          ? AppButton(
                              label: 'Buat PO',
                              icon: AppIcons.add,
                              size: AppButtonSize.small,
                              onPressed: () => _openForm(),
                            )
                          : null,
                    ),
                  )
                else
                  Expanded(
                    child: ListView.separated(
                      itemCount: rows.length,
                      separatorBuilder: (_, i) => SizedBox(height: density.sm),
                      itemBuilder: (ctx, i) => _PurchaseOrderTile(
                        order: rows[i],
                        onTap: () => context.go(AppRoutes.purchaseOrder(rows[i].id.toString())),
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

class _PurchaseOrderTile extends StatelessWidget {
  final PurchaseOrder order;
  final VoidCallback onTap;

  const _PurchaseOrderTile({required this.order, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final text = context.text;
    final density = context.space;

    return AppPanel(
      onTap: onTap,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(order.poNumber, style: text.formLabel),
                SizedBox(height: density.xs),
                Text(
                  'Supplier: ${order.supplierName} • Gudang: ${order.warehouseName}',
                  style: text.caption,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Rp ${order.totalAmount.toStringAsFixed(0)}',
                style: text.sectionHeading,
              ),
              SizedBox(height: density.xs),
              AppBadge(
                label: order.status.toUpperCase(),
                variant: order.status == 'completed'
                    ? AppBadgeVariant.success
                    : (order.status == 'approved' ? AppBadgeVariant.info : AppBadgeVariant.neutral),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PurchaseOrderForm extends StatefulWidget {
  final int outletId;
  const _PurchaseOrderForm({required this.outletId});

  @override
  State<_PurchaseOrderForm> createState() => _PurchaseOrderFormState();
}

class _PurchaseOrderFormState extends State<_PurchaseOrderForm> {
  late final TextEditingController _poNumber;
  late final TextEditingController _supplierId;
  late final TextEditingController _warehouseId;
  late final TextEditingController _productId;
  late final TextEditingController _qty;
  late final TextEditingController _price;

  @override
  void initState() {
    super.initState();
    _poNumber = TextEditingController(text: 'PO-${DateTime.now().millisecondsSinceEpoch}');
    _supplierId = TextEditingController(text: '1');
    _warehouseId = TextEditingController(text: '1');
    _productId = TextEditingController(text: '1');
    _qty = TextEditingController(text: '50');
    _price = TextEditingController(text: '15000');
  }

  @override
  void dispose() {
    _poNumber.dispose();
    _supplierId.dispose();
    _warehouseId.dispose();
    _productId.dispose();
    _qty.dispose();
    _price.dispose();
    super.dispose();
  }

  void _submit() {
    final poNo = _poNumber.text.trim();
    final suppId = int.tryParse(_supplierId.text.trim()) ?? 1;
    final whId = int.tryParse(_warehouseId.text.trim()) ?? 1;
    final prodId = int.tryParse(_productId.text.trim()) ?? 1;
    final qtyVal = double.tryParse(_qty.text.trim()) ?? 1.0;
    final priceVal = double.tryParse(_price.text.trim()) ?? 0.0;
    final totalVal = qtyVal * priceVal;

    context.read<PurchaseCubit>().create(PurchaseOrder(
      id: 0,
      poNumber: poNo,
      supplierId: suppId,
      supplierName: 'Supplier #$suppId',
      warehouseId: whId,
      warehouseName: 'Gudang #$whId',
      subtotal: totalVal,
      totalAmount: totalVal,
      items: [
        PurchaseOrderItem(
          productId: prodId,
          productName: 'Produk #$prodId',
          qtyOrdered: qtyVal,
          unitPrice: priceVal,
          totalPrice: totalVal,
        ),
      ],
    ));

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final density = context.space;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        AppTextField(
          label: 'Nomor PO *',
          controller: _poNumber,
        ),
        SizedBox(height: density.md),
        AppTextField(
          label: 'ID Supplier *',
          controller: _supplierId,
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: density.md),
        AppTextField(
          label: 'ID Gudang Tujuan *',
          controller: _warehouseId,
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: density.md),
        AppTextField(
          label: 'ID Produk Item *',
          controller: _productId,
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: density.md),
        AppTextField(
          label: 'Jumlah Dipesan (Qty)',
          controller: _qty,
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: density.md),
        AppTextField(
          label: 'Harga Beli Satuan (Rp)',
          controller: _price,
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: density.xl),
        AppButton(
          label: 'Simpan Purchase Order',
          onPressed: _submit,
        ),
      ],
    );
  }
}
