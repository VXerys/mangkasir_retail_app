import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design/design.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/session/session_scope.dart';
import '../../domain/repositories/purchase_repository.dart';

class PurchaseReturnsPage extends StatelessWidget {
  const PurchaseReturnsPage({super.key});

  static Widget pageBuilder(BuildContext context, GoRouterState state) {
    return const PurchaseReturnsPage();
  }

  @override
  Widget build(BuildContext context) {
    final outletId = context.sessionOrNull?.activeOutlet?.id;
    if (outletId == null) {
      return const Center(child: Text('Pilih outlet terlebih dahulu.'));
    }
    return _PurchaseReturnsContent(outletId: outletId);
  }
}

class _PurchaseReturnsContent extends StatefulWidget {
  final int outletId;
  const _PurchaseReturnsContent({required this.outletId});

  @override
  State<_PurchaseReturnsContent> createState() => _PurchaseReturnsContentState();
}

class _PurchaseReturnsContentState extends State<_PurchaseReturnsContent> {
  final List<Map<String, dynamic>> _returns = [];

  void _openForm() {
    showAppDrawer(
      context: context,
      builder: (ctx) => AppDrawer(
        title: 'Buat Retur Pembelian Supplier',
        content: _ReturnForm(
          outletId: widget.outletId,
          onSuccess: (ret) {
            setState(() {
              _returns.add(ret);
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
                child: Text('Retur Pembelian (Purchase Returns)'),
              ),
              AppButton(
                label: 'Buat Retur Beli',
                icon: AppIcons.add,
                size: AppButtonSize.small,
                onPressed: () => _openForm(),
              ),
            ],
          ),
          SizedBox(height: density.md),
          if (_returns.isEmpty)
            Expanded(
              child: AppEmptyState(
                title: 'Belum ada retur pembelian',
                message: 'Kembalikan barang cacat atau tidak sesuai ke supplier dengan mutasi stok otomatis.',
                icon: AppIcons.purchaseReturn,
                action: AppButton(
                  label: 'Buat Retur Beli',
                  icon: AppIcons.add,
                  size: AppButtonSize.small,
                  onPressed: () => _openForm(),
                ),
              ),
            )
          else
            Expanded(
              child: ListView.separated(
                itemCount: _returns.length,
                separatorBuilder: (_, i) => SizedBox(height: density.sm),
                itemBuilder: (ctx, i) {
                  final ret = _returns[i];
                  return AppPanel(
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('PO #${ret['po_id']} • Supplier #${ret['supplier_id']}', style: ctx.text.formLabel),
                              Text('Alasan: ${ret['reason']} • Qty: ${ret['qty']}', style: ctx.text.formHelper),
                            ],
                          ),
                        ),
                        AppBadge(label: 'Diretur', color: ctx.colors.warning),
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

class _ReturnForm extends StatefulWidget {
  final int outletId;
  final ValueChanged<Map<String, dynamic>> onSuccess;

  const _ReturnForm({required this.outletId, required this.onSuccess});

  @override
  State<_ReturnForm> createState() => _ReturnFormState();
}

class _ReturnFormState extends State<_ReturnForm> {
  late final TextEditingController _poId;
  late final TextEditingController _supplierId;
  late final TextEditingController _productId;
  late final TextEditingController _qty;
  late final TextEditingController _reason;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _poId = TextEditingController(text: '1');
    _supplierId = TextEditingController(text: '1');
    _productId = TextEditingController(text: '1');
    _qty = TextEditingController(text: '5');
    _reason = TextEditingController(text: 'Barang Cacat/Kemasan Rusak');
  }

  @override
  void dispose() {
    _poId.dispose();
    _supplierId.dispose();
    _productId.dispose();
    _qty.dispose();
    _reason.dispose();
    super.dispose();
  }

  void _submit() async {
    final poVal = int.tryParse(_poId.text.trim()) ?? 1;
    final suppVal = int.tryParse(_supplierId.text.trim()) ?? 1;
    final prodVal = int.tryParse(_productId.text.trim()) ?? 1;
    final qtyVal = double.tryParse(_qty.text.trim()) ?? 1.0;
    final reasonStr = _reason.text.trim();

    if (reasonStr.isEmpty) {
      AppToast.danger(context, 'Alasan retur wajib diisi');
      return;
    }

    setState(() => _isSaving = true);
    final repo = getIt<PurchaseRepository>();
    final result = await repo.returnItems(
      poId: poVal,
      supplierId: suppVal,
      reason: reasonStr,
      items: [
        {
          'product_id': prodVal,
          'qty_returned': qtyVal,
        }
      ],
    );

    if (!mounted) return;
    setState(() => _isSaving = false);

    result.fold(
      (f) => AppToast.danger(context, f.message),
      (_) {
        AppToast.success(context, 'Retur pembelian berhasil dibuat & stok dikurangi');
        widget.onSuccess({
          'po_id': poVal,
          'supplier_id': suppVal,
          'product_id': prodVal,
          'qty': qtyVal,
          'reason': reasonStr,
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
          label: 'ID Purchase Order (PO) *',
          controller: _poId,
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: density.md),
        AppTextField(
          label: 'ID Supplier *',
          controller: _supplierId,
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: density.md),
        AppTextField(
          label: 'ID Produk *',
          controller: _productId,
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: density.md),
        AppTextField(
          label: 'Jumlah Diretur (Qty) *',
          controller: _qty,
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: density.md),
        AppTextField(
          label: 'Alasan Retur *',
          controller: _reason,
        ),
        SizedBox(height: density.xl),
        AppButton(
          label: _isSaving ? 'Menyimpan…' : 'Proses Retur Beli',
          onPressed: _isSaving ? null : _submit,
        ),
      ],
    );
  }
}
