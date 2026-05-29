# Implementation Plan: Phase 2 Authentication and User Profile

**Branch**: `003-auth-profile` | **Date**: 2026-05-30 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `specs/003-auth-profile/spec.md`

## Summary

Build the Phase 2 account entry, session, local unlock, and basic profile
foundation for Bringly. The implementation adds email/password registration and
login, email password reset, session restoration, logout, biometric or device
PIN local app unlock after login, profile summary/editing, role selection,
email confirmation gating, verification status display, and suspended/blocked
account handling. The mobile app remains a renderer and requester of account
state; backend-controlled account status, role eligibility, verification,
suspension, and forced logout remain authoritative.

## Technical Context

**Language/Version**: Dart SDK constraint `^3.11.4` with Flutter SDK compatible
with the existing project. Phase 1 planning recorded Flutter `3.41.6` and Dart
`3.11.4`.

**Primary Dependencies**: Flutter, flutter_riverpod, go_router,
supabase_flutter through existing runtime configuration, flutter_secure_storage
behind `ProtectedStorage`, local_auth or equivalent platform biometric/PIN
adapter behind a mockable abstraction, cupertino_icons, flutter_lints,
flutter_test.

**Storage**: Auth/session tokens only in secure storage through the existing
`core/storage/ProtectedStorage` abstraction. Non-sensitive profile display cache
is optional and may only contain display name, avatar reference, country/city,
preferred language, role label, and safe status labels.

**Testing**: `flutter analyze`, `flutter test`, focused unit tests for domain
entities/use cases/error mapping, widget tests for auth/profile/local unlock
states, router tests for auth gates, and integration tests for login,
restoration, logout, password reset, email confirmation blocking, local unlock,
and suspended account handling where feasible.

**Target Platform**: iOS-first Flutter mobile app with Android compatibility.
Biometric unlock must use native device capabilities with device PIN fallback
where the platform supports it.

**Project Type**: Flutter mobile app using feature-first Clean Architecture.

**Performance Goals**: App launch session check and local unlock should resolve
to the correct signed-in or signed-out state within 3 seconds under normal
network conditions. Auth forms and profile updates should provide immediate
local validation feedback and avoid unnecessary rebuilds or repeated network
requests.

**Constraints**: No hardcoded secrets; no service-role keys; no raw token,
credential, Supabase, provider, policy, risk, or suspension internals in logs,
analytics, or UI; no client-only authorization decisions; account status and
marketplace access remain backend-controlled; local biometric/PIN unlock does
not replace backend authentication or authorization.

**Scale/Scope**: Phase 2 covers authentication, local app unlock, basic profile,
role selection, email confirmation gating, verification status display, and
account restriction handling only. Identity document submission, phone
verification, government ID, liveness, payment/payout readiness, shopper
requests, traveler trips, matching, payments, evidence, delivery, disputes,
ratings, notifications, and admin workflows are out of scope.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- Security before features: PASS. The plan adds no secrets, service-role keys,
  payment credentials, admin capabilities, or client-authoritative security
  decisions. Credentials and tokens must never be logged.
- Backend-controlled lifecycle: PASS. Account status, email confirmation,
  verification, role eligibility, suspension, forced logout, and protected
  marketplace access are refreshed from backend-controlled state.
- Clean Architecture: PASS. Auth/profile presentation, application, domain, and
  data concerns are separated. Supabase auth/profile access, secure storage,
  and local unlock integrations sit behind mockable abstractions.
- Privacy minimization: PASS. Only basic profile fields are in Phase 2. No
  identity documents, payment data, receipts, travel proof, or risk scores are
  collected, cached, logged, or displayed.
- Testable MVP discipline: PASS. The plan stays inside Phase 2 and requires
  success, failure, loading, empty, unauthorized, blocked, and edge-state tests
  for auth, session, local unlock, profile, role, email confirmation, and
  suspension flows.

## Project Structure

### Documentation (this feature)

```text
specs/003-auth-profile/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   ├── auth-session-contract.md
│   ├── profile-account-contract.md
│   └── local-unlock-contract.md
├── checklists/
│   └── requirements.md
└── tasks.md              # Created later by /speckit-tasks
```

### Source Code (repository root)

