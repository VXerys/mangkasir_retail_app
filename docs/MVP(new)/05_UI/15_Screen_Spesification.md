---
id: ui-screen-spec
title: Screen Specification
type: ui
parent: ui-flow
tags: ui, screen
version: 1.0
---

# Tahap 15 — Screen Inventory & Screen Specification

## Tujuan

Mendefinisikan **seluruh layar** yang ada di aplikasi.

Bukan hanya nama halamannya.

Tetapi juga:

- fungsi
- route
- actor
- API
- permission
- state
- komponen
- navigasi

---

# Screen Inventory

Saya membagi berdasarkan module.

```text
Application

├── Authentication
├── Dashboard
├── Product
├── Inventory
├── Purchase
├── Sales
├── Finance
├── CRM
├── Reporting
└── Settings
```

---

# Authentication

## Login

```
Route

/login
```

Purpose

Masuk ke sistem.

Actor

- Owner
- Admin
- Kasir
- Manager

API

```
POST /auth/login
```

Component

```
Email

Password

Remember Me

Login Button

Forgot Password
```

Navigation

```
Login

↓

Dashboard
```

---

# Dashboard

## Dashboard Home

Route

```
/dashboard
```

`/` bukan alamat halaman ini, melainkan pengalihan: ia mengantar pengguna ke
tujuan awal menurut perannya. Kasir mendarat di `/sales/pos`, peran lain di
`/dashboard`. Alasannya ada di §13 Permission Navigation — kasir tidak mampir
ke dasbor, dan memaksanya lewat sana menambah satu ketukan pada pekerjaan yang
paling sering dilakukan di aplikasi ini.

Component

```
Today's Sales

Profit

Stock Alert

Cash

Quick Action

Chart

Recent Transaction
```

Permission

```
(tanpa syarat)
```

Diperbaiki 24 Juli 2026. `DASHBOARD_VIEW` **tidak ada** di tabel `permissions`
— kamus izin berisi 26 kode dan tidak satu pun menyebut dasbor. Dasbor karena
itu terbuka untuk siapa pun yang sudah masuk, sejalan dengan Permission Matrix
di bawah yang memberi tanda ✓ pada keempat peran. Isi kartunya sendiri yang
menyaring diri: kartu laba hanya muncul bagi pemegang `REPORTS_READ`, kartu kas
bagi pemegang `CASH_VIEW`.

---

# Product

Produk berada **di dalam** area Inventory menurut §13, jadi jalurnya bersarang
seperti tetangganya (`/inventory/stocks`). Jalur rata `/products` yang tertulis
sebelumnya membuat satu-satunya entitas Inventory yang tidak bersarang, dan
breadcrumb kehilangan induknya. Diperbaiki 24 Juli 2026.

## Product List

Route

```
/inventory/products
```

Component

```
Search

Category Filter

Brand Filter

Table

Pagination

Toolbar

Export

Import
```

Action

```
Create

View

Edit

Archive
```

API

```
GET /products

DELETE /products/{id}
```

---

## Product Detail

```
/inventory/products/:id
```

Tabs

```
General

Variant

Price

Stock

Movement

History
```

Action

```
Edit

Archive

Duplicate
```

---

## Product Create

```
/inventory/products/new
```

Component

```
General Form

Price Form

Image

Variant

Save
```

API

```
POST /products
```

---

# Inventory

## Stock List

Route

```
/inventory/stocks
```

Widget

```
Warehouse

Available

Reserved

Minimum

Updated At
```

---

## Stock Movement

```
/inventory/movements
```

Table

```
Date

Product

Type

Qty

Reference

User
```

---

## Stock Adjustment

```
/inventory/adjustments/new
```

Component

```
Product

Qty

Reason

Save
```

---

# Purchase

## Purchase List

```
/purchase-orders
```

Action

```
Create

Approve

Cancel

Receiving
```

---

## Purchase Detail

Tabs

```
General

Items

Receiving

History
```

---

## Receiving

```
Receiving Form

Batch

Expiry

Qty
```

---

# Sales

## POS

Route

```
/sales/pos
```

Layout

```
Product Grid

Cart

Summary

Payment
```

---

## Transaction List

```
/sales
```

Action

```
Refund

Print

Detail
```

---

## Sale Detail

Tabs

```
Summary

Items

Payment

Activity
```

