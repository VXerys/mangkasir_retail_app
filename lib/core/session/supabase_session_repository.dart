import 'package:dartz/dartz.dart';
// import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../error/failures.dart';
import '../preferences/app_preferences.dart';
import 'app_session.dart';
import 'session_repository.dart';

/// Implementasi sesi berbasis Supabase Auth.
///
/// Menggantikan [DevSessionRepository] di build produksi. Tiga langkah utama:
///
/// 1. `auth.signInWithPassword` → mendapatkan token Supabase.
/// 2. Query `public.users` (cocokkan `uuid` dengan `auth.uid()`) → id lokal.
/// 3. Susun [AppSession] dari business, outlet yang boleh diakses, dan himpunan
///    izin **untuk outlet aktif** — bukan untuk pengguna secara keseluruhan.
///
/// **Offline-first**: sesi di-cache ke Hive setelah login atau restore berhasil.
/// Bila jaringan tidak ada tetapi token belum kedaluwarsa, sesi dikembalikan dari
/// cache sehingga kasir tidak terkunci. Token yang sudah kedaluwarsa tetap
/// memaksa login ulang — cache bukan pengganti validitas token.
// @LazySingleton(as: SessionRepository)
class SupabaseSessionRepository implements SessionRepository {
  final SupabaseClient _client;
  final AppPreferences _prefs;

  SupabaseSessionRepository(this._client, this._prefs);

