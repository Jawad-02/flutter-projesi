# TASKS.md — RedEast Store Backend

> Read `.agents/AGENTS.md` and `.agents/CONTEXT.md` first.
> App-side tasks live in the parent `.agents/TASKS.md`; keep both in sync.

## Conventions

- IDs are stable (`B-001`, `B-002`, …); one task per row.
- Status: `todo`, `in-progress`, `blocked`, `done`, `cancelled`.
- A task is `done` only when its verification passes.
- Record the date when starting/finishing.
- Do not add tasks without the user’s agreement.

## Phase 0 — completed: docs + skills + hygiene

| ID | Task | Status | Acceptance criteria |
|---|---|---|---|
| B-001 | Create backend `.agents` AGENTS/CONTEXT/TASKS | done | Docs match the installed stack and plan |
| B-002 | Copy the shared brand spec to backend `.agents/design` | done | Identical to the Flutter brand doc |
| B-003 | Add a project pointer outside the Boost block in root `AGENTS.md` | done | Pointer present; Boost block untouched |
| B-004 | Add `skills.paths` to `opencode.json` | done | Backend Boost skills load in opencode |
| B-005 | Keep generated artifacts out of Git; caches on Storage | done | vendor/node_modules stay in project (Composer autoload); ignored by Git |
| B-006 | Ignore local SQLite files | done | `database/*.sqlite` ignored |

## Next — Phase 1: foundation

| ID | Task | Status | Acceptance criteria |
|---|---|---|---|
| B-101 | Run `php artisan install:api` (Sanctum + `routes/api.php`) | done | `/api/v1/health` 200; Sanctum migration ran |
| B-102 | Install Filament 5 panel at `/admin` | done | Admin login 200; panel boots |
| B-103 | Install Shield + Spatie Permission | done | Roles `super_admin`/`admin`/`staff`/`customer`; gate before |
| B-104 | Add R2 filesystem + Neon/R2 env placeholders | done | `r2` disk configured; `.env`/`.env.example` documented |
| B-105 | Add API docs package (Scramble) | done | Package installed; docs route available |
| B-106 | Apply RedEast theme to Filament | done | Palette/fonts/logo/login applied; Turkish UI |
| B-107 | Seed admin + customer accounts | done | `admin@redeast.agency` super_admin; customer role |

## Phase 2 — completed: catalog + admin + API

| ID | Task | Status | Acceptance criteria |
|---|---|---|---|
| B-201 | Catalog migrations/models/factories | done | Categories, brands, products, variants, images, inventory movements; specs JSON |
| B-202 | Filament catalog resources | done | CRUD, variants/images repeaters, stock, filters, soft deletes |
| B-203 | Catalog API v1 | done | List/detail/filter/sort/paginate + Resources |
| B-204 | Seed 20 demo products | done | 7 categories, 1 brand, 20 products; reproducible seeder |
| B-205 | Catalog tests | done | Pest 11/11 including admin pages + API filters |
| B-206 | API docs updated | done | Scramble docs + `.agents/CONTEXT.md` |

## Phase 3 — completed: auth, cart, checkout, orders

| ID | Task | Status | Acceptance criteria |
|---|---|---|---|
| B-301 | Customer auth + addresses + wishlist | done | Register/login/logout/me/profile; policies |
| B-302 | Carts + guest merge + coupons | done | Guest cart, merge on login, coupon validation |
| B-303 | Shipping + tax + checkout quote | done | Quote totals in integer cents |
| B-304 | Orders + payments (manual/COD) + refunds | done | Transactional, idempotent order creation |
| B-305 | Inventory movements | done | Reserve/decrement/restore with history |
| B-306 | Filament orders/customers/coupons/shipping | done | Status transitions, notes, refunds |
| B-307 | Commerce tests | done | Auth, cart, checkout, stock, idempotency |

## Phase 4 — in progress: engagement + quality

| ID | Task | Status | Acceptance criteria |
|---|---|---|---|
| B-401 | Reviews + moderation | done | Verified purchase flag; admin moderation |
| B-402 | Notifications (email + database) | done | Order confirmation/status emails queued |
| B-403 | Search/filter tuning + indexes | done | Postgres-safe search; no N+1 |
| B-404 | Reports + CSV export | in-progress | Sales/products/customers |
| B-405 | Settings + activity log | todo | Store/currency/tax/shipping settings |
| B-406 | Security/perf pass | in-progress | Rate limits, signed URLs, image conversions, indexes |
| B-407 | CI (Pest + Pint + Vite build) | done | GitHub Actions green |

## Done

| ID | Task | Completed | Verification |
|---|---|---|---|
| B-001..B-006 | Phase 0: backend docs, brand spec, skills paths, hygiene | 2026-10-24 | `php artisan about` OK; Pest 2/2 |
| B-101..B-107 | Phase 1: Filament, Sanctum, Shield, R2, theme, seed | 2026-10-24 | Admin login 200; Pest 5/5; Vite build OK |
| B-201..B-206 | Phase 2: catalog schema/admin/API/seed | 2026-10-24 | 20 products; Pest 11/11; Flutter loads API |
| B-301..B-307 | Phase 3: auth, cart, checkout, orders, admin commerce | 2026-10-24 | Pest 23/23; transactional idempotent orders |
| B-401..B-407 | Phase 4: reviews, notifications, stats, permissions, CI | 2026-10-24 | Pest 26/26; CI workflow added |

## Planning log

| Date | Decision | Notes |
|---|---|---|
| 2026-10-24 | Backend created inside repo | Laravel 13.38.0, Pest 5.3, Boost 2.2; no nested Git |
| 2026-10-24 | Phase 0 complete | `.agents` docs, brand spec, skills paths, SQLite ignored |
| 2026-10-24 | vendor/node_modules correction | Composer autoload requires vendor inside the project; keep deps there, caches on Storage |
| 2026-10-24 | Phase 1 complete | Filament 5 + Sanctum + Shield + R2 + Scramble; branded admin; seeded roles/users |
| 2026-10-24 | Phase 2 complete | Catalog schema/admin/API/seed; Flutter fetches backend catalog |
| 2026-10-24 | Phase 3 complete | Auth/cart/checkout/orders/coupons/shipping/manual payments + admin |
| 2026-10-24 | Phase 4 progress | Reviews/notifications/stats/CI; settings/activity log + CSV report pending |
