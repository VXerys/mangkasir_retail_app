import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/design/design.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/session/app_permissions.dart';
import '../../../../core/session/session_scope.dart';
import '../../domain/entities/category.dart';
import '../bloc/category/category_bloc.dart';
import '../bloc/category/category_event.dart';
import '../bloc/category/category_state.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  static Widget pageBuilder(BuildContext context, GoRouterState state) {
    return BlocProvider<CategoryBloc>(
      create: (_) => getIt<CategoryBloc>()..add(const CategoryEvent.watchStarted()),
      child: const CategoriesPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const _CategoriesContent();
  }
}

class _CategoriesContent extends StatefulWidget {
  const _CategoriesContent();

  @override
  State<_CategoriesContent> createState() => _CategoriesContentState();
}

class _CategoriesContentState extends State<_CategoriesContent> {
  String _query = '';

  List<Category> _filtered(List<Category> categories) {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return categories;
    return categories.where((c) => c.name.toLowerCase().contains(q)).toList();
  }

  void _openForm({Category? editing}) {
    final bloc = context.read<CategoryBloc>();
    final session = context.sessionOrNull;
    if (session == null) return;

    showAppDrawer(
      context: context,
      builder: (ctx) => AppDrawer(
        title: editing == null ? 'Tambah kategori' : 'Ubah kategori',
        content: BlocProvider.value(
          value: bloc,
          child: _CategoryForm(
            storeId: session.activeOutlet?.id.toString() ?? '',
            editing: editing,
          ),
        ),
      ),
    );
  }

  void _confirmArchive(BuildContext context, Category category) async {
    final confirmed = await showAppConfirm(
      context: context,
      title: 'Arsipkan kategori?',
      message:
          '"${category.name}" tidak akan muncul lagi di daftar. Produk yang sudah memakai kategori ini tidak bisa diarsipkan.',
      isDestructive: true,
    );
    if (confirmed == true && context.mounted) {
      context.read<CategoryBloc>().add(CategoryEvent.archived(id: category.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    final canManage = context.can(AppPermissions.productManage);
    final density = context.space;

    return BlocListener<CategoryBloc, CategoryState>(
      listener: (context, state) {
        if (state is CategoryError) {
          AppToast.danger(context, state.message);
        }
      },
      child: Padding(
        padding: EdgeInsets.all(density.xl),
        child: BlocBuilder<CategoryBloc, CategoryState>(
          builder: (context, state) {
            final categories = state is CategoryLoaded ? state.categories : <Category>[];
            final rows = _filtered(categories);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Toolbar(
                  canManage: canManage,
                  onQueryChanged: (q) => setState(() => _query = q),
                  onAdd: canManage ? () => _openForm() : null,
                ),
                SizedBox(height: density.md),
                if (state is CategoryLoading)
                  const Expanded(child: Center(child: AppSkeleton(height: 200)))
                else if (rows.isEmpty)
                  Expanded(
                    child: AppEmptyState(
                      title: _query.isEmpty ? 'Belum ada kategori' : 'Tidak ditemukan',
                      message: _query.isEmpty
                          ? 'Tambahkan kategori untuk mengelompokkan produk.'
                          : 'Tidak ada kategori yang cocok dengan "$_query".',
                      icon: AppIcons.category,
                      action: _query.isEmpty && canManage
                          ? AppButton(
                              label: 'Tambah kategori',
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
                      itemBuilder: (ctx, i) => _CategoryTile(
                        category: rows[i],
                        canManage: canManage,
                        onEdit: canManage ? () => _openForm(editing: rows[i]) : null,
                        onArchive: canManage ? () => _confirmArchive(context, rows[i]) : null,
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

class _Toolbar extends StatelessWidget {
  final bool canManage;
  final ValueChanged<String> onQueryChanged;
  final VoidCallback? onAdd;

  const _Toolbar({
    required this.canManage,
    required this.onQueryChanged,
    this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppSearchField(
            hint: 'Cari nama kategori…',
            onChanged: onQueryChanged,
            onSubmitted: onQueryChanged,
          ),
        ),
        if (canManage && onAdd != null) ...[
          SizedBox(width: context.space.md),
          AppButton(
            label: 'Tambah kategori',
            icon: AppIcons.add,
            size: AppButtonSize.small,
            onPressed: onAdd,
          ),
        ],
      ],
    );
  }
}

class _CategoryTile extends StatelessWidget {
  final Category category;
  final bool canManage;
  final VoidCallback? onEdit;
  final VoidCallback? onArchive;

  const _CategoryTile({
    required this.category,
    required this.canManage,
    this.onEdit,
    this.onArchive,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final density = context.space;
    final text = context.text;

    return AppPanel(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(category.name, style: text.formLabel),
                SizedBox(height: density.xs),
                AppBadge(
                  label: category.syncStatus == 'synced' ? 'Tersinkron' : 'Menunggu',
                  color: category.syncStatus == 'synced' ? colors.success : colors.syncPending,
                  showDot: true,
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
              onPressed: onArchive,
              tooltip: 'Arsipkan',
            ),
          ],
        ],
      ),
    );
  }
}

class _CategoryForm extends StatefulWidget {
  final String storeId;
  final Category? editing;

  const _CategoryForm({required this.storeId, this.editing});

  @override
  State<_CategoryForm> createState() => _CategoryFormState();
}

class _CategoryFormState extends State<_CategoryForm> {
  late final TextEditingController _name;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.editing?.name ?? '');
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  void _submit() {
    if (_name.text.trim().isEmpty) {
      AppToast.danger(context, 'Nama kategori tidak boleh kosong');
      return;
    }

    final now = DateTime.now();
    final editing = widget.editing;

    final category = editing == null
        ? Category(
            id: const Uuid().v4(),
            guid: const Uuid().v4(),
            name: _name.text.trim(),
            storeId: widget.storeId,
            createdAt: now,
            updatedAt: now,
          )
        : editing.copyWith(name: _name.text.trim());

    final bloc = context.read<CategoryBloc>();
    if (editing == null) {
      bloc.add(CategoryEvent.added(category: category));
    } else {
      bloc.add(CategoryEvent.updated(category: category));
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
          label: 'Nama kategori',
          controller: _name,
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
