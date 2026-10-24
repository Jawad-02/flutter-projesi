# CONTEXT.md — RedEast Store

Last verified: 2026-10-24.

## 1. What this project is

**RedEast Store** is a Flutter storefront for Android/iOS/Web, backed by a
Laravel API and admin dashboard in `backend/`. RedEast supplies the **brand and
design system only** — no RedEast business data or client project content is
part of this product.

Current state: the Flutter screens still use the mock catalog at
`https://wantapi.com/products.php`. The Laravel backend exists but is not wired
to the app yet. Migration to the backend API is Phase 2/3 work.

## 2. Repository layout (one repo, two apps)

```text
flutter-projesi/                    # git repo root (one PR)
├── AGENTS.md                       # entry point → .agents/
├── opencode.json                   # skills.paths (.agents/skills)
├── skills-lock.json                # installed skill versions (npx skills update)
├── .agents/
│   ├── AGENTS.md  CONTEXT.md  TASKS.md
│   ├── design/brand.md             # shared RedEast design system
│   └── skills/                     # 5 official Flutter/Dart skills
├── Makefile  local.mk              # Flutter run/build automation (local.mk ignored)
├── assets/brand/                   # logos + fonts (licensed)
├── lib/                            # Flutter app
│   └── theme/redeast_theme.dart    # RedEast ThemeData (light/dark)
├── test/
├── android/  ios/  web/
└── backend/                        # Laravel 13 API + Filament admin
    ├── AGENTS.md                   # entry point + Boost guidelines block
    ├── opencode.json               # skills.paths + laravel-boost MCP
    ├── .agents/
    │   ├── AGENTS.md  CONTEXT.md  TASKS.md
    │   ├── design/brand.md         # same design system
    │   └── skills/                 # Boost Laravel skills
    ├── app/
    │   └── Filament/               # admin resources (Phase 2+)
    ├── routes/api.php + api/v1.php # /api/v1 catalog API
    ├── public/brand/               # logos + fonts served to admin
    ├── resources/css/filament/admin/theme.css
    └── .env                        # local secrets (ignored)
```

The backend is intentionally **inside** this repo so the app and API can ship
in one PR. It has no nested `.git`.

## 3. Tech stack

### Flutter
| Area | Choice |
|---|---|
| Framework | Flutter 3.47.7 (stable), Dart 3.13.5, Material 3 |
| SDK constraint | `^3.12.2` |
| Runtime deps | none yet beyond Flutter (planned: go_router, provider, dio, flutter_secure_storage, cached_network_image, flutter_svg, intl, shared_preferences) |
| Dev deps | flutter_test, flutter_lints 6, flutter_launcher_icons, flutter_native_splash |
| State | `ChangeNotifier` + `CartModelScope` (`InheritedNotifier`) |
| HTTP | Custom conditional client (`dart:io` / `dart:html`) |
| Platforms | Android, iOS, Web |

### Backend
| Area | Choice |
|---|---|
| Framework | Laravel 13.38.0, PHP 8.4 |
| Testing | Pest 5.3 |
| AI tooling | Laravel Boost 2.2 (MCP + skills) |
| Admin | Filament 5.10 + Shield 4.3 at `/admin` |
| API auth | Laravel Sanctum, `/api/v1` |
| Roles | Filament Shield + spatie/laravel-permission |
| Database | SQLite locally; Neon Postgres in production (`DB_URL`) |
| Storage | Local `public` locally; Cloudflare R2 via S3 driver in production |
| Queue/cache/session | database |
| Build | Vite 8, Tailwind CSS 4 |

### Toolchain paths
```text
Flutter:  /home/jawad/Storage/flutter-3.47.7
Android:  /home/jawad/Storage/Android/sdk-linux
JDK 21:   /home/jawad/Storage/toolchains/jdk-21
Node 22:  /home/jawad/Storage/toolchains/node-22   # skills CLI only
Gradle:   /home/jawad/Storage/gradle
Backend:  PHP 8.4 + Composer 2.9 + system Node 20 for Vite
```

## 4. Design system

Read `.agents/design/brand.md` before any UI work. Summary:

- Charcoal `#363636` primary, gray `#9C9C9C` secondary, red `#ED2839` accent,
  white/black neutrals. Light surface `#F7F7F5`; dark surface `#111111`.
- Instrument Serif for display headings; Cabinet Grotesk for UI/body.
- Logos use the supplied SVGs; never redraw.
- Flutter: light-first with dark support; charcoal primary buttons, red accents.
- Filament: dark charcoal sidebar, light content, red active states.
- Assets go in `assets/brand/` (Flutter) and `backend/public/brand/` (backend).
- Implemented in Flutter: `lib/theme/redeast_theme.dart`, bundled fonts, native
  icon/splash, "RedEast Store" labels, bundle id `agency.redeast.store`.
- Implemented in Filament: brand logo/name/favicon, charcoal primary, Red East
  fonts in `resources/css/filament/admin/theme.css`.

## 5. Architecture (current Flutter)

```text
main()
  └── MainApp
        ├── CartModel
        ├── CartModelScope (InheritedNotifier)
        └── MaterialApp
              └── IndexedStack
                    ├── HomePage (mock API)
                    └── CartPage

HomePage → ApiService.fetchProducts() → HttpClientService
         → FutureBuilder → ProductCard → ProductDetailPage
```

Target architecture adds auth, catalog, cart, checkout, orders, wishlist,
reviews, and notifications backed by `/api/v1`.

## 6. API contract

