import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/design/design.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/session/session_scope.dart';
import '../../domain/entities/supplier.dart';
import '../bloc/supplier_cubit.dart';
import '../bloc/supplier_state.dart';

class SupplierDetailPage extends StatelessWidget {
  final String supplierId;

  const SupplierDetailPage({super.key, required this.supplierId});

  static Widget pageBuilder(BuildContext context, GoRouterState state) {
    final id = state.pathParameters['id'] ?? '';
    return BlocProvider<SupplierCubit>(
      create: (_) => getIt<SupplierCubit>(),
      child: SupplierDetailPage(supplierId: id),
    );
  }

  @override
  Widget build(BuildContext context) {
    final businessId = context.sessionOrNull?.business.id;
    if (businessId == null) {
      return const Center(child: Text('Identitas bisnis tidak ditemukan.'));
    }
    return _SupplierDetailContent(supplierId: supplierId, businessId: businessId);
  }
}

class _SupplierDetailContent extends StatefulWidget {
  final String supplierId;
  final int businessId;

  const _SupplierDetailContent({required this.supplierId, required this.businessId});

  @override
  State<_SupplierDetailContent> createState() => _SupplierDetailContentState();
}

class _SupplierDetailContentState extends State<_SupplierDetailContent> {
  @override
  void initState() {
    super.initState();
    context.read<SupplierCubit>().load(widget.businessId);
  }

  @override
  Widget build(BuildContext context) {
    final density = context.space;
    final text = context.text;

    return Padding(
      padding: EdgeInsets.all(density.xl),
      child: BlocBuilder<SupplierCubit, SupplierState>(
        builder: (context, state) {
          if (state is SupplierLoading) {
            return const Center(child: AppSkeleton(height: 250));
          }

          final idNum = int.tryParse(widget.supplierId);
          final suppliers = state is SupplierLoaded ? state.suppliers : <Supplier>[];
          final supplier = suppliers.where((s) => s.id == idNum).firstOrNull;

          if (supplier == null) {
            return AppEmptyState(
              title: 'Pemasok tidak ditemukan',
              message: 'Data pemasok dengan ID #${widget.supplierId} tidak tersedia.',
              icon: AppIcons.supplier,
              action: AppButton(
                label: 'Kembali ke daftar pemasok',
                icon: AppIcons.back,
                size: AppButtonSize.small,
                onPressed: () => context.go(AppRoutes.crmSuppliers),
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
                      onPressed: () => context.go(AppRoutes.crmSuppliers),
                      tooltip: 'Kembali',
                    ),
                    SizedBox(width: density.md),
                    Expanded(
                      child: Text(supplier.name, style: text.dialogTitle),
                    ),
                    AppBadge(
                      label: supplier.paymentTerms ?? 'Termin Standar',
                      color: context.colors.info,
                    ),
                  ],
                ),
                SizedBox(height: density.xl),

                // Detail Profil
                AppPanel(
                  header: Text('Informasi Pemasok & NPWP', style: text.toolbarTitle),
                  child: Column(
                    children: [
                      _DetailRow(label: 'ID Pemasok', value: '#${supplier.id}'),
                      _DetailRow(label: 'UUID', value: supplier.uuid),
                      _DetailRow(label: 'Nomor Telepon', value: supplier.phone ?? '-'),
                      _DetailRow(label: 'Email', value: supplier.email ?? '-'),
                      _DetailRow(label: 'Alamat', value: supplier.address ?? '-'),
                      _DetailRow(label: 'NPWP (Tax ID)', value: supplier.taxId ?? '-'),
                      _DetailRow(
                        label: 'Termin Pembayaran',
                        value: supplier.paymentTerms ?? '-',
                      ),
                    ],
                  ),
                ),
                SizedBox(height: density.xl),

                // Riwayat Purchase Order Placeholder
                AppPanel(
                  header: Text('Riwayat Purchase Order (PO)', style: text.toolbarTitle),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Daftar pesanan pembelian barang ke pemasok ini.',
                        style: text.formHelper,
                      ),
                      SizedBox(height: density.md),
                      AppButton(
                        label: 'Lihat Semua Order Pembelian',
                        icon: AppIcons.purchaseOrder,
                        variant: AppButtonVariant.secondary,
                        size: AppButtonSize.small,
                        onPressed: () => context.go(AppRoutes.purchaseOrders),
                      ),
                    ],
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