```text
lib/
├── app/
│   ├── app.dart
│   ├── config/
│   └── router/
│       └── app_router.dart
├── core/
│   ├── errors/
│   ├── logging/
│   ├── security/
│   │   └── local_app_unlock.dart
│   └── storage/
│       └── protected_storage.dart
├── design_system/
│   ├── components/
│   └── layouts/
└── features/
    ├── auth/
    │   ├── application/
    │   │   ├── auth_controller.dart
    │   │   ├── request_password_reset.dart
    │   │   ├── restore_session.dart
    │   │   ├── sign_in_with_email.dart
    │   │   ├── sign_out.dart
    │   │   └── sign_up_with_email.dart
    │   ├── data/
    │   │   ├── auth_repository.dart
    │   │   ├── supabase_auth_repository.dart
    │   │   └── local_unlock_repository.dart
    │   ├── domain/
    │   │   ├── entities/
    │   │   │   ├── auth_failure.dart
    │   │   │   ├── auth_session.dart
    │   │   │   ├── email_confirmation_status.dart
    │   │   │   └── local_unlock_state.dart
    │   │   └── value_objects/
    │   │       ├── email_address.dart
    │   │       └── password_input.dart
    │   └── presentation/
    │       ├── login_screen.dart
    │       ├── local_unlock_screen.dart
    │       ├── onboarding_screen.dart
    │       ├── password_reset_screen.dart
    │       └── register_screen.dart
    ├── profile/
    │   ├── application/
    │   │   ├── load_profile_summary.dart
    │   │   ├── update_basic_profile.dart
    │   │   └── update_marketplace_role.dart
    │   ├── data/
    │   │   ├── profile_repository.dart
    │   │   └── supabase_profile_repository.dart
    │   ├── domain/
    │   │   ├── entities/
    │   │   │   ├── account_restriction.dart
    │   │   │   ├── marketplace_role.dart
    │   │   │   ├── user_profile.dart
    │   │   │   └── verification_status.dart
    │   │   └── value_objects/
    │   │       ├── country_city.dart
    │   │       ├── display_name.dart
    │   │       └── preferred_language.dart
    │   └── presentation/
    │       ├── profile_edit_screen.dart
    │       ├── profile_summary_screen.dart
    │       └── role_selection_screen.dart
    └── app_shell/
        └── presentation/
            └── marketplace_shell.dart

test/
├── core/
│   └── security/
├── features/
│   ├── auth/
│   │   ├── application/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   └── profile/
│       ├── application/
│       ├── data/
│       ├── domain/
│       └── presentation/
└── app/
    └── router/

integration_test/
└── auth_profile_flow_test.dart
```

**Structure Decision**: Implement account entry and session concerns in
`features/auth/`, profile and role/status concerns in `features/profile/`, and
device biometric/PIN access behind `core/security/` plus feature-level
repositories. Existing Phase 1 shell/profile placeholder routes are replaced or
guarded by Phase 2 auth/profile screens without moving reusable design-system
components into feature code.

## Complexity Tracking

No constitution violations or extra complexity are required for Phase 2.

## Phase 0: Research

See [research.md](research.md). All planning unknowns were resolved without
additional clarification.

## Phase 1: Design and Contracts

See:

- [data-model.md](data-model.md)
- [contracts/auth-session-contract.md](contracts/auth-session-contract.md)
- [contracts/profile-account-contract.md](contracts/profile-account-contract.md)
- [contracts/local-unlock-contract.md](contracts/local-unlock-contract.md)
- [quickstart.md](quickstart.md)

## Post-Design Constitution Check

- Security before features: PASS. Contracts prohibit logging tokens,
  credentials, raw provider errors, internal risk details, and sensitive account
  metadata. Session values remain behind secure storage.
- Backend-controlled lifecycle: PASS. Contracts define backend-owned status for
  email confirmation, verification, role eligibility, suspension, and forced
  logout; local app unlock is only a device access layer.
- Clean Architecture: PASS. Data adapters map provider responses to domain
  entities and safe failures; use cases and presentation depend on abstractions.
- Privacy minimization: PASS. Data model is limited to Phase 2 profile fields
  and safe status labels; identity documents and high-risk data are excluded.
- Testable MVP discipline: PASS. Quickstart and contracts define success,
  failure, unauthorized, loading, empty, blocked, local unlock, password reset,
  and account restriction checks.
