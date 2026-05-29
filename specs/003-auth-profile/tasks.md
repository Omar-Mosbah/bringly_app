# Tasks: Phase 2 Authentication and User Profile

**Input**: Design documents from `specs/003-auth-profile/`

**Prerequisites**: [plan.md](plan.md), [spec.md](spec.md), [research.md](research.md), [data-model.md](data-model.md), [contracts/](contracts/), [quickstart.md](quickstart.md)

**Tests**: Tests are REQUIRED for this Bringly feature. Cover success, failure, loading, empty, unauthorized, blocked, and edge states before marking a story complete.

**Organization**: Tasks are grouped by independently testable user story. Complete Phase 1 and Phase 2 first; then stories can be implemented in priority order.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel with other `[P]` tasks in the same phase when files do not overlap.
- **[Story]**: Maps to the spec user story (`US1` through `US6`).
- Every task includes an exact file or directory path. Do not implement outside the named path unless the task explicitly says to update another path.

## Hard Rules For Implementers

- Do not add hardcoded secrets, service-role keys, private keys, passwords, or payment credentials.
- Do not log auth tokens, credentials, PII, raw Supabase/provider errors, verification details, suspension reasons, or internal risk data.
- Do not store tokens in normal local storage; use `lib/core/storage/protected_storage.dart`.
- Do not let local biometric/PIN unlock replace backend authentication or authorization.
- Do not make protected marketplace authorization decisions only from local cached profile data.
- Do not implement Phase 3 identity document, phone verification, government ID, liveness, payment, shopper request, traveler trip, matching, evidence, delivery, dispute, rating, notification, or admin flows in these tasks.

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Prepare dependencies, folders, and explicit feature boundaries.

- [x] T001 Add `local_auth` dependency for biometric/device PIN support in `pubspec.yaml`; do not add any secret or provider credential.
- [x] T002 Run dependency resolution and commit only generated lockfile changes required by T001 in `pubspec.lock`.
- [x] T003 [P] Create auth feature directories in `lib/features/auth/application/`, `lib/features/auth/data/`, `lib/features/auth/domain/entities/`, `lib/features/auth/domain/value_objects/`, and `lib/features/auth/presentation/`.
- [x] T004 [P] Create profile feature directories in `lib/features/profile/application/`, `lib/features/profile/data/`, `lib/features/profile/domain/entities/`, `lib/features/profile/domain/value_objects/`, and `lib/features/profile/presentation/`.
- [x] T005 [P] Create local security directory in `lib/core/security/`.
- [x] T006 [P] Create auth test directories in `test/features/auth/application/`, `test/features/auth/data/`, `test/features/auth/domain/`, and `test/features/auth/presentation/`.
- [x] T007 [P] Create profile test directories in `test/features/profile/application/`, `test/features/profile/data/`, `test/features/profile/domain/`, and `test/features/profile/presentation/`.
- [x] T008 [P] Create local security test directory in `test/core/security/`.

**Checkpoint**: Directory and dependency setup exists; no user story behavior is implemented yet.

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Implement shared domain types, safe failures, local unlock abstraction, and fake repositories required by every user story.

**Critical**: Do not start user story implementation until this phase is complete.

