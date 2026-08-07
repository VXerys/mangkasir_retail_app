import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/design/design.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/session/session_scope.dart';
import '../../domain/entities/customer.dart';
import '../bloc/customer_cubit.dart';
import '../bloc/customer_state.dart';

class CustomerDetailPage extends StatelessWidget {
  final String customerId;

  const CustomerDetailPage({super.key, required this.customerId});

  static Widget pageBuilder(BuildContext context, GoRouterState state) {
    final id = state.pathParameters['id'] ?? '';
    return BlocProvider<CustomerCubit>(
      create: (_) => getIt<CustomerCubit>(),
      child: CustomerDetailPage(customerId: id),
    );
  }

  @override
  Widget build(BuildContext context) {
    final outletId = context.sessionOrNull?.activeOutlet?.id;
    if (outletId == null) {
      return const Center(child: Text('Pilih outlet terlebih dahulu.'));
    }
    return _CustomerDetailContent(customerId: customerId, outletId: outletId);
  }
}

class _CustomerDetailContent extends StatefulWidget {
  final String customerId;
  final int outletId;

  const _CustomerDetailContent({required this.customerId, required this.outletId});

  @override
  State<_CustomerDetailContent> createState() => _CustomerDetailContentState();
}

class _CustomerDetailContentState extends State<_CustomerDetailContent> {
  @override
  void initState() {
    super.initState();
    context.read<CustomerCubit>().load(widget.outletId);
  }

  @override
  Widget build(BuildContext context) {
    final density = context.space;
    final text = context.text;

    return Padding(
      padding: EdgeInsets.all(density.xl),
      child: BlocBuilder<CustomerCubit, CustomerState>(
        builder: (context, state) {
          if (state is CustomerLoading) {
            return const Center(child: AppSkeleton(height: 250));
          }

          final idNum = int.tryParse(widget.customerId);
          final customers = state is CustomerLoaded ? state.customers : <Customer>[];
          final customer = customers.where((c) => c.id == idNum).firstOrNull;

          if (customer == null) {
            return AppEmptyState(
              title: 'Pelanggan tidak ditemukan',
              message: 'Data pelanggan dengan ID #${widget.customerId} tidak tersedia.',
              icon: AppIcons.customer,
              action: AppButton(
                label: 'Kembali ke daftar pelanggan',
                icon: AppIcons.back,
                size: AppButtonSize.small,
                onPressed: () => context.go(AppRoutes.crmCustomers),
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
                      onPressed: () => context.go(AppRoutes.crmCustomers),
                      tooltip: 'Kembali',
                    ),
                    SizedBox(width: density.md),
                    Expanded(
                      child: Text(customer.name, style: text.dialogTitle),
                    ),
                    AppBadge(
                      label: customer.phone ?? 'Tanpa Telepon',
                      color: context.colors.info,
                    ),
                  ],
                ),
                SizedBox(height: density.xl),

                // Ringkasan Poin & Piutang
                Row(
                  children: [
                    Expanded(
                      child: AppPanel(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Poin Loyalitas', style: text.formHelper),
                            SizedBox(height: density.xs),
                            Text(
                              '${customer.loyaltyPoints.toStringAsFixed(0)} Pts',
                              style: text.dialogTitle,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: density.md),
                    Expanded(
                      child: AppPanel(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Limit Piutang', style: text.formHelper),
                            SizedBox(height: density.xs),
                            Text(
                              'Rp ${customer.creditLimit.toStringAsFixed(0)}',
                              style: text.dialogTitle,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: density.xl),

                // Detail Profil
                AppPanel(
                  header: Text('Informasi Kontak & Alamat', style: text.toolbarTitle),
                  child: Column(
                    children: [
                      _DetailRow(label: 'ID Pelanggan', value: '#${customer.id}'),
                      _DetailRow(label: 'UUID', value: customer.uuid),
                      _DetailRow(label: 'Nomor Telepon', value: customer.phone ?? '-'),
                      _DetailRow(label: 'Email', value: customer.email ?? '-'),
                      _DetailRow(label: 'Alamat', value: customer.address ?? '-'),
                    ],
                  ),
                ),
                SizedBox(height: density.xl),

                // Riwayat Transaksi Placeholder
                AppPanel(
                  header: Text('Riwayat Transaksi Terkait', style: text.toolbarTitle),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Daftar transaksi penjualan untuk pelanggan ini.',
                        style: text.formHelper,
                      ),
                      SizedBox(height: density.md),
                      AppButton(
                        label: 'Lihat Semua Transaksi Penjualan',
                        icon: AppIcons.sales,
                        variant: AppButtonVariant.secondary,
                        size: AppButtonSize.small,
                        onPressed: () => context.go(AppRoutes.salesTransactions),
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
