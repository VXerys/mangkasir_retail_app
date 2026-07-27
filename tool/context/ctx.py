"""
ctx — sistem konteks-chat MangRitel.

Menjaga satu file sumber kebenaran (context/roadmap.yaml) dan merendernya ke
direktori memory Claude Code, supaya tiap sesi chat baru langsung tahu posisi
proyek tanpa harus membaca ulang `git log`.

  ctx status                    papan fase di konsol
  ctx next                      apa yang dikerjakan berikutnya
  ctx snapshot                  cetak snapshot 1-layar
  ctx sync                      render ulang semua keluaran
  ctx doctor                    validasi roadmap

  ctx phase start|done|block <id> [alasan]
  ctx task  start|done|block <key> [alasan] [--commit SHA]
  ctx task  defer <key> --to <fase>
  ctx add-task <fase> <key> "<judul>"

  ctx log "<judul>" [--type session|decision]
  ctx git-scan [--since REF] [--apply]

Semua perintah yang mengubah roadmap otomatis menjalankan sync.
"""

from __future__ import annotations

import argparse
import sys

import doctor as doctor_mod
import gitlink
import journal
import model
import render
import sync as sync_mod
from model import RoadmapError
from paths import ROADMAP_FILE


def _setup_console() -> None:
    """Konsol Windows sering ber-codepage cp1252 dan tersedak karakter non-ASCII.
    Keluaran konsol sendiri sudah ASCII, ini hanya jaring pengaman."""
    for stream in (sys.stdout, sys.stderr):
        try:
            stream.reconfigure(encoding="utf-8", errors="replace")
        except (AttributeError, ValueError):
            pass


def _load() -> model.Roadmap:
    return model.load()


def _save_and_sync(rm: model.Roadmap, quiet: bool = False) -> None:
    model.save(rm)
    changed = sync_mod.sync(rm)
    if not quiet:
        if changed:
            for path in changed:
                print(f"  diperbarui  {path}")
        else:
            print("  (tidak ada file hasil render yang berubah)")


# ── perintah baca ────────────────────────────────────────────────────────────


def cmd_status(args) -> int:
    print(render.console_status(_load()))
    return 0


def cmd_next(args) -> int:
    print(render.console_next(_load()))
    return 0


def cmd_snapshot(args) -> int:
    rm = _load()
    print("\n".join(render.snapshot_body(rm, journal.recent(3))))
    return 0


def cmd_sync(args) -> int:
    rm = _load()
    changed = sync_mod.sync(rm)
    if changed:
        print(f"\n  {len(changed)} file diperbarui:")
        for path in changed:
            print(f"    {path}")
    else:
        print("\n  Semua file hasil render sudah mutakhir.")
    print()
    return 0


def cmd_doctor(args) -> int:
    rm = _load()
    errors, warns = doctor_mod.check(rm, check_git=not args.no_git)
    print(doctor_mod.format_report(errors, warns))
    return 1 if errors else 0


# ── perintah ubah ────────────────────────────────────────────────────────────


def cmd_phase(args) -> int:
    rm = _load()
    phase = rm.find_phase(args.id)
    import datetime as _dt

    today = _dt.date.today().isoformat()

    if args.action == "start":
        phase.status = "in_progress"
        if not phase.started_at:
            phase.started_at = today
    elif args.action == "done":
        open_tasks = [t.key for t in phase.tasks if t.status in ("pending", "in_progress")]
        if open_tasks and not args.force:
            print(
                f"\n  Ditolak: {phase.id} masih punya {len(open_tasks)} task belum selesai:\n"
                f"    {', '.join(open_tasks)}\n\n"
                "  Selesaikan dulu, atau pakai --force kalau memang mau ditutup begitu saja.\n"
            )
            return 1
        phase.status = "done"
        phase.completed_at = today
    elif args.action == "block":
        phase.status = "blocked"

    print(f"\n  {phase.id} -> {phase.status}")
    _save_and_sync(rm)
    print()
    return 0


def cmd_task(args) -> int:
    rm = _load()
    phase, task = rm.find_task(args.key)

    if args.action == "start":
        task.status = "in_progress"
        if phase.status == "pending":
            phase.status = "in_progress"
            import datetime as _dt

            phase.started_at = phase.started_at or _dt.date.today().isoformat()
    elif args.action == "done":
        task.status = "done"
        task.note = ""
    elif args.action == "block":
        if not args.reason:
            print("\n  Butuh alasan: ctx task block <key> \"kenapa terhambat\"\n")
            return 1
        task.status = "blocked"
        task.note = args.reason

    if args.commit:
        if not gitlink.commit_exists(args.commit):
            print(f"\n  Ditolak: commit '{args.commit}' tidak ada di repo ini.\n")
            return 1
        task.commit = args.commit

    print(f"\n  {task.key} -> {task.status}  ({phase.id})")
    if task.note:
        print(f"    alasan: {task.note}")
    _save_and_sync(rm)
    print()
    return 0


def cmd_defer(args) -> int:
    rm = _load()
    source, task = rm.find_task(args.key)
    target = rm.find_phase(args.to)

    if target.id == source.id:
        print(f"\n  Ditolak: {task.key} sudah ada di {target.id}.\n")
        return 1

    source.tasks.remove(task)
    target.tasks.append(task)
    source.deferred.append(model.Deferred(to=target.id, what=f"`{task.key}` {task.title}"))

    print(f"\n  {task.key}: {source.id} -> {target.id} (tercatat sebagai penundaan)")
    _save_and_sync(rm)
    print()
    return 0