- [x] T009 [P] Create `AuthFailure` safe failure taxonomy in `lib/features/auth/domain/entities/auth_failure.dart` with invalid input, invalid credentials, weak password, rate limited, offline, unauthorized, blocked, suspended, forced logout, service unavailable, local unlock failed, and unknown safe failure cases.
- [x] T010 [P] Create `EmailAddress` value object with validation in `lib/features/auth/domain/value_objects/email_address.dart`.
- [x] T011 [P] Create `PasswordInput` value object with non-empty and minimum-strength validation in `lib/features/auth/domain/value_objects/password_input.dart`.
- [x] T012 [P] Create `AuthSession` entity without token contents in `lib/features/auth/domain/entities/auth_session.dart`.
- [x] T013 [P] Create `EmailConfirmationStatus` enum/entity in `lib/features/auth/domain/entities/email_confirmation_status.dart`.
- [x] T014 [P] Create `LocalUnlockState` entity in `lib/features/auth/domain/entities/local_unlock_state.dart`.
- [x] T015 [P] Create `LocalAppUnlock` abstraction in `lib/core/security/local_app_unlock.dart` with check availability, request unlock, and reset methods.
- [x] T016 [P] Create fake `LocalAppUnlock` test adapter in `test/core/security/fake_local_app_unlock.dart`.
- [x] T017 [P] Create `MarketplaceRole` entity in `lib/features/profile/domain/entities/marketplace_role.dart`.
- [x] T018 [P] Create `VerificationStatus` entity in `lib/features/profile/domain/entities/verification_status.dart`.
- [x] T019 [P] Create `AccountRestriction` entity in `lib/features/profile/domain/entities/account_restriction.dart`.
- [x] T020 [P] Create `DisplayName` value object in `lib/features/profile/domain/value_objects/display_name.dart`.
- [x] T021 [P] Create `CountryCity` value object in `lib/features/profile/domain/value_objects/country_city.dart`.
- [x] T022 [P] Create `PreferredLanguage` value object in `lib/features/profile/domain/value_objects/preferred_language.dart`.
- [x] T023 [P] Create `UserProfile` entity in `lib/features/profile/domain/entities/user_profile.dart`.
- [x] T024 [P] Add domain tests for auth value objects and entities in `test/features/auth/domain/auth_domain_test.dart`.
- [x] T025 [P] Add domain tests for profile value objects and entities in `test/features/profile/domain/profile_domain_test.dart`.
- [x] T026 [P] Add local unlock abstraction tests in `test/core/security/local_app_unlock_test.dart`.
- [x] T027 Create `AuthRepository` contract in `lib/features/auth/data/auth_repository.dart` matching `contracts/auth-session-contract.md`.
- [x] T028 Create `ProfileRepository` contract in `lib/features/profile/data/profile_repository.dart` matching `contracts/profile-account-contract.md`.
- [x] T029 Create in-memory/fake auth repository for tests in `test/features/auth/data/fake_auth_repository.dart`.
- [x] T030 Create in-memory/fake profile repository for tests in `test/features/profile/data/fake_profile_repository.dart`.
- [x] T031 Create `LocalUnlockRepository` wrapper in `lib/features/auth/data/local_unlock_repository.dart` that maps platform/local unlock failures to `AuthFailure`.
- [x] T032 [P] Add repository contract tests for fake auth behavior in `test/features/auth/data/auth_repository_contract_test.dart`.
- [x] T033 [P] Add repository contract tests for fake profile behavior in `test/features/profile/data/profile_repository_contract_test.dart`.
- [x] T034 [P] Add local unlock repository tests in `test/features/auth/data/local_unlock_repository_test.dart`.

**Checkpoint**: Shared domain/repository foundations compile and tests fail or pass only for foundation behavior; no screens are wired yet.

---

## Phase 3: User Story 1 - Create Account and Start Safely (Priority: P1) MVP

**Goal**: A new visitor can onboard, register with email/password, choose shopper/traveler/both, and see safe guidance when email or verification is incomplete.

**Independent Test**: Register a new account with a role, land in the app/profile area, see role and verification/email status, and verify protected marketplace actions are blocked when email or verification is incomplete.

### Tests for User Story 1

- [x] T035 [P] [US1] Add registration use-case tests for success, invalid email, weak password, duplicate/unavailable email, rate limited, offline, and safe unknown failure in `test/features/auth/application/sign_up_with_email_test.dart`.
- [x] T036 [P] [US1] Add onboarding screen widget tests for signed-out loading, empty, normal, and navigation-to-register states in `test/features/auth/presentation/onboarding_screen_test.dart`.
- [x] T037 [P] [US1] Add register screen widget tests for valid submit, invalid input, loading, duplicate email, rate-limited, offline, and safe error states in `test/features/auth/presentation/register_screen_test.dart`.
- [x] T038 [P] [US1] Add role selection tests for shopper, traveler, both, unavailable role, unauthorized, and backend rejected eligibility in `test/features/profile/application/update_marketplace_role_test.dart`.
- [x] T039 [P] [US1] Add protected marketplace gate tests for unconfirmed email and incomplete verification in `test/features/auth/application/protected_marketplace_gate_test.dart`.

