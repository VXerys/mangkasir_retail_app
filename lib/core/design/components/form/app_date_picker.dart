import 'package:flutter/material.dart';

import '../../../utils/date_formatter.dart';
import '../../design.dart';

/// Isian tanggal. Tidak bisa diketik; hanya dipilih dari kalender.
///
/// Mengetik tanggal bebas berarti harus menerima "23/7/26", "23-07-2026", dan
/// "2026-07-23" sekaligus — lalu menebak mana yang bulan dan mana yang hari.
/// Untuk laporan dan tanggal jatuh tempo, salah tebak sekali saja sudah cukup
/// merugikan, jadi masukannya dibatasi pada kalender.
class AppDateField extends StatelessWidget {
  final DateTime? value;

  /// `null` menonaktifkan kontrol.
  final ValueChanged<DateTime>? onChanged;

  final String? label;
  final String hint;
  final String? helperText;
  final String? errorText;

  final DateTime? firstDate;
  final DateTime? lastDate;

  /// Menampilkan tombol silang untuk mengosongkan pilihan.
  final VoidCallback? onCleared;

  const AppDateField({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.hint = 'Pilih tanggal',
    this.helperText,
    this.errorText,
    this.firstDate,
    this.lastDate,
    this.onCleared,
  });

  Future<void> _pick(BuildContext context) async {
    final now = DateTime.now();
    final first = firstDate ?? DateTime(now.year - 5);
    final last = lastDate ?? DateTime(now.year + 5, 12, 31);

    // Nilai awal harus berada di dalam rentang, kalau tidak CalendarDatePicker
    // melempar assertion.
    var initial = value ?? now;
    if (initial.isBefore(first)) initial = first;
    if (initial.isAfter(last)) initial = last;

    final picked = await showAppDialog<DateTime>(
      context: context,
      builder: (dialogContext) => AppDialog(
        title: label ?? 'Pilih tanggal',
        maxWidth: 360,
        content: _Calendar(
          initialDate: initial,
          firstDate: first,
          lastDate: last,
          onSelected: (date) => Navigator.of(dialogContext).pop(date),
        ),
      ),
    );

    if (picked != null) onChanged?.call(picked);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final density = context.space;
    final typography = context.text;
    final enabled = onChanged != null;

    final field = GestureDetector(
      onTap: enabled ? () => _pick(context) : null,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: density.controlHeight,
        padding: EdgeInsets.symmetric(horizontal: density.md),
        decoration: BoxDecoration(
          color: enabled ? colors.surface : colors.surfaceSubtle,
          borderRadius: AppRadius.rSm,
          border: Border.all(
            color: errorText != null
                ? colors.danger.border
                : colors.borderDefault,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 14,
              color: enabled ? colors.textTertiary : colors.textDisabled,
            ),
            SizedBox(width: density.sm),
            Expanded(
              child: Text(
                value == null ? hint : DateFormatter.date(value!),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: typography.formInput.copyWith(
                  color: !enabled
                      ? colors.textDisabled
                      : value == null
                          ? colors.textTertiary
                          : colors.textPrimary,
                ),
              ),
            ),
            if (value != null && onCleared != null && enabled)
              AppIconButton(
                icon: AppIcons.close,
                tooltip: 'Kosongkan',
                size: AppButtonSize.small,
                onPressed: onCleared,
              ),
          ],
        ),
      ),
    );

    final message = errorText ?? helperText;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: typography.formLabel.copyWith(color: colors.textSecondary),
          ),
          SizedBox(height: density.xs),
        ],
        field,
        if (message != null) ...[
          SizedBox(height: density.xs),
          Text(
            message,
            style: typography.formHelper.copyWith(
              color: errorText != null ? colors.danger.fg : colors.textTertiary,
            ),
          ),
        ],
      ],
    );
  }
}

