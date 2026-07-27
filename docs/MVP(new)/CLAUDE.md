# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## ⚠️ Baca ini dulu — dokumen ini ditulis untuk repo lain

Berkas ini berasal dari repo spesifikasi berdiri sendiri, lalu foldernya
disalin masuk ke `mangkasir_retail_app`. Dua pernyataan di bawah **sudah tidak
benar** untuk repo tempat berkas ini sekarang berada:

1. **"There is no application source code yet"** — salah. Repo induk berisi
   aplikasi Flutter yang berjalan: design system lengkap di `lib/core/design/`,
   Drift + BLoC + get_it di `lib/features/`, 193 tes lulus.
2. **Backend Modular Monolith + DDD + JWT + MySQL** — tidak pernah dibangun.
   Yang benar-benar ada adalah **Supabase PostgreSQL 17** sebagai backend
   langsung: 51 tabel, RLS aktif di 51/51 tabel, 8 trigger, 26 permission,
   7 peran, 0 Edge Function. Klien memakai `supabase_flutter`.

Untuk status proyek yang sebenarnya, baca **`context/SNAPSHOT.md`** di akar repo
(dihasilkan dari `context/roadmap.yaml`), lalu `docs/informations/` untuk laporan
kondisi database yang diverifikasi langsung ke Supabase.

Sisa dokumen ini tetap berlaku **hanya** sebagai panduan membaca folder
`docs/MVP(new)/` itu sendiri — konvensi frontmatter, urutan baca, dan graphify.

## What this repo is

Specification-only repository for an MVP **Business Management System for UMKM** (multi-tenant retail SaaS, ref: EQioZmart). Docs are written in Indonesian.

Read `README.md` first: it explains the folder layout and the intended top-down reading order (Vision → Business → Architecture → Data → API → UI → Roadmap).

## Layout

Numbered folders, each doc is one stage of the design:

- `00_Project/` — vision, scope, development roadmap
- `01_Business/` — domain analysis, process mapping, functional spec, business rules & state machines
- `02_Architecture/` — bounded contexts, backend & frontend architecture
- `03_Data/` — conceptual → logical → physical data models
- `04_API/` — API contract
- `05_UI/` — information architecture, UI flow, screen spec, design system
- `glossary.md` — canonical domain terms (Product, Inventory, Outlet, Tenant, etc.)

Doc dependency chain (per README): Business Domain → Process → Bounded Context → Database → API → UI → Roadmap.

## Document conventions

Every doc has YAML frontmatter (`id`, `title`, `type`, `parent`, `tags`, `version`) used for graph extraction, and ends with relation sections (`## Related Domains`, `## Related Processes`, `## Related Entities`, `## Related Database`, `## Related API`, `## Business Rules`, `## References`) for cross-navigation. Preserve these when editing — they are the graph's edges, not decoration.

`refactor.py` is the source of truth for each file's frontmatter and the required relation sections. To add a new spec doc or fix metadata, register it in the `files_metadata` dict and run `python3 refactor.py` (rewrites frontmatter + appends any missing `## ...` sections in place).

## Graphify knowledge graph

A Graphify graph lives in `graphify-out/`. Per `.agents/rules/graphify.md`: for architecture/codebase questions, prefer `graphify query "<question>"` (or the MCP `query_graph`), `graphify path "<A>" "<B>"`, and `graphify explain "<concept>"` over grepping raw files. Read `graphify-out/GRAPH_REPORT.md` only for broad review. After changing files, run `graphify update .` to keep the graph current.

## Planned system architecture (RENCANA LAMA — TIDAK DIPAKAI)

> Bagian di bawah adalah rencana arsitektur dari spec, yang **ditinggalkan**.
> Implementasi nyata memakai Supabase + RLS (lihat peringatan di awal berkas).
> Disimpan hanya sebagai catatan sejarah; jangan dipakai sebagai acuan koding.

- **Backend**: Modular Monolith + DDD, 4 layers (Presentation → Application → Domain → Infrastructure). Dependencies point inward only; Domain knows nothing of DB/HTTP/framework. Per-module structure `application/ domain/ infrastructure/ presentation/` under `src/{identity,organization,product,inventory,purchase,crm,sales,finance,reporting,settings,shared}`.
- **Cross-module communication**: synchronous via service calls; asynchronous via Domain Events (e.g. `SaleCompleted` → ReduceStock, CreateCashTransaction, UpdateDashboard). Multi-aggregate use cases (Checkout) run in a single DB transaction boundary.
- **Auth**: JWT → middleware → permission check (e.g. `PRODUCT_CREATE`) → controller.
- **Database**: MVP is a single database, logically partitioned by domain. Note the backend doc says MySQL while data docs reference Prisma/Postgres-style tooling — resolve this before writing migrations.

When generating code, the specs are the requirements. Pick the stack already implied by a doc rather than inventing one, and flag contradictions (like the MySQL vs. Prisma note above) instead of silently choosing.

## graphify

This project has a knowledge graph at graphify-out/ with god nodes, community structure, and cross-file relationships.

Rules:
- For codebase questions, first run `graphify query "<question>"` when graphify-out/graph.json exists. Use `graphify path "<A>" "<B>"` for relationships and `graphify explain "<concept>"` for focused concepts. These return a scoped subgraph, usually much smaller than GRAPH_REPORT.md or raw grep output.
- If graphify-out/wiki/index.md exists, use it for broad navigation instead of raw source browsing.
- Read graphify-out/GRAPH_REPORT.md only for broad architecture review or when query/path/explain do not surface enough context.
- After modifying code, run `graphify update .` to keep the graph current (AST-only, no API cost).