### Implementation for User Story 1

- [x] T040 [P] [US1] Implement `SignUpWithEmail` use case in `lib/features/auth/application/sign_up_with_email.dart`.
- [x] T041 [P] [US1] Implement `UpdateMarketplaceRole` use case in `lib/features/profile/application/update_marketplace_role.dart`.
- [x] T042 [US1] Implement `AuthController` registration state handling in `lib/features/auth/application/auth_controller.dart`.
- [x] T043 [US1] Implement `ProfileController` role state handling in `lib/features/profile/application/profile_controller.dart`.
- [x] T044 [P] [US1] Implement onboarding screen in `lib/features/auth/presentation/onboarding_screen.dart`.
- [x] T045 [P] [US1] Implement register screen in `lib/features/auth/presentation/register_screen.dart`.
- [x] T046 [P] [US1] Implement role selection screen in `lib/features/profile/presentation/role_selection_screen.dart`.
- [x] T047 [US1] Implement protected marketplace gate use case in `lib/features/auth/application/protected_marketplace_gate.dart`.
- [x] T048 [US1] Wire registration, role selection, and blocked marketplace guidance into routes in `lib/app/router/app_router.dart`.
- [x] T049 [US1] Add safe copy for unconfirmed email and incomplete verification blocked states in `lib/features/auth/presentation/auth_blocked_state_view.dart`.
- [x] T050 [US1] Ensure registration and blocked-state flows never log credentials, tokens, raw provider errors, or sensitive status internals in `lib/features/auth/application/auth_controller.dart`.

**Checkpoint**: User Story 1 is independently functional and testable as the MVP entry flow.

---

## Phase 4: User Story 2 - Log In and Restore Session (Priority: P1)

**Goal**: A returning user can log in, complete biometric/device PIN unlock, restore a valid session after restart, and safely handle expired or invalid sessions.

**Independent Test**: Log in with valid credentials, require local unlock before account content, restart with valid session, restore after unlock, and reject expired/revoked/corrupted sessions.

### Tests for User Story 2

- [x] T051 [P] [US2] Add sign-in use-case tests for success, invalid credentials, rate limited, offline, blocked/suspended, and safe unknown failure in `test/features/auth/application/sign_in_with_email_test.dart`.
- [x] T052 [P] [US2] Add session restoration tests for valid, missing, expired, revoked, corrupted, unauthorized, backend unavailable, and forced logout states in `test/features/auth/application/restore_session_test.dart`.
- [x] T053 [P] [US2] Add local unlock use-case tests for available, unavailable, disabled, cancelled, failed, locked out, device PIN fallback, and success states in `test/features/auth/application/require_local_unlock_test.dart`.
- [x] T054 [P] [US2] Add login screen widget tests for success, loading, invalid credentials, offline, rate-limited, blocked, and safe errors in `test/features/auth/presentation/login_screen_test.dart`.
- [x] T055 [P] [US2] Add local unlock screen widget tests for required, in progress, unlocked, failed, cancelled, locked out, unavailable, and sign-out states in `test/features/auth/presentation/local_unlock_screen_test.dart`.
- [x] T056 [P] [US2] Add router tests for signed-out, signed-in-locked, signed-in-unlocked, invalid config, and expired session routing in `test/app/router/auth_router_test.dart`.

### Implementation for User Story 2

- [x] T057 [P] [US2] Implement `SignInWithEmail` use case in `lib/features/auth/application/sign_in_with_email.dart`.
- [x] T058 [P] [US2] Implement `RestoreSession` use case in `lib/features/auth/application/restore_session.dart`.
- [x] T059 [P] [US2] Implement `RequireLocalUnlock` use case in `lib/features/auth/application/require_local_unlock.dart`.
- [x] T060 [US2] Extend `AuthController` for login, restoration, locked, unlocked, expired, unauthorized, and blocked states in `lib/features/auth/application/auth_controller.dart`.
- [x] T061 [P] [US2] Implement login screen in `lib/features/auth/presentation/login_screen.dart`.
- [x] T062 [P] [US2] Implement local unlock screen in `lib/features/auth/presentation/local_unlock_screen.dart`.
- [x] T063 [US2] Implement native local auth adapter in `lib/core/security/local_auth_app_unlock.dart` using `local_auth` behind `LocalAppUnlock`.
- [x] T064 [US2] Implement Supabase auth session adapter in `lib/features/auth/data/supabase_auth_repository.dart` without exposing token contents to domain entities.
- [x] T065 [US2] Wire startup session restoration and local unlock routing in `lib/app/router/app_router.dart`.
- [x] T066 [US2] Add app startup provider wiring for auth restoration and local unlock dependencies in `lib/main.dart`.

