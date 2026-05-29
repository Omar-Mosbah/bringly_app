# Tasks: Phase 0 Foundation and Security Baseline

**Input**: Design documents from `/specs/001-foundation-security-baseline/`

**Prerequisites**: [plan.md](plan.md), [spec.md](spec.md), [research.md](research.md), [data-model.md](data-model.md), [contracts/](contracts/), [quickstart.md](quickstart.md)

**Tests**: Required. Write tests before implementation for new behavior and cover success, failure, loading, empty, blocked, offline, and edge states.

**Organization**: Tasks are grouped by user story so each story can be implemented and tested independently after the shared foundation is complete.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel because it touches different files and has no dependency on incomplete tasks
- **[Story]**: Required only in user story phases
- Every task includes exact file paths for a coding model to modify or create

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Prepare dependencies, directories, CI, and baseline documentation before feature code.

- [X] T001 Update `pubspec.yaml` to add `flutter_riverpod`, `go_router`, and `flutter_secure_storage` dependencies while keeping `supabase_flutter`
- [X] T002 Run dependency resolution and update `pubspec.lock` with the dependencies from `pubspec.yaml`
- [X] T003 Replace the default counter entry point in `lib/main.dart` with a bootstrap that calls `BringlyApp`
- [X] T004 Create app foundation directories in `lib/app/config/`, `lib/app/router/`, `lib/app/theme/`, `lib/core/`, `lib/design_system/`, and `lib/features/foundation/`
- [X] T005 Create test directories in `test/app/`, `test/core/`, `test/design_system/`, and `test/features/foundation/`
- [X] T006 [P] Create `.github/workflows/ci.yml` to run dependency resolution, analysis, and automated tests without echoing secrets
- [X] T007 [P] Update `README.md` with Phase 0 validation commands and safe `--dart-define` configuration examples from `specs/001-foundation-security-baseline/quickstart.md`
- [X] T008 [P] Create `lib/app/theme/bringly_theme.dart` with a minimal Cupertino-first theme boundary
- [X] T009 [P] Create `lib/design_system/tokens/bringly_colors.dart` with neutral, success, warning, danger, and accent color tokens
- [X] T010 [P] Create `lib/design_system/tokens/bringly_spacing.dart` with spacing tokens used by foundation screens
- [X] T011 [P] Create `lib/design_system/tokens/bringly_radii.dart` with radius tokens of 8px or less for cards and controls

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core abstractions and value objects required before any user story implementation.

**CRITICAL**: No user story work should begin until this phase is complete.

- [X] T012 Create `lib/app/config/app_environment.dart` with the `AppEnvironment` enum for development, staging, and production
- [X] T013 Create `lib/app/config/app_config.dart` to read `BRINGLY_ENV`, `SUPABASE_URL`, and `SUPABASE_ANON_KEY` from runtime defines without logging full values
- [X] T014 Create `lib/core/errors/app_failure.dart` with safe failure codes for invalid configuration, unavailable, timeout, offline, storage failure, and unexpected failure
- [X] T015 [P] Create `lib/core/logging/redactor.dart` with fake-value-aware redaction for tokens, email, phone, payment, document, receipt, travel proof, backend secret, provider error, and risk data categories
- [X] T016 [P] Create `lib/core/logging/safe_logger.dart` with a logger interface that accepts safe messages and redacted metadata only
- [X] T017 [P] Create `lib/core/analytics/analytics_event.dart` with allowlisted event names and safe metadata value types
- [X] T018 [P] Create `lib/core/analytics/analytics_reporter.dart` with a no-op implementation for Phase 0
- [X] T019 [P] Create `lib/core/storage/protected_storage.dart` with a mockable read/write/delete abstraction
- [X] T020 [P] Create `lib/core/storage/flutter_secure_protected_storage.dart` implementing `ProtectedStorage` with `flutter_secure_storage`
- [X] T021 [P] Create `lib/core/storage/memory_protected_storage.dart` for tests and non-sensitive smoke-test verification
- [X] T022 Create `lib/features/foundation/domain/entities/environment_profile.dart` with fields and validation issue codes from `data-model.md`
- [X] T023 Create `lib/features/foundation/domain/entities/connectivity_check_result.dart` with statuses `idle`, `loading`, `success`, `unavailable`, `timeout`, `invalidConfiguration`, `offline`, and `failed`
- [X] T024 Create `lib/features/foundation/domain/entities/foundation_destination.dart` with allowed destination ids `startup`, `configurationStatus`, `connectivity`, and `uiStateDemo`
- [X] T025 Create `lib/features/foundation/domain/entities/baseline_ui_state.dart` with loading, empty, error, blocked, offline, and success kinds
- [X] T026 Create `lib/features/foundation/domain/entities/protected_storage_smoke_test_result.dart` with statuses `notRun`, `running`, `passed`, `writeFailed`, `readFailed`, `deleteFailed`, and `skipped`
- [X] T027 Create `lib/features/foundation/domain/entities/validation_checklist.dart` with analysis, tests, security baseline, CI, and remaining issues fields
- [X] T028 Create `lib/features/foundation/domain/entities/repository_check_result.dart` with pending, running, passed, failed, and cancelled statuses
- [X] T029 [P] Create `test/core/logging/redactor_test.dart` covering redaction of fake tokens, emails, phone numbers, payment strings, document strings, receipt strings, travel proof strings, provider errors, and risk data
- [X] T030 [P] Create `test/core/analytics/analytics_reporter_test.dart` verifying unsafe metadata is rejected or redacted before reporting
- [X] T031 [P] Create `test/core/storage/memory_protected_storage_test.dart` covering read, write, delete, missing-key, and replacement behavior
- [X] T032 [P] Create `test/features/foundation/domain/environment_profile_test.dart` covering valid profiles, missing URL, missing key, invalid URL, and unsupported environment names
- [X] T033 [P] Create `test/features/foundation/domain/connectivity_check_result_test.dart` covering allowed statuses, retry rules, and safe messages
- [X] T034 [P] Create `test/features/foundation/domain/foundation_destination_test.dart` verifying only Phase 0 destinations are allowed and marketplace destinations are rejected
- [X] T035 [P] Create `test/features/foundation/domain/protected_storage_smoke_test_result_test.dart` covering pass and partial-failure status mapping