  // ── Public API ──────────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, AppSession>> signIn(
    String email,
    String password,
  ) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.user == null) {
        return const Left(AuthFailure('Login gagal: respons server kosong'));
      }
      return _buildAndCacheSession(_prefs.activeOutletId);
    } on AuthException catch (e) {
      return Left(AuthFailure(_mapAuthError(e.message)));
    } catch (e) {
      return Left(RemoteFailure('Login gagal: $e'));
    }
  }

  @override
  Future<Either<Failure, AppSession>> restore() async {
    final authSession = _client.auth.currentSession;
    if (authSession == null) {
      return const Left(AuthFailure('Tidak ada sesi tersimpan'));
    }

    // Token masih valid. Coba ambil data segar dari server.
    try {
      return await _buildAndCacheSession(_prefs.activeOutletId);
    } catch (_) {
      // Server tidak terjangkau — gunakan cache lokal bila tersedia.
      final cached = _prefs.cachedSession;
      if (cached != null) return Right(_sessionFromCache(cached));
      return const Left(
        NetworkFailure('Server tidak terjangkau dan tidak ada cache lokal'),
      );
    }
  }

  @override
  Future<Either<Failure, AppSession>> selectOutlet(int outletId) async {
    final authUser = _client.auth.currentUser;
    if (authUser == null) return const Left(AuthFailure('Tidak ada sesi'));

    try {
      final userData = await _client
          .from('users')
          .select('id')
          .eq('uuid', authUser.id)
          .single();

      final userId = userData['id'] as int;

      final access = await _client
          .from('user_has_outlet')
          .select('outlet_id')
          .eq('user_id', userId)
          .eq('outlet_id', outletId)
          .maybeSingle();

      if (access == null) {
        return const Left(ForbiddenFailure('Outlet tidak dapat diakses'));
      }

      await _prefs.setActiveOutletId(outletId);
      return await _buildAndCacheSession(outletId);
    } on PostgrestException catch (e) {
      return Left(RemoteFailure('Gagal berpindah outlet: ${e.message}'));
    } catch (e) {
      return Left(RemoteFailure('Gagal berpindah outlet: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> forgotPassword(String email) async {
    try {
      await _client.auth.resetPasswordForEmail(email);
      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure(_mapAuthError(e.message)));
    } catch (e) {
      return Left(RemoteFailure('Gagal mengirim email pemulihan: $e'));
    }
  }

  @override
  Future<void> signOut() async {
    await _client.auth.signOut();
    await _prefs.setActiveOutletId(null);
    await _prefs.setCachedSession(null);
  }

  // ── Pembangun sesi ──────────────────────────────────────────────────────────

  Future<Either<Failure, AppSession>> _buildAndCacheSession(
    int? preferredOutletId,
  ) async {
    final authUser = _client.auth.currentUser;
    if (authUser == null) return const Left(AuthFailure('Tidak ada sesi auth'));

    try {
      // Satu query: user + bisnis + outlet yang boleh diakses.
      final userData = await _client
          .from('users')
          .select('''
            id, uuid, username, email,
            businesses!inner(id, name),
            user_has_outlet(outlets!inner(id, name))
          ''')
          .eq('uuid', authUser.id)
          .single();

      final userId = userData['id'] as int;
      final businessRaw = userData['businesses'] as Map<String, dynamic>;

      final business = SessionBusiness(
        id: businessRaw['id'] as int,
        name: businessRaw['name'] as String,
      );

      final outlets = (userData['user_has_outlet'] as List)
          .map((e) => e['outlets'] as Map<String, dynamic>)
          .map(
            (o) => SessionOutlet(id: o['id'] as int, name: o['name'] as String),
          )
          .toList();

      if (outlets.isEmpty) {
        return const Left(
          ForbiddenFailure('Akun tidak memiliki akses ke outlet mana pun'),
        );
      }

      final activeOutletId =
          preferredOutletId != null &&
                  outlets.any((o) => o.id == preferredOutletId)
              ? preferredOutletId
              : outlets.first.id;

      final activeOutlet = outlets.firstWhere((o) => o.id == activeOutletId);

      // Query terpisah: peran dan izin untuk outlet aktif.
      // OR filter: `outlet_id IS NULL` (berlaku se-bisnis) atau tepat outlet ini.
      final rolesRaw = await _client
          .from('user_roles')
          .select(
            'outlet_id, roles!inner(name, role_permissions(permissions!inner(code)))',
          )
          .eq('user_id', userId)
          .or('outlet_id.is.null,outlet_id.eq.$activeOutletId');

      final roleNames = <String>{};
      final permissions = <String>{};

      for (final ur in rolesRaw) {
        final role = ur['roles'] as Map<String, dynamic>;
        roleNames.add(role['name'] as String);

        for (final rp in role['role_permissions'] as List) {
          permissions.add(
            (rp['permissions'] as Map<String, dynamic>)['code'] as String,
          );
        }
      }

      final session = AppSession(
        user: SessionUser(
          id: userId,
          uuid: userData['uuid'] as String,
          username: userData['username'] as String? ??
              authUser.email?.split('@').first ??
              '',
          email:
              userData['email'] as String? ?? authUser.email ?? '',
        ),
        business: business,
        outlets: outlets,
        activeOutlet: activeOutlet,
        roleNames: roleNames,
        permissions: permissions,
      );

      await _prefs.setCachedSession(_toCache(session));
      await _prefs.setActiveOutletId(activeOutletId);

      return Right(session);
    } on PostgrestException catch (e) {
      // PGRST116 = tidak ada baris yang cocok (user tidak ada di public.users)
      if (e.code == 'PGRST116') {
        return const Left(
          AuthFailure('Akun tidak ditemukan — hubungi administrator'),
        );
      }
      // Coba fallback ke cache sebelum melapor galat
      final cached = _prefs.cachedSession;
      if (cached != null) return Right(_sessionFromCache(cached));
      return Left(RemoteFailure('Galat server: ${e.message}'));
    } catch (e) {
      final cached = _prefs.cachedSession;
      if (cached != null) return Right(_sessionFromCache(cached));
      return Left(NetworkFailure('Tidak dapat terhubung ke server'));
    }
  }

  // ── Cache ───────────────────────────────────────────────────────────────────

  Map<String, dynamic> _toCache(AppSession s) => {
        'user_id': s.user.id,
        'user_uuid': s.user.uuid,
        'user_username': s.user.username,
        'user_email': s.user.email,
        'business_id': s.business.id,
        'business_name': s.business.name,
        'outlets':
            s.outlets.map((o) => {'id': o.id, 'name': o.name}).toList(),
        'active_outlet_id': s.activeOutlet?.id,
        'role_names': s.roleNames.toList(),
        'permissions': s.permissions.toList(),
      };

  AppSession _sessionFromCache(Map<String, dynamic> c) {
    final outlets = (c['outlets'] as List)
        .map(
          (o) => SessionOutlet(
            id: o['id'] as int,
            name: o['name'] as String,
          ),
        )
        .toList();

    final activeId = c['active_outlet_id'] as int?;
    final activeOutlet = activeId != null
        ? outlets.firstWhere(
            (o) => o.id == activeId,
            orElse: () => outlets.first,
          )
        : outlets.firstOrNull;

    return AppSession(
      user: SessionUser(
        id: c['user_id'] as int,
        uuid: c['user_uuid'] as String,
        username: c['user_username'] as String,
        email: c['user_email'] as String,
      ),
      business: SessionBusiness(
        id: c['business_id'] as int,
        name: c['business_name'] as String,
      ),
      outlets: outlets,
      activeOutlet: activeOutlet,
      roleNames: Set<String>.from(c['role_names'] as List),
      permissions: Set<String>.from(c['permissions'] as List),
    );
  }

  // ── Helper ──────────────────────────────────────────────────────────────────

  String _mapAuthError(String message) => switch (message) {
        String s when s.contains('Invalid login credentials') =>
          'Email atau kata sandi salah',
        String s when s.contains('Email not confirmed') =>
          'Email belum dikonfirmasi — periksa kotak masuk Anda',
        String s when s.contains('User not found') =>
          'Akun tidak ditemukan',
        String s when s.contains('Too many requests') =>
          'Terlalu banyak percobaan — coba lagi beberapa menit kemudian',
        _ => 'Login gagal: $message',
      };
}
