"""
Model data roadmap + pembaca/penulis YAML kanonik.

`context/roadmap.yaml` adalah SATU-SATUNYA sumber kebenaran. Definisi fase dan
status penyelesaiannya hidup di file yang sama, sehingga drift antara "apa yang
direncanakan" dan "apa yang sudah selesai" secara struktural mustahil.

Penulisnya kanonik dan ditulis tangan (bukan `yaml.dump` polos) supaya urutan key
stabil; kalau tidak, tiap `sync` menghasilkan diff berisik dan mengubah satu
status terlihat seperti menulis ulang seluruh file.
"""

from __future__ import annotations

import datetime as _dt
import difflib
import re
from dataclasses import dataclass, field
from typing import Iterator

import yaml

from paths import ROADMAP_FILE

STATUSES = ("pending", "in_progress", "done", "blocked")
SEVERITIES = ("low", "medium", "high")

# Penanda ASCII untuk konsol; emoji hanya dipakai di file markdown.
ASCII_MARK = {"done": "[x]", "in_progress": "[~]", "blocked": "[!]", "pending": "[ ]"}
EMOJI_MARK = {"done": "✅", "in_progress": "🔄", "blocked": "🚫", "pending": "⬜"}


class RoadmapError(Exception):
    """Kesalahan yang layak ditampilkan ke pengguna tanpa traceback."""


# ── tipe ─────────────────────────────────────────────────────────────────────


@dataclass
class Task:
    key: str
    title: str
    status: str = "pending"
    note: str = ""
    commit: str = ""
    files: list[str] = field(default_factory=list)


@dataclass
class Decision:
    what: str
    why: str = ""


@dataclass
class Deferred:
    to: str
    what: str


@dataclass
class Risk:
    what: str
    severity: str = "medium"


@dataclass
class Phase:
    id: str
    name: str
    track: str = "ui"
    goal: str = ""
    status: str = "pending"
    started_at: str = ""
    completed_at: str = ""
    commits: list[str] = field(default_factory=list)
    verification: str = ""
    tasks: list[Task] = field(default_factory=list)
    decisions: list[Decision] = field(default_factory=list)
    deferred: list[Deferred] = field(default_factory=list)
    risks: list[Risk] = field(default_factory=list)

    @property
    def total(self) -> int:
        return len(self.tasks)

    @property
    def done(self) -> int:
        return sum(1 for t in self.tasks if t.status == "done")

    @property
    def pct(self) -> int:
        return int(self.done / self.total * 100) if self.total else 0

    def counts(self) -> dict[str, int]:
        out = {s: 0 for s in STATUSES}
        for t in self.tasks:
            out[t.status] = out.get(t.status, 0) + 1
        return out


def source_stamp(path=None) -> str:
    """Kapan roadmap.yaml terakhir benar-benar berubah.

    Sengaja tidak disimpan sebagai field di YAML — versi itu sempat dibuat dan
    salah, karena hanya terbarui lewat mutasi CLI dan diam-diam basi tiap kali
    file diedit tangan (cara pakai yang didukung).

    mtime murni juga salah: `git checkout`/`clone`/`pull` menulis ulang file ke
    disk dan membuat mtime melompat ke waktu checkout, bukan waktu isinya
    sungguh berubah — sync pertama sesudah clone akan selalu terlihat "baru
    saja berubah" walau tidak ada yang menyentuhnya.

    Jadi: kalau file cocok persis dengan HEAD git, pakai waktu commit terakhir
    yang menyentuhnya (stabil lintas checkout/clone). Kalau berbeda dari HEAD
    (sedang diedit, belum di-commit) atau bukan repo git, baru pakai mtime.
    """
    path = path or ROADMAP_FILE
    if not path.exists():
        return "belum pernah"

    try:
        import gitlink

        if gitlink.file_matches_head(path):
            stamp = gitlink.last_commit_time(path)
            if stamp:
                return stamp
    except gitlink.GitError:
        pass

    moment = _dt.datetime.fromtimestamp(path.stat().st_mtime, _dt.timezone.utc)
    return moment.strftime("%Y-%m-%dT%H:%M:%SZ")