**Checkpoint**: Foundational value objects and cross-cutting safety abstractions are ready for user stories.

---

## Phase 3: User Story 1 - Launch the Baseline App Shell (Priority: P1)

**Goal**: The app opens to a foundation shell, supports only startup, configuration/status, connectivity, and UI-state demo destinations, and shows safe blocked behavior for invalid configuration.

**Independent Test**: Run the app with valid and invalid runtime configuration, navigate to every foundation destination, and verify no marketplace destinations appear.

### Tests for User Story 1

- [X] T036 [P] [US1] Create router tests in `test/app/router/app_router_test.dart` for startup, configuration/status, connectivity, and UI-state demo routes only
- [X] T037 [P] [US1] Create app bootstrap widget tests in `test/app/bringly_app_test.dart` covering launch with valid config and blocked launch with invalid config
- [X] T038 [P] [US1] Create foundation navigation widget tests in `test/features/foundation/presentation/foundation_shell_test.dart` verifying all foundation destinations are reachable
- [X] T039 [P] [US1] Create marketplace exclusion tests in `test/features/foundation/presentation/foundation_navigation_scope_test.dart` verifying shopper, traveler, activity, profile, auth, payment, delivery, dispute, and notification routes are absent
- [X] T040 [P] [US1] Create baseline UI-state widget tests in `test/design_system/components/baseline_state_view_test.dart` covering loading, empty, error, blocked, offline, and success states

### Implementation for User Story 1

- [X] T041 [P] [US1] Create `lib/design_system/components/baseline_state_view.dart` for loading, empty, error, blocked, offline, and success state rendering
- [X] T042 [P] [US1] Create `lib/design_system/layouts/foundation_scaffold.dart` for consistent foundation screen layout
- [X] T043 [US1] Create `lib/app/router/app_router.dart` with routes for `/`, `/config`, `/connectivity`, and `/ui-states`
- [X] T044 [US1] Create `lib/app/app.dart` with `BringlyApp`, router wiring, theme wiring, and no marketplace routes
- [X] T045 [P] [US1] Create `lib/features/foundation/presentation/startup_screen.dart` showing initialization and safe blocked states
- [X] T046 [P] [US1] Create `lib/features/foundation/presentation/configuration_status_screen.dart` showing environment status without full keys
- [X] T047 [P] [US1] Create `lib/features/foundation/presentation/connectivity_screen.dart` with non-sensitive connectivity status placeholders and retry affordance
- [X] T048 [P] [US1] Create `lib/features/foundation/presentation/ui_state_demo_screen.dart` using fake data only
- [X] T049 [US1] Create `lib/features/foundation/presentation/foundation_shell.dart` to compose foundation navigation and destination content
- [X] T050 [US1] Update `lib/main.dart` to load `AppConfig`, create `BringlyApp`, and avoid printing runtime define values
- [X] T051 [US1] Replace default counter test in `test/widget_test.dart` with a Phase 0 shell smoke test or remove it after equivalent tests exist in `test/app/bringly_app_test.dart`

