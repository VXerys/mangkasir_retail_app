import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design/design.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/session/app_permissions.dart';
import '../../../../core/session/session_scope.dart';
import '../../domain/entities/warehouse.dart';
import '../bloc/warehouse_cubit.dart';
import '../bloc/warehouse_state.dart';

class WarehousesPage extends StatelessWidget {
  const WarehousesPage({super.key});

  static Widget pageBuilder(BuildContext context, GoRouterState state) {
    return BlocProvider<WarehouseCubit>(
      create: (_) => getIt<WarehouseCubit>(),
      child: const WarehousesPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final outletId = context.sessionOrNull?.activeOutlet?.id;
    if (outletId == null) return const SizedBox.shrink();
    return _WarehousesContent(outletId: outletId);
  }
}

class _WarehousesContent extends StatefulWidget {
  final int outletId;
  const _WarehousesContent({required this.outletId});

  @override
  State<_WarehousesContent> createState() => _WarehousesContentState();
}

class _WarehousesContentState extends State<_WarehousesContent> {
  @override
  void initState() {
    super.initState();
    context.read<WarehouseCubit>().load(widget.outletId);
  }

  void _openForm({Warehouse? editing}) {
    final cubit = context.read<WarehouseCubit>();
    showAppDrawer(
      context: context,
      builder: (ctx) => AppDrawer(
        title: editing == null ? 'Tambah gudang' : 'Ubah gudang',
        content: BlocProvider.value(
          value: cubit,
          child: _WarehouseForm(outletId: widget.outletId, editing: editing),
        ),
      ),
    );
  }

  void _confirmDeactivate(BuildContext context, Warehouse warehouse) async {
    if (warehouse.isDefault) {
      AppToast.danger(context, 'Gudang utama tidak bisa dinonaktifkan');
      return;
    }
    final confirmed = await showAppConfirm(
      context: context,
      title: 'Nonaktifkan gudang?',
      message: '"${warehouse.name}" tidak akan bisa menerima stok baru.',
      isDestructive: true,
    );
    if (confirmed == true && context.mounted) {
      context.read<WarehouseCubit>().deactivate(warehouse.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final canManage = context.can(AppPermissions.settingManage);
    final density = context.space;

    return BlocListener<WarehouseCubit, WarehouseState>(
      listener: (context, state) {
        if (state is WarehouseError) AppToast.danger(context, state.message);
      },
      child: Padding(
        padding: EdgeInsets.all(density.xl),
        child: BlocBuilder<WarehouseCubit, WarehouseState>(
          builder: (context, state) {
            final warehouses =
                state is WarehouseLoaded ? state.warehouses : <Warehouse>[];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (canManage)
                  Align(
                    alignment: Alignment.centerRight,
                    child: AppButton(
                      label: 'Tambah gudang',
                      icon: AppIcons.add,
                      size: AppButtonSize.small,
                      onPressed: () => _openForm(),
                    ),
                  ),
                SizedBox(height: density.md),
                if (state is WarehouseLoading)
                  const Expanded(child: Center(child: AppSkeleton(height: 200)))
                else if (warehouses.isEmpty)
                  Expanded(
                    child: AppEmptyState(
                      title: 'Belum ada gudang',
                      message: 'Tambahkan gudang untuk outlet ini.',
                      icon: AppIcons.warehouse,
                      action: canManage
                          ? AppButton(
                              label: 'Tambah gudang',
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
                      itemCount: warehouses.length,
                      separatorBuilder: (_, i) => SizedBox(height: density.sm),
                      itemBuilder: (ctx, i) => _WarehouseTile(
                        warehouse: warehouses[i],
                        canManage: canManage,
                        onEdit: canManage ? () => _openForm(editing: warehouses[i]) : null,
                        onDeactivate: canManage
                            ? () => _confirmDeactivate(context, warehouses[i])
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

class _WarehouseTile extends StatelessWidget {
  final Warehouse warehouse;
  final bool canManage;
  final VoidCallback? onEdit;
  final VoidCallback? onDeactivate;

  const _WarehouseTile({
    required this.warehouse,
    required this.canManage,
    this.onEdit,
    this.onDeactivate,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = context.text;
    final density = context.space;

    return AppPanel(
      child: Row(
        children: [
          Icon(
            AppIcons.warehouse,
            color: warehouse.isDefault ? colors.accent : colors.textSecondary,
          ),
          SizedBox(width: density.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(warehouse.name, style: text.formLabel),
                if (warehouse.isDefault)
                  Text(
                    'Gudang utama',
                    style:
                        text.formHelper.copyWith(color: colors.textSecondary),
                  ),
              ],
            ),
          ),
          if (warehouse.isDefault)
            AppBadge(label: 'Utama', color: colors.success),
          if (canManage) ...[
            SizedBox(width: density.sm),
            AppIconButton(
              icon: AppIcons.edit,
              onPressed: onEdit,
              tooltip: 'Ubah',
            ),
            if (!warehouse.isDefault)
              AppIconButton(
                icon: AppIcons.delete,
                onPressed: onDeactivate,
                tooltip: 'Nonaktifkan',
              ),
          ],
        ],
      ),
    );
  }
}

class _WarehouseForm extends StatefulWidget {
  final int outletId;
  final Warehouse? editing;

  const _WarehouseForm({required this.outletId, this.editing});

  @override
  State<_WarehouseForm> createState() => _WarehouseFormState();
}

class _WarehouseFormState extends State<_WarehouseForm> {
  late final TextEditingController _name;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.editing?.name ?? '');
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  void _submit() {
    if (_name.text.trim().isEmpty) {
      AppToast.danger(context, 'Nama gudang tidak boleh kosong');
      return;
    }

    final editing = widget.editing;
    final cubit = context.read<WarehouseCubit>();

    if (editing == null) {
      cubit.create(Warehouse(
        id: 0,
        name: _name.text.trim(),
        outletId: widget.outletId,
      ));
    } else {
      cubit.update(editing.copyWith(name: _name.text.trim()));
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
          label: 'Nama gudang',
          controller: _name,
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
