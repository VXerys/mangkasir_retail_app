import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../design/design.dart';
import '../di/injection.dart';
import '../session/session_cubit.dart';
import '../../features/identity/presentation/bloc/login/login_cubit.dart';
import '../../features/identity/presentation/bloc/login/login_state.dart';

/// Layar masuk — autentikasi Supabase sungguhan.
///
/// Tidak punya Scaffold sendiri: ia berada di luar ShellRoute sehingga GoRouter
/// membuatnya langsung sebagai halaman penuh tanpa AppShell. Scaffold
/// didefinisikan di sini.
///
/// Form tidak mengizinkan submit saat loading, dan tombol lupa kata sandi
/// membuka alur pemulihan di halaman yang sama tanpa navigasi tambahan.
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginCubit>(
      create: (_) => getIt<LoginCubit>(),
      child: const _LoginScaffold(),
    );
  }
}

class _LoginScaffold extends StatelessWidget {
  const _LoginScaffold();

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
              constraints: const BoxConstraints(maxWidth: 420),
              child: BlocBuilder<LoginCubit, LoginState>(
                builder: (context, state) {
                  if (state is LoginForgotIdle ||
                      state is LoginForgotLoading ||
                      state is LoginForgotSent) {
                    return _ForgotPasswordForm(state: state);
                  }
                  return _LoginForm(state: state);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Form login utama ─────────────────────────────────────────────────────────

class _LoginForm extends StatefulWidget {
  final LoginState state;

  const _LoginForm({required this.state});

  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  bool get _isLoading => widget.state is LoginLoading;

  void _submit() {
    if (_isLoading) return;
    final email = _emailCtrl.text.trim();
    final password = _passwordCtrl.text;
    if (email.isEmpty || password.isEmpty) return;

    context.read<LoginCubit>().signIn(
          email,
          password,
          context.read<SessionCubit>(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final text = context.text;
    final colors = context.colors;
    final density = context.space;
    final errorMessage =
        widget.state is LoginError ? (widget.state as LoginError).message : null;

    return AppPanel(
      header: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('MangRitel', style: text.toolbarTitle),
          SizedBox(height: density.xs),
          Text(
            'Masuk ke akun Anda',
            style: text.formHelper.copyWith(color: colors.textSecondary),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (errorMessage != null) ...[
            _ErrorBanner(message: errorMessage),
            SizedBox(height: density.md),
          ],
          AppTextField(
            label: 'Email',
            controller: _emailCtrl,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            enabled: !_isLoading,
            hint: 'nama@toko.com',
          ),
          SizedBox(height: density.md),
          AppTextField(
            label: 'Kata sandi',
            controller: _passwordCtrl,
            obscureText: _obscure,
            textInputAction: TextInputAction.done,
            enabled: !_isLoading,
            onSubmitted: (_) => _submit(),
            suffix: AppIconButton(
              icon: _obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
              tooltip: _obscure ? 'Tampilkan' : 'Sembunyikan',
              onPressed: () => setState(() => _obscure = !_obscure),
            ),
          ),
          SizedBox(height: density.sm),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: _isLoading
                  ? null
                  : () => context.read<LoginCubit>().showForgotPassword(),
              child: Text(
                'Lupa kata sandi?',
                style: text.formHelper.copyWith(color: colors.accent),
              ),
            ),
          ),
          SizedBox(height: density.md),
          AppButton(
            label: 'Masuk',
            variant: AppButtonVariant.primary,
            isLoading: _isLoading,
            onPressed: _isLoading ? null : _submit,
          ),
        ],
      ),
    );
  }
}

// ── Form lupa kata sandi ─────────────────────────────────────────────────────

class _ForgotPasswordForm extends StatefulWidget {
  final LoginState state;

  const _ForgotPasswordForm({required this.state});

  @override
  State<_ForgotPasswordForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<_ForgotPasswordForm> {
  final _emailCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  bool get _isLoading => widget.state is LoginForgotLoading;
  bool get _isSent => widget.state is LoginForgotSent;

  @override
  Widget build(BuildContext context) {
    final text = context.text;
    final colors = context.colors;
    final density = context.space;

    return AppPanel(
      header: Text('Pemulihan kata sandi', style: text.toolbarTitle),
      child: _isSent
          ? _SentConfirmation(
              email: _emailCtrl.text,
              onBack: () => context.read<LoginCubit>().backToLogin(),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Masukkan email akun Anda. Kami akan mengirimkan tautan '
                  'untuk membuat kata sandi baru.',
                  style: text.formHelper.copyWith(color: colors.textSecondary),
                ),
                SizedBox(height: density.lg),
                AppTextField(
                  label: 'Email',
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  enabled: !_isLoading,
                  onSubmitted: (_) => context
                      .read<LoginCubit>()
                      .sendPasswordReset(_emailCtrl.text),
                ),
                SizedBox(height: density.lg),
                AppButton(
                  label: 'Kirim tautan pemulihan',
                  variant: AppButtonVariant.primary,
                  isLoading: _isLoading,
                  onPressed: _isLoading
                      ? null
                      : () => context
                          .read<LoginCubit>()
                          .sendPasswordReset(_emailCtrl.text),
                ),
                SizedBox(height: density.sm),
                AppButton(
                  label: 'Kembali ke login',
                  variant: AppButtonVariant.ghost,
                  onPressed: () => context.read<LoginCubit>().backToLogin(),
                ),
              ],
            ),
    );
  }
}

class _SentConfirmation extends StatelessWidget {
  final String email;
  final VoidCallback onBack;

  const _SentConfirmation({required this.email, required this.onBack});

  @override
  Widget build(BuildContext context) {
    final text = context.text;
    final colors = context.colors;
    final density = context.space;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Icon(Icons.mark_email_read_outlined, size: 48, color: colors.success.fg),
        SizedBox(height: density.md),
        Text(
          'Email terkirim',
          style: text.toolbarTitle,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: density.sm),
        Text(
          'Kami mengirimkan tautan pemulihan ke $email. '
          'Periksa kotak masuk dan folder spam Anda.',
          style: text.formHelper.copyWith(color: colors.textSecondary),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: density.lg),
        AppButton(
          label: 'Kembali ke login',
          variant: AppButtonVariant.secondary,
          onPressed: onBack,
        ),
      ],
    );
  }
}

// ── Widget bantu ─────────────────────────────────────────────────────────────

class _ErrorBanner extends StatelessWidget {
  final String message;

  const _ErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final density = context.space;
    final text = context.text;

    return Container(
      padding: EdgeInsets.all(density.md),
      decoration: BoxDecoration(
        color: colors.danger.bg.withValues(alpha: 0.12),
        border: Border.all(color: colors.danger.border),
        borderRadius: AppRadius.rSm,
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: colors.danger.fg, size: 18),
          SizedBox(width: density.sm),
          Expanded(
            child: Text(
              message,
              style: text.formHelper.copyWith(color: colors.danger.fg),
            ),
          ),
        ],
      ),
    );
  }
}
