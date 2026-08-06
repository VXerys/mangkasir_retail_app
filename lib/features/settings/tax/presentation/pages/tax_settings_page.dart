import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/design/design.dart';
import '../../../../../core/di/injection.dart';
import '../../../../../core/session/app_permissions.dart';
import '../../../../../core/session/session_scope.dart';
import '../../domain/entities/tax_settings.dart';
import '../bloc/tax_cubit.dart';
import '../bloc/tax_state.dart';

class TaxSettingsPage extends StatelessWidget {
  const TaxSettingsPage({super.key});

  static Widget pageBuilder(BuildContext context, GoRouterState state) {
    return BlocProvider<TaxCubit>(
      create: (_) => getIt<TaxCubit>(),
      child: const TaxSettingsPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final outletId = context.sessionOrNull?.activeOutlet?.id;
    if (outletId == null) return const SizedBox.shrink();
    return _TaxSettingsContent(outletId: outletId);
  }
}

class _TaxSettingsContent extends StatefulWidget {
  final int outletId;
  const _TaxSettingsContent({required this.outletId});

  @override
  State<_TaxSettingsContent> createState() => _TaxSettingsContentState();
}

class _TaxSettingsContentState extends State<_TaxSettingsContent> {
  late final TextEditingController _taxName;
  late final TextEditingController _taxRate;
  bool _isEnabled = false;
  bool _isInclusive = false;
  bool _dirty = false;

  @override
  void initState() {
    super.initState();
    _taxName = TextEditingController();
    _taxRate = TextEditingController();
    context.read<TaxCubit>().load(widget.outletId);
  }

  @override
  void dispose() {
    _taxName.dispose();
    _taxRate.dispose();
    super.dispose();
  }

  void _populateFrom(TaxSettings settings) {
    _taxName.text = settings.taxName;
    _taxRate.text = settings.taxRate.toStringAsFixed(
      settings.taxRate == settings.taxRate.roundToDouble() ? 0 : 2,
    );
    _isEnabled = settings.isEnabled;
    _isInclusive = settings.isInclusive;
    _dirty = false;
  }

  void _save() {
    final rate = double.tryParse(_taxRate.text.replaceAll(',', '.'));
    if (rate == null || rate < 0 || rate > 100) {
      AppToast.danger(context, 'Tarif pajak harus antara 0 dan 100');
      return;
    }
    if (_taxName.text.trim().isEmpty) {
      AppToast.danger(context, 'Nama pajak tidak boleh kosong');
      return;
    }

    context.read<TaxCubit>().save(TaxSettings(
          outletId: widget.outletId,
          taxName: _taxName.text.trim(),
          taxRate: rate,
          isInclusive: _isInclusive,
          isEnabled: _isEnabled,
        ));
  }

  @override
  Widget build(BuildContext context) {
    final canManage = context.can(AppPermissions.settingManage);
    final density = context.space;
    final text = context.text;
    final colors = context.colors;

    return BlocConsumer<TaxCubit, TaxState>(
      listener: (context, state) {
        if (state is TaxLoaded && !_dirty) {
          setState(() => _populateFrom(state.settings));
        }
        if (state is TaxError) {
          AppToast.danger(context, state.message);
        }
        if (state is TaxLoaded && _dirty) {
          AppToast.success(context, 'Setelan pajak disimpan');
          setState(() => _dirty = false);
        }
      },
      builder: (context, state) {
        if (state is TaxLoading) {
          return const Center(child: AppSkeleton(height: 200));
        }

        return Padding(
          padding: EdgeInsets.all(density.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Pajak Penjualan', style: text.toolbarTitle),
              SizedBox(height: density.xl),
              AppPanel(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppSwitch(
                      label: 'Aktifkan pajak',
                      value: _isEnabled,
                      onChanged: canManage
                          ? (v) => setState(() {
                                _isEnabled = v;
                                _dirty = true;
                              })
                          : null,
                    ),
                    if (_isEnabled) ...[
                      SizedBox(height: density.md),
                      AppTextField(
                        label: 'Nama pajak',
                        controller: _taxName,
                        hint: 'Contoh: PPN',
                        enabled: canManage,
                        onChanged: (_) => setState(() => _dirty = true),
                        textInputAction: TextInputAction.next,
                      ),
                      SizedBox(height: density.md),
                      AppTextField(
                        label: 'Tarif (%)',
                        controller: _taxRate,
                        hint: '11',
                        keyboardType: TextInputType.number,
                        enabled: canManage,
                        onChanged: (_) => setState(() => _dirty = true),
                        textInputAction: TextInputAction.done,
                      ),
                      SizedBox(height: density.md),
                      AppSwitch(
                        label: 'Harga sudah termasuk pajak (inklusif)',
                        value: _isInclusive,
                        onChanged: canManage
                            ? (v) => setState(() {
                                  _isInclusive = v;
                                  _dirty = true;
                                })
                            : null,
                      ),
                      SizedBox(height: density.xs),
                      Text(
                        _isInclusive
                            ? 'Harga yang tertera sudah termasuk pajak.'
                            : 'Pajak akan ditambahkan di atas harga jual.',
                        style:
                            text.formHelper.copyWith(color: colors.textSecondary),
                      ),
                    ],
                  ],
                ),
              ),
              if (canManage) ...[
                SizedBox(height: density.xl),
                AppButton(
                  label: 'Simpan',
                  onPressed: state is TaxSaving ? null : _save,
                  isLoading: state is TaxSaving,
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