**Checkpoint**: User Story 1 is independently testable with app launch and foundation navigation only.

---

## Phase 4: User Story 2 - Verify Security and Privacy Guardrails (Priority: P1)

**Goal**: The foundation proves secrets, sensitive data, logging, analytics, storage, and future backend-controlled actions are constrained from the start.

**Independent Test**: Run fake sensitive values through logging/analytics/storage and confirm they are redacted, excluded, or kept inside the approved protected boundary.

### Tests for User Story 2

- [X] T052 [P] [US2] Create configuration validation tests in `test/features/foundation/application/validate_environment_profile_test.dart` for valid config, invalid config, and no connectivity attempt on invalid config
- [X] T053 [P] [US2] Create protected storage smoke-test use case tests in `test/features/foundation/application/run_protected_storage_smoke_test_test.dart` for passed, writeFailed, readFailed, deleteFailed, skipped, and cleanup-after-pass
- [X] T054 [P] [US2] Create safe logger integration tests in `test/core/logging/safe_logger_test.dart` proving fake sensitive values are absent from emitted messages and metadata
- [X] T055 [P] [US2] Create analytics guardrail tests in `test/core/analytics/noop_analytics_reporter_test.dart` proving unsafe metadata is excluded and safe event names are accepted
- [X] T056 [P] [US2] Create no-marketplace-state tests in `test/features/foundation/application/marketplace_scope_guard_test.dart` proving approval, payment, delivery, dispute, payout, auth, session, and profile actions are not available in Phase 0 APIs

### Implementation for User Story 2

- [X] T057 [P] [US2] Create `lib/features/foundation/application/validate_environment_profile.dart` to validate environment name, HTTPS Supabase URL, and publishable key presence without exposing key values
- [X] T058 [P] [US2] Create `lib/features/foundation/application/run_protected_storage_smoke_test.dart` using a harmless non-sensitive validation key/value and deleting it after validation
- [X] T059 [P] [US2] Create `lib/core/logging/in_memory_safe_logger.dart` for tests and local diagnostics with redacted metadata
- [X] T060 [P] [US2] Create `lib/core/analytics/noop_analytics_reporter.dart` that accepts only allowlisted safe metadata and sends nothing externally in Phase 0
- [X] T061 [US2] Create `lib/features/foundation/application/marketplace_scope_guard.dart` documenting and enforcing unavailable Phase 0 actions with safe failures
- [X] T062 [US2] Wire `ValidateEnvironmentProfile` into `lib/app/config/app_config.dart` so invalid profiles produce blocked status without backend calls
- [X] T063 [US2] Wire `RunProtectedStorageSmokeTest` into `lib/features/foundation/presentation/configuration_status_screen.dart` without storing auth-token-shaped or real user data
- [X] T064 [US2] Update `lib/features/foundation/presentation/foundation_shell.dart` to surface safe guardrail status without exposing sensitive values

**Checkpoint**: User Story 2 is independently testable through security/privacy guardrail tests and configuration/status UI.

---

## Phase 5: User Story 3 - Build Future Features on a Consistent Foundation (Priority: P2)

**Goal**: Developers have reusable configuration, communication, storage, errors, logging, analytics, UI-state, tests, and minimal CI foundations for later phases.

**Independent Test**: Run the non-business demonstration path, validate connectivity outcomes through the standard boundary, and confirm CI executes analysis and tests.

### Tests for User Story 3

- [X] T065 [P] [US3] Create backend connectivity contract tests in `test/features/foundation/data/backend_connectivity_client_test.dart` for success, unavailable, timeout, offline, invalidConfiguration, and failed outcomes
- [X] T066 [P] [US3] Create connectivity use case tests in `test/features/foundation/application/run_connectivity_check_test.dart` proving invalid config blocks calls and raw provider errors become safe failures
- [X] T067 [P] [US3] Create connectivity screen widget tests in `test/features/foundation/presentation/connectivity_screen_test.dart` covering loading, success, unavailable, timeout, offline, invalid configuration, safe error, and retry states
- [X] T068 [P] [US3] Create UI-state demo widget tests in `test/features/foundation/presentation/ui_state_demo_screen_test.dart` covering stable text for all baseline UI states
- [X] T069 [P] [US3] Create CI workflow static test or documentation check in `test/core/repository_check/ci_workflow_contract_test.dart` verifying `.github/workflows/ci.yml` contains dependency resolution, analysis, and test steps without secret echo commands

