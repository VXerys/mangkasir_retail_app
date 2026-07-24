import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../design.dart';

/// Kolom mana yang sedang mengurutkan tabel, dan ke arah mana.
@immutable
class AppSortState {
  final String columnId;
  final bool ascending;

  const AppSortState(this.columnId, {this.ascending = true});

  AppSortState get toggled =>
      AppSortState(columnId, ascending: !ascending);

  @override
  bool operator ==(Object other) =>
      other is AppSortState &&
      other.columnId == columnId &&
      other.ascending == ascending;

  @override
  int get hashCode => Object.hash(columnId, ascending);
}

/// Tabel data padat.
///
/// [DataTable] bawaan Material tidak dipakai karena dua alasan yang keduanya
/// menggugurkan: ia membangun **seluruh** baris sekaligus, sehingga 50 baris ×
/// 8 kolom berarti 400 widget yang dibangun walau hanya 20 baris yang terlihat;
/// dan tinggi barisnya diatur oleh `DataTableTheme` Material, bukan oleh
/// kerapatan design system ini.
///
/// Di sini isi tabel digulir lewat [ListView.builder] dengan tinggi baris tetap
/// `density.rowHeight`, jadi target 25–50 baris terlihat sekaligus pada mode
/// compact (16.3) tercapai tanpa membangun apa pun yang berada di luar layar.
///
/// **Pengurutan dikendalikan dari luar.** Tabel tidak pernah mengurutkan
/// [rows] sendiri; ia hanya melaporkan lewat [onSortChanged]. Yang memegang
/// kebenaran urutan adalah bloc, karena pada halaman berhalaman-halaman
/// pengurutan harus terjadi di kueri, bukan di sepotong data yang kebetulan
/// sedang tampil.
///
/// Pada layar `compact` tabel berubah menjadi daftar kartu yang disusun dari
/// [ColumnPriority]. Lihat [AppColumn] untuk aturannya.
class AppDataTable<T> extends StatefulWidget {
  final List<T> rows;
  final List<AppColumn<T>> columns;

  /// Pengenal stabil sebuah baris. Dipakai untuk seleksi dan kunci widget.
  final Object Function(T row) rowId;

  final AppSortState? sort;
  final ValueChanged<AppSortState>? onSortChanged;

  /// Bila diisi, kolom kotak centang muncul di paling kiri.
  final Set<Object>? selectedIds;
  final ValueChanged<Set<Object>>? onSelectionChanged;

  final ValueChanged<T>? onRowTap;

  final bool isLoading;

  /// Pesan galat. Bila diisi, menggantikan seluruh isi tabel.
  final String? error;
  final VoidCallback? onRetry;

  final String emptyMessage;
  final String? emptyTitle;
  final Widget? emptyAction;

  /// Bilah di bawah tabel, di dalam bingkai yang sama. Tempat [AppPagination].
  final Widget? footer;

  /// Bilah di atas header kolom: pencarian, filter, tombol aksi.
  final Widget? toolbar;

  /// Mewarnai baris ganjil dengan permukaan yang diredam.
  final bool zebra;

  /// Lebar minimum sebelum tabel digulir mendatar.
  ///
  /// Untuk tabel berkolom banyak pada jendela `medium`: lebih baik digulir
  /// daripada memampatkan delapan kolom sampai semuanya terpotong elipsis.
  final double? minWidth;

  const AppDataTable({
    super.key,
    required this.rows,
    required this.columns,
    required this.rowId,
    this.sort,
    this.onSortChanged,
    this.selectedIds,
    this.onSelectionChanged,
    this.onRowTap,
    this.isLoading = false,
    this.error,
    this.onRetry,
    this.emptyMessage = 'Belum ada data untuk ditampilkan.',
    this.emptyTitle,
    this.emptyAction,
    this.footer,
    this.toolbar,
    this.zebra = true,
    this.minWidth,
  });

  @override
  State<AppDataTable<T>> createState() => _AppDataTableState<T>();
}

class _AppDataTableState<T> extends State<AppDataTable<T>> {
  final _scrollController = ScrollController();

  /// Baris yang sedang disorot papan ketik. `-1` berarti belum ada.
  int _focusedRow = -1;

  bool get _selectable =>
      widget.selectedIds != null && widget.onSelectionChanged != null;

