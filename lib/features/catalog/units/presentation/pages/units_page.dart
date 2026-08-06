import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/design/design.dart';
import '../../../../../core/di/injection.dart';
import '../../../../../core/session/app_permissions.dart';
import '../../../../../core/session/session_scope.dart';
import '../../domain/entities/unit.dart';
import '../bloc/unit_cubit.dart';
import '../bloc/unit_state.dart';

class UnitsPage extends StatelessWidget {
  const UnitsPage({super.key});

  static Widget pageBuilder(BuildContext context, GoRouterState state) {
    return BlocProvider<UnitCubit>(
      create: (_) => getIt<UnitCubit>(),
      child: const UnitsPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final businessId = context.sessionOrNull?.business.id;
    if (businessId == null) return const SizedBox.shrink();
    return _UnitsContent(businessId: businessId);
  }
}

class _UnitsContent extends StatefulWidget {
  final int businessId;
  const _UnitsContent({required this.businessId});

  @override
  State<_UnitsContent> createState() => _UnitsContentState();
}

class _UnitsContentState extends State<_UnitsContent> {
  String _query = '';

  @override
  void initState() {
    super.initState();
    context.read<UnitCubit>().load(widget.businessId);
  }

  List<Unit> _filtered(List<Unit> units) {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return units;
    return units
        .where((u) =>
            u.name.toLowerCase().contains(q) ||
            u.symbol.toLowerCase().contains(q))
        .toList();
  }

  void _openForm({Unit? editing}) {
    final cubit = context.read<UnitCubit>();
    showAppDrawer(
      context: context,
      builder: (ctx) => AppDrawer(
        title: editing == null ? 'Tambah satuan' : 'Ubah satuan',
        content: BlocProvider.value(
          value: cubit,
          child: _UnitForm(businessId: widget.businessId, editing: editing),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, Unit unit) async {
    final confirmed = await showAppConfirm(
      context: context,
      title: 'Hapus satuan?',
      message:
          '"${unit.name}" akan dihapus. Jika masih dipakai produk, server akan menolaknya.',
      isDestructive: true,
    );
    if (confirmed == true && context.mounted) {
      context.read<UnitCubit>().delete(unit.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final canManage = context.can(AppPermissions.productManage);
    final density = context.space;

    return BlocListener<UnitCubit, UnitState>(
      listener: (context, state) {
        if (state is UnitError) AppToast.danger(context, state.message);
      },
      child: Padding(
        padding: EdgeInsets.all(density.xl),
        child: BlocBuilder<UnitCubit, UnitState>(
          builder: (context, state) {
            final units = state is UnitLoaded ? state.units : <Unit>[];
            final rows = _filtered(units);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: AppSearchField(
                        hint: 'Cari nama atau simbol…',
                        onChanged: (q) => setState(() => _query = q),
                        onSubmitted: (q) => setState(() => _query = q),
                      ),
                    ),
                    if (canManage) ...[
                      SizedBox(width: density.md),
                      AppButton(
                        label: 'Tambah satuan',
                        icon: AppIcons.add,
                        size: AppButtonSize.small,
                        onPressed: () => _openForm(),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: density.md),
                if (state is UnitLoading)
                  const Expanded(child: Center(child: AppSkeleton(height: 200)))
                else if (rows.isEmpty)
                  Expanded(
                    child: AppEmptyState(
                      title: _query.isEmpty ? 'Belum ada satuan' : 'Tidak ditemukan',
                      message: _query.isEmpty
                          ? 'Tambahkan satuan ukur seperti pcs, kg, atau liter.'
                          : 'Tidak ada satuan yang cocok dengan "$_query".',
                      icon: AppIcons.unit,
                      action: _query.isEmpty && canManage
                          ? AppButton(
                              label: 'Tambah satuan',
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
                      itemBuilder: (ctx, i) => _UnitTile(
                        unit: rows[i],
                        canManage: canManage,
                        onEdit: canManage ? () => _openForm(editing: rows[i]) : null,
                        onDelete: canManage
                            ? () => _confirmDelete(context, rows[i])
                            : null,
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

class _UnitTile extends StatelessWidget {
  final Unit unit;
  final bool canManage;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const _UnitTile({
    required this.unit,
    required this.canManage,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = context.text;
    final density = context.space;

    return AppPanel(
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Text(unit.name, style: text.formLabel),
                SizedBox(width: density.md),
                AppBadge(label: unit.symbol, color: colors.info),
                if (unit.decimalPlaces > 0) ...[
                  SizedBox(width: density.sm),
                  AppBadge(
                    label: '${unit.decimalPlaces} desimal',
                    color: colors.syncPending,
                  ),
                ],
              ],
            ),
          ),
          if (canManage) ...[
            AppIconButton(
              icon: AppIcons.edit,
              onPressed: onEdit,
              tooltip: 'Ubah',
            ),
            AppIconButton(
              icon: AppIcons.delete,
              onPressed: onDelete,
              tooltip: 'Hapus',
            ),
          ],
        ],
      ),
    );
  }
}

class _UnitForm extends StatefulWidget {
  final int businessId;
  final Unit? editing;

  const _UnitForm({required this.businessId, this.editing});

  @override
  State<_UnitForm> createState() => _UnitFormState();
}

class _UnitFormState extends State<_UnitForm> {
  late final TextEditingController _name;
  late final TextEditingController _symbol;
  late final TextEditingController _decimal;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.editing?.name ?? '');
    _symbol = TextEditingController(text: widget.editing?.symbol ?? '');
    _decimal = TextEditingController(
        text: widget.editing?.decimalPlaces.toString() ?? '0');
  }

  @override
  void dispose() {
    _name.dispose();
    _symbol.dispose();
    _decimal.dispose();
    super.dispose();
  }

  void _submit() {
    if (_name.text.trim().isEmpty) {
      AppToast.danger(context, 'Nama satuan tidak boleh kosong');
      return;
    }
    if (_symbol.text.trim().isEmpty) {
      AppToast.danger(context, 'Simbol tidak boleh kosong');
      return;
    }
    final decimalPlaces = int.tryParse(_decimal.text);
    if (decimalPlaces == null || decimalPlaces < 0 || decimalPlaces > 6) {
      AppToast.danger(context, 'Desimal harus antara 0 dan 6');
      return;
    }

    final editing = widget.editing;
    final cubit = context.read<UnitCubit>();

    if (editing == null) {
      cubit.create(Unit(
        id: 0,
        name: _name.text.trim(),
        symbol: _symbol.text.trim(),
        businessId: widget.businessId,
        decimalPlaces: decimalPlaces,
      ));
    } else {
      cubit.update(editing.copyWith(
        name: _name.text.trim(),
        symbol: _symbol.text.trim(),
        decimalPlaces: decimalPlaces,
      ));
    }

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
          label: 'Nama satuan',
          controller: _name,
          textInputAction: TextInputAction.next,
        ),
        SizedBox(height: density.md),
        AppTextField(
          label: 'Simbol',
          controller: _symbol,
          hint: 'Contoh: pcs, kg, ltr',
          textInputAction: TextInputAction.next,
        ),
        SizedBox(height: density.md),
        AppTextField(
          label: 'Desimal',
          controller: _decimal,
          hint: '0',
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _submit(),
        ),
        SizedBox(height: density.xl),
        AppButton(
          label: widget.editing == null ? 'Simpan' : 'Perbarui',
          onPressed: _submit,
        ),
      ],
    );
  }
}
