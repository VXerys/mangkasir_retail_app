import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../preferences/app_preferences.dart';

/// Mode tema yang sedang berlaku.
///
/// Sengaja `Cubit<ThemeMode>` tanpa kelas state sendiri: tidak ada yang perlu
/// dilacak selain satu nilai, dan membungkusnya dalam state berlapis hanya
/// menambah berkas tanpa menambah kejelasan.
///
/// Nilai awal dibaca **secara sinkron** dari [AppPreferences], jadi frame
/// pertama sudah memakai tema yang benar.
@lazySingleton
class ThemeCubit extends Cubit<ThemeMode> {
  final AppPreferences _preferences;

  ThemeCubit(AppPreferences preferences)
      : _preferences = preferences,
        super(preferences.themeMode);

  Future<void> setMode(ThemeMode mode) async {
    if (mode == state) return;
    emit(mode);
    await _preferences.setThemeMode(mode);
  }
}
