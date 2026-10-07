# agc_canteen

An Android POS canteen system to support the AGCL canteen.

## Configuration

Copy `.env.example` to `.env` and set the required values:

| Variable | Description |
|---|---|
| `BASE_URL` | REST API base URL (e.g. `https://api.example.com/`) |

**Security note:** `.env` is listed as a Flutter asset and is included in release APKs. Treat its values as extractable.

### Admin access code

The admin access code for the staff auth screen is **not** stored in `.env`; inject it at build time via `--dart-define`:

```bash
fvm flutter build apk --release --dart-define=ADMIN_ACCESS_CODE=<code>
# local run:
fvm flutter run --dart-define=ADMIN_ACCESS_CODE=<code>
```

A build without the define leaves the admin-gated settings tiles locked.

## Development (FVM)

This project uses [FVM](https://fvm.app) pinned to **Flutter 3.41.9** (Dart 3.11.5). Use `fvm` for all Flutter/Dart commands:

```bash
fvm install          # first-time setup
fvm flutter pub get
fvm flutter run
fvm dart run build_runner build --delete-conflicting-outputs
fvm flutter gen-l10n
fvm flutter analyze
```

Do not use the global `flutter` / `dart` binaries for this repo unless they match the pinned version.

## Localization

After editing `.arb` files, regenerate localizations:

```bash
fvm flutter gen-l10n
```

## Production testing

Before release, run through [PRODUCTION_TEST_CHECKLIST.md](PRODUCTION_TEST_CHECKLIST.md) on a release APK on target POS hardware.
