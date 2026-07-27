"""
Semua path yang dipakai sistem konteks-chat MangRitel, terkumpul di satu tempat.

Dua direktori yang berbeda perannya:

  CONTEXT_DIR  — di dalam repo, di-commit. Sumber kebenaran (roadmap.yaml) dan
                 jurnal. Ini yang diedit manusia/CLI.
  MEMORY_DIR   — di luar repo, tidak di-commit. Direktori memory Claude Code
                 yang dimuat otomatis tiap sesi chat. Isinya hasil render satu
                 arah dari CONTEXT_DIR; tidak pernah dibaca balik.

Keduanya bisa dioverride lewat environment variable supaya bisa diuji tanpa
menyentuh direktori sungguhan.
"""

import os
from pathlib import Path

# ── di dalam repo ────────────────────────────────────────────────────────────

TOOL_DIR = Path(__file__).resolve().parent          # tool/context
REPO_ROOT = TOOL_DIR.parent.parent                  # mangkasir_retail_app

CONTEXT_DIR = Path(os.environ.get("MANGRITEL_CONTEXT_DIR", REPO_ROOT / "context"))
ROADMAP_FILE = CONTEXT_DIR / "roadmap.yaml"
JOURNAL_DIR = CONTEXT_DIR / "journal"
PROGRESS_MIRROR = CONTEXT_DIR / "PROGRESS.md"
SNAPSHOT_MIRROR = CONTEXT_DIR / "SNAPSHOT.md"

# ── di luar repo: direktori memory Claude Code ───────────────────────────────

DEFAULT_MEMORY_DIR = (
    Path.home() / ".claude" / "projects" / "C--Users-PLN-mangkasir-retail-app" / "memory"
)
MEMORY_DIR = Path(os.environ.get("MANGRITEL_MEMORY_DIR", DEFAULT_MEMORY_DIR))

MEMORY_SNAPSHOT = MEMORY_DIR / "project-snapshot.md"
MEMORY_PROGRESS = MEMORY_DIR / "project-progress.md"
MEMORY_INDEX = MEMORY_DIR / "MEMORY.md"
