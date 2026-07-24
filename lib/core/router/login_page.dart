import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../design/design.dart';
import '../session/app_role.dart';
import '../session/session_cubit.dart';

/// Layar masuk — penanda tempat.
///
/// Autentikasi sungguhan adalah pekerjaan fase auth: `Supabase.auth`, pemulihan
/// kata sandi, penyimpanan token, dan cache izin agar kasir yang kehilangan
/// sinyal tidak kehilangan hak aksesnya. Tidak satu pun dari itu dibangun di
/// Phase UI-4.
///
/// Yang ada di sini pada build debug adalah pemilih peran. Bukan kemewahan:
/// tanpa cara masuk, seluruh lapisan RBAC yang baru dibangun tidak bisa
/// dijalankan sama sekali di perangkat sungguhan — hanya di tes.
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final density = context.space;

    return Scaffold(
      backgroundColor: colors.surfaceSubtle,
      body: AppKeyboardInset(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(density.xl),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: density.sidebarExtendedWidth * 1.5),
              child: AppPanel(
                header: Text('Masuk ke MangRitel', style: context.text.toolbarTitle),
                child: kDebugMode
                    ? const _DevRolePicker()
                    : AppEmptyState(
                        title: 'Belum dibangun',
                        message: 'Layar masuk dibangun pada fase autentikasi.',
                        icon: AppIcons.account,
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DevRolePicker extends StatelessWidget {
  const _DevRolePicker();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final density = context.space;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Autentikasi belum dibangun. Pilih peran untuk mencoba navigasi '
          'dan hak akses; menu akan menyesuaikan diri.',
          style: context.text.formHelper.copyWith(color: colors.textTertiary),
        ),
        SizedBox(height: density.lg),
        for (final role in AppRole.seeded)
          Padding(
            padding: EdgeInsets.only(bottom: density.sm),
            child: AppButton(
              label: role,
              variant: role == AppRole.owner
                  ? AppButtonVariant.primary
                  : AppButtonVariant.secondary,
              onPressed: () => context.read<SessionCubit>().signInAsDev(role),
            ),
          ),
      ],
    );
  }
}
