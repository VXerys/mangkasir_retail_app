import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design/design.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/session/session_scope.dart';
import '../../domain/repositories/inventory_repository.dart';

class AdjustmentsPage extends StatelessWidget {
  const AdjustmentsPage({super.key});

  static Widget pageBuilder(BuildContext context, GoRouterState state) {
    return const AdjustmentsPage();
  }

  @override
  Widget build(BuildContext context) {
    final outletId = context.sessionOrNull?.activeOutlet?.id;
    if (outletId == null) {
      return const Center(child: Text('Pilih outlet terlebih dahulu.'));
    }
    return _AdjustmentsContent(outletId: outletId);
  }
}

class _AdjustmentsContent extends StatefulWidget {
  final int outletId;
  const _AdjustmentsContent({required this.outletId});

  @override
  State<_AdjustmentsContent> createState() => _AdjustmentsContentState();
}

class _AdjustmentsContentState extends State<_AdjustmentsContent> {
  final List<Map<String, dynamic>> _adjustments = [];

  void _openForm() {
    showAppDrawer(
      context: context,
      builder: (ctx) => AppDrawer(
        title: 'Buat Penyesuaian Stok',
        content: _AdjustmentForm(
          outletId: widget.outletId,
          onSuccess: (adj) {
            setState(() {
              _adjustments.add(adj);
            });
          },
        ),
      ),
    );
  }

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
                child: Text('Penyesuaian Stok Manual (Adjustments)'),
              ),
              AppButton(
                label: 'Tambah Penyesuaian',
                icon: AppIcons.add,
                size: AppButtonSize.small,
                onPressed: () => _openForm(),
              ),
            ],
          ),
          SizedBox(height: density.md),
          if (_adjustments.isEmpty)
            Expanded(
              child: AppEmptyState(
                title: 'Belum ada penyesuaian stok',
                message: 'Gunakan penyesuaian stok jika terdapat barang rusak, hilang, atau selisih fisik.',
                icon: AppIcons.stockAdjustment,
                action: AppButton(
                  label: 'Tambah Penyesuaian',
                  icon: AppIcons.add,
                  size: AppButtonSize.small,
                  onPressed: () => _openForm(),
                ),
              ),
            )
          else
            Expanded(
              child: ListView.separated(
                itemCount: _adjustments.length,
                separatorBuilder: (_, i) => SizedBox(height: density.sm),
                itemBuilder: (ctx, i) {
                  final adj = _adjustments[i];
                  return AppPanel(
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(adj['reason'] as String, style: ctx.text.formLabel),
                              Text('Produk ID: #${adj['product_id']} • Selisih: ${adj['actual_qty'] - adj['current_qty']}', style: ctx.text.formHelper),
                            ],
                          ),
                        ),
                        AppBadge(label: 'Selesai', color: ctx.colors.success),
                      ],
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _AdjustmentForm extends StatefulWidget {
  final int outletId;
  final ValueChanged<Map<String, dynamic>> onSuccess;

  const _AdjustmentForm({required this.outletId, required this.onSuccess});

  @override
  State<_AdjustmentForm> createState() => _AdjustmentFormState();
}

class _AdjustmentFormState extends State<_AdjustmentForm> {
  late final TextEditingController _reason;
  late final TextEditingController _productId;
  late final TextEditingController _currentQty;
  late final TextEditingController _actualQty;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _reason = TextEditingController();
    _productId = TextEditingController();
    _currentQty = TextEditingController(text: '0');
    _actualQty = TextEditingController(text: '0');
  }

  @override
  void dispose() {
    _reason.dispose();
    _productId.dispose();
    _currentQty.dispose();
    _actualQty.dispose();
    super.dispose();
  }

  void _submit() async {
    final reasonStr = _reason.text.trim();
    if (reasonStr.isEmpty) {
      AppToast.danger(context, 'Alasan penyesuaian wajib diisi');
      return;
    }

    final prodIdVal = int.tryParse(_productId.text.trim()) ?? 1;
    final currQtyVal = double.tryParse(_currentQty.text.trim()) ?? 0.0;
    final actQtyVal = double.tryParse(_actualQty.text.trim()) ?? 0.0;

    setState(() => _isSaving = true);
    final repo = getIt<InventoryRepository>();
    final result = await repo.createAdjustment(
      warehouseId: 1,
      reason: reasonStr,
      items: [
        {
          'product_id': prodIdVal,
          'current_qty': currQtyVal,
          'actual_qty': actQtyVal,
        }
      ],
    );

    if (!mounted) return;
    setState(() => _isSaving = false);

    result.fold(
      (f) => AppToast.danger(context, f.message),
      (_) {
        AppToast.success(context, 'Penyesuaian stok berhasil disimpan');
        widget.onSuccess({
          'reason': reasonStr,
          'product_id': prodIdVal,
          'current_qty': currQtyVal,
          'actual_qty': actQtyVal,
        });
        Navigator.of(context).pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final density = context.space;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        AppTextField(
          label: 'Alasan penyesuaian *',
          controller: _reason,
          hint: 'misal: Barang Rusak, Penyesuaian Opname',
        ),
        SizedBox(height: density.md),
        AppTextField(
          label: 'ID Produk *',
          controller: _productId,
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: density.md),
        AppTextField(
          label: 'Stok Sistem Saat Ini',
          controller: _currentQty,
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: density.md),
        AppTextField(
          label: 'Stok Fisik Sebenarnya (Actual)',
          controller: _actualQty,
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: density.xl),
        AppButton(
          label: _isSaving ? 'Menyimpan…' : 'Simpan Penyesuaian',
          onPressed: _isSaving ? null : _submit,
        ),
      ],
    );
  }
}
