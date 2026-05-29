# Bringly App

Bringly is a security-first Flutter marketplace app. Phase 0 builds only the
foundation shell, safe configuration validation, non-sensitive Supabase
reachability checks, protected storage smoke testing, and reusable UI-state
patterns.

## Phase 0 commands

```bash
flutter pub get
flutter analyze
flutter test
```

## Safe runtime configuration

```bash
flutter run \
  --dart-define=BRINGLY_ENV=development \
  --dart-define=SUPABASE_URL=https://jeqfsnsnpigvdpmlhqmh.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=<publishable-anon-key>
```

Only use the public project URL and publishable anon key here. Do not commit
service-role keys, private keys, passwords, payment credentials, or production
secrets.

## Phase 0 validation

- Launch the app and verify only `Startup`, `Configuration`, `Connectivity`,
  and `UI States` destinations are present.
- Confirm invalid configuration shows a blocked state before any backend check.
- Run the storage smoke test and confirm the harmless validation value is
  cleaned up.
- Run the connectivity check and confirm it shows safe status text only.
