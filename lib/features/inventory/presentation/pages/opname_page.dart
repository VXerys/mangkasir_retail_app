import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design/design.dart';
import '../../../../core/session/session_scope.dart';

class OpnamePage extends StatelessWidget {
  const OpnamePage({super.key});

  static Widget pageBuilder(BuildContext context, GoRouterState state) {
    return const OpnamePage();
  }

  @override
  Widget build(BuildContext context) {
    final outletId = context.sessionOrNull?.activeOutlet?.id;
    if (outletId == null) {
      return const Center(child: Text('Pilih outlet terlebih dahulu.'));
    }
    return _OpnameContent(outletId: outletId);
  }
}

class _OpnameContent extends StatefulWidget {
  final int outletId;
  const _OpnameContent({required this.outletId});

  @override
  State<_OpnameContent> createState() => _OpnameContentState();
}

class _OpnameContentState extends State<_OpnameContent> {
  final List<Map<String, dynamic>> _opnames = [];

  void _openForm() {
    showAppDrawer(
      context: context,
      builder: (ctx) => AppDrawer(
        title: 'Mulai Stock Opname Baru',
        content: _OpnameForm(
          outletId: widget.outletId,
          onSuccess: (opn) {
            setState(() {
              _opnames.add(opn);
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
                child: Text('Stock Opname Fisik'),
              ),
              AppButton(
                label: 'Mulai Opname',
                icon: AppIcons.add,
                size: AppButtonSize.small,
                onPressed: () => _openForm(),
              ),
            ],
          ),
          SizedBox(height: density.md),
          if (_opnames.isEmpty)
            Expanded(
              child: AppEmptyState(
                title: 'Belum ada sesi stock opname',
                message: 'Lakukan audit stok berkala untuk mencocokkan jumlah fisik dan sistem.',
                icon: AppIcons.stockOpname,
                action: AppButton(
                  label: 'Mulai Opname',
                  icon: AppIcons.add,
                  size: AppButtonSize.small,
                  onPressed: () => _openForm(),
                ),
              ),
            )
          else
            Expanded(
              child: ListView.separated(
                itemCount: _opnames.length,
                separatorBuilder: (_, i) => SizedBox(height: density.sm),
                itemBuilder: (ctx, i) {
                  final opn = _opnames[i];
                  return AppPanel(
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(opn['no'] as String, style: ctx.text.formLabel),
                              Text('Gudang ID: #${opn['warehouse_id']} • Catatan: ${opn['notes'] ?? '-'}', style: ctx.text.formHelper),
                            ],
                          ),
                        ),
                        AppBadge(label: 'Berjalan', color: ctx.colors.warning),
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

class _OpnameForm extends StatefulWidget {
  final int outletId;
  final ValueChanged<Map<String, dynamic>> onSuccess;

  const _OpnameForm({required this.outletId, required this.onSuccess});

  @override
  State<_OpnameForm> createState() => _OpnameFormState();
}

class _OpnameFormState extends State<_OpnameForm> {
  late final TextEditingController _warehouseId;
  late final TextEditingController _notes;

  @override
  void initState() {
    super.initState();
    _warehouseId = TextEditingController(text: '1');
    _notes = TextEditingController();
  }

  @override
  void dispose() {
    _warehouseId.dispose();
    _notes.dispose();
    super.dispose();
  }

  void _submit() {
    final whVal = int.tryParse(_warehouseId.text.trim()) ?? 1;
    final opnNo = 'OPN-${DateTime.now().millisecondsSinceEpoch}';

    AppToast.success(context, 'Sesi Stock Opname $opnNo berhasil dimulai');
    widget.onSuccess({
      'no': opnNo,
      'warehouse_id': whVal,
      'notes': _notes.text.trim().isEmpty ? null : _notes.text.trim(),
    });
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
          label: 'ID Gudang Opname *',
          controller: _warehouseId,
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: density.md),
        AppTextField(
          label: 'Catatan Opname',
          controller: _notes,
          hint: 'misal: Opname Rutin Bulanan Gudang Utama',
        ),
        SizedBox(height: density.xl),
        AppButton(
          label: 'Mulai Audit Opname',
          onPressed: _submit,
        ),
      ],
    );
  }
}
