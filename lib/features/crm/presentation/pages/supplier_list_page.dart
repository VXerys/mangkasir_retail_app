import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/design/design.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/session/app_permissions.dart';
import '../../../../core/session/session_scope.dart';
import '../../domain/entities/supplier.dart';
import '../bloc/supplier_cubit.dart';
import '../bloc/supplier_state.dart';

class SupplierListPage extends StatelessWidget {
  const SupplierListPage({super.key});

  static Widget pageBuilder(BuildContext context, GoRouterState state) {
    return BlocProvider<SupplierCubit>(
      create: (_) => getIt<SupplierCubit>(),
      child: const SupplierListPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final businessId = context.sessionOrNull?.business.id;
    if (businessId == null) {
      return const Center(child: Text('Identitas bisnis tidak ditemukan.'));
    }
    return _SupplierListContent(businessId: businessId);
  }
}

class _SupplierListContent extends StatefulWidget {
  final int businessId;
  const _SupplierListContent({required this.businessId});

  @override
  State<_SupplierListContent> createState() => _SupplierListContentState();
}

class _SupplierListContentState extends State<_SupplierListContent> {
  String _query = '';

  @override
  void initState() {
    super.initState();
    context.read<SupplierCubit>().load(widget.businessId);
  }

  List<Supplier> _filtered(List<Supplier> list) {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return list;
    return list.where((s) {
      final matchName = s.name.toLowerCase().contains(q);
      final matchPhone = s.phone?.toLowerCase().contains(q) ?? false;
      final matchEmail = s.email?.toLowerCase().contains(q) ?? false;
      return matchName || matchPhone || matchEmail;
    }).toList();
  }

  void _openForm({Supplier? editing}) {
    final cubit = context.read<SupplierCubit>();
    showAppDrawer(
      context: context,
      builder: (ctx) => AppDrawer(
        title: editing == null ? 'Tambah pemasok' : 'Ubah pemasok',
        content: BlocProvider.value(
          value: cubit,
          child: _SupplierForm(businessId: widget.businessId, editing: editing),
        ),
      ),
    );
  }

