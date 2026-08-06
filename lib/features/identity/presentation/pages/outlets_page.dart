import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design/design.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/session/app_permissions.dart';
import '../../../../core/session/session_scope.dart';
import '../../domain/entities/outlet.dart';
import '../bloc/outlet/outlet_cubit.dart';
import '../bloc/outlet/outlet_state.dart';

/// Daftar dan pengelolaan outlet bisnis.
///
/// Form tambah/ubah outlet dibuka sebagai drawer, bukan halaman baru, sehingga
/// tidak perlu rute baru dan tabel rute tidak bertambah.
class OutletsPage extends StatelessWidget {
  const OutletsPage({super.key});

  static Widget pageBuilder(BuildContext context, GoRouterState state) {
    return BlocProvider<OutletCubit>(
      create: (_) => getIt<OutletCubit>(),
      child: const OutletsPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final businessId = context.sessionOrNull?.business.id;
    if (businessId == null) return const SizedBox.shrink();

    return _OutletsContent(businessId: businessId);
  }
}

class _OutletsContent extends StatefulWidget {
  final int businessId;

  const _OutletsContent({required this.businessId});

  @override
  State<_OutletsContent> createState() => _OutletsContentState();
}

class _OutletsContentState extends State<_OutletsContent> {
  @override
  void initState() {
    super.initState();
    context.read<OutletCubit>().load(widget.businessId);
  }

  void _openForm({Outlet? editing}) {
    final cubit = context.read<OutletCubit>();
    showAppDrawer(
      context: context,
      builder: (ctx) => AppDrawer(
        title: editing == null ? 'Tambah outlet' : 'Ubah outlet',
        content: BlocProvider.value(
          value: cubit,
          child: _OutletForm(
            businessId: widget.businessId,
            editing: editing,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final canManage = context.can(AppPermissions.settingManage);
    final density = context.space;
    final text = context.text;

    return Padding(
      padding: EdgeInsets.all(density.xl),
      child: BlocBuilder<OutletCubit, OutletState>(
        builder: (context, state) {
          if (state is OutletLoading || state is OutletSaving) {
            return const Center(child: AppSkeleton(height: 200));
          }

          if (state is OutletError) {
            return Center(
              child: AppErrorView(
                message: state.message,
                onRetry: () => context.read<OutletCubit>().load(widget.businessId),
              ),
            );
          }

          final outlets = state is OutletLoaded ? state.outlets : <Outlet>[];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text('Outlet (${outlets.length})', style: text.toolbarTitle),
                  ),
                  if (canManage)
                    AppButton(
                      label: 'Tambah outlet',
                      icon: AppIcons.add,
                      size: AppButtonSize.small,
                      onPressed: _openForm,
                    ),
                ],
              ),
              SizedBox(height: density.md),
              if (outlets.isEmpty)
                AppEmptyState(
                  title: 'Belum ada outlet',
                  message: 'Tambahkan outlet pertama untuk mulai beroperasi.',
                  icon: AppIcons.outlet,
                  action: canManage
                      ? AppButton(
                          label: 'Tambah outlet',
                          icon: AppIcons.add,
                          size: AppButtonSize.small,
                          onPressed: _openForm,
                        )
                      : null,
                )
              else
                for (final outlet in outlets)
                  _OutletTile(
                    outlet: outlet,
                    canEdit: canManage,
                    onEdit: () => _openForm(editing: outlet),
                  ),
            ],
          );
        },
      ),
    );
  }
}

// ── Tile outlet ───────────────────────────────────────────────────────────────

class _OutletTile extends StatelessWidget {
  final Outlet outlet;
  final bool canEdit;
  final VoidCallback onEdit;

  const _OutletTile({
    required this.outlet,
    required this.canEdit,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final density = context.space;
    final text = context.text;

    return AppPanel(
      child: Row(
        children: [
          Icon(
            AppIcons.outlet,
            color: outlet.isActive ? colors.accent : colors.textTertiary,
          ),
          SizedBox(width: density.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(outlet.name, style: text.formLabel),
                if (outlet.address != null)
                  Text(
                    outlet.address!,
                    style: text.formHelper.copyWith(color: colors.textSecondary),
                  ),
              ],
            ),
          ),
          AppBadge(
            label: outlet.isActive ? 'Aktif' : 'Nonaktif',
            color: outlet.isActive ? colors.success : colors.info,
          ),
          if (canEdit) ...[
            SizedBox(width: density.sm),
            AppIconButton(
              icon: AppIcons.edit,
              tooltip: 'Ubah',
              onPressed: onEdit,
            ),
          ],
        ],
      ),
    );
  }
}

// ── Form tambah/ubah outlet ───────────────────────────────────────────────────

class _OutletForm extends StatefulWidget {
  final int businessId;
  final Outlet? editing;

  const _OutletForm({required this.businessId, this.editing});

  @override
  State<_OutletForm> createState() => _OutletFormState();
}

class _OutletFormState extends State<_OutletForm> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _addressCtrl;
  late final TextEditingController _phoneCtrl;
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.editing?.name ?? '');
    _addressCtrl = TextEditingController(text: widget.editing?.address ?? '');
    _phoneCtrl = TextEditingController(text: widget.editing?.phone ?? '');
    _isActive = widget.editing?.isActive ?? true;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _addressCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_nameCtrl.text.trim().isEmpty) {
      AppToast.danger(context, 'Nama outlet tidak boleh kosong');
      return;
    }

    final cubit = context.read<OutletCubit>();
    final editing = widget.editing;

    if (editing == null) {
      cubit.create(
        Outlet(
          id: 0,
          uuid: '',
          businessId: widget.businessId,
          name: _nameCtrl.text.trim(),
          isActive: _isActive,
          address:
              _addressCtrl.text.trim().isEmpty ? null : _addressCtrl.text.trim(),
          phone: _phoneCtrl.text.trim().isEmpty ? null : _phoneCtrl.text.trim(),
        ),
      );
    } else {
      cubit.update(
        editing.copyWith(
          name: _nameCtrl.text.trim(),
          isActive: _isActive,
          address:
              _addressCtrl.text.trim().isEmpty ? null : _addressCtrl.text.trim(),
          phone: _phoneCtrl.text.trim().isEmpty ? null : _phoneCtrl.text.trim(),
        ),
      );
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
          label: 'Nama outlet',
          controller: _nameCtrl,
          textInputAction: TextInputAction.next,
        ),
        SizedBox(height: density.md),
        AppTextField(
          label: 'Alamat',
          controller: _addressCtrl,
          maxLines: 2,
          textInputAction: TextInputAction.next,
        ),
        SizedBox(height: density.md),
        AppTextField(
          label: 'Nomor telepon',
          controller: _phoneCtrl,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.done,
        ),
        SizedBox(height: density.md),
        AppSwitch(
          label: 'Outlet aktif',
          value: _isActive,
          onChanged: (v) => setState(() => _isActive = v),
        ),
        SizedBox(height: density.xl),
        AppButton(
          label: widget.editing == null ? 'Tambah' : 'Simpan',
          variant: AppButtonVariant.primary,
          onPressed: _submit,
        ),
      ],
    );
  }
}
