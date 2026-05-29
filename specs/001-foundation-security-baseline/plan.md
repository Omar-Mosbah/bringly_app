# Implementation Plan: Phase 0 Foundation and Security Baseline

**Branch**: `001-foundation-security-baseline` | **Date**: 2026-05-29 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/001-foundation-security-baseline/spec.md`

## Summary

Build the Phase 0 Flutter foundation for Bringly: a launchable app shell with
foundation-only navigation, environment separation, non-sensitive Supabase
connectivity validation, protected storage smoke testing, privacy-safe logging
and analytics boundaries, reusable baseline UI states, automated tests, and a
minimal repository workflow. The implementation must not introduce shopper,
traveler, auth, payment, delivery, dispute, or other marketplace flows.

## Technical Context

**Language/Version**: Dart SDK `^3.11.4` from `pubspec.yaml`; Flutter SDK compatible with that constraint. Local `flutter --version` and `dart --version` commands timed out during planning and must be rechecked during implementation.

**Primary Dependencies**: Flutter SDK, `supabase_flutter` (already present), `flutter_lints`; planned Phase 0 additions: `flutter_riverpod`, `go_router`, `flutter_secure_storage`. Generated model tooling is deferred until a feature needs serializable business DTOs.

**Storage**: Supabase-backed backend boundary for non-sensitive connectivity only; protected storage abstraction for a harmless read/write/delete smoke test; no normal local storage for sensitive values.

**Testing**: `flutter test` unit and widget tests; targeted tests for configuration validation, connectivity result mapping, protected storage smoke-test outcomes, redaction behavior, foundation navigation, and baseline UI states.

**Target Platform**: iOS-first Flutter mobile app with Android compatibility.

**Project Type**: Flutter mobile app using feature-first Clean Architecture and shared `app/`, `core/`, and `design_system/` foundations.

**Performance Goals**: App shell opens and all foundation destinations are reachable in under 2 minutes for manual validation; connectivity and storage checks must expose loading, success, unavailable, timeout, invalid configuration, blocked, and offline outcomes without UI jank.

**Constraints**: No hardcoded secrets or service-role keys; no marketplace data access; no auth/session restoration; no client-only critical state transitions; no sensitive logs, analytics, crash context, or normal local storage.

**Scale/Scope**: Phase 0 only. Foundation routes are startup, configuration/status, connectivity, and baseline UI-state demo. Shopper, traveler, activity, profile, auth, verification, matching, offers, payments, evidence, delivery, disputes, ratings, and notifications are out of scope.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- Security before features: PASS. The plan uses environment configuration for
  publishable values, forbids secrets, and keeps Phase 0 to non-sensitive checks.
- Backend-controlled lifecycle: PASS. Phase 0 performs no marketplace state
  transitions and does not simulate future approval, payment, delivery, dispute,
  or payout actions locally.
- Clean Architecture: PASS. App, core, design system, and foundation feature
  boundaries are defined with integrations hidden behind abstractions.
- Privacy minimization: PASS. Smoke tests and demo data are non-sensitive only;
  logging and analytics are redacted by design.
- Testable MVP discipline: PASS. Scope is inside `PLAN.md` Phase 0 and includes
  tests for success, failure, loading, empty, blocked, offline, and edge states.

## Project Structure

### Documentation (this feature)

```text
specs/001-foundation-security-baseline/
├── spec.md
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   ├── backend-connectivity.md
│   └── foundation-ui.md
└── checklists/
    └── requirements.md
```

### Source Code (repository root)

```text
lib/
├── app/
│   ├── app.dart
│   ├── config/
│   ├── router/
│   └── theme/
├── core/
│   ├── analytics/
│   ├── errors/
│   ├── logging/
│   ├── network/
│   ├── security/
│   ├── storage/
│   ├── utils/
│   └── widgets/
├── design_system/
│   ├── components/
│   ├── cupertino_adapters/
│   ├── layouts/
│   └── tokens/
└── features/
    └── foundation/
        ├── application/
        ├── data/
        ├── domain/
        └── presentation/

test/
├── app/
├── core/
├── design_system/
└── features/
    └── foundation/

.github/
└── workflows/
    └── ci.yml
```

**Structure Decision**: Use the constitution's feature-first Clean Architecture
while keeping Phase 0 infrastructure in `app/`, `core/`, `design_system/`, and
`features/foundation/`. Platform directories remain generated Flutter host
projects and are not feature ownership locations.

## Complexity Tracking

No constitution violations require justification.

## Phase 0 Research Summary

Research is captured in [research.md](research.md). All planning unknowns were
resolved without requiring additional clarification.

## Phase 1 Design Summary

Design artifacts are captured in:

- [data-model.md](data-model.md)
- [contracts/backend-connectivity.md](contracts/backend-connectivity.md)
- [contracts/foundation-ui.md](contracts/foundation-ui.md)
- [quickstart.md](quickstart.md)

## Post-Design Constitution Check

- Security before features: PASS. Contracts explicitly forbid secrets,
  privileged credentials, session exposure, and marketplace records.
- Backend-controlled lifecycle: PASS. Backend interaction is limited to a
  non-sensitive reachability check with no reads/writes of marketplace data.
- Clean Architecture: PASS. Data model and contracts separate domain outcomes,
  data adapters, app routing, and presentation states.
- Privacy minimization: PASS. Protected storage smoke test uses a harmless value
  and requires cleanup; logs and analytics exclude sensitive values.
- Testable MVP discipline: PASS. Quickstart and contracts identify validation
  commands, CI expectations, and required test surfaces.
