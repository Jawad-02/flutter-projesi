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
| B-501..B-503 | Phase 5: Neon + R2 activation, demo catalog, root redirect | 2026-10-24 | Neon seeded; R2 signed URLs; `/` → `/admin` |

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
| 2026-10-24 | Phase 5 complete | Neon migrated/seeded; R2 active with signed URLs; demo catalog; root redirect |
| 2026-10-24 | Dashboard widgets | KPI stats, 7-day revenue chart, recent orders, top products; money inputs in product form |

## Dashboard UI — implementation plan (Filament, web-only)

Ground rules:
- Dashboard stays **inside Filament at `/admin`**; `/` redirects there. No custom public dashboard route.
- Web-only: staff use the Filament session guard; customers never access the panel; admin screens are not exposed through `/api/v1`.
- Keep the RedEast theme; run `npm run build` after admin CSS changes.
- Each task is done only with `php artisan test --compact`, `vendor/bin/pint --test`, and a smoke check against Neon/R2.

### Completed

| ID | Task | Verification |
|---|---|---|
| D-001 | `/` → `/admin` redirect; remove welcome page | `/` 302; `/admin/login` 200 |
| D-002 | Branded dashboard shell (sidebar/topbar/logo/fonts/colors) | Panel renders with RedEast theme |
| D-003 | Dashboard widgets: KPIs, 7-day revenue, recent orders, top products | `/admin` renders; Pest 26/26 |
| D-008a | Product price inputs in dollars (stored as cents) | Product edit page renders; tests pass |

### D-004 — Reports + CSV (todo)

- [ ] **D-004.1 Sales report page** inside Filament: date range (default: last 30 days), revenue, orders, AOV, refunds, daily table.
- [ ] **D-004.2 Product report**: units sold and revenue by product/category, top 20, date-filtered.
- [ ] **D-004.3 Customer report**: new customers, order count, total spend.
- [ ] **D-004.4 Inventory report**: low-stock and out-of-stock variants.
- [ ] **D-004.5 CSV export** on every report using `streamDownload`; filename includes date range; respects filters.
- **Acceptance:** report totals match direct SQL; empty ranges show `0`; CSV opens correctly; no public route.
- **Verification:** Pest tests for each report + export; manual download check.
- **Depends on:** D-005.1 currency/tax settings (use config fallback if needed).

### D-005 — Store settings + activity log (todo)

- [ ] **D-005.1 Settings table/model**: currency, tax rate, tax-inclusive flag, order prefix, contact email/phone, address, social links; seeded defaults.
- [ ] **D-005.2 Filament Settings page**: validation, save, cache invalidation, permission `ManageSettings`.
- [ ] **D-005.3 Replace `config('store.*')` reads** in checkout/order/coupon/seeders with a `StoreSettings` service (fallback to current config).
- [ ] **D-005.4 Activity log**: log admin create/update/delete, order status changes, refunds, and settings changes; add a read-only Filament view (Spatie Activitylog or a small audit table).
- [ ] **D-005.5 Tests** for settings persistence, checkout totals after changes, and audit entries.
- **Acceptance:** changing tax/currency changes new quotes; old orders keep snapshots; audit entries show actor, subject, changes.

### D-006 — Roles, permissions, 2FA (in progress)

- [ ] **D-006.1 Access matrix tests**: `super_admin` full access; `admin` operational access; `staff` limited to catalog/orders/reviews; `customer` cannot access `/admin`.
- [ ] **D-006.2 Staff management**: Filament resource/page (admin only) to assign roles; prevent deleting the last super admin.
- [ ] **D-006.3 Two-factor authentication** for admin/staff using a Filament 5-compatible 2FA plugin; recovery codes.
- [ ] **D-006.4 Ensure permissions are reproducible** on a fresh DB: document/run `shield:generate` then `ShieldPermissionSeeder`.
- **Acceptance:** forbidden pages return 403; 2FA challenge works; customer panel access remains blocked.

