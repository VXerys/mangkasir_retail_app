import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design/design.dart';
import '../../../../core/session/app_role.dart';
import '../../../../core/session/session_scope.dart';

/// Daftar peran dan ringkasan izinnya. Hanya baca — pengelolaan peran kustom
/// termasuk scope UI-7+. Membutuhkan USER_MANAGE (hanya Owner).
class RolesPage extends StatelessWidget {
  const RolesPage({super.key});

  static Widget pageBuilder(BuildContext context, GoRouterState state) =>
      const RolesPage();

  @override
  Widget build(BuildContext context) {
    final session = context.sessionOrNull;
    if (session == null) return const SizedBox.shrink();

    final density = context.space;
    final text = context.text;

    return SingleChildScrollView(
      padding: EdgeInsets.all(density.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Peran sistem', style: text.toolbarTitle),
          SizedBox(height: density.xs),
          Text(
            'Peran di bawah ini adalah peran bawaan sistem. Tiap peran membawa '
            'himpunan izin yang berbeda. Owner melewati seluruh pemeriksaan izin.',
            style: text.formHelper.copyWith(color: context.colors.textSecondary),
          ),
          SizedBox(height: density.lg),
          for (final role in AppRole.seeded)
            _RoleTile(role: role, isOwner: role == AppRole.owner),
        ],
      ),
    );
  }
}

class _RoleTile extends StatelessWidget {
  final String role;
  final bool isOwner;

  const _RoleTile({required this.role, required this.isOwner});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final density = context.space;
    final text = context.text;
    final perms = AppRole.seededPermissions[role] ?? const <String>{};

    return Padding(
      padding: EdgeInsets.only(bottom: density.sm),
      child: AppPanel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(AppIcons.role, color: colors.accent, size: 18),
                SizedBox(width: density.sm),
                Text(role, style: text.formLabel),
                if (isOwner) ...[
                  SizedBox(width: density.sm),
                  AppBadge(label: 'Bypass', color: colors.warning),
                ],
                const Spacer(),
                Text(
                  '${perms.length} izin',
                  style: text.formHelper.copyWith(color: colors.textTertiary),
                ),
              ],
            ),
            if (perms.isNotEmpty) ...[
              SizedBox(height: density.sm),
              Wrap(
                spacing: density.xs,
                runSpacing: density.xs,
                children: perms
                    .toList()
                    .map(
                      (p) => AppBadge(
                        label: p,
                        color: colors.info,
                      ),
                    )
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