@dataclass
class Roadmap:
    project: str = "MangRitel"
    tracks: dict[str, str] = field(default_factory=dict)
    phases: list[Phase] = field(default_factory=list)

    # ── track ────────────────────────────────────────────────────────────────

    def track_ids(self) -> list[str]:
        """Track sesuai urutan kemunculannya di roadmap."""
        seen: list[str] = []
        for phase in self.phases:
            if phase.track not in seen:
                seen.append(phase.track)
        return seen

    def track_label(self, track_id: str) -> str:
        return self.tracks.get(track_id, track_id)

    def phases_of(self, track_id: str) -> list[Phase]:
        return [p for p in self.phases if p.track == track_id]

    # ── pencarian ────────────────────────────────────────────────────────────

    def iter_tasks(self) -> Iterator[tuple[Phase, Task]]:
        for phase in self.phases:
            for task in phase.tasks:
                yield phase, task

    def all_task_keys(self) -> list[str]:
        return [t.key for _, t in self.iter_tasks()]

    def find_phase(self, phase_id: str) -> Phase:
        wanted = phase_id.strip().lower()
        for phase in self.phases:
            if phase.id.lower() == wanted:
                return phase
        raise RoadmapError(
            f"Fase '{phase_id}' tidak ada." + _suggest(phase_id, [p.id for p in self.phases])
        )

    def find_task(self, task_key: str) -> tuple[Phase, Task]:
        wanted = task_key.strip().lower()
        for phase, task in self.iter_tasks():
            if task.key.lower() == wanted:
                return phase, task
        raise RoadmapError(
            f"Task '{task_key}' tidak ada." + _suggest(task_key, self.all_task_keys())
        )

    # ── turunan ──────────────────────────────────────────────────────────────

    def active_phase(self, track_id: str | None = None) -> Phase | None:
        """Fase in_progress pertama; kalau tidak ada, fase belum-selesai pertama.

        Dibatasi ke satu track kalau track_id diberikan.
        """
        scope = self.phases_of(track_id) if track_id else self.phases
        for phase in scope:
            if phase.status == "in_progress":
                return phase
        for phase in scope:
            if phase.status != "done":
                return phase
        return None

    def in_progress_tasks(self) -> list[tuple[Phase, Task]]:
        return [(p, t) for p, t in self.iter_tasks() if t.status == "in_progress"]

    def blocked_tasks(self) -> list[tuple[Phase, Task]]:
        return [(p, t) for p, t in self.iter_tasks() if t.status == "blocked"]

    def next_tasks(self, limit: int = 3, track_id: str | None = None) -> list[tuple[Phase, Task]]:
        """Task pending berikutnya, dari fase yang paling awal belum selesai."""
        out: list[tuple[Phase, Task]] = []
        for phase in (self.phases_of(track_id) if track_id else self.phases):
            if phase.status == "done":
                continue
            for task in phase.tasks:
                if task.status == "pending":
                    out.append((phase, task))
                    if len(out) >= limit:
                        return out
        return out

    def open_deferred(self) -> list[tuple[Phase, Deferred]]:
        """Penundaan yang fase tujuannya belum selesai — ini backlog sebenarnya."""
        out = []
        for phase in self.phases:
            for d in phase.deferred:
                try:
                    target = self.find_phase(d.to)
                except RoadmapError:
                    out.append((phase, d))
                    continue
                if target.status != "done":
                    out.append((phase, d))
        return out

    def open_risks(self) -> list[tuple[Phase, Risk]]:
        """Risiko dari semua fase, yang paling berat lebih dulu."""
        order = {s: i for i, s in enumerate(reversed(SEVERITIES))}
        risks = [(p, r) for p in self.phases for r in p.risks]
        return sorted(risks, key=lambda pr: order.get(pr[1].severity, len(SEVERITIES)))


def _suggest(given: str, candidates: list[str]) -> str:
    near = difflib.get_close_matches(given.lower(), [c.lower() for c in candidates], n=3, cutoff=0.5)
    if not near:
        return ""
    return " Maksudmu: " + ", ".join(near) + "?"


# ── baca ─────────────────────────────────────────────────────────────────────


def _str(node: dict, key: str, default: str = "") -> str:
    value = node.get(key, default)
    if value is None:
        return default
    return str(value).strip()


def _list(node: dict, key: str) -> list:
    value = node.get(key) or []
    if not isinstance(value, list):
        raise RoadmapError(f"Field '{key}' harus berupa list, dapat {type(value).__name__}.")
    return value


def load(path=None) -> Roadmap:
    path = path or ROADMAP_FILE
    if not path.exists():
        raise RoadmapError(
            f"roadmap.yaml tidak ditemukan di {path}\n"
            "Jalankan dari repo yang benar, atau set MANGRITEL_CONTEXT_DIR."
        )

    try:
        raw = yaml.safe_load(path.read_text(encoding="utf-8")) or {}
    except yaml.YAMLError as exc:
        raise RoadmapError(f"roadmap.yaml tidak valid sebagai YAML:\n{exc}") from exc

    if not isinstance(raw, dict):
        raise RoadmapError("roadmap.yaml harus berupa mapping di level teratas.")

    phases: list[Phase] = []
    for node in _list(raw, "phases"):
        if not isinstance(node, dict):
            raise RoadmapError(f"Entri phases harus mapping, dapat: {node!r}")

        tasks = []
        for t in _list(node, "tasks"):
            tasks.append(
                Task(
                    key=_str(t, "key"),
                    title=_str(t, "title"),
                    status=_str(t, "status", "pending"),
                    note=_str(t, "note"),
                    commit=_str(t, "commit"),
                    files=[str(f) for f in (t.get("files") or [])],
                )
            )

        phases.append(
            Phase(
                id=_str(node, "id"),
                name=_str(node, "name"),
                track=_str(node, "track", "ui"),
                goal=_str(node, "goal"),
                status=_str(node, "status", "pending"),
                started_at=_str(node, "started_at"),
                completed_at=_str(node, "completed_at"),
                commits=[str(c) for c in (node.get("commits") or [])],
                verification=_str(node, "verification"),
                tasks=tasks,
                decisions=[
                    Decision(what=_str(d, "what"), why=_str(d, "why"))
                    for d in _list(node, "decisions")
                ],
                deferred=[
                    Deferred(to=_str(d, "to"), what=_str(d, "what"))
                    for d in _list(node, "deferred")
                ],
                risks=[
                    Risk(what=_str(r, "what"), severity=_str(r, "severity", "medium"))
                    for r in _list(node, "risks")
                ],
            )
        )

    tracks_raw = raw.get("tracks") or {}
    if not isinstance(tracks_raw, dict):
        raise RoadmapError("Field 'tracks' harus berupa mapping id -> label.")

    return Roadmap(
        project=_str(raw, "project", "MangRitel"),
        tracks={str(k): str(v) for k, v in tracks_raw.items()},
        phases=phases,
    )


