# ctx — sistem konteks-chat MangRitel

Menjaga satu file sumber kebenaran (`context/roadmap.yaml`) dan merendernya ke
direktori memory Claude Code, supaya tiap sesi chat baru langsung tahu posisi
proyek tanpa harus membaca ulang `git log`.

## Kenapa ini ada

Sebelum ini, seluruh sejarah pekerjaan MangRitel hanya hidup di body commit.
Lima commit `Phase UI-0` … `UI-4` berisi esai 40–80 baris: apa yang dibangun,
pendekatan apa yang ditolak dan kenapa, bug yang ketahuan, dan daftar "sengaja
ditunda ke fase berikutnya". Tidak ada satu file pun yang bisa menjawab *"fase
berikutnya apa, dan apa yang diwariskan UI-0…UI-4 ke sana"*.

Sekarang ada, dan ia dimuat otomatis tiap sesi chat.

## Pemasangan

```
pip install -r tool/context/requirements.txt
```

Hanya butuh `pyyaml`. Tidak menyentuh `pubspec.yaml`, tidak ikut
`flutter analyze`, tidak ada kaitannya dengan build Flutter.

`ctx.bat` menunjuk Python 3.11 di path tetap dan jatuh ke `python` di PATH kalau
tidak ada. Ia juga menyetel `MANGRITEL_MEMORY_DIR`.

## Aliran data

```
          context/roadmap.yaml       <- SATU sumber kebenaran, di-commit
          context/journal/*.md       <- riwayat, append-only
                   |
              tool/context/ctx.py
                   | render satu arah
        +----------+-----------+
        v                      v
context/SNAPSHOT.md      <memory>/project-snapshot.md   <- dimuat tiap sesi chat
context/PROGRESS.md      <memory>/project-progress.md
(mirror, tampak di           <memory>/MEMORY.md  (pointer, idempoten)
 GitHub)
```

`<memory>` = `%USERPROFILE%\.claude\projects\C--Users-PLN-mangkasir-retail-app\memory`

**Render selalu satu arah.** File hasil render diberi banner peringatan dan
tidak pernah dibaca balik. Semua yang dulu harus ditulis tangan — catatan,
keputusan, risiko, penundaan — sekarang punya field sendiri di YAML, jadi tidak
ada alasan mengedit hasil render.

## Track

Roadmap dibagi jadi dua track yang jalan paralel, dideklarasikan di bagian
`tracks:` pada `roadmap.yaml`:

| id | Label | Isi |
|---|---|---|
| `ui` | Aplikasi Flutter | UI-0…UI-7 — design system, navigasi, RBAC, layar |
| `be` | Backend Supabase | BE-0…BE-3 — skema/RLS/trigger, quality gate, data nyata, temuan |

Tiap track punya "fase aktif" sendiri, jadi `next` dan snapshot menampilkan dua
langkah berikutnya sekaligus. Menambah track ketiga cukup dengan menambah
barisnya di `tracks:` dan menyetel `track:` di fase yang bersangkutan.

## Perintah

```
ctx.bat status                    papan fase di konsol
ctx.bat next                      apa yang dikerjakan berikutnya
ctx.bat snapshot                  cetak snapshot 1-layar
ctx.bat sync                      render ulang semua keluaran
ctx.bat doctor                    validasi roadmap

ctx.bat phase start|done|block <id> [--force]
ctx.bat task  start|done|block <key> ["alasan"] [--commit SHA]
ctx.bat task  defer <key> --to <fase>
ctx.bat add-task <fase> <key> "<judul>"

ctx.bat log "<judul>" [--type session|decision]
ctx.bat log --list
ctx.bat git-scan [--since REF] [--apply]
```

Semua perintah yang mengubah roadmap otomatis menjalankan `sync`.

### Alur harian

```
ctx.bat next                          # mau ngapain hari ini
ctx.bat task start ui5-product-card   # mulai
...kerja...
ctx.bat task done ui5-product-card --commit abc1234
```

### Menambah/mengubah roadmap

Status lewat CLI. Selain status — tambah fase, ubah judul, tulis keputusan,
risiko, atau penundaan — edit `context/roadmap.yaml` langsung, lalu `sync`.
File itu memang ditulis untuk dibaca manusia.

Menambah task cepat tanpa buka editor:

```
ctx.bat add-task UI-6 ui6-hold-transaksi "Tahan transaksi dan lanjutkan nanti"
```

## Yang dijaga `doctor`

Semuanya keluar sebagai **error** dengan exit code 1:

- task key atau id fase salah ketik → ditolak, disertai saran key terdekat
- key dobel lintas fase
- fase ditandai `done` padahal masih ada task belum selesai
- `deferred.to` menunjuk fase yang tidak ada
- `track:` sebuah fase tidak dideklarasikan di `tracks:`
- SHA commit yang tidak ada di repo

Ini kelas kegagalan yang paling merugikan di sistem sebelumnya: salah ketik key
menghasilkan `UPDATE ... WHERE key=?` yang mengenai nol baris dan tetap
melaporkan sukses, jadi progres yang dikira tercatat sebenarnya hilang.

Peringatan (tidak menggagalkan): stempel waktu kosong, `blocked` tanpa alasan,
file hasil render yang basi.

## Keputusan desain

**YAML, bukan SQLite.** Status hidup di file yang sama dengan definisinya,
sehingga drift antara "apa yang direncanakan" dan "apa yang sudah selesai"
secara struktural mustahil. Bisa di-`git diff`, bisa direview di PR, tidak
biner.

**Penulis YAML kanonik, bukan `yaml.dump` polos.** Urutan key tetap, jadi
mengubah satu status menghasilkan diff tiga baris, bukan file teracak.

**Stempel waktu diambil dari mtime `roadmap.yaml`, bukan jam saat render.**
`sync` berulang menghasilkan byte yang identik, jadi tidak ada diff berisik di
git tiap kali file disegarkan — sementara stempelnya tetap ikut berubah saat
file diedit tangan. Menyimpannya sebagai field di YAML sempat dicoba dan salah:
ia hanya terbarui lewat mutasi CLI dan diam-diam basi setiap kali seseorang
mengedit YAML langsung.

**Baris subjek commit menang atas body waktu git-scan.** Body commit di proyek
ini sering menyebut fase lain sebagai rujukan ("kontradiksi yang ketahuan di
UI-2"); kalau body ikut dihitung, satu commit tertaut ke fase yang sekadar
disinggungnya.

**Jurnal manual, bukan ringkasan LLM.** Tidak butuh API key, tidak butuh cron,
tidak bisa mati diam-diam.

**Keluaran konsol seluruhnya ASCII.** Konsol Windows sering ber-codepage cp1252
dan tersedak emoji. Emoji hanya dipakai di file markdown, yang selalu ditulis
sebagai UTF-8.

## Integrasi Claude Code

- `.claude/commands/ctx.md` — slash command, jadi dari chat bisa langsung
  `/ctx task done ui5-product-card`
- `.claude/settings.local.json` — allowlist untuk perintah baca, plus hook
  `SessionStart` yang menjalankan `sync` tiap sesi dibuka. Hapus blok `hooks`
  kalau tidak mau.

## Struktur file

| File | Isi |
|---|---|
| `ctx.py` | entry point, argparse |
| `model.py` | tipe + baca/tulis YAML kanonik + pencarian |
| `render.py` | renderer markdown & konsol |
| `sync.py` | menulis keluaran, pointer MEMORY.md |
| `gitlink.py` | tautan commit ↔ fase/task |
| `journal.py` | entri jurnal bertanggal |
| `doctor.py` | validasi |
| `paths.py` | semua path terpusat |
