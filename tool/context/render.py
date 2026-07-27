"""
Renderer markdown. Satu arah: roadmap.yaml -> markdown, tidak pernah sebaliknya.

Dua bentuk keluaran dari badan yang sama:
  - file memory Claude  : pakai frontmatter memory (name/description/metadata)
  - mirror di repo      : pakai banner peringatan, supaya terlihat di GitHub

Stempel waktu diambil dari mtime `roadmap.yaml`, BUKAN dari jam saat render.
Konsekuensinya `sync` dua kali berturut-turut menghasilkan byte identik, jadi
tidak ada diff berisik di git tiap kali file disegarkan — sementara stempelnya
tetap ikut berubah saat file diedit tangan.
"""

from __future__ import annotations

from model import EMOJI_MARK, ASCII_MARK, Roadmap, source_stamp

BANNER = (
    "<!-- DIHASILKAN OTOMATIS — jangan edit file ini.\n"
    "     Ubah context/roadmap.yaml lalu jalankan: tool\\context\\ctx.bat sync -->"
)

MAX_SNAPSHOT_DEFERRED = 8
MAX_SNAPSHOT_RISKS = 5


def _frontmatter(name: str, description: str) -> list[str]:
    return [
        "---",
        f"name: {name}",
        f"description: {description}",
        "metadata:",
        "  type: project",
        "---",
        "",
    ]


# ── badan: snapshot ──────────────────────────────────────────────────────────


def snapshot_body(rm: Roadmap, recent_notes: list[tuple[str, str]] | None = None) -> list[str]:
    L: list[str] = [
        f"# {rm.project} — di mana proyek ini sekarang",
        "",
        f"_Sumber: `context/roadmap.yaml` · diperbarui {source_stamp()}_",
        "",
    ]

    for track_id in rm.track_ids():
        active = rm.active_phase(track_id)
        label = rm.track_label(track_id)

        if active is None:
            L += [f"## ✅ {label} — semua fase selesai", ""]
            continue

        mark = EMOJI_MARK.get(active.status, "⬜")
        L.append(f"## {mark} {label} — fase aktif {active.id} · {active.name}")
        L.append("")
        L.append(f"`{active.done}/{active.total}` task selesai ({active.pct}%)")
        if active.goal:
            L.append("")
            L.append(f"> {active.goal}")
        L.append("")

        nxt_track = rm.next_tasks(3, track_id)
        if nxt_track:
            L.append("Berikutnya:")
            L.append("")
            for i, (phase, task) in enumerate(nxt_track, start=1):
                L.append(f"{i}. `{task.key}` {task.title} _({phase.id})_")
            L.append("")

    running = rm.in_progress_tasks()
    L.append("## Sedang dikerjakan")
    L.append("")
    if running:
        for phase, task in running:
            L.append(f"- `{task.key}` {task.title} _({phase.id})_")
    else:
        L.append("_Tidak ada task berstatus in_progress._")
    L.append("")

    blocked = rm.blocked_tasks()
    if blocked:
        L.append("## 🚫 Terhambat")
        L.append("")
        for phase, task in blocked:
            reason = f" — {task.note}" if task.note else ""
            L.append(f"- `{task.key}` {task.title} _({phase.id})_{reason}")
        L.append("")

    L.append("## Semua fase sekilas")
    L.append("")
    for track_id in rm.track_ids():
        L.append(f"**{rm.track_label(track_id)}**")
        L.append("")
        for phase in rm.phases_of(track_id):
            mark = EMOJI_MARK.get(phase.status, "⬜")
            L.append(
                f"- {mark} **{phase.id}** {phase.name} — {phase.done}/{phase.total} ({phase.pct}%)"
            )
        L.append("")

    deferred = rm.open_deferred()
    if deferred:
        L.append("## Backlog tertunda")
        L.append("")
        L.append("_Diwariskan fase sebelumnya; belum ada di fase yang sudah selesai._")
        L.append("")
        for phase, d in deferred[:MAX_SNAPSHOT_DEFERRED]:
            L.append(f"- {phase.id} → **{d.to}**: {d.what}")
        if len(deferred) > MAX_SNAPSHOT_DEFERRED:
            sisa = len(deferred) - MAX_SNAPSHOT_DEFERRED
            L.append(f"- _…{sisa} lagi, lihat `project-progress.md`_")
        L.append("")

    risks = rm.open_risks()
    if risks:
        L.append("## Risiko terbuka")
        L.append("")
        for phase, r in risks[:MAX_SNAPSHOT_RISKS]:
            L.append(f"- **{r.severity}** ({phase.id}) {r.what}")
        if len(risks) > MAX_SNAPSHOT_RISKS:
            sisa = len(risks) - MAX_SNAPSHOT_RISKS
            L.append(f"- _…{sisa} lagi, lihat `project-progress.md`_")
        L.append("")

    if recent_notes:
        L.append("## Catatan terakhir")
        L.append("")
        for filename, title in recent_notes:
            L.append(f"- `context/journal/{filename}` — {title}")
        L.append("")

    L.append("---")
    L.append("")
    L.append(
        "Ubah status: `tool\\context\\ctx.bat task done <key>` · "
        "papan penuh ada di `project-progress.md`."
    )
    return L


