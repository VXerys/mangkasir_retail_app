import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../design.dart';

/// Satu pilihan di dalam [AppSelect].
@immutable
class AppSelectOption<T> {
  final T value;
  final String label;

  /// Keterangan di bawah label — misalnya SKU di bawah nama produk.
  final String? description;

  final IconData? icon;
  final bool enabled;

  const AppSelectOption({
    required this.value,
    required this.label,
    this.description,
    this.icon,
    this.enabled = true,
  });
}

/// Daftar pilihan yang membuka popover.
///
/// [DropdownButton] Material tidak dipakai: ia membuka menu **di tengah layar**
/// menutupi isian aslinya, tidak mendukung pencarian, dan mewarnai dirinya dari
/// `ColorScheme`. Pada layar POS yang padat, menu yang melompat ke tengah
/// membuat pengguna kehilangan tempatnya.
///
/// Popover di sini menempel pada isian lewat [CompositedTransformFollower],
/// membalik ke atas bila ruang di bawah tidak cukup, dan bisa dijelajahi dengan
/// panah atas/bawah lalu Enter — POS ini harus bisa dioperasikan tanpa mouse.
///
/// Nyalakan [searchable] untuk daftar panjang seperti produk dan pelanggan.
class AppSelect<T> extends StatefulWidget {
  final T? value;
  final List<AppSelectOption<T>> options;

  /// `null` menonaktifkan kontrol.
  final ValueChanged<T>? onChanged;

  final String? label;

  /// Teks saat belum ada yang dipilih.
  final String hint;

  final String? helperText;

  /// Menggantikan [helperText] dan mewarnai garis tepi menjadi merah.
  final String? errorText;

  /// Menambahkan kotak pencarian di kepala popover.
  final bool searchable;

  /// Ikon di sebelah kiri isian.
  final IconData? prefixIcon;

  const AppSelect({
    super.key,
    required this.value,
    required this.options,
    required this.onChanged,
    this.label,
    this.hint = 'Pilih…',
    this.helperText,
    this.errorText,
    this.searchable = false,
    this.prefixIcon,
  });

  @override
  State<AppSelect<T>> createState() => _AppSelectState<T>();
}

class _AppSelectState<T> extends State<AppSelect<T>> {
  final _portal = OverlayPortalController();
  final _link = LayerLink();
  final _fieldKey = GlobalKey();
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();

  /// Baris yang sedang disorot papan ketik. `-1` berarti belum ada.
  int _highlighted = -1;

  double _fieldWidth = 0;
  bool _openUpward = false;
  bool _focused = false;
  String _query = '';

  bool get _enabled => widget.onChanged != null;

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  List<AppSelectOption<T>> get _visibleOptions {
    if (_query.isEmpty) return widget.options;
    final needle = _query.toLowerCase();
    return widget.options
        .where((option) =>
            option.label.toLowerCase().contains(needle) ||
            (option.description?.toLowerCase().contains(needle) ?? false))
        .toList();
  }

  void _open() {
    if (!_enabled) return;

    final box = _fieldKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return;

    final origin = box.localToGlobal(Offset.zero);
    final screenHeight = MediaQuery.sizeOf(context).height;
    final spaceBelow = screenHeight - (origin.dy + box.size.height);

    setState(() {
      _fieldWidth = box.size.width;
      // Membalik ke atas hanya bila ruang di bawah benar-benar sempit dan ruang
      // di atas lebih lega — bukan setiap kali kurang dari tinggi maksimum,
      // karena popover pendek tetap muat di sisa ruang yang kecil.
      _openUpward = spaceBelow < 200 && origin.dy > spaceBelow;
      _query = '';
      _searchController.clear();
      _highlighted = widget.options.indexWhere((o) => o.value == widget.value);
    });

    _portal.show();
  }

  void _close() {
    _portal.hide();
    setState(() => _highlighted = -1);
  }

  void _select(AppSelectOption<T> option) {
    if (!option.enabled) return;
    widget.onChanged?.call(option.value);
    _close();
  }

