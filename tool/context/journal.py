"""
Jurnal sesi & keputusan — bagian "riwayat" dari sistem.

Append-only. Entri tidak pernah ditimpa dan tidak pernah dirangkum ulang oleh
model. Ini pengganti deterministik untuk summarizer LLM di sistem sebelumnya,
yang butuh API key + cron dan pada praktiknya tidak pernah sekalipun jalan.

Pembagian tugas yang disengaja:
  roadmap.yaml  — keadaan sekarang (berubah)
  journal/      — catatan bertanggal (tidak berubah setelah ditulis)
"""

from __future__ import annotations

import datetime as _dt
import re

from paths import JOURNAL_DIR

TYPES = ("session", "decision")

TEMPLATES = {
    "session": [
        "## Yang dikerjakan",
        "",
        "- ",
        "",
        "## Yang ditemukan",
        "",
        "- ",
        "",
        "## Yang masih terbuka",
        "",
        "- ",
        "",
    ],
    "decision": [
        "## Keputusan",
        "",
        "- ",
        "",
        "## Alasan",
        "",
        "- ",
        "",
        "## Yang ditolak dan kenapa",
        "",
        "- ",
        "",
    ],
}


def slugify(text: str) -> str:
    slug = re.sub(r"[^a-z0-9]+", "-", text.lower()).strip("-")
    return (slug or "catatan")[:48]


def _today() -> str:
    return _dt.date.today().isoformat()


def write(title: str, entry_type: str = "session", body: str = "") -> tuple:
    """Buat entri jurnal. Kalau file hari itu sudah ada, entri ditambahkan di
    bawahnya — tidak pernah menimpa. Return (path, apakah_file_baru)."""
    if entry_type not in TYPES:
        raise ValueError(f"Tipe '{entry_type}' tidak dikenal. Pilih: {', '.join(TYPES)}.")

    date = _today()
    path = JOURNAL_DIR / f"{date}-{slugify(title)}.md"
    JOURNAL_DIR.mkdir(parents=True, exist_ok=True)

    section = [f"# {date} — {title}", ""] + (
        body.rstrip().split("\n") + [""] if body else TEMPLATES[entry_type]
    )

    if path.exists():
        with path.open("a", encoding="utf-8") as f:
            f.write("\n---\n\n" + "\n".join(section) + "\n")
        return path, False

    head = [
        "---",
        f"date: {date}",
        f"type: {entry_type}",
        f'title: "{title}"',
        "---",
        "",
    ]
    path.write_text("\n".join(head + section) + "\n", encoding="utf-8")
    return path, True


def recent(limit: int = 5) -> list[tuple[str, str]]:
    """Entri terbaru sebagai (nama_file, judul), terurut mundur."""
    if not JOURNAL_DIR.exists():
        return []

    out = []
    for path in sorted(JOURNAL_DIR.glob("*.md"), reverse=True)[:limit]:
        title = path.stem
        for line in path.read_text(encoding="utf-8").split("\n")[:8]:
            match = re.match(r'^title:\s*"?(.+?)"?\s*$', line)
            if match:
                title = match.group(1)
                break
        out.append((path.name, title))
    return out


def format_list(entries: list[tuple[str, str]]) -> str:
    if not entries:
        return "\nBelum ada entri jurnal. Buat dengan: ctx log \"judul\"\n"
    L = ["", "  Entri jurnal terbaru:", ""]
    for filename, title in entries:
        L.append(f"    {filename}")
        L.append(f"      {title}")
    L.append("")
    return "\n".join(L)
