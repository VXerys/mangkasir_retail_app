import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design/design.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/session/session_scope.dart';
import '../../domain/entities/business.dart';
import '../bloc/business/business_cubit.dart';
import '../bloc/business/business_state.dart';

/// Identitas usaha — nama, kontak, dan konfigurasi bisnis.
///
/// Membutuhkan SETTING_MANAGE. Guard rute menangani redirect bila tidak punya;
/// halaman tidak perlu memeriksa ulang.
class BusinessSettingsPage extends StatelessWidget {
  const BusinessSettingsPage({super.key});

  static Widget pageBuilder(BuildContext context, GoRouterState state) {
    return BlocProvider<BusinessCubit>(
      create: (_) => getIt<BusinessCubit>(),
      child: const BusinessSettingsPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final businessId = context.sessionOrNull?.business.id;
    if (businessId == null) return const SizedBox.shrink();

    return BlocBuilder<BusinessCubit, BusinessState>(
      builder: (context, state) {
        if (state is BusinessLoading) {
          // Muat saat pertama kali dipasang
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) {
              context.read<BusinessCubit>().load(businessId);
            }
          });
          return const _LoadingView();
        }

        if (state is BusinessError) {
          return _ErrorView(
            message: state.message,
            onRetry: () => context.read<BusinessCubit>().load(businessId),
          );
        }

        final business = switch (state) {
          BusinessLoaded(:final business) => business,
          BusinessSaved(:final business) => business,
          BusinessSaving() => null,
          _ => null,
        };

        if (business == null) return const _LoadingView();

        return _BusinessForm(
          business: business,
          isSaving: state is BusinessSaving,
          justSaved: state is BusinessSaved,
        );
      },
    );
  }
}

// ── Form ──────────────────────────────────────────────────────────────────────

class _BusinessForm extends StatefulWidget {
  final Business business;
  final bool isSaving;
  final bool justSaved;

  const _BusinessForm({
    required this.business,
    required this.isSaving,
    required this.justSaved,
  });

  @override
  State<_BusinessForm> createState() => _BusinessFormState();
}

class _BusinessFormState extends State<_BusinessForm> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _addressCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _taxNumberCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.business.name);
    _phoneCtrl = TextEditingController(text: widget.business.phone ?? '');
    _addressCtrl = TextEditingController(text: widget.business.address ?? '');
    _emailCtrl = TextEditingController(text: widget.business.email ?? '');
    _taxNumberCtrl = TextEditingController(text: widget.business.taxNumber ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    _emailCtrl.dispose();
    _taxNumberCtrl.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(_BusinessForm old) {
    super.didUpdateWidget(old);
    if (widget.justSaved && !old.justSaved) {
      AppToast.success(context, 'Perubahan disimpan');
    }
  }

  void _submit() {
    if (_nameCtrl.text.trim().isEmpty) {
      AppToast.danger(context, 'Nama bisnis tidak boleh kosong');
      return;
    }
    context.read<BusinessCubit>().save(
          widget.business.copyWith(
            name: _nameCtrl.text.trim(),
            phone: _phoneCtrl.text.trim().isEmpty
                ? null
                : _phoneCtrl.text.trim(),
            address: _addressCtrl.text.trim().isEmpty
                ? null
                : _addressCtrl.text.trim(),
            email: _emailCtrl.text.trim().isEmpty
                ? null
                : _emailCtrl.text.trim(),
            taxNumber: _taxNumberCtrl.text.trim().isEmpty
                ? null
                : _taxNumberCtrl.text.trim(),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final density = context.space;
    final text = context.text;

    return SingleChildScrollView(
      padding: EdgeInsets.all(density.xl),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: AppPanel(
          header: Text('Identitas Bisnis', style: text.toolbarTitle),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppTextField(
                label: 'Nama bisnis',
                controller: _nameCtrl,
                enabled: !widget.isSaving,
              ),
              SizedBox(height: density.md),
              AppTextField(
                label: 'Nomor telepon',
                controller: _phoneCtrl,
                keyboardType: TextInputType.phone,
                enabled: !widget.isSaving,
              ),
              SizedBox(height: density.md),
              AppTextField(
                label: 'Alamat',
                controller: _addressCtrl,
                maxLines: 3,
                enabled: !widget.isSaving,
              ),
              SizedBox(height: density.md),
              AppTextField(
                label: 'Email bisnis',
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                enabled: !widget.isSaving,
              ),
              SizedBox(height: density.md),
              AppTextField(
                label: 'NPWP',
                controller: _taxNumberCtrl,
                hint: '00.000.000.0-000.000',
                enabled: !widget.isSaving,
              ),
              SizedBox(height: density.xl),
              AppButton(
                label: 'Simpan perubahan',
                variant: AppButtonVariant.primary,
                isLoading: widget.isSaving,
                onPressed: widget.isSaving ? null : _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── State views ───────────────────────────────────────────────────────────────

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(child: AppSkeleton(height: 300));
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AppErrorView(
        message: message,
        onRetry: onRetry,
      ),
    );
  }
}