**Checkpoint**: User Stories 1 and 2 work independently; account content stays hidden until local unlock succeeds.

---

## Phase 5: User Story 3 - Log Out and Clear Access (Priority: P1)

**Goal**: A signed-in user can log out, clear local sensitive session values, and lose protected access after app restart even if server confirmation fails.

**Independent Test**: Log in, log out, restart the app, and confirm no authenticated or protected screens are accessible without logging in again.

### Tests for User Story 3

- [x] T067 [P] [US3] Add sign-out use-case tests for normal logout, offline server confirmation, missing session, forced local clear, and safe unknown failure in `test/features/auth/application/sign_out_test.dart`.
- [x] T068 [P] [US3] Add secure storage clearing tests for sign-out in `test/features/auth/data/auth_secure_storage_test.dart`.
- [x] T069 [P] [US3] Add logout UI tests for confirm, loading, local success, server unavailable, and signed-out navigation in `test/features/profile/presentation/logout_action_test.dart`.
- [x] T070 [P] [US3] Add router regression test that protected routes redirect after logout and app restart in `test/app/router/logout_router_test.dart`.

### Implementation for User Story 3

- [x] T071 [P] [US3] Implement `SignOut` use case in `lib/features/auth/application/sign_out.dart`.
- [x] T072 [US3] Extend `AuthController` logout handling in `lib/features/auth/application/auth_controller.dart`.
- [x] T073 [US3] Implement secure session deletion in `lib/features/auth/data/supabase_auth_repository.dart` using `ProtectedStorage`.
- [x] T074 [US3] Add logout action UI to profile summary in `lib/features/profile/presentation/profile_summary_screen.dart`.
- [x] T075 [US3] Reset local unlock state on sign-out in `lib/features/auth/data/local_unlock_repository.dart`.
- [x] T076 [US3] Wire signed-out navigation after logout in `lib/app/router/app_router.dart`.

**Checkpoint**: P1 auth MVP is complete: registration, login/restore/unlock, and logout all work with tests.

---

## Phase 6: User Story 4 - Recover Account Access (Priority: P2)

**Goal**: A registered user can request password reset by email without account enumeration leaks.

**Independent Test**: Request password reset for valid, unknown, malformed, and rate-limited emails and confirm safe messages do not reveal whether an account exists.

### Tests for User Story 4

- [x] T077 [P] [US4] Add password reset use-case tests for valid email, unknown email, malformed email, rate limited, offline, safe unknown failure, expired link, and already-used link in `test/features/auth/application/request_password_reset_test.dart`.
- [x] T078 [P] [US4] Add password reset screen widget tests for input validation, loading, success-safe response, rate-limited, offline, and safe errors in `test/features/auth/presentation/password_reset_screen_test.dart`.
- [x] T079 [P] [US4] Add account-enumeration safety tests proving known and unknown email responses use the same safe pattern in `test/features/auth/application/password_reset_enumeration_safety_test.dart`.

### Implementation for User Story 4

- [x] T080 [P] [US4] Implement `RequestPasswordReset` use case in `lib/features/auth/application/request_password_reset.dart`.
- [x] T081 [US4] Add password reset operation to `AuthRepository` implementation in `lib/features/auth/data/supabase_auth_repository.dart`.
- [x] T082 [US4] Implement password reset screen in `lib/features/auth/presentation/password_reset_screen.dart`.
- [x] T083 [US4] Add navigation from login screen to password reset screen in `lib/features/auth/presentation/login_screen.dart`.
- [x] T084 [US4] Add password reset route in `lib/app/router/app_router.dart`.
- [x] T085 [US4] Ensure password reset never logs submitted emails, reset tokens, reset links, or raw provider errors in `lib/features/auth/application/request_password_reset.dart`.