def cmd_add_task(args) -> int:
    rm = _load()
    phase = rm.find_phase(args.phase)

    key = args.key.strip().lower()
    existing = {k.lower() for k in rm.all_task_keys()}
    if key in existing:
        print(f"\n  Ditolak: task key '{key}' sudah dipakai.\n")
        return 1

    phase.tasks.append(model.Task(key=key, title=args.title.strip()))
    print(f"\n  + {key} ditambahkan ke {phase.id}")
    _save_and_sync(rm)
    print()
    return 0


# ── jurnal & git ─────────────────────────────────────────────────────────────


def cmd_log(args) -> int:
    if args.list:
        print(journal.format_list(journal.recent(args.limit)))
        return 0

    if not args.title:
        print("\n  Butuh judul: ctx log \"judul catatan\"\n")
        return 1

    path, is_new = journal.write(args.title, args.type)
    verb = "dibuat" if is_new else "ditambahkan ke"
    print(f"\n  Entri {verb} {path}")
    print("  Isi bagian-bagiannya, lalu jalankan 'ctx sync' agar muncul di snapshot.\n")

    # Snapshot memuat 3 catatan terbaru, jadi render ulang sekarang juga.
    sync_mod.sync(_load())
    return 0


def cmd_git_scan(args) -> int:
    rm = _load()
    try:
        report = gitlink.scan(rm, args.since)
    except gitlink.GitError as exc:
        print(f"\n  {exc}\n")
        return 1

    print(gitlink.format_report(report, args.since))

    if args.apply:
        changes = gitlink.apply(rm, report)
        if changes:
            print(f"  {len(changes)} tautan ditulis:")
            for change in changes:
                print(f"    {change}")
            _save_and_sync(rm)
        else:
            print("  Tidak ada tautan baru untuk ditulis.")
        print()
    return 0


# ── parser ───────────────────────────────────────────────────────────────────


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        prog="ctx",
        description="Sistem konteks-chat MangRitel — progres fase, sprint, dan task.",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog=f"Sumber kebenaran: {ROADMAP_FILE}",
    )
    sub = parser.add_subparsers(dest="command", metavar="perintah")

    sub.add_parser("status", help="papan fase di konsol").set_defaults(func=cmd_status)
    sub.add_parser("next", help="apa yang dikerjakan berikutnya").set_defaults(func=cmd_next)
    sub.add_parser("snapshot", help="cetak snapshot 1-layar").set_defaults(func=cmd_snapshot)
    sub.add_parser("sync", help="render ulang semua keluaran").set_defaults(func=cmd_sync)

    p_doctor = sub.add_parser("doctor", help="validasi roadmap")
    p_doctor.add_argument("--no-git", action="store_true", help="lewati pemeriksaan commit")
    p_doctor.set_defaults(func=cmd_doctor)

    p_phase = sub.add_parser("phase", help="ubah status fase")
    p_phase.add_argument("action", choices=["start", "done", "block"])
    p_phase.add_argument("id", help="id fase, mis. UI-5")
    p_phase.add_argument("--force", action="store_true", help="tutup fase walau task belum selesai")
    p_phase.set_defaults(func=cmd_phase)

    p_task = sub.add_parser("task", help="ubah status task")
    p_task.add_argument("action", choices=["start", "done", "block", "defer"])
    p_task.add_argument("key", help="task key, mis. ui5-product-card")
    p_task.add_argument("reason", nargs="?", default="", help="alasan (wajib untuk block)")
    p_task.add_argument("--commit", default="", help="tautkan ke SHA commit")
    p_task.add_argument("--to", default="", help="fase tujuan (untuk defer)")
    p_task.set_defaults(func=_task_dispatch)

    p_add = sub.add_parser("add-task", help="tambah task baru ke sebuah fase")
    p_add.add_argument("phase", help="id fase")
    p_add.add_argument("key", help="task key baru")
    p_add.add_argument("title", help="judul task")
    p_add.set_defaults(func=cmd_add_task)

    p_log = sub.add_parser("log", help="catat entri jurnal sesi/keputusan")
    p_log.add_argument("title", nargs="?", default="", help="judul entri")
    p_log.add_argument("--type", choices=list(journal.TYPES), default="session")
    p_log.add_argument("--list", action="store_true", help="daftar entri terbaru")
    p_log.add_argument("--limit", type=int, default=10)
    p_log.set_defaults(func=cmd_log)

    p_git = sub.add_parser("git-scan", help="tautkan commit ke fase/task")
    p_git.add_argument("--since", default=None, help="mis. HEAD~10 atau sebuah tag")
    p_git.add_argument("--apply", action="store_true", help="tulis tautan ke roadmap.yaml")
    p_git.set_defaults(func=cmd_git_scan)

    return parser


def _task_dispatch(args) -> int:
    if args.action == "defer":
        if not args.to:
            print("\n  Butuh fase tujuan: ctx task defer <key> --to <fase>\n")
            return 1
        return cmd_defer(args)
    return cmd_task(args)


def main(argv: list[str] | None = None) -> int:
    _setup_console()
    parser = build_parser()
    args = parser.parse_args(argv)

    if not getattr(args, "func", None):
        parser.print_help()
        return 0

    try:
        return args.func(args)
    except RoadmapError as exc:
        print(f"\n  {exc}\n")
        return 1


if __name__ == "__main__":
    sys.exit(main())