  void _moveHighlight(int delta) {
    final options = _visibleOptions;
    if (options.isEmpty) return;

    var next = _highlighted;
    // Melewati pilihan yang dinonaktifkan, dan berhenti bila semuanya mati.
    for (var step = 0; step < options.length; step++) {
      next = (next + delta) % options.length;
      if (next < 0) next += options.length;
      if (options[next].enabled) break;
    }

    setState(() => _highlighted = next);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final density = context.space;
    final typography = context.text;

    final selected = widget.options
        .where((option) => option.value == widget.value)
        .firstOrNull;

    final borderColor = switch ((
      _enabled,
      widget.errorText != null,
      _focused || _portal.isShowing
    )) {
      (false, _, _) => colors.borderSubtle,
      (_, true, _) => colors.danger.border,
      (_, _, true) => colors.borderFocus,
      _ => colors.borderDefault,
    };

    final field = Container(
      key: _fieldKey,
      height: density.controlHeight,
      padding: EdgeInsets.symmetric(horizontal: density.md),
      decoration: BoxDecoration(
        color: _enabled ? colors.surface : colors.surfaceSubtle,
        borderRadius: AppRadius.rSm,
        border: Border.all(
          color: borderColor,
          width: (_focused || _portal.isShowing) ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          if (widget.prefixIcon != null) ...[
            Icon(widget.prefixIcon, size: 16, color: colors.textTertiary),
            SizedBox(width: density.sm),
          ],
          Expanded(
            child: Text(
              selected?.label ?? widget.hint,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: typography.formInput.copyWith(
                color: !_enabled
                    ? colors.textDisabled
                    : selected == null
                        ? colors.textTertiary
                        : colors.textPrimary,
              ),
            ),
          ),
          SizedBox(width: density.xs),
          Icon(
            _portal.isShowing ? AppIcons.collapse : AppIcons.expand,
            size: 16,
            color: _enabled ? colors.textSecondary : colors.textDisabled,
          ),
        ],
      ),
    );

    final interactive = FocusableActionDetector(
      enabled: _enabled,
      mouseCursor:
          _enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onShowFocusHighlight: (value) => setState(() => _focused = value),
      shortcuts: const {
        SingleActivator(LogicalKeyboardKey.arrowDown): _OpenOrMoveIntent(1),
        SingleActivator(LogicalKeyboardKey.arrowUp): _OpenOrMoveIntent(-1),
        SingleActivator(LogicalKeyboardKey.escape): _CloseIntent(),
      },
      actions: {
        ActivateIntent: CallbackAction<ActivateIntent>(
          onInvoke: (_) {
            _portal.isShowing ? _commitHighlight() : _open();
            return null;
          },
        ),
        _OpenOrMoveIntent: CallbackAction<_OpenOrMoveIntent>(
          onInvoke: (intent) {
            _portal.isShowing ? _moveHighlight(intent.delta) : _open();
            return null;
          },
        ),
        _CloseIntent: CallbackAction<_CloseIntent>(
          onInvoke: (_) {
            if (_portal.isShowing) _close();
            return null;
          },
        ),
      },
      child: GestureDetector(
        onTap: () => _portal.isShowing ? _close() : _open(),
        behavior: HitTestBehavior.opaque,
        child: field,
      ),
    );

    final control = CompositedTransformTarget(
      link: _link,
      child: OverlayPortal(
        controller: _portal,
        overlayChildBuilder: _buildPopover,
        child: interactive,
      ),
    );

    final message = widget.errorText ?? widget.helperText;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: typography.formLabel.copyWith(color: colors.textSecondary),
          ),
          SizedBox(height: density.xs),
        ],
        control,
        if (message != null) ...[
          SizedBox(height: density.xs),
          Text(
            message,
            style: typography.formHelper.copyWith(
              color: widget.errorText != null
                  ? colors.danger.fg
                  : colors.textTertiary,
            ),
          ),
        ],
      ],
    );
  }

  void _commitHighlight() {
    final options = _visibleOptions;
    if (_highlighted >= 0 && _highlighted < options.length) {
      _select(options[_highlighted]);
    }
  }

  Widget _buildPopover(BuildContext context) {
    final colors = context.colors;
    final density = context.space;
    final options = _visibleOptions;

    final list = ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 280),
      child: options.isEmpty
          ? Padding(
              padding: EdgeInsets.all(density.md),
              child: Text(
                'Tidak ada yang cocok',
                style: context.text.formHelper
                    .copyWith(color: colors.textTertiary),
              ),
            )
          : ListView.builder(
              controller: _scrollController,
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(vertical: density.xs),
              itemCount: options.length,
              itemBuilder: (context, index) => _OptionTile<T>(
                option: options[index],
                isSelected: options[index].value == widget.value,
                isHighlighted: index == _highlighted,
                onTap: () => _select(options[index]),
              ),
            ),
    );

    final popover = Material(
      color: Colors.transparent,
      child: Container(
        width: _fieldWidth,
        decoration: BoxDecoration(
          color: colors.surfaceRaised,
          borderRadius: AppRadius.rMd,
          border: Border.all(color: colors.borderDefault),
          boxShadow: context.elevation.popover,
        ),
        child: ClipRRect(
          borderRadius: AppRadius.rMd,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.searchable) ...[
                Padding(
                  padding: EdgeInsets.all(density.sm),
                  child: AppTextField(
                    controller: _searchController,
                    hint: 'Cari…',
                    autofocus: true,
                    prefixIcon: AppIcons.search,
                    onChanged: (value) => setState(() {
                      _query = value;
                      _highlighted = value.isEmpty ? -1 : 0;
                    }),
                  ),
                ),
                AppDivider(color: colors.borderSubtle),
              ],
              Flexible(child: list),
            ],
          ),
        ),
      ),
    );

    return Stack(
      children: [
        // Menangkap ketukan di luar popover. Tanpa ini popover hanya bisa
        // ditutup lewat ESC atau dengan memilih sesuatu.
        Positioned.fill(
          child: GestureDetector(
            onTap: _close,
            behavior: HitTestBehavior.opaque,
          ),
        ),
        CompositedTransformFollower(
          link: _link,
          showWhenUnlinked: false,
          targetAnchor:
              _openUpward ? Alignment.topLeft : Alignment.bottomLeft,
          followerAnchor:
              _openUpward ? Alignment.bottomLeft : Alignment.topLeft,
          offset: Offset(0, _openUpward ? -density.xs : density.xs),
          child: Align(
            alignment:
                _openUpward ? Alignment.bottomLeft : Alignment.topLeft,
            child: CallbackShortcuts(
              bindings: {
                const SingleActivator(LogicalKeyboardKey.escape): _close,
                const SingleActivator(LogicalKeyboardKey.arrowDown): () =>
                    _moveHighlight(1),
                const SingleActivator(LogicalKeyboardKey.arrowUp): () =>
                    _moveHighlight(-1),
                const SingleActivator(LogicalKeyboardKey.enter):
                    _commitHighlight,
              },
              child: popover,
            ),
          ),
        ),
      ],
    );
  }
}