**Checkpoint**: Password recovery works independently and preserves account-enumeration safety.

---

## Phase 7: User Story 5 - View and Manage Basic Profile (Priority: P2)

**Goal**: A signed-in, locally unlocked user can view and update display name, avatar reference, country/city, preferred language, and role/status summary.

**Independent Test**: Open profile, see required fields and statuses, update allowed fields, change role within permitted rules, and verify restricted trust/account fields are read-only.

### Tests for User Story 5

- [x] T086 [P] [US5] Add load profile summary tests for loading, empty, success, unauthorized, blocked, offline, and safe unknown failure in `test/features/profile/application/load_profile_summary_test.dart`.
- [x] T087 [P] [US5] Add update basic profile tests for display name, avatar reference, country/city, preferred language, invalid fields, unauthorized, blocked, and offline in `test/features/profile/application/update_basic_profile_test.dart`.
- [x] T088 [P] [US5] Add profile summary widget tests for loading, empty, success, verification statuses, email statuses, account statuses, and safe blocked guidance in `test/features/profile/presentation/profile_summary_screen_test.dart`.
- [x] T089 [P] [US5] Add profile edit widget tests for valid update, invalid field validation, loading, success, failure, unauthorized, and blocked states in `test/features/profile/presentation/profile_edit_screen_test.dart`.
- [x] T090 [P] [US5] Add role selection widget tests for shopper, traveler, both, unavailable, backend rejected, unauthorized, and loading states in `test/features/profile/presentation/role_selection_screen_test.dart`.

### Implementation for User Story 5

- [x] T091 [P] [US5] Implement `LoadProfileSummary` use case in `lib/features/profile/application/load_profile_summary.dart`.
- [x] T092 [P] [US5] Implement `UpdateBasicProfile` use case in `lib/features/profile/application/update_basic_profile.dart`.
- [x] T093 [US5] Implement profile data adapter in `lib/features/profile/data/supabase_profile_repository.dart` with safe mapping of backend statuses.
- [x] T094 [US5] Implement profile summary screen in `lib/features/profile/presentation/profile_summary_screen.dart`.
- [x] T095 [US5] Implement profile edit screen in `lib/features/profile/presentation/profile_edit_screen.dart`.
- [x] T096 [US5] Replace Phase 1 profile placeholder with Phase 2 profile summary in `lib/features/app_shell/presentation/marketplace_shell.dart`.
- [x] T097 [US5] Add profile routes for summary, edit, and role selection in `lib/app/router/app_router.dart`.
- [x] T098 [US5] Ensure profile UI does not expose legal name, phone verification, address, identity document, payment, receipt, travel proof, internal risk score, or operational review fields in `lib/features/profile/presentation/profile_summary_screen.dart`.

**Checkpoint**: Basic profile viewing/editing and role/status display work independently.

---

## Phase 8: User Story 6 - Handle Suspended or Blocked Accounts (Priority: P2)

**Goal**: Backend suspended, blocked, or forced-logout states immediately prevent protected actions and show safe next steps.

**Independent Test**: Simulate suspended, blocked, and forced-logout backend responses and confirm protected actions are blocked, session clears when required, and UI does not expose internal risk details.

### Tests for User Story 6

- [ ] T099 [P] [US6] Add account restriction tests for active, suspended, blocked, forced logout required, and unavailable states in `test/features/profile/domain/account_restriction_test.dart`.
- [ ] T100 [P] [US6] Add forced logout use-case tests for clearing session, clearing local unlock state, routing signed out, and safe messages in `test/features/auth/application/forced_logout_test.dart`.
- [ ] T101 [P] [US6] Add suspended/blocked profile widget tests for safe next steps, hidden protected actions, no risk details, and retry behavior in `test/features/profile/presentation/account_restriction_banner_test.dart`.
- [ ] T102 [P] [US6] Add protected marketplace gate tests for suspended, blocked, forced logout, backend eligibility rejected, and stale cached profile in `test/features/auth/application/account_restriction_gate_test.dart`.

### Implementation for User Story 6

