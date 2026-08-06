import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/design/design.dart';
import '../../../../../core/di/injection.dart';
import '../../../../../core/session/app_permissions.dart';
import '../../../../../core/session/session_scope.dart';
import '../../domain/entities/brand.dart';
import '../bloc/brand_cubit.dart';
import '../bloc/brand_state.dart';

class BrandsPage extends StatelessWidget {
  const BrandsPage({super.key});

  static Widget pageBuilder(BuildContext context, GoRouterState state) {
    return BlocProvider<BrandCubit>(
      create: (_) => getIt<BrandCubit>(),
      child: const BrandsPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final businessId = context.sessionOrNull?.business.id;
    if (businessId == null) return const SizedBox.shrink();
    return _BrandsContent(businessId: businessId);
  }
}

class _BrandsContent extends StatefulWidget {
  final int businessId;
  const _BrandsContent({required this.businessId});

  @override
  State<_BrandsContent> createState() => _BrandsContentState();
}

class _BrandsContentState extends State<_BrandsContent> {
  String _query = '';

  @override
  void initState() {
    super.initState();
    context.read<BrandCubit>().load(widget.businessId);
  }

  List<Brand> _filtered(List<Brand> brands) {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return brands;
    return brands.where((b) => b.name.toLowerCase().contains(q)).toList();
  }

  void _openForm({Brand? editing}) {
    final cubit = context.read<BrandCubit>();
    showAppDrawer(
      context: context,
      builder: (ctx) => AppDrawer(
        title: editing == null ? 'Tambah merek' : 'Ubah merek',
        content: BlocProvider.value(
          value: cubit,
          child: _BrandForm(businessId: widget.businessId, editing: editing),
        ),
      ),
    );
  }

  void _confirmDeactivate(BuildContext context, Brand brand) async {
    final confirmed = await showAppConfirm(
      context: context,
      title: 'Nonaktifkan merek?',
      message: '"${brand.name}" tidak akan muncul lagi di pilihan merek produk.',
      isDestructive: true,
    );
    if (confirmed == true && context.mounted) {
      context.read<BrandCubit>().deactivate(brand.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final canManage = context.can(AppPermissions.productManage);
    final density = context.space;

    return BlocListener<BrandCubit, BrandState>(
      listener: (context, state) {
        if (state is BrandError) AppToast.danger(context, state.message);
      },
      child: Padding(
        padding: EdgeInsets.all(density.xl),
        child: BlocBuilder<BrandCubit, BrandState>(
          builder: (context, state) {
            final brands = state is BrandLoaded ? state.brands : <Brand>[];
            final rows = _filtered(brands);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: AppSearchField(
                        hint: 'Cari nama merek…',
                        onChanged: (q) => setState(() => _query = q),
                        onSubmitted: (q) => setState(() => _query = q),
                      ),
                    ),
                    if (canManage) ...[
                      SizedBox(width: density.md),
                      AppButton(
                        label: 'Tambah merek',
                        icon: AppIcons.add,
                        size: AppButtonSize.small,
                        onPressed: () => _openForm(),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: density.md),
                if (state is BrandLoading)
                  const Expanded(child: Center(child: AppSkeleton(height: 200)))
                else if (rows.isEmpty)
                  Expanded(
                    child: AppEmptyState(
                      title: _query.isEmpty ? 'Belum ada merek' : 'Tidak ditemukan',
                      message: _query.isEmpty
                          ? 'Tambahkan merek produk yang dijual di toko ini.'
                          : 'Tidak ada merek yang cocok dengan "$_query".',
                      icon: AppIcons.brand,
                      action: _query.isEmpty && canManage
                          ? AppButton(
                              label: 'Tambah merek',
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
                      itemBuilder: (ctx, i) => _BrandTile(
                        brand: rows[i],
                        canManage: canManage,
                        onEdit: canManage ? () => _openForm(editing: rows[i]) : null,
                        onDeactivate: canManage
                            ? () => _confirmDeactivate(context, rows[i])
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

class _BrandTile extends StatelessWidget {
  final Brand brand;
  final bool canManage;
  final VoidCallback? onEdit;
  final VoidCallback? onDeactivate;

  const _BrandTile({
    required this.brand,
    required this.canManage,
    this.onEdit,
    this.onDeactivate,
  });

  @override
  Widget build(BuildContext context) {
    final text = context.text;

    return AppPanel(
      child: Row(
        children: [
          Expanded(child: Text(brand.name, style: text.formLabel)),
          if (canManage) ...[
            AppIconButton(
              icon: AppIcons.edit,
              onPressed: onEdit,
              tooltip: 'Ubah',
            ),
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

class _BrandForm extends StatefulWidget {
  final int businessId;
  final Brand? editing;

  const _BrandForm({required this.businessId, this.editing});

  @override
  State<_BrandForm> createState() => _BrandFormState();
}

class _BrandFormState extends State<_BrandForm> {
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
      AppToast.danger(context, 'Nama merek tidak boleh kosong');
      return;
    }

    final editing = widget.editing;
    final cubit = context.read<BrandCubit>();

    if (editing == null) {
      cubit.create(Brand(id: 0, name: _name.text.trim(), businessId: widget.businessId));
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
          label: 'Nama merek',
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
