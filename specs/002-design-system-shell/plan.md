# Implementation Plan: Phase 1 Design System and App Experience Shell

**Branch**: `002-design-system-shell` | **Date**: 2026-05-29 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `specs/002-design-system-shell/spec.md`

## Summary

Build the Phase 1 reusable UI foundation for Bringly: a Cupertino-first
marketplace app shell with four primary placeholder tabs, a reachable
non-primary Design System Demo route, reusable trust-oriented components, and
widget tests for navigation and component states. The implementation extends the
Phase 0 Flutter foundation under `app/`, `design_system/`, and a new
feature-first app shell area without adding auth, marketplace business logic,
backend state transitions, sensitive storage, or real personal/payment/document
data.

## Technical Context

**Language/Version**: Dart SDK constraint `^3.11.4` with Flutter SDK compatible
with the existing project. Local `flutter --version` did not return before the
20 second planning timeout; Phase 0 quickstart previously recorded Flutter
`3.41.6` and Dart `3.11.4`.

**Primary Dependencies**: Flutter, flutter_riverpod, go_router,
supabase_flutter through existing Phase 0 configuration only,
flutter_secure_storage abstraction from Phase 0, cupertino_icons,
flutter_lints, flutter_test.

**Storage**: No new storage for Phase 1. Demo data is static, fake, and
non-sensitive. Secure storage remains available only through Phase 0
abstractions and is not used by design system demo components.

**Testing**: `flutter analyze`, `flutter test`, focused widget tests for shell
navigation, Design System Demo reachability, component normal/loading/disabled
/error states, and loading/empty/blocked/error screens.

**Target Platform**: iOS-first Flutter mobile app with Android compatibility.
Use Cupertino interaction patterns and avoid protected third-party trade dress.

**Project Type**: Flutter mobile app using feature-first Clean Architecture.

**Performance Goals**: Shell tab switches and demo route navigation should feel
immediate on mobile; component demos should avoid unnecessary async work,
network calls, storage writes, or rebuild-heavy state. Static demo lists should
use lightweight widgets and stable test keys.

**Constraints**: No hardcoded secrets; no service-role keys; no raw Supabase,
payment, provider, or token internals in UI; no client-authoritative
marketplace state changes; no real PII, payment, document, receipt, travel, or
risk data; no sensitive logs, analytics, crash context, or local storage writes.

**Scale/Scope**: Phase 1 covers the shell and reusable UI only. Shopper,
Traveler, Activity, and Profile are safe placeholders. Authentication, profile
editing, verification, requests, trips, matching, offers, payments, evidence,
handover, disputes, ratings, notifications, and backend-controlled marketplace
state remain out of scope.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- Security before features: PASS. The plan adds no secrets, private keys,
  payment credentials, direct database access, or sensitive decision logic.
- Backend-controlled lifecycle: PASS. Phase 1 placeholders cannot trigger
  critical marketplace state transitions; all future actions remain unavailable.
- Clean Architecture: PASS. Reusable UI belongs in `lib/design_system/`, app
  shell routing belongs in `lib/app/router/`, and shell placeholder feature code
  belongs under `lib/features/app_shell/` with presentation/application/domain
  boundaries where useful.
- Privacy minimization: PASS. Demo content is fake and non-sensitive; components
  must not write to logs, analytics, crash contexts, normal local storage, or
  secure storage.
- Testable MVP discipline: PASS. The plan stays inside Phase 1 and requires
  tests for navigation plus normal, loading, disabled, error, empty, and blocked
  component states.

## Project Structure

### Documentation (this feature)

```text
specs/002-design-system-shell/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   ├── component-contract.md
│   └── navigation-shell.md
├── checklists/
│   └── requirements.md
└── tasks.md              # Created later by /speckit-tasks
```

### Source Code (repository root)

```text
lib/
├── app/
│   ├── app.dart
│   ├── router/
│   │   └── app_router.dart
│   └── theme/
│       └── bringly_theme.dart
├── design_system/
│   ├── components/
│   │   ├── bringly_button.dart
│   │   ├── bringly_card.dart
│   │   ├── bringly_text_field.dart
│   │   ├── cupertino_bottom_action_sheet.dart
│   │   ├── evidence_tile.dart
│   │   ├── price_breakdown_card.dart
│   │   ├── request_card.dart
│   │   ├── status_chip.dart
│   │   ├── traveler_card.dart
│   │   ├── trust_badge.dart
│   │   └── verification_status_banner.dart
│   ├── layouts/
│   │   ├── foundation_scaffold.dart
│   │   └── marketplace_shell_scaffold.dart
│   └── tokens/
│       ├── bringly_colors.dart
│       ├── bringly_radii.dart
│       └── bringly_spacing.dart
└── features/
    ├── app_shell/
    │   ├── application/
    │   ├── domain/
    │   │   └── entities/
    │   │       └── marketplace_destination.dart
    │   └── presentation/
    │       ├── activity_placeholder_screen.dart
    │       ├── design_system_demo_screen.dart
    │       ├── marketplace_shell.dart
    │       ├── profile_placeholder_screen.dart
    │       ├── shopper_placeholder_screen.dart
    │       └── traveler_placeholder_screen.dart
    └── foundation/
        └── ... existing Phase 0 foundation code

test/
├── app/
├── design_system/
│   └── components/
└── features/
    └── app_shell/
        ├── domain/
        └── presentation/
```

**Structure Decision**: Extend the existing Phase 0 structure with a dedicated
`features/app_shell/` feature for marketplace shell placeholders and demo route
composition, while keeping reusable widgets in `design_system/`. This avoids
putting future marketplace business concerns in shared UI and keeps the demo
screen separate from production primary tabs.

## Complexity Tracking

No constitution violations or extra complexity are required for Phase 1.

## Phase 0: Research

See [research.md](research.md). All planning unknowns were resolved without
needing additional clarification.

## Phase 1: Design and Contracts

See:

- [data-model.md](data-model.md)
- [contracts/navigation-shell.md](contracts/navigation-shell.md)
- [contracts/component-contract.md](contracts/component-contract.md)
- [quickstart.md](quickstart.md)

## Post-Design Constitution Check

- Security before features: PASS. Contracts explicitly prohibit backend state
  changes, sensitive demo data, and provider internals.
- Backend-controlled lifecycle: PASS. Future actions are represented only as
  blocked/unavailable placeholder messages.
- Clean Architecture: PASS. Domain entities describe destinations, component
  state, demo data, and placeholder messages; widgets render those values
  without owning marketplace decisions.
- Privacy minimization: PASS. Demo data validation rejects real or sensitive
  identity, payment, document, receipt, travel, token, and risk-like values.
- Testable MVP discipline: PASS. Quickstart and contracts define automated and
  manual checks for navigation, demo reachability, state variants, accessibility,
  and safe placeholder copy.