/// Sepasang [AppDateField] untuk rentang tanggal laporan.
///
/// Sengaja bukan `showDateRangePicker` bawaan Material: pemilih rentang itu
/// membuka layar penuh dengan bilah aplikasi sendiri, yang pada desktop terasa
/// seperti aplikasi lain menumpang lewat. Dua isian berdampingan juga lebih
/// jujur — pengguna melihat kedua batas sekaligus tanpa membuka apa pun.
class AppDateRangeField extends StatelessWidget {
  final DateTime? start;
  final DateTime? end;

  final ValueChanged<DateTime>? onStartChanged;
  final ValueChanged<DateTime>? onEndChanged;

  final String? label;
  final String? errorText;

  const AppDateRangeField({
    super.key,
    required this.start,
    required this.end,
    required this.onStartChanged,
    required this.onEndChanged,
    this.label,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final density = context.space;
    final isCompact = context.windowSize == WindowSize.compact;

    final from = AppDateField(
      value: start,
      onChanged: onStartChanged,
      label: 'Dari',
      // Batas awal tidak boleh melewati batas akhir yang sudah dipilih.
      lastDate: end,
    );

    final to = AppDateField(
      value: end,
      onChanged: onEndChanged,
      label: 'Sampai',
      firstDate: start,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: context.text.formLabel
                .copyWith(color: context.colors.textSecondary),
          ),
          SizedBox(height: density.xs),
        ],
        if (isCompact)
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [from, SizedBox(height: density.sm), to],
          )
        else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: from),
              SizedBox(width: density.sm),
              Expanded(child: to),
            ],
          ),
        if (errorText != null) ...[
          SizedBox(height: density.xs),
          Text(
            errorText!,
            style: context.text.formHelper
                .copyWith(color: context.colors.danger.fg),
          ),
        ],
      ],
    );
  }
}

/// Kisi kalender di dalam dialog.
///
/// Memakai [CalendarDatePicker] bawaan Material, satu-satunya widget Material
/// yang sengaja dipertahankan di design system ini. Alasannya: yang dibawanya
/// adalah **perilaku** — aturan kabisat, awal minggu per locale, jangkauan
/// papan ketik, pembacaan oleh pembaca layar — bukan bahasa visual. Sisi
/// visualnya seluruhnya ditimpa lewat [DatePickerThemeData] di bawah, sehingga
/// tidak ada warna Material yang lolos ke layar.
class _Calendar extends StatelessWidget {
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final ValueChanged<DateTime> onSelected;

  const _Calendar({
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.text;

    return Theme(
      data: Theme.of(context).copyWith(
        datePickerTheme: DatePickerThemeData(
          backgroundColor: colors.surfaceRaised,
          headerBackgroundColor: colors.surfaceRaised,
          headerForegroundColor: colors.textPrimary,
          weekdayStyle: typography.tableHeader
              .copyWith(color: colors.textSecondary),
          dayStyle: typography.tableCell,
          dayForegroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) return colors.textDisabled;
            if (states.contains(WidgetState.selected)) return colors.textOnAccent;
            return colors.textPrimary;
          }),
          dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) return colors.accent;
            if (states.contains(WidgetState.hovered)) return colors.surfaceHover;
            return Colors.transparent;
          }),
          todayForegroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) return colors.textOnAccent;
            return colors.accent;
          }),
          todayBackgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) return colors.accent;
            return Colors.transparent;
          }),
          todayBorder: BorderSide(color: colors.accent),
          yearStyle: typography.formInput,
          yearForegroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) return colors.textOnAccent;
            return colors.textPrimary;
          }),
          yearBackgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) return colors.accent;
            return Colors.transparent;
          }),
        ),
      ),
      // [CalendarDatePicker] menuntut leluhur [Material] untuk menggambar riak
      // sentuhannya. `AppDialog` sengaja tidak menyediakannya — panelnya
      // digambar dengan garis, bukan lembar Material. Jadi lembar itu
      // disediakan di sini, transparan, hanya seluas kalender.
      child: Material(
        color: Colors.transparent,
        child: SizedBox(
          height: 320,
          child: CalendarDatePicker(
            initialDate: initialDate,
            firstDate: firstDate,
            lastDate: lastDate,
            onDateChanged: onSelected,
          ),
        ),
      ),
    );
  }
}