### D-007 — Web-only + responsive verification (in progress)

- [ ] **D-007.1 Web-only audit**: panel uses the web guard; no admin routes under `/api/v1`; root redirect intact.
- [ ] **D-007.2 Responsive pass**: desktop/tablet layouts, collapsible sidebar, horizontal table scroll, form max-width.
- [ ] **D-007.3 Dark-mode pass** across dashboard, widgets, tables, forms, login.
- [ ] **D-007.4 Screenshots** for login, dashboard, product edit, order view, reports.
- **Acceptance:** usable at 1280px, 1024px, and tablet widths; no overflow; dark mode consistent.

### D-008 — Admin UX polish (in progress)

- [ ] **D-008.1 Product form**: variants/images UX, stock alerts, bulk activate/deactivate/feature/price update.
- [ ] **D-008.2 Order detail**: status timeline, internal notes, payment/refund audit, invoice link (optional).
- [ ] **D-008.3 Customer detail**: profile, addresses, order history, total spend.
- [ ] **D-008.4 Coupons, shipping, reviews**: filters, bulk actions, clearer empty states.
- [ ] **D-008.5 Dashboard**: quick-action links, better empty states, optional date filter for widgets.
- **Acceptance:** no dead ends; destructive actions confirm; tables/search/filters remain fast with Neon.

### D-009 — Dashboard tests + CI (todo)

- [ ] **D-009.1 Pest feature tests** for dashboard widgets, reports, settings, permissions, 2FA.
- [ ] **D-009.2 CI** runs Pint, Pest, and Vite build; no new warnings/errors.
- [ ] **D-009.3 Manual smoke test** against Neon + R2 (login, create product, upload image, place order, dashboard updates).
- **Acceptance:** CI green; dashboard data reflects Neon; signed R2 previews load.

### D-010 — Backlog (not scheduled)

- [ ] PDF invoices / packing slips
- [ ] Email template previews
- [ ] Stock reservation alerts
- [ ] Scheduled report exports
- [ ] Media library view for R2

### Recommended order

1. D-005 settings + activity log
2. D-004 reports + CSV
3. D-006 roles/permissions/2FA
4. D-008 admin UX polish
5. D-007 responsive/dark/web-only pass
6. D-009 tests + CI
7. D-010 backlog only if requested

## Done

| ID | Task | Completed | Verification |
|---|---|---|---|
| B-001..B-006 | Phase 0: backend docs, brand spec, skills paths, hygiene | 2026-10-24 | `php artisan about` OK; Pest 2/2 |
| B-101..B-107 | Phase 1: Filament, Sanctum, Shield, R2, theme, seed | 2026-10-24 | Admin login 200; Pest 5/5; Vite build OK |
| B-201..B-206 | Phase 2: catalog schema/admin/API/seed | 2026-10-24 | 20 products; Pest 11/11; Flutter loads API |
| B-301..B-307 | Phase 3: auth, cart, checkout, orders, admin commerce | 2026-10-24 | Pest 23/23; transactional idempotent orders |
| B-401..B-407 | Phase 4: reviews, notifications, stats, permissions, CI | 2026-10-24 | Pest 26/26; CI workflow added |
| B-501..B-503 | Phase 5: Neon + R2 activation, demo catalog, root redirect | 2026-10-24 | Neon seeded; R2 signed URLs; `/` → `/admin` |
| D-001..D-003, D-008a | Dashboard shell, widgets, money inputs | 2026-10-24 | `/admin` 200; Pest 26/26 |

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
| 2026-10-24 | Phase 5 complete | Neon migrated/seeded; R2 active with signed URLs; demo catalog; root redirect |
| 2026-10-24 | Dashboard Phase 1 | KPI stats, 7-day revenue chart, recent orders, top products; money inputs |
| 2026-10-24 | Dashboard plan frozen | Remaining work captured as D-004..D-010 for the post-compaction session |
