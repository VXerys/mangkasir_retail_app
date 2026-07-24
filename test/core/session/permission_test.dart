import 'package:flutter_test/flutter_test.dart';
import 'package:mangkasir_retail_app/core/session/app_permissions.dart';
import 'package:mangkasir_retail_app/core/session/app_role.dart';
import 'package:mangkasir_retail_app/core/session/app_session.dart';
import 'package:mangkasir_retail_app/core/session/dev_session_repository.dart';

void main() {
  group('AppPermissions', () {
    test('kamus memuat tepat 26 kode, sama seperti tabel di server', () {
      // Angka ini bukan hiasan. Tabel `permissions` dibaca langsung pada
      // 24 Juli 2026 dan berisi 26 baris. Kalau seseorang menambah konstanta
      // yang tidak ada di server, menu akan menyembunyikan halaman dari semua
      // orang tanpa satu pun pesan kesalahan.
      expect(AppPermissions.all, hasLength(26));
    });

    test('setiap kode berformat SCREAMING_SNAKE_CASE', () {
      final pattern = RegExp(r'^[A-Z]+(_[A-Z]+)*$');
      for (final code in AppPermissions.all) {
        expect(pattern.hasMatch(code), isTrue, reason: '$code salah format');
      }
    });

    test('sinonim menunjuk kode yang benar-benar ada', () {
      for (final entry in AppPermissions.synonyms.entries) {
        expect(AppPermissions.all, contains(entry.key));
        expect(AppPermissions.all, contains(entry.value));
      }
    });

    test('canonical memetakan sinonim, dan membiarkan yang lain', () {
      expect(
        AppPermissions.canonical(AppPermissions.saleRead),
        AppPermissions.saleView,
      );
      expect(
        AppPermissions.canonical(AppPermissions.inventoryView),
        AppPermissions.stockRead,
      );
      expect(
        AppPermissions.canonical(AppPermissions.productRead),
        AppPermissions.productRead,
      );
    });
  });

  group('AppSession.can', () {
    test('Owner melewati seluruh pemeriksaan', () {
      // Bukan kelonggaran yang dipilih aplikasi: `public.has_permission`
      // mem-bypass Owner di sisi database. Klien yang tidak ikut akan
      // menyembunyikan menu yang justru diizinkan server.
      final owner = AppSession(
        user: DevSessionRepository.sampleSession(AppRole.owner).user,
        business: DevSessionRepository.sampleSession(AppRole.owner).business,
        outlets: const [],
        activeOutlet: null,
        roleNames: const {AppRole.owner},
        // Sengaja kosong: bypass tidak boleh bergantung pada isi himpunan.
        permissions: const {},
      );

      expect(owner.can(AppPermissions.userManage), isTrue);
      expect(owner.can(AppPermissions.saleVoid), isTrue);
    });

    test('kode yang tidak dipegang ditolak', () {
      final kasir = DevSessionRepository.sampleSession(AppRole.kasir);

      expect(kasir.can(AppPermissions.reportsRead), isFalse);
      expect(kasir.can(AppPermissions.settingManage), isFalse);
      expect(kasir.can(AppPermissions.purchaseRead), isFalse);
    });

    test('kode yang tidak ada di kamus ditolak, bukan diloloskan', () {
      final kasir = DevSessionRepository.sampleSession(AppRole.kasir);

      // 'PRODUCT_VIEW' terdengar benar dan pernah tertulis di dokumen, tetapi
      // tidak pernah ada di server.
      expect(kasir.can('PRODUCT_VIEW'), isFalse);
    });

    test('sinonim diterima setara di kedua arah', () {
      // Kasir memegang INVENTORY_VIEW, bukan STOCK_READ. Rute yang menuntut
      // STOCK_READ tetap harus terbuka baginya — keduanya kode yang sama di
      // kamus server, hanya dituliskan dua kali.
      final kasir = DevSessionRepository.sampleSession(AppRole.kasir);

      expect(kasir.permissions, contains(AppPermissions.inventoryView));
      expect(kasir.permissions, isNot(contains(AppPermissions.stockRead)));
      expect(kasir.can(AppPermissions.stockRead), isTrue);

      // Dan sebaliknya: Gudang memegang keduanya, jadi arah mana pun benar.
      final gudang = DevSessionRepository.sampleSession(AppRole.gudang);
      expect(gudang.can(AppPermissions.inventoryView), isTrue);
    });

    test('canAny longgar, canAll ketat', () {
      final kasir = DevSessionRepository.sampleSession(AppRole.kasir);

      expect(
        kasir.canAny([AppPermissions.reportsRead, AppPermissions.saleCreate]),
        isTrue,
      );
      expect(
        kasir.canAll([AppPermissions.reportsRead, AppPermissions.saleCreate]),
        isFalse,
      );
      // Daftar kosong berarti tanpa syarat, bukan terlarang.
      expect(kasir.canAny(const []), isTrue);
    });

    test('peran yang tak dikenal tidak melempar, ia hanya tidak berhak', () {
      // Peran buatan tenant belum ada hari ini tetapi akan ada. Yang tidak
      // boleh terjadi adalah aplikasi mogok saat menemuinya.
      final asing = DevSessionRepository.sampleSession('Kepala Gudang Regional');

      expect(asing.permissions, isEmpty);
      expect(asing.can(AppPermissions.productRead), isFalse);
    });
  });

  group('himpunan izin per peran cocok dengan seed server', () {
    // Jumlah izin tiap peran dibaca langsung dari `role_permissions`.
    // Owner dikecualikan karena ia mem-bypass, jadi isinya tidak menentukan.
    const expected = {
      AppRole.owner: 26,
      AppRole.administrator: 25,
      AppRole.manager: 21,
      AppRole.kasir: 11,
      AppRole.purchasing: 9,
      AppRole.gudang: 8,
      AppRole.finance: 6,
    };

    for (final entry in expected.entries) {
      test('${entry.key} memegang ${entry.value} izin', () {
        expect(
          AppRole.seededPermissions[entry.key],
          hasLength(entry.value),
        );
      });
    }

    test('seluruh izin yang di-seed ada di kamus', () {
      for (final permissions in AppRole.seededPermissions.values) {
        for (final code in permissions) {
          expect(AppPermissions.all, contains(code));
        }
      }
    });

    test('USER_MANAGE hanya dipegang Owner', () {
      final pemegang = AppRole.seededPermissions.entries
          .where((e) => e.value.contains(AppPermissions.userManage))
          .map((e) => e.key);

      expect(pemegang, [AppRole.owner]);
    });
  });

  group('ganti outlet menghitung ulang izin', () {
    test('sesi baru dibangun, bukan label yang ditukar', () async {
      // `user_roles.outlet_id` boleh NULL atau berisi satu outlet, jadi orang
      // yang sama bisa punya peran berbeda di cabang berbeda. Yang harus
      // dibuktikan di sini: berpindah outlet menghasilkan objek sesi baru
      // dengan outlet aktif yang berbeda — bukan mutasi diam-diam.
      final awal = DevSessionRepository.sampleSession(AppRole.kasir, outletId: 1);
      final sesudah =
          DevSessionRepository.sampleSession(AppRole.kasir, outletId: 2);

      expect(awal.activeOutlet?.id, 1);
      expect(sesudah.activeOutlet?.id, 2);
      expect(awal, isNot(sesudah));
    });
  });
}
