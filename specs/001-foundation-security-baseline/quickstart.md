# Quickstart: Phase 0 Foundation and Security Baseline

## Prerequisites

- Flutter SDK compatible with Dart SDK constraint `^3.11.4`
- Project dependencies resolved with `flutter pub get`
- Non-production Supabase public configuration available

## Environment Configuration

Provide public runtime values through environment-specific configuration:

```bash
flutter run \
  --dart-define=BRINGLY_ENV=development \
  --dart-define=SUPABASE_URL=https://jeqfsnsnpigvdpmlhqmh.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=<publishable-anon-key>
```

Rules:

- Do not commit service-role keys, private keys, payment credentials, passwords,
  or production secrets.
- Do not print `SUPABASE_ANON_KEY` in logs or CI output.
- Use fake data only for UI-state demonstrations.

## Validation Commands

```bash
flutter pub get
flutter analyze
flutter test
```

Verified local toolchain on 2026-05-29:

- Flutter `3.41.6`
- Dart `3.11.4`

## Manual Smoke Validation

1. Start the app with valid development configuration.
2. Confirm the app opens to the foundation shell.
3. Visit startup, configuration/status, connectivity, and UI-state demo
   destinations.
4. Run the connectivity check and confirm it uses only non-sensitive
   reachability status.
5. Run the protected storage smoke test and confirm it writes, reads, deletes,
   and leaves no harmless validation value behind.
6. Start the app with missing configuration and confirm a safe blocked state.
7. Confirm no sensitive values appear in UI text, logs, analytics payloads, or
   normal local storage.

## CI Expectation

Create a minimal repository workflow that runs:

```bash
flutter pub get
flutter analyze
flutter test
```

The workflow must not echo secrets or sensitive runtime values.

## Implementation Notes

- Verified routes: `/`, `/config`, `/connectivity`, `/ui-states`
- `flutter analyze` passes
- `flutter test` passes