- [ ] T103 [US6] Extend `ProtectedMarketplaceGate` for suspended, blocked, forced logout, stale cached profile, and backend eligibility rejected states in `lib/features/auth/application/protected_marketplace_gate.dart`.
- [ ] T104 [US6] Extend `AuthController` to process forced logout status and clear sensitive local session values in `lib/features/auth/application/auth_controller.dart`.
- [ ] T105 [US6] Extend `ProfileController` to surface safe suspended/blocked account guidance in `lib/features/profile/application/profile_controller.dart`.
- [ ] T106 [P] [US6] Implement account restriction banner in `lib/features/profile/presentation/account_restriction_banner.dart`.
- [ ] T107 [US6] Integrate account restriction banner into profile summary in `lib/features/profile/presentation/profile_summary_screen.dart`.
- [ ] T108 [US6] Add router handling for forced logout and blocked protected routes in `lib/app/router/app_router.dart`.
- [ ] T109 [US6] Ensure suspended/blocked UI and logs omit suspension reasons, internal risk scores, policy internals, and operational notes in `lib/features/profile/presentation/account_restriction_banner.dart`.

**Checkpoint**: Suspended, blocked, and forced-logout accounts are safely handled everywhere Phase 2 exposes account state.

---

## Phase 9: Polish & Cross-Cutting Concerns

**Purpose**: Final checks that affect multiple stories and constitution compliance.

- [ ] T110 [P] Add integration test for register, local unlock, profile summary, blocked email/verification guidance, logout, and restart access denial in `integration_test/auth_profile_flow_test.dart`.
- [ ] T111 [P] Add privacy regression tests proving auth/profile flows do not log tokens, credentials, raw provider errors, PII, risk scores, or sensitive status internals in `test/features/auth/application/auth_privacy_logging_test.dart`.
- [ ] T112 [P] Add profile privacy regression tests proving legal name, phone verification, address, ID documents, payment data, receipts, and travel proof are absent from Phase 2 UI in `test/features/profile/presentation/profile_privacy_scope_test.dart`.
- [ ] T113 Run `dart format` on `lib/core/security/`, `lib/features/auth/`, `lib/features/profile/`, `test/core/security/`, `test/features/auth/`, and `test/features/profile/`.
- [ ] T114 Run `flutter analyze` from repository root and fix only Phase 2 issues in `lib/features/auth/`, `lib/features/profile/`, `lib/core/security/`, `test/features/auth/`, `test/features/profile/`, and `test/core/security/`.
- [ ] T115 Run `flutter test` from repository root and fix only Phase 2 regressions in `lib/features/auth/`, `lib/features/profile/`, `lib/core/security/`, `test/features/auth/`, `test/features/profile/`, and `test/core/security/`.
- [ ] T116 Review `lib/features/auth/` for Clean Architecture violations where presentation imports data adapters or domain imports Flutter/Supabase.
- [ ] T117 Review `lib/features/profile/` for Clean Architecture violations where presentation imports data adapters or domain imports Flutter/Supabase.
- [ ] T118 Review `lib/app/router/app_router.dart` to confirm invalid runtime configuration still shows Phase 0 blocked startup before auth/profile routes.
- [ ] T119 Update `specs/003-auth-profile/quickstart.md` only if implementation commands or test file names changed during task execution.

---

## Dependencies & Execution Order

### Phase Dependencies

- **Phase 1 Setup**: No dependencies.
- **Phase 2 Foundational**: Depends on Phase 1. Blocks every user story.
- **Phase 3 US1**: Depends on Phase 2. This is the MVP entry flow.
- **Phase 4 US2**: Depends on Phase 2 and integrates best after US1 registration entry exists.
- **Phase 5 US3**: Depends on Phase 2 and is safest after US2 session state exists.
- **Phase 6 US4**: Depends on Phase 2 and can run after US1 or in parallel with US5/US6.
- **Phase 7 US5**: Depends on Phase 2 and can run after US1 role/status entities exist.
- **Phase 8 US6**: Depends on Phase 2 and integrates with US2/US5 account state handling.
- **Phase 9 Polish**: Depends on all desired user stories being complete.

### User Story Dependencies

