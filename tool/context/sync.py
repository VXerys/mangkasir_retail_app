"""
Menulis semua keluaran hasil render.

Empat file ditulis tiap `sync`:
  context/SNAPSHOT.md                      mirror di repo (terlihat di GitHub)
  context/PROGRESS.md                      mirror di repo
  <memory>/project-snapshot.md             dimuat Claude tiap sesi chat
  <memory>/project-progress.md             dimuat saat butuh papan penuh

Plus dua baris pointer di <memory>/MEMORY.md, disisipkan secara idempoten.
Baris MEMORY.md yang sudah ada tidak pernah disentuh — file itu ditulis manusia
dan berisi memory lain yang tidak ada hubungannya dengan roadmap.
"""

from __future__ import annotations

from pathlib import Path

import journal
import render
from model import Roadmap
from paths import (
    CONTEXT_DIR,
    MEMORY_DIR,
    MEMORY_INDEX,
    MEMORY_PROGRESS,
    MEMORY_SNAPSHOT,
    PROGRESS_MIRROR,
    SNAPSHOT_MIRROR,
)

POINTERS = [
    (
        "project-snapshot.md",
        "- [Posisi proyek sekarang](project-snapshot.md) — fase aktif, yang dikerjakan, "
        "yang terhambat, langkah berikutnya",
    ),
    (
        "project-progress.md",
        "- [Papan progres lengkap](project-progress.md) — semua fase, task, keputusan, "
        "penundaan, dan risiko",
    ),
]


def _write(path: Path, content: str) -> bool:
    """Tulis hanya bila berubah. Return True kalau file benar-benar disentuh."""
    path.parent.mkdir(parents=True, exist_ok=True)
    if path.exists() and path.read_text(encoding="utf-8") == content:
        return False
    path.write_text(content, encoding="utf-8")
    return True


def ensure_memory_index() -> list[str]:
    """Sisipkan pointer ke MEMORY.md kalau belum ada. Idempoten."""
    added = []
    existing = ""
    if MEMORY_INDEX.exists():
        existing = MEMORY_INDEX.read_text(encoding="utf-8")

    new_lines = [line for filename, line in POINTERS if filename not in existing]
    if not new_lines:
        return added

    MEMORY_INDEX.parent.mkdir(parents=True, exist_ok=True)
    prefix = "" if (existing == "" or existing.endswith("\n")) else "\n"
    with MEMORY_INDEX.open("a", encoding="utf-8") as f:
        f.write(prefix + "\n".join(new_lines) + "\n")

    added.extend(new_lines)
    return added


def sync(rm: Roadmap) -> list[Path]:
    """Render ulang semua keluaran. Return daftar file yang isinya berubah."""
    CONTEXT_DIR.mkdir(parents=True, exist_ok=True)
    MEMORY_DIR.mkdir(parents=True, exist_ok=True)

    notes = journal.recent(3)
    targets = [
        (SNAPSHOT_MIRROR, render.mirror_snapshot(rm, notes)),
        (PROGRESS_MIRROR, render.mirror_progress(rm)),
        (MEMORY_SNAPSHOT, render.memory_snapshot(rm, notes)),
        (MEMORY_PROGRESS, render.memory_progress(rm)),
    ]

    changed = [path for path, content in targets if _write(path, content)]
    ensure_memory_index()
    return changed