---

# Finance

## Cash Session

```
Open

Current Balance

Cash In

Cash Out

Close
```

---

## Cash Flow

```
Income

Expense

Transfer
```

---

# CRM

## Customer List

```
Search

Table

History
```

---

## Customer Detail

```
General

Transaction

Debt

History
```

---

# Reporting

## Sales Report

Filter

```
Date

Outlet

Cashier

Category
```

Output

```
Chart

Table

PDF

Excel
```

---

# Settings

## Business

```
Business Profile

Tax

Currency

Receipt
```

---

## Printer

```
Printer List

Connect

Test Print
```

---

# Screen Template

Saya menyarankan semua screen menggunakan template yang sama.

```text
Screen Name

Purpose

Route

Actor

Permission

API

Component

Toolbar

Action

Validation

Navigation In

Navigation Out

Loading

Empty State

Error State

Responsive Behaviour
```

---

# Navigation Matrix

| From           | To             |
| -------------- | -------------- |
| Dashboard      | POS            |
| Dashboard      | Product        |
| Product        | Product Detail |
| Product Detail | Edit Product   |
| Purchase       | Receiving      |
| Sales          | Payment        |
| Sales          | Receipt        |
| Customer       | Transaction    |
| Inventory      | Adjustment     |

---

# Permission Matrix

> **Sumber kebenaran matriks ini adalah tabel `role_permissions` di database,
> bukan tabel di dokumen ini.** RLS-lah yang benar-benar menolak atau
> mengizinkan; tabel di sini hanya ringkasannya untuk dibaca manusia. Kalau
> keduanya berbeda, database yang menang — UI yang menampilkan menu lalu
> ditolak server lebih buruk daripada UI yang tidak menampilkannya sejak awal.

Diperbaiki 24 Juli 2026 setelah dicocokkan dengan seed sungguhan. Ada **tujuh
peran** yang di-seed, bukan empat, dan semuanya global lintas tenant
(`roles.business_id` NULL). Empat sel pada versi lama bertentangan dengan
database dan sudah dibetulkan; ditandai †.

| Area      | Owner | Administrator | Manager | Kasir | Purchasing | Gudang | Finance |
| --------- | ----- | ------------- | ------- | ----- | ---------- | ------ | ------- |
| Dashboard | ✓     | ✓             | ✓       | ✓     | ✓          | ✓      | ✓       |
| Product   | ✓     | ✓             | ✓       | ✓ †   | ✓          | ✓      | ✗       |
| Inventory | ✓     | ✓             | ✓       | ✓ †   | ✓          | ✓      | ✗       |
| Purchase  | ✓     | ✓             | ✓       | ✗     | ✓          | ✓      | ✓       |
| POS       | ✓     | ✓             | ✓       | ✓     | ✗          | ✗      | ✗       |
| Sales     | ✓     | ✓             | ✓       | ✓     | ✗          | ✗      | ✓       |
| CRM       | ✓     | ✓             | ✓       | ✓     | ✓          | ✗      | ✗       |
| Finance   | ✓     | ✓             | ✓       | ✓ †   | ✗          | ✗      | ✓       |
| Reporting | ✓     | ✓             | ✓       | ✗     | ✗          | ✗      | ✓       |
| Settings  | ✓     | ✓             | ✓ †     | ✗     | ✗          | ✗      | ✗       |

Empat perbaikan itu bukan kelonggaran, melainkan gambaran kerja yang sebenarnya:

- **Product × Kasir** dan **Inventory × Kasir** — kasir memegang `PRODUCT_READ`
  dan `INVENTORY_VIEW`. Ia mustahil menjual tanpa membaca katalog, dan perlu
  tahu sisa stok sebelum menjanjikan barang kepada pembeli.
- **Finance × Kasir** — kasir memegang `CASH_VIEW` dan `CASH_CREATE`. Dialah
  yang membuka dan menutup laci kas; sesi kas adalah pekerjaannya, bukan
  pekerjaan pemilik.
- **Settings × Manager** — manager memegang `SETTING_MANAGE`. Yang tidak ia
  pegang adalah `USER_MANAGE`, dan itu hanya milik Owner.

