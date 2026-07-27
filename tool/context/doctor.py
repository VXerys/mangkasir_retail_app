"""
Validasi roadmap.

Ini yang menangkap kelas kegagalan paling menyebalkan di sistem sebelumnya:
salah ketik task key menghasilkan `UPDATE ... WHERE key=?` yang mengenai nol
baris dan tetap melaporkan sukses. Di sini setiap referensi divalidasi, dan
`error` membuat exit code 1.

Dua tingkat:
  error  — roadmap tidak konsisten, harus dibetulkan
  warn   — mencurigakan tapi mungkin disengaja
"""

from __future__ import annotations

from model import SEVERITIES, STATUSES, Roadmap
from paths import (
    MEMORY_PROGRESS,
    MEMORY_SNAPSHOT,
    PROGRESS_MIRROR,
    ROADMAP_FILE,
    SNAPSHOT_MIRROR,
)


def check(rm: Roadmap, check_git: bool = True) -> tuple[list[str], list[str]]:
    errors: list[str] = []
    warns: list[str] = []

    if not rm.phases:
        errors.append("Roadmap tidak punya fase satu pun.")

    # ── fase ────────────────────────────────────────────────────────────────
    seen_phases: dict[str, int] = {}
    for i, phase in enumerate(rm.phases):
        where = f"phases[{i}]"

        if not phase.id:
            errors.append(f"{where}: field 'id' kosong.")
        if not phase.name:
            warns.append(f"{phase.id or where}: field 'name' kosong.")

        lowered = phase.id.lower()
        if lowered in seen_phases:
            errors.append(f"Id fase '{phase.id}' dobel (juga di phases[{seen_phases[lowered]}]).")
        seen_phases[lowered] = i

        if phase.status not in STATUSES:
            errors.append(
                f"{phase.id}: status '{phase.status}' tidak dikenal. Pilih: {', '.join(STATUSES)}."
            )

        if rm.tracks and phase.track not in rm.tracks:
            errors.append(
                f"{phase.id}: track '{phase.track}' tidak dideklarasikan di 'tracks'. "
                f"Yang ada: {', '.join(rm.tracks)}."
            )

        if phase.status == "done":
            open_tasks = [t.key for t in phase.tasks if t.status in ("pending", "in_progress")]
            if open_tasks:
                errors.append(
                    f"{phase.id}: fase 'done' tapi {len(open_tasks)} task belum selesai "
                    f"({', '.join(open_tasks[:4])})."
                )
            if not phase.completed_at:
                warns.append(f"{phase.id}: fase 'done' tapi 'completed_at' kosong.")
        if phase.status == "in_progress" and not phase.started_at:
            warns.append(f"{phase.id}: fase 'in_progress' tapi 'started_at' kosong.")
        if phase.status != "done" and phase.completed_at:
            warns.append(f"{phase.id}: punya 'completed_at' padahal status '{phase.status}'.")

        for r in phase.risks:
            if r.severity not in SEVERITIES:
                errors.append(
                    f"{phase.id}: severity risiko '{r.severity}' tidak dikenal. "
                    f"Pilih: {', '.join(SEVERITIES)}."
                )
            if not r.what:
                errors.append(f"{phase.id}: ada risiko tanpa 'what'.")

        for d in phase.decisions:
            if not d.what:
                errors.append(f"{phase.id}: ada keputusan tanpa 'what'.")

    # ── task ────────────────────────────────────────────────────────────────
    seen_tasks: dict[str, str] = {}
    for phase, task in rm.iter_tasks():
        if not task.key:
            errors.append(f"{phase.id}: ada task tanpa 'key'.")
            continue
        if not task.title:
            warns.append(f"{task.key}: 'title' kosong.")

        lowered = task.key.lower()
        if lowered in seen_tasks:
            errors.append(f"Task key '{task.key}' dobel ({seen_tasks[lowered]} dan {phase.id}).")
        seen_tasks[lowered] = phase.id

        if task.status not in STATUSES:
            errors.append(
                f"{task.key}: status '{task.status}' tidak dikenal. Pilih: {', '.join(STATUSES)}."
            )
        if task.status == "blocked" and not task.note:
            warns.append(f"{task.key}: 'blocked' tanpa alasan di 'note'.")

    # ── penundaan menunjuk fase nyata ───────────────────────────────────────
    for phase in rm.phases:
        for d in phase.deferred:
            if not d.what:
                errors.append(f"{phase.id}: ada penundaan tanpa 'what'.")
            if not d.to:
                errors.append(f"{phase.id}: penundaan '{d.what[:40]}' tanpa 'to'.")
            elif d.to.lower() not in seen_phases:
                errors.append(
                    f"{phase.id}: penundaan menunjuk fase '{d.to}' yang tidak ada di roadmap."
                )

    # ── commit benar-benar ada di git ───────────────────────────────────────
    if check_git:
        try:
            import gitlink

            checked: dict[str, bool] = {}

            def exists(sha: str) -> bool:
                if sha not in checked:
                    checked[sha] = gitlink.commit_exists(sha)
                return checked[sha]

            for phase in rm.phases:
                for sha in phase.commits:
                    if not exists(sha):
                        errors.append(f"{phase.id}: commit '{sha}' tidak ada di repo ini.")
            for _, task in rm.iter_tasks():
                if task.commit and not exists(task.commit):
                    errors.append(f"{task.key}: commit '{task.commit}' tidak ada di repo ini.")
        except gitlink.GitError as exc:
            warns.append(f"Lewati pemeriksaan commit: {exc}")

    # ── file hasil render masih segar ───────────────────────────────────────
    if ROADMAP_FILE.exists():
        source_mtime = ROADMAP_FILE.stat().st_mtime
        for target in (SNAPSHOT_MIRROR, PROGRESS_MIRROR, MEMORY_SNAPSHOT, MEMORY_PROGRESS):
            if not target.exists():
                warns.append(f"Belum pernah dirender: {target.name}. Jalankan 'ctx sync'.")
            elif target.stat().st_mtime < source_mtime:
                warns.append(f"Basi dibanding roadmap.yaml: {target.name}. Jalankan 'ctx sync'.")

    return errors, warns


def format_report(errors: list[str], warns: list[str]) -> str:
    L = ["", "=" * 72, "  ctx doctor", "=" * 72, ""]

    if errors:
        L.append(f"  {len(errors)} ERROR")
        L.append("")
        for e in errors:
            L.append(f"    [x] {e}")
        L.append("")

    if warns:
        L.append(f"  {len(warns)} peringatan")
        L.append("")
        for w in warns:
            L.append(f"    [!] {w}")
        L.append("")

    if not errors and not warns:
        L.append("  Bersih. Roadmap konsisten dan semua file hasil render segar.")
        L.append("")

    L.append("=" * 72)
    L.append("")
    return "\n".join(L)