### Implementation for User Story 3

- [X] T070 [P] [US3] Create `lib/core/network/backend_connectivity_client.dart` interface for non-sensitive reachability checks only
- [X] T071 [P] [US3] Create `lib/features/foundation/data/supabase_connectivity_client.dart` implementing `BackendConnectivityClient` with no signed-in user, no session exposure, and no marketplace record reads
- [X] T072 [P] [US3] Create `lib/features/foundation/data/fake_connectivity_client.dart` for tests and UI-state demonstrations
- [X] T073 [P] [US3] Create `lib/features/foundation/application/run_connectivity_check.dart` to map client outcomes into `ConnectivityCheckResult`
- [X] T074 [US3] Wire `RunConnectivityCheck` into `lib/features/foundation/presentation/connectivity_screen.dart` with retry support and safe messages
- [X] T075 [US3] Update `lib/features/foundation/presentation/ui_state_demo_screen.dart` to render every `BaselineUiState` using `BaselineStateView`
- [X] T076 [US3] Create `lib/features/foundation/application/build_validation_checklist.dart` to produce `ValidationChecklist` status from analysis, test, security baseline, and CI inputs
- [X] T077 [US3] Create `lib/features/foundation/application/build_repository_check_result.dart` to model pending, running, passed, failed, and cancelled repository-check states
- [X] T078 [US3] Update `.github/workflows/ci.yml` to run `flutter pub get`, `flutter analyze`, and `flutter test` on push and pull request events

**Checkpoint**: User Story 3 is independently testable through connectivity boundary tests, UI-state demo tests, and CI workflow validation.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Final validation, documentation, cleanup, and security review across all Phase 0 stories.

- [X] T079 [P] Update `specs/001-foundation-security-baseline/quickstart.md` if implementation commands or route names changed
- [X] T080 [P] Update `README.md` with final Phase 0 run, analyze, test, and environment configuration instructions
- [X] T081 [P] Create `specs/001-foundation-security-baseline/checklists/security.md` with completed Phase 0 checks for no hardcoded secrets, no sensitive logs, no sensitive analytics, no direct marketplace DB access, no sensitive local storage, safe connectivity, and protected storage cleanup
- [X] T082 Run `flutter pub get` and ensure `pubspec.lock` matches `pubspec.yaml`
- [X] T083 Run `flutter analyze` and fix any issues in `lib/`, `test/`, and `.github/workflows/ci.yml`
- [X] T084 Run `flutter test` and fix any failing tests in `test/`
- [X] T085 Search `lib/`, `test/`, `.github/workflows/ci.yml`, `README.md`, and `specs/001-foundation-security-baseline/` for full Supabase anon key, service-role key patterns, token-like fake data, payment-like fake data, and accidental sensitive strings
- [X] T086 Verify `lib/features/foundation/presentation/foundation_shell.dart` exposes no shopper, traveler, activity, profile, auth, verification, payment, delivery, dispute, rating, notification, or support routes
- [X] T087 Verify `lib/features/foundation/data/supabase_connectivity_client.dart` performs no marketplace table reads, no marketplace table writes, no session reads, and no privileged calls
- [X] T088 Verify `lib/features/foundation/application/run_protected_storage_smoke_test.dart` deletes the harmless validation value after pass and after recoverable failures where possible
- [X] T089 Review `lib/core/logging/` and `lib/core/analytics/` to confirm sensitive metadata is redacted or rejected before it can leave the app
- [X] T090 Confirm `.github/workflows/ci.yml` does not echo `SUPABASE_ANON_KEY`, service-role keys, tokens, payment data, or any runtime secret value
- [X] T091 Record final implementation notes in `specs/001-foundation-security-baseline/quickstart.md`, including verified Flutter and Dart versions if local commands work

---

## Dependencies & Execution Order

### Phase Dependencies

- **Phase 1 Setup**: No dependencies.
- **Phase 2 Foundational**: Depends on Phase 1. Blocks all user stories.
- **Phase 3 US1**: Depends on Phase 2. Provides launchable shell and foundation navigation.
- **Phase 4 US2**: Depends on Phase 2. Can run after or alongside US1 where files do not overlap, but final UI wiring depends on US1 shell files.
- **Phase 5 US3**: Depends on Phase 2. Connectivity screen wiring depends on US1 screen files.
- **Phase 6 Polish**: Depends on all selected user stories.