  /// Lebar kolom kotak centang. Tetap, karena isinya juga tetap.
  static const double _selectionColumnWidth = 40;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _moveFocus(int delta) {
    if (widget.rows.isEmpty) return;
    final next = (_focusedRow + delta).clamp(0, widget.rows.length - 1);
    if (next == _focusedRow) return;

    setState(() => _focusedRow = next);

    // Menggulir agar baris yang disorot tetap terlihat. Tanpa ini, menahan
    // panah bawah menggeser sorotan ke luar layar tanpa jejak.
    final density = context.space;
    final offset = next * density.rowHeight;
    final viewport = _scrollController.position.viewportDimension;
    final current = _scrollController.offset;

    if (offset < current) {
      _scrollController.jumpTo(offset);
    } else if (offset + density.rowHeight > current + viewport) {
      _scrollController.jumpTo(offset + density.rowHeight - viewport);
    }
  }

  void _toggleRowSelection(Object id) {
    final next = {...widget.selectedIds!};
    next.contains(id) ? next.remove(id) : next.add(id);
    widget.onSelectionChanged!(next);
  }

  void _toggleAll(bool selectAll) {
    widget.onSelectionChanged!(
      selectAll ? widget.rows.map(widget.rowId).toSet() : <Object>{},
    );
  }

