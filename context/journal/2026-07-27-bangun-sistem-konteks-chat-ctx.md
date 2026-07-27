---
date: 2026-07-27
type: session
title: "Bangun sistem konteks-chat ctx"
---

# 2026-07-27 — Bangun sistem konteks-chat ctx

## Yang dikerjakan

- Membangun `tool/context/` (Python 3.11, hanya butuh pyyaml) dan
  `context/roadmap.yaml` sebagai sumber kebenaran tunggal progres proyek.
- Merekonstruksi UI-0…UI-4 dari lima body commit menjadi 8 fase / 56 task,
  lengkap dengan keputusan, penundaan, risiko, dan hasil verifikasi tiap fase.
- Menurunkan UI-5 (Komponen Bisnis), UI-6 (Layar Kasir), UI-7 (Auth Asli) dari
  daftar "sengaja ditunda" di UI-0 dan UI-4 — bukan dikarang baru.
- Menambah track kedua (Backend Supabase): BE-0 dari 11 spec Kiro yang seluruh
  tahapnya sudah `[x]`, lalu BE-1 (12 quality gate yang belum dicentang di spec
  01-03), BE-2 (data operasional 0% dan 8 trigger yang belum pernah dijalankan),
  BE-3 (temuan T-02…T-09 dari audit 15 Juli). Total jadi 12 fase / 85 task.
- Menyambungkan ke Claude Code: slash command `/ctx`, allowlist perintah baca,
  dan hook `SessionStart` yang menyegarkan file memory tiap sesi dibuka.

## Yang ditemukan

- Sistem serupa di marketiv-web punya tiga cacat terukur yang sengaja tidak
  ditiru: dua sumber kebenaran (SQLite vs markdown, sudah drift 8/18 vs 0/18),
  paruh summarizer LLM yang tidak pernah sekali pun jalan, dan definisi task
  yang ter-hardcode di Python sehingga menambah task berarti commit kode.
- `git log --format` tidak bisa memakai karakter null sungguhan di argv —
  `CreateProcess` Windows menolaknya. Harus placeholder `%x00`.
- Body commit di proyek ini sering menyebut fase lain sebagai rujukan
  ("kontradiksi yang ketahuan di UI-2"), jadi git-scan versi pertama menautkan
  satu commit ke tiga fase sekaligus. Baris subjek dijadikan penentu.

- Menyimpan `updated_at` sebagai field di YAML ternyata keliru: ia hanya ikut
  terbarui lewat mutasi CLI dan diam-diam basi tiap kali YAML diedit tangan —
  padahal mengedit langsung memang cara pakai yang didukung. Diganti mtime file.
- `docs/MVP(new)/CLAUDE.md` diberi koreksi di awal berkas. Ia masih menyatakan
  "there is no application source code yet" dan mendokumentasikan backend
  Modular Monolith + MySQL, dan berkas itu ikut termuat otomatis tiap kali ada
  yang membaca file di folder tersebut.

## Yang masih terbuka

- Belum ada `CLAUDE.md` di akar repo. Yang ada hanya salinan basi di
  `docs/MVP(new)/`, yang sekarang sudah diberi peringatan tapi bukan pengganti.
- BE-1 sampai BE-3 seluruhnya `pending` dan tidak bisa dikerjakan dari sini —
  butuh akses jalankan SQL ke Supabase.