### User Story Dependencies

- **US1 Launch the Baseline App Shell**: MVP slice. Must be completed first for a visible demo.
- **US2 Verify Security and Privacy Guardrails**: Shares the app config and shell from US1, but guardrail domain/application tests can begin after Phase 2.
- **US3 Build Future Features on a Consistent Foundation**: Uses US1 presentation surfaces and US2 safety abstractions for final wiring.

### Within Each User Story

- Write tests first and confirm they fail for new behavior.
- Create or update domain entities before use cases.
- Create interfaces before implementations.
- Wire presentation after application/data logic exists.
- Complete each checkpoint before moving to dependent phases.

### Parallel Opportunities

- Setup tasks T006-T011 can run in parallel after T001-T005 are understood.
- Foundational tasks T015-T021 and T029-T035 can run in parallel because they touch different files.
- US1 test tasks T036-T040 can run in parallel.
- US1 screen/component tasks T041-T048 can run in parallel after router and config expectations are known.
- US2 test tasks T052-T056 can run in parallel.
- US2 implementation tasks T057-T061 can run in parallel before wiring tasks T062-T064.
- US3 test tasks T065-T069 can run in parallel.
- US3 implementation tasks T070-T073 can run in parallel before wiring tasks T074-T078.
- Polish documentation tasks T079-T081 can run in parallel before final command validation.

---

## Parallel Example: User Story 1

```text
Task: T036 Create router tests in test/app/router/app_router_test.dart
Task: T037 Create app bootstrap widget tests in test/app/bringly_app_test.dart
Task: T038 Create foundation navigation widget tests in test/features/foundation/presentation/foundation_shell_test.dart
Task: T039 Create marketplace exclusion tests in test/features/foundation/presentation/foundation_navigation_scope_test.dart
Task: T040 Create baseline UI-state widget tests in test/design_system/components/baseline_state_view_test.dart
```

## Parallel Example: User Story 2

```text
Task: T052 Create configuration validation tests in test/features/foundation/application/validate_environment_profile_test.dart
Task: T053 Create protected storage smoke-test use case tests in test/features/foundation/application/run_protected_storage_smoke_test_test.dart
Task: T054 Create safe logger integration tests in test/core/logging/safe_logger_test.dart
Task: T055 Create analytics guardrail tests in test/core/analytics/noop_analytics_reporter_test.dart
Task: T056 Create no-marketplace-state tests in test/features/foundation/application/marketplace_scope_guard_test.dart
```

## Parallel Example: User Story 3

```text
Task: T065 Create backend connectivity contract tests in test/features/foundation/data/backend_connectivity_client_test.dart
Task: T066 Create connectivity use case tests in test/features/foundation/application/run_connectivity_check_test.dart
Task: T067 Create connectivity screen widget tests in test/features/foundation/presentation/connectivity_screen_test.dart
Task: T068 Create UI-state demo widget tests in test/features/foundation/presentation/ui_state_demo_screen_test.dart
Task: T069 Create CI workflow static test or documentation check in test/core/repository_check/ci_workflow_contract_test.dart
```

---

## Implementation Strategy

### MVP First

1. Complete Phase 1 and Phase 2.
2. Complete Phase 3 / US1.
3. Stop and validate that the app launches, foundation-only navigation works, invalid config blocks safely, and no marketplace route is exposed.

### Incremental Delivery

1. Add US1 for the visible app shell.
2. Add US2 for security and privacy guardrails.
3. Add US3 for reusable backend connectivity, CI, and future-feature foundation.
4. Run Phase 6 polish checks before moving to Phase 1 of the product roadmap.

### Model-Friendly Execution Notes

- Implement tasks in numeric order unless working on a `[P]` task explicitly listed as parallel.
- Do not add shopper, traveler, activity, profile, auth, verification, payment, delivery, dispute, rating, notification, or support routes.
- Do not introduce real user data, real document data, real payment data, real receipt data, real travel proof, service-role keys, or admin credentials.
- Keep generated code out of Phase 0 unless a later task explicitly adds a generator.
- Prefer small, plain Dart value objects for Phase 0 entities.
- Every new public class should have at least one direct unit or widget test in the task list above.

## Notes

- [P] tasks use different files and have no direct dependency on incomplete tasks.
- Story labels map to user stories in [spec.md](spec.md).
- The suggested MVP scope is Phase 1, Phase 2, and Phase 3 / US1.
- Optional Git hooks may be run separately with `/speckit-git-commit`.
