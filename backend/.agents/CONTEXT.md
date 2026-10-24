# CONTEXT.md — RedEast Store Backend

Last verified: 2026-10-24.

## 1. What this is

Laravel 13 backend for **RedEast Store**:

- JSON API (`/api/v1`) consumed by the Flutter app.
- Filament 5 admin dashboard (`/admin`) for products, orders, customers, coupons,
  shipping, reviews, settings, and reports.
- Auth for customers (Sanctum) and staff (Filament session + Shield roles).
- Neon Postgres in production; Cloudflare R2 for media.
- RedEast is used for **design only**; no RedEast business data is imported.

The backend lives at `backend/` inside the Flutter repository and has no nested
Git repo. It ships in the same PR as the app.

## 2. Stack (current and planned)

| Area | Choice | Status |
|---|---|---|
| PHP | 8.4 | installed |
| Laravel | 13.38.0 | installed |
| Pest | 5.3 | installed |
| Laravel Boost | 2.2 | installed |
| Admin | Filament 5.10 + Shield 4.3 at `/admin` | installed |
| API auth | Sanctum, `routes/api.php` + `routes/api/v1.php` | installed |
| Roles | Filament Shield + spatie/laravel-permission | installed |
| DB (local) | SQLite | active |
| DB (prod) | Neon Postgres (`DB_URL`, `DB_SSLMODE`) | placeholders ready |
| Media (prod) | Cloudflare R2 via `r2` S3 disk | placeholders ready |
| Frontend build | Vite 8 + Tailwind CSS 4 | installed |
| Queue/cache/session | database | active |
| API docs | Scramble | installed |
| Image processing | intervention/image-laravel | installed |

## 3. Directory map

```text
backend/
├── .agents/                    # this documentation + design spec + Boost skills
├── AGENTS.md                   # entry point + generated Boost guidelines block
├── opencode.json               # skills.paths + laravel-boost MCP
├── app/
│   ├── Http/Controllers/Api/V1/    # thin API controllers (planned)
│   ├── Http/Requests/Api/V1/       # Form Requests (planned)
│   ├── Http/Resources/Api/V1/      # API Resources (planned)
│   ├── Models/                     # Eloquent models
│   ├── Services/                   # checkout/orders/inventory/payments/media
│   └── Filament/                   # panel resources/widgets/theme
├── routes/
│   ├── web.php
│   ├── console.php
│   └── api.php                     # to be added by install:api
├── database/
│   ├── migrations/
│   ├── factories/
│   └── seeders/
├── resources/css/app.css           # Tailwind 4 + RedEast tokens
├── public/brand/                   # logos/fonts served by the dashboard
├── tests/                          # Pest
└── .env / .env.example             # SQLite local; Neon/R2 placeholders
```

## 4. Environment

### Local (`.env`)
```ini
APP_NAME=RedEast
APP_ENV=local
APP_URL=http://localhost:8000
APP_LOCALE=tr
APP_FALLBACK_LOCALE=en
APP_TIMEZONE=Europe/Istanbul

DB_CONNECTION=sqlite
FILESYSTEM_DISK=local
QUEUE_CONNECTION=database
CACHE_STORE=database
SESSION_DRIVER=database

# Neon (fill in / uncomment to switch to Postgres)
# DB_CONNECTION=pgsql
# DB_URL=postgresql://USER:PASSWORD@HOST/DATABASE?sslmode=require
# DB_HOST=
# DB_PORT=5432
# DB_DATABASE=
# DB_USERNAME=
# DB_PASSWORD=

# Cloudflare R2
# R2_ACCESS_KEY_ID=
# R2_SECRET_ACCESS_KEY=
# R2_BUCKET=
# R2_ENDPOINT=https://ACCOUNT_ID.r2.cloudflarestorage.com
# R2_URL=
# R2_REGION=auto
```

### Production (`.env.example`)
- `DB_CONNECTION=pgsql`, `DB_URL=postgresql://USER:PASSWORD@HOST/DATABASE?sslmode=require`
- `FILESYSTEM_DISK=r2`
- `R2_*` placeholders as above.
- Add a custom `r2` disk in `config/filesystems.php` using the `R2_*` values and
  path-style endpoint.
- Make `sslmode` env-driven if Neon requires `require` explicitly.
- The user fills the real tokens in `.env`; never commit them.

## 5. Planned data model

- **Users**: customers + staff (`users`, roles/permissions, addresses,
  personal_access_tokens, password resets, sessions).
- **Catalog**: `categories`, `brands`, `products`, `product_variants`,
  `product_images`, `attributes`, `attribute_values`,
  `product_attribute_values`, `inventory_movements`.
