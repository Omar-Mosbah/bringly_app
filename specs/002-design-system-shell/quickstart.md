# Quickstart: Phase 1 Design System and App Experience Shell

## Prerequisites

- Flutter SDK compatible with Dart SDK constraint `^3.11.4`
- Project dependencies resolved with `flutter pub get`
- Phase 0 foundation implementation available
- Development Supabase public configuration available through dart defines when
  running the full app

## Environment Configuration

Use the same runtime configuration pattern established in Phase 0:

```bash
flutter run \
  --dart-define=BRINGLY_ENV=development \
  --dart-define=SUPABASE_URL=https://jeqfsnsnpigvdpmlhqmh.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=<publishable-anon-key>
```

Rules:

- Do not hardcode or print service-role keys, private keys, payment
  credentials, passwords, or production secrets.
- Keep the publishable anon key in runtime configuration, not feature code.
- Use fake non-sensitive demo data only.

## Implementation Checks

```bash
flutter pub get
dart analyze lib/ test/
flutter test
```

Implemented routes (Phase 1):

| Route | Screen |
|-------|--------|
| `/shopper` | Shopper placeholder (initial) |
| `/traveler` | Traveler placeholder |
| `/activity` | Activity placeholder |
| `/profile` | Profile placeholder with Design System link |
| `/design-system` | Design System Demo (non-primary route) |

Focused test areas:

- App shell launches with four primary tabs only.
- Shopper, Traveler, Activity, and Profile placeholders are reachable.
- Design System Demo is reachable from Profile or a discoverable
  foundation/developer area.
- Design System Demo is not a fifth primary tab.
- Required components appear in the demo.
- Normal, loading, disabled, error, empty, and blocked states are covered.
- Disabled controls do not invoke actions.
- Demo actions do not call backend state-changing APIs.

## Manual Smoke Validation

1. Start the app with valid development configuration.
2. Confirm the app opens to the Phase 1 marketplace shell.
3. Visit Shopper, Traveler, Activity, and Profile primary tabs.
4. Confirm each tab is a safe placeholder and does not expose business actions.
5. Open the Design System Demo from Profile or the chosen discoverable area.
6. Confirm the demo shows all required components:
   BringlyButton, BringlyCard, BringlyTextField, TrustBadge, StatusChip,
   PriceBreakdownCard, TravelerCard, RequestCard, EvidenceTile,
   VerificationStatusBanner, CupertinoBottomActionSheet, and state screens.
7. Confirm normal, loading, disabled, error, empty, and blocked states are
   visible or demonstrable.
8. Increase platform text scaling and verify text remains readable without
   overlapping controls.
9. Open and dismiss the bottom action sheet without taking action.
10. Confirm no real personal, payment, document, receipt, travel, token, or risk
    data appears in UI, logs, analytics, storage, or crash contexts.

## Out-of-Scope Validation

The following must remain unavailable in Phase 1:

- Authentication and logout
- Profile editing
- Verification submission
- Shopper request creation
- Traveler trip creation
- Matching, offers, payments, evidence upload, handover, disputes, ratings, and
  notifications
- Backend-controlled marketplace state transitions
