import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/design/design.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/session/app_permissions.dart';
import '../../../../core/session/session_scope.dart';
import '../../domain/entities/customer.dart';
import '../bloc/customer_cubit.dart';
import '../bloc/customer_state.dart';

class CustomerListPage extends StatelessWidget {
  const CustomerListPage({super.key});

  static Widget pageBuilder(BuildContext context, GoRouterState state) {
    return BlocProvider<CustomerCubit>(
      create: (_) => getIt<CustomerCubit>(),
      child: const CustomerListPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final outletId = context.sessionOrNull?.activeOutlet?.id;
    if (outletId == null) {
      return const Center(child: Text('Pilih outlet terlebih dahulu.'));
    }
    return _CustomerListContent(outletId: outletId);
  }
}

class _CustomerListContent extends StatefulWidget {
  final int outletId;
  const _CustomerListContent({required this.outletId});

  @override
  State<_CustomerListContent> createState() => _CustomerListContentState();
}

class _CustomerListContentState extends State<_CustomerListContent> {
  String _query = '';

  @override
  void initState() {
    super.initState();
    context.read<CustomerCubit>().load(widget.outletId);
  }

  List<Customer> _filtered(List<Customer> list) {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return list;
    return list.where((c) {
      final matchName = c.name.toLowerCase().contains(q);
      final matchPhone = c.phone?.toLowerCase().contains(q) ?? false;
      final matchEmail = c.email?.toLowerCase().contains(q) ?? false;
      return matchName || matchPhone || matchEmail;
    }).toList();
  }

  void _openForm({Customer? editing}) {
    final cubit = context.read<CustomerCubit>();
    showAppDrawer(
      context: context,
      builder: (ctx) => AppDrawer(
        title: editing == null ? 'Tambah pelanggan' : 'Ubah pelanggan',
        content: BlocProvider.value(
          value: cubit,
          child: _CustomerForm(outletId: widget.outletId, editing: editing),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, Customer customer) async {
    final confirmed = await showAppConfirm(
      context: context,
      title: 'Hapus pelanggan?',
      message: '"${customer.name}" akan dihapus dari daftar pelanggan outlet ini.',
      isDestructive: true,
    );
    if (confirmed == true && context.mounted) {
      context.read<CustomerCubit>().delete(customer.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final canManage = context.can(AppPermissions.crmRead);
    final density = context.space;

    return BlocListener<CustomerCubit, CustomerState>(
      listener: (context, state) {
        if (state is CustomerError) AppToast.danger(context, state.message);
      },
      child: Padding(
        padding: EdgeInsets.all(density.xl),
        child: BlocBuilder<CustomerCubit, CustomerState>(
          builder: (context, state) {
            final customers = state is CustomerLoaded ? state.customers : <Customer>[];
            final rows = _filtered(customers);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: AppSearchField(
                        hint: 'Cari nama, telepon, atau email…',
                        onChanged: (q) => setState(() => _query = q),
                        onSubmitted: (q) => setState(() => _query = q),
                      ),
                    ),
                    if (canManage) ...[
                      SizedBox(width: density.md),
                      AppButton(
                        label: 'Tambah pelanggan',
                        icon: AppIcons.add,
                        size: AppButtonSize.small,
                        onPressed: () => _openForm(),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: density.md),
                if (state is CustomerLoading)
                  const Expanded(child: Center(child: AppSkeleton(height: 200)))
                else if (rows.isEmpty)
                  Expanded(
                    child: AppEmptyState(
                      title: _query.isEmpty ? 'Belum ada pelanggan' : 'Tidak ditemukan',
                      message: _query.isEmpty
                          ? 'Daftarkan pelanggan toko untuk mengumpulkan poin & limit piutang.'
                          : 'Tidak ada pelanggan yang cocok dengan "$_query".',
                      icon: AppIcons.customer,
                      action: _query.isEmpty && canManage
                          ? AppButton(
                              label: 'Tambah pelanggan',
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
                      itemBuilder: (ctx, i) => _CustomerTile(
                        customer: rows[i],
                        canManage: canManage,
                        onTap: () => context.go(AppRoutes.customerDetail(rows[i].id.toString())),
                        onEdit: canManage ? () => _openForm(editing: rows[i]) : null,
                        onDelete: canManage ? () => _confirmDelete(context, rows[i]) : null,
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

class _CustomerTile extends StatelessWidget {
  final Customer customer;
  final bool canManage;
  final VoidCallback onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const _CustomerTile({
    required this.customer,
    required this.canManage,
    required this.onTap,
    this.onEdit,
    this.onDelete,
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
                Text(customer.name, style: text.formLabel),
                SizedBox(height: density.xs),
                Text(
                  [
                    if (customer.phone != null && customer.phone!.isNotEmpty) customer.phone,
                    if (customer.email != null && customer.email!.isNotEmpty) customer.email,
                  ].join(' • '),
                  style: text.caption,
                ),
              ],
            ),
          ),
          if (customer.loyaltyPoints > 0) ...[
            AppBadge(
              label: '${customer.loyaltyPoints.toStringAsFixed(0)} poin',
              variant: AppBadgeVariant.info,
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
              onPressed: onDelete,
              tooltip: 'Hapus',
            ),
          ],
        ],
      ),
    );
  }
}

class _CustomerForm extends StatefulWidget {
  final int outletId;
  final Customer? editing;

  const _CustomerForm({required this.outletId, this.editing});

  @override
  State<_CustomerForm> createState() => _CustomerFormState();
}

class _CustomerFormState extends State<_CustomerForm> {
  late final TextEditingController _name;
  late final TextEditingController _phone;
  late final TextEditingController _email;
  late final TextEditingController _address;
  late final TextEditingController _creditLimit;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.editing?.name ?? '');
    _phone = TextEditingController(text: widget.editing?.phone ?? '');
    _email = TextEditingController(text: widget.editing?.email ?? '');
    _address = TextEditingController(text: widget.editing?.address ?? '');
    _creditLimit = TextEditingController(
      text: widget.editing?.creditLimit.toStringAsFixed(0) ?? '0',
    );
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _email.dispose();
    _address.dispose();
    _creditLimit.dispose();
    super.dispose();
  }

  void _submit() {
    final nameStr = _name.text.trim();
    if (nameStr.isEmpty) {
      AppToast.danger(context, 'Nama pelanggan tidak boleh kosong');
      return;
    }

    final creditLimitVal = double.tryParse(_creditLimit.text.trim()) ?? 0.0;
    final editing = widget.editing;
    final cubit = context.read<CustomerCubit>();

    if (editing == null) {
      cubit.create(Customer(
        id: 0,
        uuid: '',
        outletId: widget.outletId,
        name: nameStr,
        phone: _phone.text.trim().isEmpty ? null : _phone.text.trim(),
        email: _email.text.trim().isEmpty ? null : _email.text.trim(),
        address: _address.text.trim().isEmpty ? null : _address.text.trim(),
        creditLimit: creditLimitVal,
      ));
    } else {
      cubit.update(editing.copyWith(
        name: nameStr,
        phone: _phone.text.trim().isEmpty ? null : _phone.text.trim(),
        email: _email.text.trim().isEmpty ? null : _email.text.trim(),
        address: _address.text.trim().isEmpty ? null : _address.text.trim(),
        creditLimit: creditLimitVal,
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
          label: 'Nama lengkap *',
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
          label: 'Limit Piutang (Rp)',
          controller: _creditLimit,
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