# ── tulis (kanonik) ──────────────────────────────────────────────────────────

_PLAIN_SAFE = re.compile(r"^[A-Za-z0-9][A-Za-z0-9 _.,()/§+\-]*$")
_RESERVED = {"true", "false", "null", "yes", "no", "on", "off", "~"}


def _scalar(value: str, indent: int) -> str:
    """Emit scalar YAML: polos bila aman, blok bila multi-baris, kutip bila perlu."""
    text = "" if value is None else str(value)
    if text == "":
        return '""'
    if "\n" in text:
        pad = " " * (indent + 2)
        body = "\n".join(pad + line if line else "" for line in text.rstrip("\n").split("\n"))
        return "|-\n" + body
    if text.lower() in _RESERVED or _PLAIN_SAFE.match(text) is None:
        escaped = text.replace("\\", "\\\\").replace('"', '\\"')
        return f'"{escaped}"'
    return text


def _emit(lines: list[str], indent: int, key: str, value: str) -> None:
    lines.append(f"{' ' * indent}{key}: {_scalar(value, indent)}")


def _emit_opt(lines: list[str], indent: int, key: str, value: str) -> None:
    if value:
        _emit(lines, indent, key, value)


def _emit_flow_list(lines: list[str], indent: int, key: str, values: list[str]) -> None:
    if not values:
        return
    items = ", ".join(_scalar(v, indent) for v in values)
    lines.append(f"{' ' * indent}{key}: [{items}]")


def dumps(roadmap: Roadmap) -> str:
    lines: list[str] = [
        "# Sumber kebenaran tunggal progres MangRitel.",
        "# Diedit langsung, atau lewat CLI: tool\\context\\ctx.bat --help",
        "# Semua file markdown di context/ dan di memory dir adalah hasil render",
        "# satu arah dari file ini. Jangan edit file hasil render.",
        "",
    ]
    _emit(lines, 0, "project", roadmap.project)

    if roadmap.tracks:
        lines.append("")
        lines.append("# Label track. Tiap fase menyebut salah satu id di bawah lewat field 'track'.")
        lines.append("tracks:")
        for track_id, label in roadmap.tracks.items():
            _emit(lines, 2, track_id, label)

    lines.append("")
    lines.append("phases:")

    for phase in roadmap.phases:
        lines.append("")
        lines.append(f"  - id: {_scalar(phase.id, 4)}")
        _emit(lines, 4, "track", phase.track)
        _emit(lines, 4, "name", phase.name)
        _emit_opt(lines, 4, "goal", phase.goal)
        _emit(lines, 4, "status", phase.status)
        _emit_opt(lines, 4, "started_at", phase.started_at)
        _emit_opt(lines, 4, "completed_at", phase.completed_at)
        _emit_flow_list(lines, 4, "commits", phase.commits)
        _emit_opt(lines, 4, "verification", phase.verification)

        if phase.tasks:
            lines.append("    tasks:")
            for task in phase.tasks:
                lines.append(f"      - key: {_scalar(task.key, 8)}")
                _emit(lines, 8, "title", task.title)
                _emit(lines, 8, "status", task.status)
                _emit_opt(lines, 8, "note", task.note)
                _emit_opt(lines, 8, "commit", task.commit)
                _emit_flow_list(lines, 8, "files", task.files)

        if phase.decisions:
            lines.append("    decisions:")
            for d in phase.decisions:
                lines.append(f"      - what: {_scalar(d.what, 8)}")
                _emit_opt(lines, 8, "why", d.why)

        if phase.deferred:
            lines.append("    deferred:")
            for d in phase.deferred:
                lines.append(f"      - to: {_scalar(d.to, 8)}")
                _emit(lines, 8, "what", d.what)

        if phase.risks:
            lines.append("    risks:")
            for r in phase.risks:
                lines.append(f"      - what: {_scalar(r.what, 8)}")
                _emit(lines, 8, "severity", r.severity)

    return "\n".join(lines) + "\n"


def save(roadmap: Roadmap, path=None) -> None:
    path = path or ROADMAP_FILE
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(dumps(roadmap), encoding="utf-8")