- **Commerce**: `carts`, `cart_items`, `coupons`, `coupon_usages`, `orders`,
  `order_items`, `order_addresses`, `shipments`, `payments`, `refunds`.
- **Engagement**: `reviews`, `wishlists`, `notifications`, `settings`, `media`,
  `activity_log`.
- **Money**: integer cents; currency + tax rate in settings.
- **Stock**: reserve/decrement on order, restore on cancel/refund, full movement
  history.
- **Orders**: statuses `pending`, `paid`, `processing`, `shipped`, `delivered`,
  `cancelled`, `refunded`; separate payment status. Idempotency key unique index.

## 6. API plan (`/api/v1`)

Live now: `GET /api/v1/health`.

```text
POST   /auth/register
POST   /auth/login
POST   /auth/logout
GET    /auth/me
PUT    /auth/profile
POST   /auth/forgot-password
POST   /auth/reset-password

GET    /products                 filters: category, brand, price, search, sort
GET    /products/{slug}
GET    /categories
GET    /brands

GET    /cart
POST   /cart/items
PUT    /cart/items/{id}
DELETE /cart/items/{id}
POST   /cart/merge               merge guest cart after login
POST   /coupons/validate
GET    /shipping/methods
POST   /checkout/quote
POST   /orders                  idempotency key
GET    /orders
GET    /orders/{number}
POST   /orders/{number}/cancel

GET    /addresses
POST   /addresses
PUT    /addresses/{id}
DELETE /addresses/{id}

GET    /wishlist
POST   /wishlist/{product}
DELETE /wishlist/{product}

GET    /products/{slug}/reviews
POST   /products/{slug}/reviews

GET    /notifications
POST   /notifications/{id}/read

POST   /payments/intent          manual now, Stripe later
POST   /webhooks/stripe          placeholder
```

Admin uses Filament, not the API. API responses use Resources, pagination meta,
stable error shape, and rate limiting.

## 7. Filament admin plan

- Panel `/admin` with Filament 5, branded RedEast theme.
- Roles: `super_admin`, `admin`, `staff`; Shield permissions.
- Resources: products (variants/images/inventory), categories, brands, orders
  (status transitions/notes/refunds), customers, coupons, shipping methods,
  reviews, settings, staff.
- Dashboard widgets: revenue, orders, AOV, customers, low stock, top products,
  sales chart.
- Reports: sales/products/customers with CSV export.
- Branded login page, dark charcoal sidebar, Instrument Serif headings,
  Cabinet Grotesk UI.

## 8. Design system

See `.agents/design/brand.md` (same file as the Flutter app). Summary:
charcoal `#363636`, gray `#9C9C9C`, red `#ED2839`, white/black; Instrument Serif
display, Cabinet Grotesk UI. Admin: dark sidebar, light content, red active
states. Use the supplied logos; never redraw.

## 9. Commands

```bash
cd backend
php artisan about
php artisan serve
npm run dev
npm run build
php artisan migrate --seed
php artisan test --compact
vendor/bin/pint --dirty --format agent
```

## 10. Current state

- Laravel 13.38.0, Pest 5.3, Boost 2.2.
- Filament 5.10 panel at `/admin`, branded RedEast login/theme; Shield 4.3 with
  `super_admin`, `admin`, `staff`, `customer` roles.
- Sanctum installed; `GET /api/v1/health` returns 200.
- R2 S3 disk, Scramble, and Intervention Image installed.
- Neon/R2 placeholders in `.env` and `.env.example`; local `.env` stays SQLite.
- Admin panel access: `admin@redeast.agency` (super_admin) and
  `customer@redeast.agency` (customer); local password `password`.
- Boost generated root `AGENTS.md`, `CLAUDE.md`, `boost.json`, and four skills in
  `.agents/skills/`.
- `vendor/` and `node_modules/` stay inside the project: Composer autoload
  resolves relative to `vendor/`, so moving it breaks Artisan. Both are ignored
  by Git; caches belong on Storage.
- Tests: Pest 5/5 (admin access, customer denial, API health).

## 11. Known gaps / next work

1. Build catalog schema/admin/API and seed 20 demo products (Phase 2).
2. Build auth/cart/checkout/orders (Phase 3).
3. Reviews/wishlist/notifications/reports/localization/tests (Phase 4).
4. Add real Neon/R2 credentials in `.env` and verify the remote disks.
5. Replace the seeded local password before any deployment.

## 12. Decisions to preserve

- One repo, backend inside `backend/`, one PR; no nested Git.
- `/api/v1` versioning; Sanctum for app tokens; Filament session for staff.
- Integer cents for money; transactions for commerce writes; idempotent orders.
- R2 for production media; local public disk in development.
- RedEast design-only; no business data import.
