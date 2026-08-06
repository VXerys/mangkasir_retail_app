import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design/design.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/session/session_scope.dart';
import '../../domain/entities/app_user.dart';
import '../bloc/user/user_cubit.dart';
import '../bloc/user/user_state.dart';

/// Daftar pengguna dalam bisnis. Membutuhkan USER_MANAGE (hanya Owner).
class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  static Widget pageBuilder(BuildContext context, GoRouterState state) {
    return BlocProvider<UserCubit>(
      create: (_) => getIt<UserCubit>(),
      child: const UsersPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final businessId = context.sessionOrNull?.business.id;
    if (businessId == null) return const SizedBox.shrink();

    return _UsersContent(businessId: businessId);
  }
}

class _UsersContent extends StatefulWidget {
  final int businessId;

  const _UsersContent({required this.businessId});

  @override
  State<_UsersContent> createState() => _UsersContentState();
}

class _UsersContentState extends State<_UsersContent> {
  @override
  void initState() {
    super.initState();
    context.read<UserCubit>().load(widget.businessId);
  }

  @override
  Widget build(BuildContext context) {
    final density = context.space;
    final text = context.text;

    return Padding(
      padding: EdgeInsets.all(density.xl),
      child: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          if (state is UserLoading) {
            return const Center(child: AppSkeleton(height: 200));
          }

          if (state is UserError) {
            return Center(
              child: AppErrorView(
                message: state.message,
                onRetry: () => context.read<UserCubit>().load(widget.businessId),
              ),
            );
          }

          final users = state is UserLoaded ? state.users : <AppUser>[];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Pengguna (${users.length})', style: text.toolbarTitle),
              SizedBox(height: density.md),
              if (users.isEmpty)
                AppEmptyState(
                  title: 'Belum ada pengguna lain',
                  message: 'Undang anggota tim untuk mulai berkolaborasi.',
                  icon: AppIcons.user,
                )
              else
                for (final user in users) _UserTile(user: user),
            ],
          );
        },
      ),
    );
  }
}

class _UserTile extends StatelessWidget {
  final AppUser user;

  const _UserTile({required this.user});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final density = context.space;
    final text = context.text;

    final roleLabels = user.roles
        .map((r) => r.outletName != null
            ? '${r.roleName} (${r.outletName})'
            : r.roleName)
        .join(', ');

    return Padding(
      padding: EdgeInsets.only(bottom: density.sm),
      child: AppPanel(
        child: Row(
          children: [
            Icon(AppIcons.account, color: colors.textSecondary),
            SizedBox(width: density.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user.username, style: text.formLabel),
                  Text(
                    user.email,
                    style: text.formHelper.copyWith(color: colors.textSecondary),
                  ),
                  if (roleLabels.isNotEmpty)
                    Text(
                      roleLabels,
                      style: text.formHelper.copyWith(color: colors.textTertiary),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