# ── badan: papan penuh ───────────────────────────────────────────────────────


def progress_body(rm: Roadmap) -> list[str]:
    total = sum(p.total for p in rm.phases)
    done = sum(p.done for p in rm.phases)
    pct = int(done / total * 100) if total else 0

    L: list[str] = [
        f"# Progres {rm.project}",
        "",
        f"_Sumber: `context/roadmap.yaml` · diperbarui {source_stamp()}_",
        "",
        f"**Total: {done}/{total} task selesai ({pct}%) di {len(rm.phases)} fase.**",
        "",
    ]

    for track_id in rm.track_ids():
        L.extend(_track_heading(rm, track_id))
        for phase in rm.phases_of(track_id):
            L.extend(_phase_block(phase))

    return L


def _track_heading(rm: Roadmap, track_id: str) -> list[str]:
    phases = rm.phases_of(track_id)
    total = sum(p.total for p in phases)
    done = sum(p.done for p in phases)
    pct = int(done / total * 100) if total else 0
    return [f"# Track {rm.track_label(track_id)} — {done}/{total} ({pct}%)", ""]


def _phase_block(phase) -> list[str]:
    mark = EMOJI_MARK.get(phase.status, "⬜")
    L: list[str] = [
        f"## {mark} {phase.id} — {phase.name} ({phase.done}/{phase.total} · {phase.pct}%)",
        "",
    ]

    meta = []
    if phase.started_at:
        meta.append(f"mulai {phase.started_at}")
    if phase.completed_at:
        meta.append(f"selesai {phase.completed_at}")
    if phase.commits:
        meta.append("commit " + ", ".join(f"`{c}`" for c in phase.commits))
    if meta:
        L.append("_" + " · ".join(meta) + "_")
        L.append("")

    if phase.goal:
        L.append(f"> {phase.goal}")
        L.append("")

    for task in phase.tasks:
        t_mark = EMOJI_MARK.get(task.status, "⬜")
        note = f" — _{task.note}_" if task.note else ""
        commit = f" `{task.commit}`" if task.commit else ""
        L.append(f"- {t_mark} `{task.key}` {task.title}{commit}{note}")
    if phase.tasks:
        L.append("")

    if phase.decisions:
        L.append("**Keputusan**")
        L.append("")
        for d in phase.decisions:
            why = f" — {d.why}" if d.why else ""
            L.append(f"- {d.what}{why}")
        L.append("")

    if phase.deferred:
        L.append("**Sengaja ditunda**")
        L.append("")
        for d in phase.deferred:
            L.append(f"- → **{d.to}**: {d.what}")
        L.append("")

    if phase.risks:
        L.append("**Risiko**")
        L.append("")
        for r in phase.risks:
            L.append(f"- **{r.severity}** {r.what}")
        L.append("")

    if phase.verification:
        L.append(f"**Verifikasi:** {phase.verification}")
        L.append("")

    return L


