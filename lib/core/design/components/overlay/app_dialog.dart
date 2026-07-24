import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../design.dart';

/// Jendela modal aplikasi.
///
/// Susunannya sengaja sama dengan [AppPanel] — kepala, isi, kaki, dipisah
/// [AppDivider] — supaya dialog terasa seperti panel yang diangkat, bukan
/// komponen dengan bahasa visual tersendiri. Bedanya hanya permukaan
/// ([AppSemanticColors.surfaceRaised]), radius yang sedikit lebih besar, dan
/// bayangan `elevation.dialog`.
///
/// [Dialog] bawaan Material tidak dipakai karena membawa `Card`, elevasi
/// Material, dan warna permukaan bertingkat yang semuanya bertentangan dengan
/// aturan "garis, bukan bayangan".
///
/// Buka lewat [showAppDialog], bukan `showDialog` — pembungkus itulah yang
/// mengatur tirai, transisi, dan perilaku lembar-bawah pada layar sempit.
class AppDialog extends StatelessWidget {
  final String title;

  /// Keterangan singkat di bawah judul. Untuk menjelaskan akibat sebuah aksi
  /// tanpa memanjangkan judulnya.
  final String? subtitle;

  final Widget content;

  /// Tombol aksi di kaki dialog, dirata-kanankan. Aksi utama diletakkan
  /// terakhir, mengikuti kebiasaan "aksi utama paling dekat ibu jari".
  final List<Widget> actions;

  /// Dipanggil saat Enter ditekan. Isi dengan aksi utama yang sama seperti
  /// tombol terakhir di [actions].
  ///
  /// Sengaja dipisah dari [actions] karena dialog tidak boleh menebak tombol
  /// mana yang aman dijalankan tanpa klik — dialog hapus tidak boleh terpicu
  /// hanya karena kursor kebetulan berada di sebuah isian saat Enter ditekan.
  final VoidCallback? onSubmit;

  /// Lebar maksimum pada layar `medium` ke atas.
  final double maxWidth;

  /// Menampilkan tombol silang di pojok kanan atas.
  final bool showCloseButton;

  const AppDialog({
    super.key,
    required this.title,
    required this.content,
    this.subtitle,
    this.actions = const [],
    this.onSubmit,
    this.maxWidth = 480,
    this.showCloseButton = true,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final density = context.space;
    final typography = context.text;
    final isCompact = context.windowSize == WindowSize.compact;

    // Pada layar sempit dialog menjadi lembar yang menempel di tepi bawah, jadi
    // dua sudut bawahnya diluruskan agar tidak menyisakan celah.
    final radius = isCompact
        ? const BorderRadius.vertical(top: Radius.circular(AppRadius.lg))
        : AppRadius.rLg;

    final header = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, style: typography.dialogTitle),
              if (subtitle != null) ...[
                SizedBox(height: density.xs),
                Text(
                  subtitle!,
                  style: typography.formHelper
                      .copyWith(color: colors.textSecondary),
                ),
              ],
            ],
          ),
        ),
        if (showCloseButton) ...[
          SizedBox(width: density.sm),
          AppIconButton(
            icon: AppIcons.close,
            tooltip: 'Tutup',
            size: AppButtonSize.small,
            onPressed: () => Navigator.of(context).maybePop(),
          ),
        ],
      ],
    );

    final panel = DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surfaceRaised,
        borderRadius: radius,
        border: Border.all(color: colors.borderDefault),
        boxShadow: context.elevation.dialog,
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: density.lg,
                vertical: density.md,
              ),
              child: header,
            ),
            AppDivider(color: colors.borderSubtle),
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(density.lg),
                child: content,
              ),
            ),
            if (actions.isNotEmpty) ...[
              AppDivider(color: colors.borderSubtle),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: density.lg,
                  vertical: density.md,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    for (final (index, action) in actions.indexed) ...[
                      if (index > 0) SizedBox(width: density.sm),
                      action,
                    ],
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );

    // Enter ditangani oleh sebuah [FocusScope] yang meminta fokus saat dialog
    // terbuka, bukan oleh [CallbackShortcuts] di dalam panel.
    //
    // Alasannya menyangkut arah rambat peristiwa papan ketik: fokus utama
    // berjalan naik ke leluhurnya, tidak turun. Rute modal memegang fokus pada
    // scope miliknya sendiri selama belum ada widget di dalam dialog yang
    // difokuskan — dan scope itu berada di *atas* isi dialog, sehingga penangan
    // apa pun yang dipasang di dalam panel tidak akan pernah kebagian tombol.
    //
    // Scope di bawah ini menutup kedua keadaan sekaligus: saat belum ada yang
    // difokuskan ia sendiri yang memegang fokus, dan begitu sebuah isian di
    // dalamnya difokuskan ia tetap dilewati sebagai leluhur.
    final shortcuts = FocusScope(
      autofocus: true,
      onKeyEvent: onSubmit == null
          ? null
          : (node, event) {
              if (event is KeyDownEvent &&
                  event.logicalKey == LogicalKeyboardKey.enter) {
                onSubmit!();
                return KeyEventResult.handled;
              }
              return KeyEventResult.ignored;
            },
      child: panel,
    );

    if (isCompact) {
      // Dialog di layar sempit menempel di tepi bawah — tepat di tempat papan
      // ketik layar muncul. Tanpa pengangkatan ini, isian di dalamnya tertutup
      // persis saat pengguna mulai mengetik.
      return AppKeyboardInset(
        child: SafeArea(top: false, child: shortcuts),
      );
    }

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: shortcuts,
    );
  }
}