Izin per aksi (bukan per layar) tetap lebih sempit dari tabel ini. Contoh:
Kasir melihat daftar produk lewat `PRODUCT_READ` tetapi tidak bisa menambah
produk karena `PRODUCT_CREATE` tidak ada padanya, dan Manager tidak bisa
menyetujui PO karena `PURCHASE_APPROVE` hanya dipegang Owner dan Administrator.

## Kamus izin

26 kode, dikelompokkan per domain:

| Domain    | Kode                                                                  |
| --------- | --------------------------------------------------------------------- |
| Produk    | `PRODUCT_READ` `PRODUCT_CREATE` `PRODUCT_UPDATE` `PRODUCT_DELETE` `PRODUCT_MANAGE` |
| Stok      | `STOCK_READ` `STOCK_ADJUST` `STOCK_TRANSFER` `INVENTORY_VIEW` `INVENTORY_ADJUST`   |
| Penjualan | `SALE_CREATE` `SALE_READ` `SALE_VIEW` `SALE_VOID`                      |
| Pembelian | `PURCHASE_READ` `PURCHASE_CREATE` `PURCHASE_APPROVE` `PURCHASE_RECEIVE` |
| CRM       | `CRM_READ` `CRM_CREATE` `CRM_UPDATE`                                  |
| Kas       | `CASH_VIEW` `CASH_CREATE`                                             |
| Laporan   | `REPORTS_READ`                                                        |
| Setelan   | `SETTING_MANAGE` `USER_MANAGE`                                        |

**Owner mem-bypass seluruh pemeriksaan.** Fungsi `public.has_permission`
mengembalikan TRUE untuk peran Owner tanpa melihat kode yang diminta, jadi
klien wajib ikut mem-bypass — kalau tidak, UI menyembunyikan menu yang justru
diizinkan server.

**Catatan untuk tim backend.** Kamus ini memuat sinonim: `SALE_READ` dan
`SALE_VIEW` berdeskripsi sama dan selalu di-seed berpasangan, sementara
`STOCK_READ`/`INVENTORY_VIEW` dan `STOCK_ADJUST`/`INVENTORY_ADJUST` saling
tumpang tindih. Aplikasi memilih satu dari tiap pasangan (`SALE_VIEW`,
`STOCK_READ`, `STOCK_ADJUST`) dan memperlakukan sisanya sebagai sinonim.
Merapikannya adalah pekerjaan database, bukan pekerjaan UI.

---

# API Matrix

| Screen         | API                  |
| -------------- | -------------------- |
| Login          | POST /auth/login     |
| Product List   | GET /products        |
| Product Detail | GET /products/{id}   |
| Product Create | POST /products       |
| Purchase       | GET /purchase-orders |
| POS            | POST /sales          |
| Dashboard      | GET /dashboard       |

---

# Component Inventory

Contoh.

```
Button

Input

Textarea

Number Input

Currency Input

Date Picker

Barcode Scanner

Table

Chart

Modal

Drawer

Toast

Badge

Tabs

Pagination

Search

Filter
```

Komponen ini akan menjadi dasar Design System.

---

# Responsive Matrix

| Screen    | Mobile | Tablet | Desktop |
| --------- | ------ | ------ | ------- |
| Login     | ✓      | ✓      | ✓       |
| Dashboard | ✓      | ✓      | ✓       |
| POS       | ✓      | ✓      | ✓       |
| Reporting | ✗      | ✓      | ✓       |
| Settings  | ✗      | ✓      | ✓       |

Tidak semua layar harus tersedia di semua perangkat. Misalnya laporan kompleks mungkin hanya tersedia di tablet dan desktop.

---

## Summary

This document provides a comprehensive inventory and specification for every screen in the MVP Retail application, detailing routes, components, APIs, and permissions.

## Related Domains

- [All Core Domains](../01_Business/02_Business_Domain_Analysis.md)

## Related Processes

- [Functional Specification](../01_Business/05_Functional_Spesification.md) (features mapped to specific screens)

## Related Entities

- [Logical Data Model](../03_Data/08_Logical_Data_Model.md)

## Related Database

- N/A

## Related API

- [API Contract](../04_API/11_API_Contract.md) (specifically the API Matrix correlating screens to endpoints)

## Business Rules

- [Business Rules & State Machines](../01_Business/06_Business_Rules_And_State_Machine.md) (specifically the Permission Matrix)

## References

- [UI Flow](./14_UI_FLOW.md)
- [Design System](./16_Design_System.md)