class _OptionTile<T> extends StatefulWidget {
  final AppSelectOption<T> option;
  final bool isSelected;
  final bool isHighlighted;
  final VoidCallback onTap;

  const _OptionTile({
    required this.option,
    required this.isSelected,
    required this.isHighlighted,
    required this.onTap,
  });

  @override
  State<_OptionTile<T>> createState() => _OptionTileState<T>();
}

class _OptionTileState<T> extends State<_OptionTile<T>> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final density = context.space;
    final option = widget.option;

    final background = switch ((
      option.enabled,
      widget.isSelected,
      widget.isHighlighted || _hovered
    )) {
      (false, _, _) => Colors.transparent,
      (_, true, _) => colors.accentSubtle,
      (_, _, true) => colors.surfaceHover,
      _ => Colors.transparent,
    };

    final foreground = option.enabled
        ? (widget.isSelected ? colors.accent : colors.textPrimary)
        : colors.textDisabled;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: option.enabled
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: option.enabled ? widget.onTap : null,
        behavior: HitTestBehavior.opaque,
        child: Container(
          color: background,
          constraints: BoxConstraints(minHeight: density.rowHeight),
          padding: EdgeInsets.symmetric(
            horizontal: density.md,
            vertical: density.xs,
          ),
          child: Row(
            children: [
              if (option.icon != null) ...[
                Icon(option.icon, size: 16, color: foreground),
                SizedBox(width: density.sm),
              ],
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      option.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.text.formInput.copyWith(
                        color: foreground,
                        fontWeight:
                            widget.isSelected ? FontWeight.w600 : null,
                      ),
                    ),
                    if (option.description != null)
                      Text(
                        option.description!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.text.formHelper
                            .copyWith(color: colors.textTertiary),
                      ),
                  ],
                ),
              ),
              if (widget.isSelected) ...[
                SizedBox(width: density.sm),
                Icon(AppIcons.check, size: 14, color: colors.accent),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Membuka popover bila tertutup, atau memindahkan sorotan bila sudah terbuka.
class _OpenOrMoveIntent extends Intent {
  final int delta;
  const _OpenOrMoveIntent(this.delta);
}

class _CloseIntent extends Intent {
  const _CloseIntent();
}