/// Membuka [builder] sebagai modal.
///
/// Memakai [showGeneralDialog], bukan `showDialog`/`showModalBottomSheet`,
/// karena keduanya memaksakan warna tirai dan transisi Material. Di sini tirai
/// memakai token `colors.overlay` dan durasinya tunduk pada plafon 220 ms.
///
/// Pada layar `compact` dialog masuk sebagai lembar dari tepi bawah; pada layar
/// yang lebih lebar ia muncul di tengah dengan pudar dan skala halus.
Future<T?> showAppDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool barrierDismissible = true,
}) {
  final colors = context.colors;
  final isCompact = context.windowSize == WindowSize.compact;

  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    // Dibacakan pembaca layar saat tirai difokuskan. Wajib diisi bila
    // barrierDismissible bernilai true.
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: colors.overlay,
    transitionDuration: AppMotion.normal,
    pageBuilder: (dialogContext, _, _) {
      final child = Builder(builder: builder);
      return Align(
        alignment: isCompact ? Alignment.bottomCenter : Alignment.center,
        child: Padding(
          padding: EdgeInsets.all(isCompact ? 0 : DensityScope.of(dialogContext).xl),
          child: child,
        ),
      );
    },
    transitionBuilder: (context, animation, _, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: AppMotion.standard,
        reverseCurve: AppMotion.standard.flipped,
      );

      if (isCompact) {
        return FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position: Tween(
              begin: const Offset(0, 0.08),
              end: Offset.zero,
            ).animate(curved),
            child: child,
          ),
        );
      }

      return FadeTransition(
        opacity: curved,
        child: ScaleTransition(
          scale: Tween(begin: 0.98, end: 1.0).animate(curved),
          child: child,
        ),
      );
    },
  );
}

/// Dialog konfirmasi ya/tidak.
///
/// Mengembalikan `true` hanya bila pengguna menekan tombol penegas. Menutup
/// lewat ESC, tirai, atau tombol batal semuanya menghasilkan `false`, sehingga
/// pemanggil tidak perlu menangani `null`:
///
/// ```dart
/// if (await showAppConfirm(
///   context: context,
///   title: 'Kosongkan keranjang?',
///   message: '3 item akan dihapus dari tab ini.',
///   confirmLabel: 'Kosongkan',
///   isDestructive: true,
/// )) {
///   context.read<CartBloc>().add(const CartEvent.cleared());
/// }
/// ```
Future<bool> showAppConfirm({
  required BuildContext context,
  required String title,
  required String message,
  String confirmLabel = 'Lanjutkan',
  String cancelLabel = 'Batal',

  /// Mewarnai tombol penegas sebagai aksi merusak. Untuk Hapus, Batalkan
  /// Transaksi, dan Kosongkan Keranjang.
  bool isDestructive = false,
}) async {
  final result = await showAppDialog<bool>(
    context: context,
    builder: (dialogContext) {
      void confirm() => Navigator.of(dialogContext).pop(true);

      return AppDialog(
        title: title,
        maxWidth: 400,
        showCloseButton: false,
        onSubmit: confirm,
        content: Text(
          message,
          style: dialogContext.text.dialogBody
              .copyWith(color: dialogContext.colors.textSecondary),
        ),
        actions: [
          AppButton(
            label: cancelLabel,
            variant: AppButtonVariant.secondary,
            onPressed: () => Navigator.of(dialogContext).pop(false),
          ),
          AppButton(
            label: confirmLabel,
            variant: isDestructive
                ? AppButtonVariant.danger
                : AppButtonVariant.primary,
            onPressed: confirm,
          ),
        ],
      );
    },
  );

  return result ?? false;
}