# ── pembungkus ───────────────────────────────────────────────────────────────


def memory_snapshot(rm: Roadmap, recent_notes=None) -> str:
    head = _frontmatter(
        "project-snapshot",
        f"Posisi {rm.project} hari ini — fase aktif, yang dikerjakan, yang terhambat, langkah berikutnya",
    )
    return "\n".join(head + snapshot_body(rm, recent_notes)) + "\n"


def memory_progress(rm: Roadmap) -> str:
    head = _frontmatter(
        "project-progress",
        f"Papan fase & task {rm.project} lengkap dengan keputusan, penundaan, dan risiko tiap fase",
    )
    return "\n".join(head + progress_body(rm)) + "\n"


def mirror_snapshot(rm: Roadmap, recent_notes=None) -> str:
    return "\n".join([BANNER, ""] + snapshot_body(rm, recent_notes)) + "\n"


def mirror_progress(rm: Roadmap) -> str:
    return "\n".join([BANNER, ""] + progress_body(rm)) + "\n"


# ── konsol (ASCII, aman di cmd/PowerShell dengan codepage apa pun) ────────────


def console_status(rm: Roadmap) -> str:
    L = ["", "=" * 72, f"  {rm.project} — papan fase", "=" * 72]
    for track_id in rm.track_ids():
        phases = rm.phases_of(track_id)
        total = sum(p.total for p in phases)
        done = sum(p.done for p in phases)
        pct = int(done / total * 100) if total else 0
        L.append("")
        L.append(f"  --- {rm.track_label(track_id)}  ({done}/{total}, {pct}%) " + "-" * 20)

        for phase in phases:
            c = phase.counts()
            mark = ASCII_MARK.get(phase.status, "[ ]")
            L.append("")
            L.append(f"  {mark} {phase.id}  {phase.name}")
            extra = ""
            if c["in_progress"]:
                extra += f", {c['in_progress']} jalan"
            if c["blocked"]:
                extra += f", {c['blocked']} terhambat"
            L.append(f"       {phase.done}/{phase.total} selesai ({phase.pct}%){extra}")
            for task in phase.tasks:
                if task.status != "pending":
                    t_mark = ASCII_MARK.get(task.status, "[ ]")
                    L.append(f"       {t_mark} {task.key:<24} {task.title[:40]}")
    L += ["", "=" * 72, ""]
    return "\n".join(L)


def console_next(rm: Roadmap) -> str:
    L = [""]

    any_active = False
    for track_id in rm.track_ids():
        active = rm.active_phase(track_id)
        if active is None:
            continue
        any_active = True
        L.append(f"  {rm.track_label(track_id)}")
        L.append(f"    Fase aktif : {active.id} — {active.name} ({active.done}/{active.total})")
        if active.goal:
            L.append(f"    Tujuan     : {active.goal}")
        for i, (phase, task) in enumerate(rm.next_tasks(3, track_id), start=1):
            L.append(f"    {i}. {task.key:<24} {task.title[:44]}")
        L.append("")

    if not any_active:
        return "\nSemua fase selesai.\n"

    running = rm.in_progress_tasks()
    if running:
        L.append("")
        L.append("  Sedang jalan:")
        for _, task in running:
            L.append(f"    [~] {task.key:<24} {task.title}")

    blocked = rm.blocked_tasks()
    if blocked:
        L.append("")
        L.append("  Terhambat:")
        for _, task in blocked:
            L.append(f"    [!] {task.key:<24} {task.note or task.title}")
        L.append("")

    return "\n".join(L)