  /// `null` bila hanya sebagian baris terpilih.
  bool? get _headerCheckboxValue {
    if (widget.rows.isEmpty) return false;
    final selected = widget.selectedIds!;
    final ids = widget.rows.map(widget.rowId);
    final count = ids.where(selected.contains).length;
    if (count == 0) return false;
    if (count == widget.rows.length) return true;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isCompact = context.windowSize == WindowSize.compact;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: AppRadius.rMd,
        border: Border.all(color: colors.borderDefault),
      ),
      child: ClipRRect(
        borderRadius: AppRadius.rMd,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.toolbar != null) ...[
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.space.md,
                  vertical: context.space.sm,
                ),
                child: widget.toolbar,
              ),
              AppDivider(color: colors.borderSubtle),
            ],
            Flexible(child: _buildBody(context, isCompact)),
            if (widget.footer != null) ...[
              AppDivider(color: colors.borderSubtle),
              widget.footer!,
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, bool isCompact) {
    if (widget.error != null) {
      return Padding(
        padding: EdgeInsets.all(context.space.xl),
        child: AppErrorView(
          message: widget.error!,
          onRetry: widget.onRetry,
        ),
      );
    }

    if (widget.isLoading) return _SkeletonRows(isCompact: isCompact);

    if (widget.rows.isEmpty) {
      return Padding(
        padding: EdgeInsets.all(context.space.xl),
        child: AppEmptyState(
          title: widget.emptyTitle,
          message: widget.emptyMessage,
          action: widget.emptyAction,
        ),
      );
    }

    return isCompact ? _buildCards(context) : _buildTable(context);
  }

  // --- Jalur lebar: tabel sungguhan -----------------------------------------

  Widget _buildTable(BuildContext context) {
    final table = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHeader(context),
        AppDivider(color: context.colors.borderDefault),
        Flexible(child: _buildRows(context)),
      ],
    );

    if (widget.minWidth == null) return table;

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= widget.minWidth!) return table;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(width: widget.minWidth, child: table),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    final colors = context.colors;
    final density = context.space;

    return Container(
      height: density.rowHeight,
      color: colors.surfaceSubtle,
      padding: EdgeInsets.symmetric(horizontal: density.md),
      child: Row(
        children: [
          if (_selectable)
            SizedBox(
              width: _selectionColumnWidth,
              child: AppCheckbox(
                value: _headerCheckboxValue,
                tristate: true,
                onChanged: _toggleAll,
              ),
            ),
          for (final column in widget.columns)
            _wrapWidth(
              column,
              _HeaderCell<T>(
                column: column,
                sort: widget.sort,
                onSortChanged: widget.onSortChanged,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildRows(BuildContext context) {
    final density = context.space;

    return FocusableActionDetector(
      shortcuts: const {
        SingleActivator(LogicalKeyboardKey.arrowDown): _MoveRowIntent(1),
        SingleActivator(LogicalKeyboardKey.arrowUp): _MoveRowIntent(-1),
      },
      actions: {
        _MoveRowIntent: CallbackAction<_MoveRowIntent>(
          onInvoke: (intent) {
            _moveFocus(intent.delta);
            return null;
          },
        ),
        ActivateIntent: CallbackAction<ActivateIntent>(
          onInvoke: (_) {
            if (_focusedRow >= 0 && _focusedRow < widget.rows.length) {
              widget.onRowTap?.call(widget.rows[_focusedRow]);
            }
            return null;
          },
        ),
      },
      child: ListView.builder(
        controller: _scrollController,
        itemExtent: density.rowHeight,
        itemCount: widget.rows.length,
        itemBuilder: (context, index) {
          final row = widget.rows[index];
          final id = widget.rowId(row);

          return _TableRow<T>(
            key: ValueKey(id),
            row: row,
            columns: widget.columns,
            isEven: index.isEven,
            zebra: widget.zebra,
            isSelected: widget.selectedIds?.contains(id) ?? false,
            isFocused: index == _focusedRow,
            selectable: _selectable,
            onSelectionToggled:
                _selectable ? () => _toggleRowSelection(id) : null,
            onTap: widget.onRowTap == null
                ? null
                : () {
                    setState(() => _focusedRow = index);
                    widget.onRowTap!(row);
                  },
            selectionColumnWidth: _selectionColumnWidth,
          );
        },
      ),
    );
  }

  // --- Jalur sempit: daftar kartu -------------------------------------------

  Widget _buildCards(BuildContext context) {
    final density = context.space;

    final primary = widget.columns
        .where((c) => c.priority == ColumnPriority.primary)
        .firstOrNull;
    final secondary = widget.columns
        .where((c) => c.priority == ColumnPriority.secondary)
        .toList();

    return ListView.separated(
      controller: _scrollController,
      itemCount: widget.rows.length,
      separatorBuilder: (context, _) =>
          AppDivider(color: context.colors.borderSubtle),
      itemBuilder: (context, index) {
        final row = widget.rows[index];
        final id = widget.rowId(row);

        return _RowCard<T>(
          key: ValueKey(id),
          row: row,
          primary: primary,
          secondary: secondary,
          isSelected: widget.selectedIds?.contains(id) ?? false,
          onSelectionToggled:
              _selectable ? () => _toggleRowSelection(id) : null,
          selectable: _selectable,
          onTap:
              widget.onRowTap == null ? null : () => widget.onRowTap!(row),
          minHeight: density.rowHeight,
        );
      },
    );
  }

  Widget _wrapWidth(AppColumn<T> column, Widget child) {
    return column.width == null
        ? Expanded(flex: column.flex, child: child)
        : SizedBox(width: column.width, child: child);
  }
}

/// Sel header, sekaligus tombol pengurut bila kolomnya [AppColumn.sortable].
class _HeaderCell<T> extends StatelessWidget {
  final AppColumn<T> column;
  final AppSortState? sort;
  final ValueChanged<AppSortState>? onSortChanged;

  const _HeaderCell({
    required this.column,
    required this.sort,
    required this.onSortChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final density = context.space;
    final isSorted = sort?.columnId == column.id;
    final canSort = column.sortable && onSortChanged != null;

    final label = Text(
      column.label,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: column.textAlign,
      style: context.text.tableHeader.copyWith(
        color: isSorted ? colors.textPrimary : colors.textSecondary,
      ),
    );

    final content = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: switch (column.effectiveAlign) {
        ColumnAlign.start => MainAxisAlignment.start,
        ColumnAlign.center => MainAxisAlignment.center,
        ColumnAlign.end => MainAxisAlignment.end,
      },
      children: [
        Flexible(child: label),
        if (isSorted) ...[
          SizedBox(width: density.xs),
          Icon(
            sort!.ascending ? AppIcons.collapse : AppIcons.expand,
            size: 14,
            color: colors.accent,
          ),
        ],
      ],
    );

    final padded = Padding(
      padding: EdgeInsets.symmetric(horizontal: density.sm),
      child: Align(alignment: column.alignment, child: content),
    );

    if (!canSort) return padded;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onSortChanged!(
          // Menekan kolom yang sudah aktif membalik arah; kolom lain selalu
          // mulai menaik, karena itu yang diharapkan saat berpindah kolom.
          isSorted ? sort!.toggled : AppSortState(column.id),
        ),
        hoverColor: colors.surfaceHover,
        child: padded,
      ),
    );
  }
}

/// Satu baris pada jalur tabel.
class _TableRow<T> extends StatefulWidget {
  final T row;
  final List<AppColumn<T>> columns;
  final bool isEven;
  final bool zebra;
  final bool isSelected;
  final bool isFocused;
  final bool selectable;
  final VoidCallback? onSelectionToggled;
  final VoidCallback? onTap;
  final double selectionColumnWidth;

  const _TableRow({
    super.key,
    required this.row,
    required this.columns,
    required this.isEven,
    required this.zebra,
    required this.isSelected,
    required this.isFocused,
    required this.selectable,
    required this.onSelectionToggled,
    required this.onTap,
    required this.selectionColumnWidth,
  });

  @override
  State<_TableRow<T>> createState() => _TableRowState<T>();
}

class _TableRowState<T> extends State<_TableRow<T>> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final density = context.space;

    // Urutan penting: terpilih mengalahkan sorotan kursor, dan keduanya
    // mengalahkan zebra. Kalau tidak, baris terpilih berubah warna hanya
    // karena kursor lewat di atasnya.
    final Color background;
    if (widget.isSelected) {
      background = colors.accentSubtle;
    } else if (_hovered) {
      background = colors.surfaceHover;
    } else if (widget.zebra && !widget.isEven) {
      background = colors.surfaceSubtle;
    } else {
      background = colors.surface;
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: widget.onTap == null
          ? SystemMouseCursors.basic
          : SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          decoration: BoxDecoration(
            color: background,
            border: widget.isFocused
                ? Border.all(color: colors.borderFocus, width: 1.5)
                : Border(
                    bottom: BorderSide(color: colors.borderSubtle),
                  ),
          ),
          padding: EdgeInsets.symmetric(horizontal: density.md),
          child: Row(
            children: [
              if (widget.selectable)
                SizedBox(
                  width: widget.selectionColumnWidth,
                  child: AppCheckbox(
                    value: widget.isSelected,
                    onChanged: widget.onSelectionToggled == null
                        ? null
                        : (_) => widget.onSelectionToggled!(),
                  ),
                ),
              for (final column in widget.columns)
                _cell(column, context, density),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cell(AppColumn<T> column, BuildContext context, AppDensity density) {
    final content = Padding(
      padding: EdgeInsets.symmetric(horizontal: density.sm),
      child: Align(
        alignment: column.alignment,
        child: column.cell(context, widget.row),
      ),
    );

    return column.width == null
        ? Expanded(flex: column.flex, child: content)
        : SizedBox(width: column.width, child: content);
  }
}

/// Satu baris pada jalur kartu (layar sempit).
class _RowCard<T> extends StatelessWidget {
  final T row;
  final AppColumn<T>? primary;
  final List<AppColumn<T>> secondary;
  final bool isSelected;
  final bool selectable;
  final VoidCallback? onSelectionToggled;
  final VoidCallback? onTap;
  final double minHeight;

  const _RowCard({
    super.key,
    required this.row,
    required this.primary,
    required this.secondary,
    required this.isSelected,
    required this.selectable,
    required this.onSelectionToggled,
    required this.onTap,
    required this.minHeight,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final density = context.space;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        color: isSelected ? colors.accentSubtle : colors.surface,
        constraints: BoxConstraints(minHeight: minHeight),
        padding: EdgeInsets.symmetric(
          horizontal: density.md,
          vertical: density.sm,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (selectable) ...[
              AppCheckbox(
                value: isSelected,
                onChanged: onSelectionToggled == null
                    ? null
                    : (_) => onSelectionToggled!(),
              ),
              SizedBox(width: density.sm),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (primary != null)
                    DefaultTextStyle.merge(
                      style: context.text.tableCellEmphasis,
                      child: primary!.cell(context, row),
                    ),
                  for (final column in secondary) ...[
                    SizedBox(height: density.xs),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            column.label,
                            style: context.text.formHelper
                                .copyWith(color: colors.textTertiary),
                          ),
                        ),
                        SizedBox(width: density.sm),
                        column.cell(context, row),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            if (onTap != null) ...[
              SizedBox(width: density.sm),
              Icon(AppIcons.forward, size: 16, color: colors.textTertiary),
            ],
          ],
        ),
      ),
    );
  }
}

/// Baris rangka saat data sedang dimuat.
///
/// Jumlahnya dihitung dari tinggi yang tersedia, bukan angka tetap: rangka yang
/// hanya mengisi sepertiga layar terbaca sebagai "datanya memang sedikit",
/// bukan "sedang dimuat".
class _SkeletonRows extends StatelessWidget {
  final bool isCompact;

  const _SkeletonRows({required this.isCompact});

  @override
  Widget build(BuildContext context) {
    final density = context.space;

    return LayoutBuilder(
      builder: (context, constraints) {
        final available = constraints.maxHeight.isFinite
            ? constraints.maxHeight
            : density.rowHeight * 8;
        final count = (available / density.rowHeight).floor().clamp(3, 40);

        return ListView.builder(
          padding: EdgeInsets.symmetric(vertical: density.xs),
          itemExtent: density.rowHeight,
          itemCount: count,
          itemBuilder: (context, index) => Padding(
            padding: EdgeInsets.symmetric(
              horizontal: density.md,
              vertical: density.xs,
            ),
            child: Row(
              children: [
                Expanded(flex: 3, child: AppSkeleton(height: density.xs * 3)),
                SizedBox(width: density.lg),
                Expanded(child: AppSkeleton(height: density.xs * 3)),
                if (!isCompact) ...[
                  SizedBox(width: density.lg),
                  Expanded(child: AppSkeleton(height: density.xs * 3)),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _MoveRowIntent extends Intent {
  final int delta;
  const _MoveRowIntent(this.delta);
}
