"""
Menautkan commit git ke fase dan task.

Di proyek ini seluruh sejarah pekerjaan hidup di body commit — lima commit
"Phase UI-N" berisi esai 40–80 baris. Modul ini membuat sejarah itu bisa
ditautkan ke roadmap, dan melaporkan apa yang belum tertaut ke arah manapun.

Sengaja tidak pernah mengubah status task. Yang ditulisnya hanya field
`commit` (task) dan `commits` (fase), dan hanya kalau diminta `--apply`.
"""

from __future__ import annotations

import re
import subprocess

from model import Roadmap
from paths import REPO_ROOT

# Pemisah harus ditulis sebagai placeholder git (%x00 / %x1e), bukan sebagai
# karakter sungguhan di argv: CreateProcess di Windows menolak null di argumen.
RECORD_SEP = "\x1e"
FIELD_SEP = "\x00"
FMT_RECORD_SEP = "%x1e"
FMT_FIELD_SEP = "%x00"

# ui0-tokens, ui4-permissions, be2-rls — huruf, angka fase, tanda hubung, slug
TASK_KEY_RE = re.compile(r"\b[a-z]{2,4}\d+-[a-z0-9]+(?:-[a-z0-9]+)*\b")


class GitError(Exception):
    pass


def _git(*args: str) -> str:
    try:
        result = subprocess.run(
            ["git", *args],
            cwd=REPO_ROOT,
            capture_output=True,
            text=True,
            encoding="utf-8",
            errors="replace",
        )
    except FileNotFoundError as exc:
        raise GitError("Perintah 'git' tidak ditemukan di PATH.") from exc
    if result.returncode != 0:
        raise GitError(result.stderr.strip() or f"git {' '.join(args)} gagal.")
    return result.stdout


def commit_exists(sha: str) -> bool:
    try:
        _git("cat-file", "-e", f"{sha}^{{commit}}")
        return True
    except GitError:
        return False


def log(since: str | None = None) -> list[dict]:
    fmt = FMT_FIELD_SEP.join(["%h", "%ad", "%s", "%b"]) + FMT_RECORD_SEP
    args = ["log", f"--format={fmt}", "--date=short"]
    if since:
        args.append(f"{since}..HEAD")

    out = _git(*args)
    commits = []
    for chunk in out.split(RECORD_SEP):
        chunk = chunk.strip("\n")
        if not chunk:
            continue
        parts = chunk.split(FIELD_SEP)
        if len(parts) < 4:
            continue
        sha, date, subject, body = parts[0], parts[1], parts[2], parts[3]
        commits.append({"sha": sha, "date": date, "subject": subject, "body": body})
    return commits


def _phases_in(rm: Roadmap, text: str) -> list[str]:
    lowered = text.lower()
    found = []
    for phase in rm.phases:
        # Cocokkan id fase sebagai kata utuh, mis. "Phase UI-4" atau "[UI-4]"
        if re.search(rf"(?<![A-Za-z0-9]){re.escape(phase.id.lower())}(?![A-Za-z0-9-])", lowered):
            found.append(phase.id)
    return found


def _match_commit(rm: Roadmap, commit: dict) -> tuple[list[str], list[str]]:
    """Return (phase_ids, task_keys) yang disebut commit ini.

    Baris subjek menang atas body. Body commit di proyek ini sering menyebut fase
    lain sebagai rujukan ("kontradiksi yang ketahuan di UI-2", "sudah ada sejak
    UI-0/UI-1") — kalau body ikut dihitung, satu commit tertaut ke fase yang
    sekadar disinggungnya.
    """
    known_tasks = {k.lower(): k for k in rm.all_task_keys()}
    task_keys = []
    for found in TASK_KEY_RE.findall(f"{commit['subject']}\n{commit['body']}".lower()):
        canonical = known_tasks.get(found)
        if canonical and canonical not in task_keys:
            task_keys.append(canonical)

    phase_ids = _phases_in(rm, commit["subject"]) or _phases_in(rm, commit["body"])
    return phase_ids, task_keys


def scan(rm: Roadmap, since: str | None = None) -> dict:
    """Laporan tautan commit <-> roadmap. Tidak mengubah apa pun."""
    commits = log(since)

    linked: list[dict] = []
    unlinked: list[dict] = []
    for commit in commits:
        phase_ids, task_keys = _match_commit(rm, commit)
        entry = {**commit, "phases": phase_ids, "tasks": task_keys}
        (linked if (phase_ids or task_keys) else unlinked).append(entry)

    done_without_commit = [
        (phase, task)
        for phase, task in rm.iter_tasks()
        if task.status == "done" and not task.commit and not phase.commits
    ]

    return {
        "commits": commits,
        "linked": linked,
        "unlinked": unlinked,
        "done_without_commit": done_without_commit,
    }


def apply(rm: Roadmap, report: dict) -> list[str]:
    """Tulis tautan yang ditemukan ke roadmap. Return daftar perubahan."""
    changes: list[str] = []

    for entry in report["linked"]:
        sha = entry["sha"]

        for phase_id in entry["phases"]:
            phase = rm.find_phase(phase_id)
            if sha not in phase.commits:
                phase.commits.append(sha)
                changes.append(f"{phase.id}: + commit {sha}")

        for key in entry["tasks"]:
            _, task = rm.find_task(key)
            if not task.commit:
                task.commit = sha
                changes.append(f"{task.key}: commit -> {sha}")

    return changes


def format_report(report: dict, since: str | None) -> str:
    L = ["", "=" * 72, "  Tautan commit <-> roadmap", "=" * 72, ""]
    scope = f"{since}..HEAD" if since else "seluruh riwayat"
    L.append(f"  Cakupan: {scope} ({len(report['commits'])} commit)")
    L.append("")

    if report["linked"]:
        L.append("  Tertaut:")
        for entry in report["linked"]:
            bits = []
            if entry["phases"]:
                bits.append("fase " + ", ".join(entry["phases"]))
            if entry["tasks"]:
                bits.append("task " + ", ".join(entry["tasks"]))
            L.append(f"    {entry['sha']}  {entry['date']}  {entry['subject'][:44]}")
            L.append(f"              -> {' | '.join(bits)}")
        L.append("")

    if report["unlinked"]:
        L.append("  Belum tertaut ke fase/task manapun:")
        for entry in report["unlinked"]:
            L.append(f"    {entry['sha']}  {entry['date']}  {entry['subject'][:52]}")
        L.append("")

    if report["done_without_commit"]:
        L.append("  Task 'done' tanpa commit (fasenya juga tidak punya commit):")
        for phase, task in report["done_without_commit"]:
            L.append(f"    {task.key:<24} ({phase.id}) {task.title[:36]}")
        L.append("")

    L.append("  Gunakan --apply untuk menuliskan tautan ini ke roadmap.yaml.")
    L.append("")
    return "\n".join(L)
