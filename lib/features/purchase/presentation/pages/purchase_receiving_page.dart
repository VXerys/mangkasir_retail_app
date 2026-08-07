import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/design/design.dart';
import '../../../../core/session/session_scope.dart';

class PurchaseReceivingPage extends StatelessWidget {
  const PurchaseReceivingPage({super.key});

  static Widget pageBuilder(BuildContext context, GoRouterState state) {
    return const PurchaseReceivingPage();
  }

  @override
  Widget build(BuildContext context) {
    final outletId = context.sessionOrNull?.activeOutlet?.id;
    if (outletId == null) {
      return const Center(child: Text('Pilih outlet terlebih dahulu.'));
    }
    return _PurchaseReceivingContent(outletId: outletId);
  }
}

class _PurchaseReceivingContent extends StatelessWidget {
  final int outletId;
  const _PurchaseReceivingContent({required this.outletId});

  @override
  Widget build(BuildContext context) {
    final density = context.space;

    return Padding(
      padding: EdgeInsets.all(density.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text('Penerimaan Barang (Goods Receiving)'),
              ),
              AppButton(
                label: 'Lihat Daftar PO',
                icon: AppIcons.purchaseOrder,
                size: AppButtonSize.small,
                onPressed: () => context.go(AppRoutes.purchaseOrders),
              ),
            ],
          ),
          SizedBox(height: density.md),
          Expanded(
            child: AppEmptyState(
              title: 'Penerimaan Barang Terhubung ke Purchase Order',
              message: 'Buka detail Purchase Order yang telah disetujui (Approved) untuk memproses penerimaan barang ke gudang.',
              icon: AppIcons.receiving,
              action: AppButton(
                label: 'Buka Daftar PO',
                icon: AppIcons.purchaseOrder,
                size: AppButtonSize.small,
                onPressed: () => context.go(AppRoutes.purchaseOrders),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