- **US1 Create Account and Start Safely**: Start after Phase 2. Suggested MVP scope.
- **US2 Log In and Restore Session**: Start after Phase 2; uses auth foundations and local unlock.
- **US3 Log Out and Clear Access**: Start after US2 or after auth session state exists.
- **US4 Recover Account Access**: Start after Phase 2; independent from profile.
- **US5 View and Manage Basic Profile**: Start after Phase 2; integrates with US1 role selection.
- **US6 Handle Suspended or Blocked Accounts**: Start after Phase 2; best after US2/US5 controllers exist.

### Within Each User Story

- Write tests first and confirm they fail for new behavior.
- Implement domain/value objects before use cases.
- Implement use cases before repository adapters and presentation wiring.
- Implement repository adapters behind interfaces; never call Supabase directly from widgets.
- Implement UI after state/use cases are available.
- Update routing last for each story so incomplete screens are not reachable.

## Parallel Opportunities

- T003-T008 can run in parallel after T001/T002 if dependency resolution is complete.
- T009-T026 can run in parallel because they target separate domain/security files.
- T027-T031 should happen before repository contract tests T032-T034.
- Tests within each user story marked `[P]` can be written in parallel.
- US4 password reset can run in parallel with US5 profile after Phase 2.
- US6 banner UI T106 can run in parallel with gate/controller work after account restriction entities exist.
- Polish tests T110-T112 can run in parallel after all story screens/use cases exist.

## Parallel Example: User Story 1

```text
Task: T035 Add registration use-case tests in test/features/auth/application/sign_up_with_email_test.dart
Task: T036 Add onboarding screen tests in test/features/auth/presentation/onboarding_screen_test.dart
Task: T037 Add register screen tests in test/features/auth/presentation/register_screen_test.dart
Task: T038 Add role selection use-case tests in test/features/profile/application/update_marketplace_role_test.dart
Task: T039 Add protected marketplace gate tests in test/features/auth/application/protected_marketplace_gate_test.dart
```

## Parallel Example: User Story 2

```text
Task: T051 Add sign-in use-case tests in test/features/auth/application/sign_in_with_email_test.dart
Task: T052 Add session restoration tests in test/features/auth/application/restore_session_test.dart
Task: T053 Add local unlock use-case tests in test/features/auth/application/require_local_unlock_test.dart
Task: T054 Add login screen tests in test/features/auth/presentation/login_screen_test.dart
Task: T055 Add local unlock screen tests in test/features/auth/presentation/local_unlock_screen_test.dart
Task: T056 Add auth router tests in test/app/router/auth_router_test.dart
```

## Parallel Example: User Story 5

```text
Task: T086 Add load profile summary tests in test/features/profile/application/load_profile_summary_test.dart
Task: T087 Add update basic profile tests in test/features/profile/application/update_basic_profile_test.dart
Task: T088 Add profile summary widget tests in test/features/profile/presentation/profile_summary_screen_test.dart
Task: T089 Add profile edit widget tests in test/features/profile/presentation/profile_edit_screen_test.dart
Task: T090 Add role selection widget tests in test/features/profile/presentation/role_selection_screen_test.dart
```

## Implementation Strategy

### MVP First

1. Complete Phase 1 and Phase 2.
2. Complete Phase 3 (US1) and validate registration, role selection, and safe blocked marketplace guidance.
3. Complete Phase 4 (US2) so returning users can log in, restore sessions, and unlock locally.
4. Complete Phase 5 (US3) so users can safely log out and clear local access.
5. Stop and run `flutter analyze` and `flutter test`.

### Full Phase 2 Delivery

1. Add US4 password reset.
2. Add US5 profile summary/editing.
3. Add US6 suspended/blocked/forced logout handling.
4. Complete Phase 9 polish and quickstart validation.

### Handoff Notes For A Smaller Model

- Follow task IDs in order unless a task is explicitly marked `[P]`.
- Keep changes inside the paths named by the current task.
- When a task says "safe", map raw provider/platform errors into domain failures and user-safe messages.
- If a task seems to require identity documents, phone verification, payments, receipts, travel proof, or admin powers, stop; that is outside Phase 2.
- If Supabase behavior is unavailable locally, implement the repository interface and fake repository tests first; leave real integration behind the adapter boundary.
