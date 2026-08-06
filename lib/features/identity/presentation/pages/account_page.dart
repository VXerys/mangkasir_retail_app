import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/design/design.dart';
import '../../../../core/session/session_cubit.dart';
import '../../../../core/session/session_scope.dart';
import '../../../../core/sync/sync_bloc/sync_bloc.dart';
import '../../../../core/sync/sync_bloc/sync_state.dart';

/// Profil dan konteks sesi aktif.
///
/// Tidak punya Scaffold — dirender ke slot workspace milik AppShell.
class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  static Widget pageBuilder(BuildContext context, GoRouterState state) =>
      const AccountPage();

  @override
  Widget build(BuildContext context) {
    final session = context.sessionOrNull;
    if (session == null) return const SizedBox.shrink();

    final density = context.space;

    return SingleChildScrollView(
      padding: EdgeInsets.all(density.xl),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ProfileCard(session: session),
            SizedBox(height: density.lg),
            _OutletCard(session: session),
            SizedBox(height: density.lg),
            _SyncStatusCard(),
            SizedBox(height: density.xl),
            _LogoutButton(),
          ],
        ),
      ),
    );
  }
}

// ── Kartu profil ─────────────────────────────────────────────────────────────

class _ProfileCard extends StatelessWidget {
  final dynamic session;

  const _ProfileCard({required this.session});

  @override
  Widget build(BuildContext context) {
    final text = context.text;
    final colors = context.colors;
    final density = context.space;

    return AppPanel(
      header: Row(
        children: [
          Icon(AppIcons.account, color: colors.accent),
          SizedBox(width: density.sm),
          Text('Profil', style: text.toolbarTitle),
        ],
      ),
      child: Column(
        children: [
          _Row(label: 'Nama pengguna', value: session.user.username),
          _Row(label: 'Email', value: session.user.email),
          _Row(label: 'Bisnis', value: session.business.name),
          _Row(label: 'Peran', value: session.roleNames.join(', ')),
        ],
      ),
    );
  }
}

// ── Kartu outlet aktif ────────────────────────────────────────────────────────

class _OutletCard extends StatelessWidget {
  final dynamic session;

  const _OutletCard({required this.session});

  @override
  Widget build(BuildContext context) {
    final text = context.text;
    final colors = context.colors;
    final density = context.space;
    final cubit = context.read<SessionCubit>();

    return AppPanel(
      header: Row(
        children: [
          Icon(AppIcons.outlet, color: colors.accent),
          SizedBox(width: density.sm),
          Text('Outlet aktif', style: text.toolbarTitle),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Row(
            label: 'Outlet saat ini',
            value: session.activeOutlet?.name ?? '—',
          ),
          if (session.outlets.length > 1) ...[
            SizedBox(height: density.md),
            Text(
              'Ganti outlet',
              style: text.formLabel.copyWith(color: colors.textSecondary),
            ),
            SizedBox(height: density.sm),
            Wrap(
              spacing: density.sm,
              runSpacing: density.sm,
              children: [
                for (final outlet in session.outlets)
                  if (outlet.id != session.activeOutlet?.id)
                    AppButton(
                      label: outlet.name,
                      size: AppButtonSize.small,
                      variant: AppButtonVariant.secondary,
                      onPressed: () => cubit.selectOutlet(outlet.id),
                    ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// ── Status sinkronisasi ───────────────────────────────────────────────────────

class _SyncStatusCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final text = context.text;
    final colors = context.colors;
    final density = context.space;

    return BlocBuilder<SyncBloc, SyncState>(
      builder: (context, state) {
        final (label, icon, color) = switch (state) {
          Syncing() => (
              'Menyinkronkan…',
              AppIcons.syncRunning,
              colors.accent,
            ),
          SyncFailed(:final message) => (
              'Sinkronisasi gagal: $message',
              AppIcons.syncFailed,
              colors.danger.fg,
            ),
          SyncCompleted() => (
              'Tersinkron',
              AppIcons.syncDone,
              colors.success.fg,
            ),
          _ => (
              'Menunggu sinkronisasi',
              AppIcons.syncPending,
              colors.textTertiary,
            ),
        };

        return AppPanel(
          header: Row(
            children: [
              Icon(AppIcons.syncPending, color: colors.textSecondary),
              SizedBox(width: density.sm),
              Text('Sinkronisasi', style: text.toolbarTitle),
            ],
          ),
          child: Row(
            children: [
              Icon(icon, color: color, size: 18),
              SizedBox(width: density.sm),
              Expanded(child: Text(label, style: text.formHelper)),
            ],
          ),
        );
      },
    );
  }
}

// ── Tombol keluar ─────────────────────────────────────────────────────────────

class _LogoutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppButton(
      label: 'Keluar',
      icon: AppIcons.logout,
      variant: AppButtonVariant.ghost,
      onPressed: () async {
        final confirmed = await showAppConfirm(
          context: context,
          title: 'Keluar dari akun?',
          message:
              'Data yang belum tersinkronkan akan tetap tersimpan di perangkat ini.',
          confirmLabel: 'Keluar',
          isDestructive: true,
        );
        if (confirmed && context.mounted) {
          await context.read<SessionCubit>().signOut();
          if (context.mounted) context.go(AppRoutes.login);
        }
      },
    );
  }
}

// ── Helper ────────────────────────────────────────────────────────────────────

class _Row extends StatelessWidget {
  final String label;
  final String value;

  const _Row({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final text = context.text;
    final colors = context.colors;
    final density = context.space;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: density.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: text.formLabel.copyWith(color: colors.textSecondary),
            ),
          ),
          Expanded(
            child: Text(value, style: text.formLabel),
          ),
        ],
      ),
    );
  }
}

