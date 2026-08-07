import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design/design.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/session/session_scope.dart';
import '../../domain/repositories/inventory_repository.dart';

class TransfersPage extends StatelessWidget {
  const TransfersPage({super.key});

  static Widget pageBuilder(BuildContext context, GoRouterState state) {
    return const TransfersPage();
  }

  @override
  Widget build(BuildContext context) {
    final outletId = context.sessionOrNull?.activeOutlet?.id;
    if (outletId == null) {
      return const Center(child: Text('Pilih outlet terlebih dahulu.'));
    }
    return _TransfersContent(outletId: outletId);
  }
}

class _TransfersContent extends StatefulWidget {
  final int outletId;
  const _TransfersContent({required this.outletId});

  @override
  State<_TransfersContent> createState() => _TransfersContentState();
}

class _TransfersContentState extends State<_TransfersContent> {
  final List<Map<String, dynamic>> _transfers = [];

  void _openForm() {
    showAppDrawer(
      context: context,
      builder: (ctx) => AppDrawer(
        title: 'Buat Transfer Antar Gudang',
        content: _TransferForm(
          outletId: widget.outletId,
          onSuccess: (trf) {
            setState(() {
              _transfers.add(trf);
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
                child: Text('Transfer Stok Antar Gudang'),
              ),
              AppButton(
                label: 'Buat Transfer',
                icon: AppIcons.add,
                size: AppButtonSize.small,
                onPressed: () => _openForm(),
              ),
            ],
          ),
          SizedBox(height: density.md),
          if (_transfers.isEmpty)
            Expanded(
              child: AppEmptyState(
                title: 'Belum ada transfer stok',
                message: 'Pindahkan stok antar gudang toko secara transparan dan terdata.',
                icon: AppIcons.stockTransfer,
                action: AppButton(
                  label: 'Buat Transfer',
                  icon: AppIcons.add,
                  size: AppButtonSize.small,
                  onPressed: () => _openForm(),
                ),
              ),
            )
          else
            Expanded(
              child: ListView.separated(
                itemCount: _transfers.length,
                separatorBuilder: (_, i) => SizedBox(height: density.sm),
                itemBuilder: (ctx, i) {
                  final trf = _transfers[i];
                  return AppPanel(
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Gudang #${trf['from_id']} ➔ Gudang #${trf['to_id']}', style: ctx.text.formLabel),
                              Text('Produk ID: #${trf['product_id']} • Qty: ${trf['qty']}', style: ctx.text.formHelper),
                            ],
                          ),
                        ),
                        AppBadge(label: 'Terkirim', color: ctx.colors.info),
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

class _TransferForm extends StatefulWidget {
  final int outletId;
  final ValueChanged<Map<String, dynamic>> onSuccess;

  const _TransferForm({required this.outletId, required this.onSuccess});

  @override
  State<_TransferForm> createState() => _TransferFormState();
}

class _TransferFormState extends State<_TransferForm> {
  late final TextEditingController _fromId;
  late final TextEditingController _toId;
  late final TextEditingController _productId;
  late final TextEditingController _qty;
  late final TextEditingController _notes;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _fromId = TextEditingController(text: '1');
    _toId = TextEditingController(text: '2');
    _productId = TextEditingController(text: '1');
    _qty = TextEditingController(text: '10');
    _notes = TextEditingController();
  }

  @override
  void dispose() {
    _fromId.dispose();
    _toId.dispose();
    _productId.dispose();
    _qty.dispose();
    _notes.dispose();
    super.dispose();
  }

  void _submit() async {
    final fromVal = int.tryParse(_fromId.text.trim()) ?? 1;
    final toVal = int.tryParse(_toId.text.trim()) ?? 2;
    final prodVal = int.tryParse(_productId.text.trim()) ?? 1;
    final qtyVal = double.tryParse(_qty.text.trim()) ?? 0.0;

    if (fromVal == toVal) {
      AppToast.danger(context, 'Gudang asal dan gudang tujuan tidak boleh sama');
      return;
    }

    setState(() => _isSaving = true);
    final repo = getIt<InventoryRepository>();
    final result = await repo.createTransfer(
      fromWarehouseId: fromVal,
      toWarehouseId: toVal,
      items: [
        {
          'product_id': prodVal,
          'qty': qtyVal,
        }
      ],
      notes: _notes.text.trim().isEmpty ? null : _notes.text.trim(),
    );

    if (!mounted) return;
    setState(() => _isSaving = false);

    result.fold(
      (f) => AppToast.danger(context, f.message),
      (_) {
        AppToast.success(context, 'Transfer stok berhasil dibuat');
        widget.onSuccess({
          'from_id': fromVal,
          'to_id': toVal,
          'product_id': prodVal,
          'qty': qtyVal,
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
          label: 'ID Gudang Asal *',
          controller: _fromId,
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: density.md),
        AppTextField(
          label: 'ID Gudang Tujuan *',
          controller: _toId,
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
          label: 'Jumlah Transfer (Qty) *',
          controller: _qty,
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: density.md),
        AppTextField(
          label: 'Catatan',
          controller: _notes,
        ),
        SizedBox(height: density.xl),
        AppButton(
          label: _isSaving ? 'Menyimpan…' : 'Kirim Transfer',
          onPressed: _isSaving ? null : _submit,
        ),
      ],
    );
  }
}
