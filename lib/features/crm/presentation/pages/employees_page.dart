import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design/design.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/session/app_permissions.dart';
import '../../../../core/session/session_scope.dart';
import '../../domain/entities/employee.dart';
import '../bloc/employee_cubit.dart';
import '../bloc/employee_state.dart';

class EmployeesPage extends StatelessWidget {
  const EmployeesPage({super.key});

  static Widget pageBuilder(BuildContext context, GoRouterState state) {
    return BlocProvider<EmployeeCubit>(
      create: (_) => getIt<EmployeeCubit>(),
      child: const EmployeesPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final businessId = context.sessionOrNull?.business.id;
    if (businessId == null) {
      return const Center(child: Text('Identitas bisnis tidak ditemukan.'));
    }
    return _EmployeesContent(businessId: businessId);
  }
}

class _EmployeesContent extends StatefulWidget {
  final int businessId;
  const _EmployeesContent({required this.businessId});

  @override
  State<_EmployeesContent> createState() => _EmployeesContentState();
}

class _EmployeesContentState extends State<_EmployeesContent> {
  String _query = '';

  @override
  void initState() {
    super.initState();
    context.read<EmployeeCubit>().load(widget.businessId);
  }

  List<Employee> _filtered(List<Employee> list) {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return list;
    return list.where((e) {
      final matchName = e.name.toLowerCase().contains(q);
      final matchRole = e.roleName.toLowerCase().contains(q);
      final matchEmail = e.email?.toLowerCase().contains(q) ?? false;
      return matchName || matchRole || matchEmail;
    }).toList();
  }

  void _openForm({Employee? editing}) {
    final cubit = context.read<EmployeeCubit>();
    showAppDrawer(
      context: context,
      builder: (ctx) => AppDrawer(
        title: editing == null ? 'Tambah pegawai' : 'Ubah pegawai',
        content: BlocProvider.value(
          value: cubit,
          child: _EmployeeForm(businessId: widget.businessId, editing: editing),
        ),
      ),
    );
  }

  void _confirmDeactivate(BuildContext context, Employee employee) async {
    final confirmed = await showAppConfirm(
      context: context,
      title: 'Nonaktifkan pegawai?',
      message: '"${employee.name}" tidak akan memiliki akses staf operasional lagi.',
      isDestructive: true,
    );
    if (confirmed == true && context.mounted) {
      context.read<EmployeeCubit>().deactivate(employee.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final canManage = context.can(AppPermissions.userManage);
    final density = context.space;

    return BlocListener<EmployeeCubit, EmployeeState>(
      listener: (context, state) {
        if (state is EmployeeError) AppToast.danger(context, state.message);
      },
      child: Padding(
        padding: EdgeInsets.all(density.xl),
        child: BlocBuilder<EmployeeCubit, EmployeeState>(
          builder: (context, state) {
            final employees = state is EmployeeLoaded ? state.employees : <Employee>[];
            final rows = _filtered(employees);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: AppSearchField(
                        hint: 'Cari nama pegawai, peran, email…',
                        onChanged: (q) => setState(() => _query = q),
                        onSubmitted: (q) => setState(() => _query = q),
                      ),
                    ),
                    if (canManage) ...[
                      SizedBox(width: density.md),
                      AppButton(
                        label: 'Tambah pegawai',
                        icon: AppIcons.add,
                        size: AppButtonSize.small,
                        onPressed: () => _openForm(),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: density.md),
                if (state is EmployeeLoading)
                  const Expanded(child: Center(child: AppSkeleton(height: 200)))
                else if (rows.isEmpty)
                  Expanded(
                    child: AppEmptyState(
                      title: _query.isEmpty ? 'Belum ada data pegawai' : 'Tidak ditemukan',
                      message: _query.isEmpty
                          ? 'Daftarkan data pegawai toko untuk penugasan peran & hak akses.'
                          : 'Tidak ada pegawai yang cocok dengan "$_query".',
                      icon: AppIcons.employee,
                      action: _query.isEmpty && canManage
                          ? AppButton(
                              label: 'Tambah pegawai',
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
                      itemBuilder: (ctx, i) => _EmployeeTile(
                        employee: rows[i],
                        canManage: canManage,
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

class _EmployeeTile extends StatelessWidget {
  final Employee employee;
  final bool canManage;
  final VoidCallback? onEdit;
  final VoidCallback? onDeactivate;

  const _EmployeeTile({
    required this.employee,
    required this.canManage,
    this.onEdit,
    this.onDeactivate,
  });

  @override
  Widget build(BuildContext context) {
    final text = context.text;
    final density = context.space;

    return AppPanel(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(employee.name, style: text.formLabel),
                    SizedBox(width: density.sm),
                    AppBadge(
                      label: employee.roleName,
                      variant: AppBadgeVariant.info,
                    ),
                  ],
                ),
                SizedBox(height: density.xs),
                Text(
                  [
                    if (employee.email != null && employee.email!.isNotEmpty) employee.email,
                    if (employee.phone != null && employee.phone!.isNotEmpty) employee.phone,
                  ].join(' • '),
                  style: text.caption,
                ),
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
              onPressed: onDeactivate,
              tooltip: 'Nonaktifkan',
            ),
          ],
        ],
      ),
    );
  }
}

class _EmployeeForm extends StatefulWidget {
  final int businessId;
  final Employee? editing;

  const _EmployeeForm({required this.businessId, this.editing});

  @override
  State<_EmployeeForm> createState() => _EmployeeFormState();
}

class _EmployeeFormState extends State<_EmployeeForm> {
  late final TextEditingController _name;
  late final TextEditingController _email;
  late final TextEditingController _phone;
  late final TextEditingController _roleName;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.editing?.name ?? '');
    _email = TextEditingController(text: widget.editing?.email ?? '');
    _phone = TextEditingController(text: widget.editing?.phone ?? '');
    _roleName = TextEditingController(text: widget.editing?.roleName ?? 'Kasir');
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _roleName.dispose();
    super.dispose();
  }

  void _submit() {
    final nameStr = _name.text.trim();
    if (nameStr.isEmpty) {
      AppToast.danger(context, 'Nama pegawai tidak boleh kosong');
      return;
    }

    final editing = widget.editing;
    final cubit = context.read<EmployeeCubit>();

    if (editing == null) {
      cubit.create(Employee(
        id: '',
        businessId: widget.businessId,
        name: nameStr,
        email: _email.text.trim().isEmpty ? null : _email.text.trim(),
        phone: _phone.text.trim().isEmpty ? null : _phone.text.trim(),
        roleName: _roleName.text.trim().isEmpty ? 'Kasir' : _roleName.text.trim(),
      ));
    } else {
      cubit.update(editing.copyWith(
        name: nameStr,
        email: _email.text.trim().isEmpty ? null : _email.text.trim(),
        phone: _phone.text.trim().isEmpty ? null : _phone.text.trim(),
        roleName: _roleName.text.trim().isEmpty ? 'Kasir' : _roleName.text.trim(),
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
          label: 'Email',
          controller: _email,
          keyboardType: TextInputType.emailAddress,
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
          label: 'Peran / Jabatan (misal: Kasir, Manager, Staf)',
          controller: _roleName,
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
