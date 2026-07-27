---
description: Papan progres MangRitel — lihat & ubah status fase/task dari chat
argument-hint: "[status|next|sync|doctor|task done <key>|log \"judul\"|git-scan]"
allowed-tools: Bash(tool/context/ctx.bat:*)
---

Jalankan CLI konteks-chat proyek ini:

```
tool\context\ctx.bat $ARGUMENTS
```

Kalau `$ARGUMENTS` kosong, jalankan `tool\context\ctx.bat next`.

Setelah perintahnya jalan, laporkan hasilnya ke user secara ringkas dalam bahasa
Indonesia — jangan menempelkan seluruh keluaran konsol mentah kalau panjang.

Konteks yang perlu kamu tahu:

- Sumber kebenaran tunggal ada di `context/roadmap.yaml`. Semua file markdown di
  `context/` dan di direktori memory Claude adalah hasil render satu arah dari
  file itu. **Jangan pernah mengedit file hasil render.**
- Untuk mengubah roadmap (menambah/menghapus fase, mengubah judul task,
  menambah keputusan/risiko/penundaan), edit `context/roadmap.yaml` langsung,
  lalu jalankan `tool\context\ctx.bat sync`.
- Untuk sekadar mengubah status, pakai CLI — jangan edit YAML:
  `ctx.bat task start|done|block <key>` dan `ctx.bat phase start|done <id>`.
- Perintah yang mengubah sesuatu otomatis menjalankan `sync`.
- Kalau sebuah perintah ditolak (task key salah ketik, fase ditutup padahal
  task belum selesai, SHA commit tidak ada), itu memang disengaja. Jangan
  akali dengan mengedit YAML — betulkan perintahnya.
