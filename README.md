README.md

# ☕ Coffee Keliling Maulana — Mobile App

Aplikasi manajemen operasional coffee keliling. Offline-first, Role-based Workspace.
Role: Owner (Full Access) · Karyawan (Operational) · Investor (Read-Only).

## Dokumentasi

- PRD.docx = kebenaran fitur & aturan bisnis (FR/BR/DV/AC/NFR)
- DESIGN.md = design system & token UI (versi client)
- DECISIONS_LOG.md = keputusan produk/arsitektur di luar PRD

## Tech Stack

Flutter (Dart) · Supabase (PostgreSQL+Auth+Storage) · SQLite (lokal offline-first)
Tools: VS Code, Android Studio, Git/GitHub, Postman, Figma

## Arsitektur

- Feature-based folders · Repository pattern · Sync Service (pending queue + conflict handling)
- RBAC di client + RLS Supabase per role · State: [Riverpod/Bloc — putuskan di P0]

## Struktur Folder

lib/
core/ # theme, tokens, utils, constants
data/ # models, repositories, supabase/, sqlite/, sync/
features/
auth/ # splash 3-status, login, daftar, setup usaha, recovery
owner/ # beranda, master_data, distribusi, keuangan, laporan, audit
karyawan/ # beranda, pos, draft, stok, adjustment, closing
investor/ # beranda, laporan, audit
shared/ # profil, pengaturan, notifikasi, log_aktivitas
app/ # routing, role_guard

## Setup

1. flutter pub get
2. cp .env.example .env → SUPABASE_URL, SUPABASE_ANON_KEY
3. supabase db push (SQL di /supabase/migrations)
4. flutter run

## Aturan Code (wajib)

- Uang = integer/decimal(12,2); tampil tabular.
- Transaksi immutable (BR-13) · Draft tidak memengaruhi stok (BR-06/19)
- Audit otomatis pasca-closing (BR-10) · Sync idempoten, tanpa duplikat (NFR-R04)

## Fase Build

P0 Fondasi → P1 Auth → P2 Master Data → P3 Operasional (POS/Draft/Audit) → P4 Laporan → P5 Sistem

## STATE MANAGEMENT: GetX (README)

- Controller per feature: XxxController extends GetxController
- Bindings per route untuk dependency injection
- GetRouter + GetMiddleware sebagai role guard (Owner/Karyawan/Investor)
- GetxService untuk layanan global: AuthService, SupabaseService,
  LocalDbService (SQLite), SyncService (queue pending + retry), NotifService
- Reactive: .obs + Obx; dilarang setState; dilarang business logic di UI

## Struktur folder penyesuaian GetX

lib/
app/
routes/ # app_pages.dart, app_routes.dart, middlewares/
bindings/ # global_binding.dart
core/ # theme, tokens, utils, constants
data/
models/ repositories/
services/ # supabase_service.dart, local_db_service.dart, sync_service.dart
features/
auth/ # controllers/ views/ widgets/
owner/ karyawan/ investor/ shared/
main.dart