  void _confirmDeactivate(BuildContext context, Supplier supplier) async {
    final confirmed = await showAppConfirm(
      context: context,
      title: 'Nonaktifkan pemasok?',
      message: '"${supplier.name}" tidak akan muncul di daftar pilihan pemasok.',
      isDestructive: true,
    );
    if (confirmed == true && context.mounted) {
      context.read<SupplierCubit>().deactivate(supplier.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final canManage = context.can(AppPermissions.crmRead);
    final density = context.space;

    return BlocListener<SupplierCubit, SupplierState>(
      listener: (context, state) {
        if (state is SupplierError) AppToast.danger(context, state.message);
      },
      child: Padding(
        padding: EdgeInsets.all(density.xl),
        child: BlocBuilder<SupplierCubit, SupplierState>(
          builder: (context, state) {
            final suppliers = state is SupplierLoaded ? state.suppliers : <Supplier>[];
            final rows = _filtered(suppliers);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: AppSearchField(
                        hint: 'Cari nama pemasok, telepon, email…',
                        onChanged: (q) => setState(() => _query = q),
                        onSubmitted: (q) => setState(() => _query = q),
                      ),
                    ),
                    if (canManage) ...[
                      SizedBox(width: density.md),
                      AppButton(
                        label: 'Tambah pemasok',
                        icon: AppIcons.add,
                        size: AppButtonSize.small,
                        onPressed: () => _openForm(),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: density.md),
                if (state is SupplierLoading)
                  const Expanded(child: Center(child: AppSkeleton(height: 200)))
                else if (rows.isEmpty)
                  Expanded(
                    child: AppEmptyState(
                      title: _query.isEmpty ? 'Belum ada pemasok' : 'Tidak ditemukan',
                      message: _query.isEmpty
                          ? 'Daftarkan distributor/pemasok barang untuk kebutuhan purchase order.'
                          : 'Tidak ada pemasok yang cocok dengan "$_query".',
                      icon: AppIcons.supplier,
                      action: _query.isEmpty && canManage
                          ? AppButton(
                              label: 'Tambah pemasok',
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
                      itemBuilder: (ctx, i) => _SupplierTile(
                        supplier: rows[i],
                        canManage: canManage,
                        onTap: () => context.go(AppRoutes.supplierDetail(rows[i].id.toString())),
                        onEdit: canManage ? () => _openForm(editing: rows[i]) : null,
                        onDeactivate: canManage ? () => _confirmDeactivate(context, rows[i]) : null,
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

class _SupplierTile extends StatelessWidget {
  final Supplier supplier;
  final bool canManage;
  final VoidCallback onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDeactivate;

  const _SupplierTile({
    required this.supplier,
    required this.canManage,
    required this.onTap,
    this.onEdit,
    this.onDeactivate,
  });

  @override
  Widget build(BuildContext context) {
    final text = context.text;
    final density = context.space;

    return AppPanel(
      onTap: onTap,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(supplier.name, style: text.formLabel),
                SizedBox(height: density.xs),
                Text(
                  [
                    if (supplier.phone != null && supplier.phone!.isNotEmpty) supplier.phone,
                    if (supplier.paymentTerms != null && supplier.paymentTerms!.isNotEmpty)
                      'Termin: ${supplier.paymentTerms}',
                  ].join(' • '),
                  style: text.caption,
                ),
              ],
            ),
          ),
          if (supplier.taxId != null && supplier.taxId!.isNotEmpty) ...[
            AppBadge(
              label: 'NPWP',
              variant: AppBadgeVariant.neutral,
            ),
            SizedBox(width: density.sm),
          ],
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

class _SupplierForm extends StatefulWidget {
  final int businessId;
  final Supplier? editing;

  const _SupplierForm({required this.businessId, this.editing});

  @override
  State<_SupplierForm> createState() => _SupplierFormState();
}

class _SupplierFormState extends State<_SupplierForm> {
  late final TextEditingController _name;
  late final TextEditingController _phone;
  late final TextEditingController _email;
  late final TextEditingController _address;
  late final TextEditingController _taxId;
  late final TextEditingController _paymentTerms;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.editing?.name ?? '');
    _phone = TextEditingController(text: widget.editing?.phone ?? '');
    _email = TextEditingController(text: widget.editing?.email ?? '');
    _address = TextEditingController(text: widget.editing?.address ?? '');
    _taxId = TextEditingController(text: widget.editing?.taxId ?? '');
    _paymentTerms = TextEditingController(text: widget.editing?.paymentTerms ?? '');
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _email.dispose();
    _address.dispose();
    _taxId.dispose();
    _paymentTerms.dispose();
    super.dispose();
  }

  void _submit() {
    final nameStr = _name.text.trim();
    if (nameStr.isEmpty) {
      AppToast.danger(context, 'Nama pemasok tidak boleh kosong');
      return;
    }

    final editing = widget.editing;
    final cubit = context.read<SupplierCubit>();

    if (editing == null) {
      cubit.create(Supplier(
        id: 0,
        uuid: '',
        businessId: widget.businessId,
        name: nameStr,
        phone: _phone.text.trim().isEmpty ? null : _phone.text.trim(),
        email: _email.text.trim().isEmpty ? null : _email.text.trim(),
        address: _address.text.trim().isEmpty ? null : _address.text.trim(),
        taxId: _taxId.text.trim().isEmpty ? null : _taxId.text.trim(),
        paymentTerms: _paymentTerms.text.trim().isEmpty ? null : _paymentTerms.text.trim(),
      ));
    } else {
      cubit.update(editing.copyWith(
        name: nameStr,
        phone: _phone.text.trim().isEmpty ? null : _phone.text.trim(),
        email: _email.text.trim().isEmpty ? null : _email.text.trim(),
        address: _address.text.trim().isEmpty ? null : _address.text.trim(),
        taxId: _taxId.text.trim().isEmpty ? null : _taxId.text.trim(),
        paymentTerms: _paymentTerms.text.trim().isEmpty ? null : _paymentTerms.text.trim(),
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
          label: 'Nama pemasok *',
          controller: _name,
          textInputAction: TextInputAction.next,
        ),
        SizedBox(height: density.md),
        AppTextField(
          label: 'Nomor telepon',
          controller: _phone,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
        ),
        SizedBox(height: density.md),
        AppTextField(
          label: 'Email',
          controller: _email,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
        ),
        SizedBox(height: density.md),
        AppTextField(
          label: 'Alamat',
          controller: _address,
          textInputAction: TextInputAction.next,
        ),
        SizedBox(height: density.md),
        AppTextField(
          label: 'NPWP (Tax ID)',
          controller: _taxId,
          textInputAction: TextInputAction.next,
        ),
        SizedBox(height: density.md),
        AppTextField(
          label: 'Termin Pembayaran (misal: Net 30, COD)',
          controller: _paymentTerms,
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