- Local emulator: `http://10.0.2.2:8000/api/v1`
- Production: `https://api.redeast.agency/api/v1`
- Auth: Sanctum bearer tokens (customer abilities), JSON resources.
- **Live now:**
  - `GET /api/v1/health`
  - `GET /api/v1/products` (`category`, `brand`, `search`, `min_price`,
    `max_price`, `featured`, `sort`, `per_page`)
  - `GET /api/v1/products/{slug}`
  - `GET /api/v1/categories` / `{slug}`
  - `GET /api/v1/brands` / `{slug}`
- Planned: `/auth/*`, `/cart`, `/coupons/validate`, `/shipping/methods`,
  `/checkout/quote`, `/orders`, `/addresses`, `/wishlist`, `/reviews`,
  `/notifications`.
- Flutter now calls the Laravel API (`ApiConfig`), not `wantapi.com` directly.

## 7. Commands

```bash
# Flutter (repo root; Makefile exports the environment)
make run            # boot emulator if needed + flutter run
make app            # install prebuilt APK
make analyze        # --no-fatal-infos; 2 accepted dart:html infos
make test           # fails on stale widget test
make build          # debug APK
make stop

# Backend (from backend/)
php artisan serve
npm run dev
npm run build
php artisan test --compact
vendor/bin/pint --dirty --format agent
php artisan migrate --seed
```

## 8. Current backend state

- Laravel 13.38.0, Pest 5.3, Boost 2.2 installed.
- Boost generated root `AGENTS.md`, `CLAUDE.md`, `boost.json`, and skills in
  `.agents/skills/` (`infer-conventions`, `laravel-best-practices`,
  `testing-best-practices`, `tailwindcss-development`).
- Phase 0 added backend `.agents` docs, the shared brand spec, `skills.paths` in
  `backend/opencode.json`, and SQLite ignore rules.
- `backend/vendor` and `backend/node_modules` stay inside the project:
  Composer's autoloader resolves paths relative to `vendor/`, so moving it to
  Storage breaks `artisan`. They are Git-ignored; npm/Composer caches live on
  Storage.
- Phase 1 installed Filament 5.10 + Shield, Sanctum (`/api/v1`), R2 S3 driver,
  Scramble, and Intervention Image.
- `.env` uses SQLite + local disk; Neon/R2 placeholders are present in
  `.env`/`.env.example`; the `r2` disk is configured.
- Admin: `/admin`, branded login; `admin@redeast.agency` (super_admin) and
  `customer@redeast.agency` (customer) seeded with local password `password`.
- Phase 2 added catalog schema/models/factories, 7 categories, 1 brand, 20
  seeded products/variants/images, catalog API, and Filament Catalog resources.
- The Flutter app now fetches products/categories from the backend and shows
  category chips; product detail and local cart use the API data.
- Tests: Pest 11/11 (auth, admin pages, catalog API, health).

## 9. Planned feature phases

| Phase | Scope |
|---|---|
| 0 | ✅ `.agents` refactor, 5 skills, design spec, git/disk hygiene |
| 1 | ✅ Brand assets/theme, Filament + Sanctum, Neon/R2 env, DB foundation |
| 2 | ✅ Catalog schema, admin CRUD, API, seed data, Flutter catalog |
| 3 | Auth, cart, checkout, orders, inventory, coupons, shipping/tax, manual payments |
| 4 | Reviews, wishlist, notifications, search, reports, roles, localization, tests/CI |

## 10. Known issues / technical debt

| # | Issue | Location | Impact |
|---|---|---|---|
| 1 | Widget test expects `Home`/`Cart`; UI renders `Ana Sayfa`/`Sepet` | `test/widget_test.dart:12` | `flutter test` fails |
| 2 | `Navigator.pushNamed(context, '/cart')` has no route | `product_detail_page.dart:197`, `main.dart` | Detail cart icon / snackbar action throws |
| 3 | Detail button label uses `cart.totalItems` | `product_detail_page.dart:183` | Misleading |
| 4 | TLS accepts any certificate | `http_client_io.dart:9` | Demo only; remove before production |
| 5 | `dart:html` deprecated | `http_client_web.dart:2` | 2 accepted analyzer infos |
| 6 | No error/empty-state tests | `test/` | Low coverage |
| 7 | Cart not persisted; checkout is a stub | cart model/page | Will be replaced by backend |
| 8 | iOS build impossible on Linux | `ios/` | Environment |
| 9 | Emulator is slow under host load | AVD | Use 480x1040/4-vCPU AVD; prefer `make app` |
| 10 | `make run` rebuilds via Gradle (~10 min first time) | Makefile | Use `make app` for quick checks |
| 11 | Shield permissions not generated for catalog resources | `app/Filament` | Only `super_admin` bypass works; run `shield:generate` before staff roles |
| 12 | Demo images are external wantapi URLs | `CatalogSeeder` | Replace with R2 media before release |
| 13 | Admin price inputs are labeled in cents | `ProductForm` | Usability; add a money input later |
| 14 | API base URL defaults to `10.0.2.2` for the emulator | `lib/config/api_config.dart` | Physical device needs `--dart-define=API_BASE_URL=...` |

Do not fix these unless they are in `TASKS.md`.

## 11. Decisions to preserve

- RedEast is design-only; no business data import.
- Backend stays inside this repo for a single PR; no nested Git repo.
- Keep one API version prefix `/api/v1`.
- Money is stored as integer cents in the backend.
- Keep the Flutter app dependency-light until each dependency is approved.
- Keep the Turkish UI; add English through localization, not by replacing Turkish.
- Keep assets/fonts bundled; do not rely on runtime font CDNs.
