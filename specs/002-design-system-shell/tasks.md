# Tasks: Phase 1 Design System and App Experience Shell

**Input**: Design documents from `specs/002-design-system-shell/`

**Prerequisites**: [plan.md](plan.md), [spec.md](spec.md), [research.md](research.md), [data-model.md](data-model.md), [contracts/](contracts/), [quickstart.md](quickstart.md)

**Tests**: Required. The Phase 1 spec requires widget tests for shell navigation and component states, plus coverage for loading, empty, blocked, error, disabled, and normal states.

**Organization**: Tasks are grouped by user story so each story can be implemented and tested independently. Follow the order unless a task is marked `[P]`.

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Prepare directories and test helpers that all Phase 1 stories use.

- [x] T001 Create Phase 1 feature directories in `lib/features/app_shell/application/`, `lib/features/app_shell/domain/entities/`, `lib/features/app_shell/presentation/`, `test/features/app_shell/domain/`, and `test/features/app_shell/presentation/`
- [x] T002 Create design system component test directory in `test/design_system/components/`
- [x] T003 [P] Create shared widget test helper for Cupertino app pumping in `test/helpers/pump_bringly_widget.dart`
- [x] T004 [P] Create app shell router test fixture helpers reusing Phase 0 fake config in `test/features/app_shell/presentation/app_shell_test_helpers.dart`
- [x] T005 Review existing Phase 0 router and foundation tests in `lib/app/router/app_router.dart` and `test/app/router/app_router_test.dart` before changing routes

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Define shell/domain primitives and shared UI foundations before user story work.

**Critical**: No user story work should begin until this phase is complete.

- [x] T006 [P] Implement `MarketplaceDestinationId`, `MarketplaceDestination`, and safe placeholder definitions in `lib/features/app_shell/domain/entities/marketplace_destination.dart`
- [x] T007 [P] Implement `PlaceholderMessage` value object with safe titles, messages, optional action label, and blocked reason in `lib/features/app_shell/domain/entities/placeholder_message.dart`
- [x] T008 [P] Implement `ComponentState` enum and display helpers for normal, loading, disabled, error, empty, blocked, pending, success, and warning in `lib/design_system/components/component_state.dart`
- [x] T009 [P] Add domain tests for four primary destinations and no demo-as-primary-tab rule in `test/features/app_shell/domain/marketplace_destination_test.dart`
- [x] T010 [P] Add domain tests for placeholder copy not implying approval, payment, verification, delivery, dispute, payout, auth, or backend success in `test/features/app_shell/domain/placeholder_message_test.dart`
- [x] T011 Extend Bringly design tokens for Phase 1 component needs without one-note palettes in `lib/design_system/tokens/bringly_colors.dart`
- [x] T012 Extend Cupertino typography and theme affordances for Phase 1 components in `lib/app/theme/bringly_theme.dart`
- [x] T013 Implement shared `MarketplaceShellScaffold` layout with stable content constraints and no nested-card page sections in `lib/design_system/layouts/marketplace_shell_scaffold.dart`
- [x] T014 [P] Add widget tests for `MarketplaceShellScaffold` safe area, title rendering, and compact layout behavior in `test/design_system/components/marketplace_shell_scaffold_test.dart`

**Checkpoint**: Domain primitives, shared tokens, and shell layout are ready for user stories.

---

## Phase 3: User Story 1 - Navigate the Marketplace Shell (Priority: P1) MVP

**Goal**: Provide a polished app shell with Shopper, Traveler, Activity, and Profile primary tabs, each showing a safe placeholder and no marketplace actions.

**Independent Test**: Open the app, switch between Shopper, Traveler, Activity, and Profile, and verify each destination is reachable, preserves the shell, and exposes no request/trip/offer/payment/evidence/delivery/dispute/rating/notification action.

### Tests for User Story 1

- [x] T015 [P] [US1] Add widget test for four primary shell tabs only in `test/features/app_shell/presentation/marketplace_shell_test.dart`
- [x] T016 [P] [US1] Add widget test for switching Shopper, Traveler, Activity, and Profile placeholders in `test/features/app_shell/presentation/marketplace_shell_navigation_test.dart`
- [x] T017 [P] [US1] Add widget test that future marketplace action labels are absent from placeholders in `test/features/app_shell/presentation/placeholder_safety_test.dart`
- [x] T018 [P] [US1] Update router contract test to expect Phase 1 routes including four primary shell routes and demo route in `test/app/router/app_router_test.dart`

### Implementation for User Story 1

- [x] T019 [P] [US1] Implement Shopper placeholder screen with safe copy in `lib/features/app_shell/presentation/shopper_placeholder_screen.dart`
- [x] T020 [P] [US1] Implement Traveler placeholder screen with safe copy in `lib/features/app_shell/presentation/traveler_placeholder_screen.dart`
- [x] T021 [P] [US1] Implement Activity placeholder screen with safe copy in `lib/features/app_shell/presentation/activity_placeholder_screen.dart`
- [x] T022 [P] [US1] Implement Profile placeholder screen with safe copy and later demo entry point placeholder in `lib/features/app_shell/presentation/profile_placeholder_screen.dart`
- [x] T023 [US1] Implement four-tab Cupertino marketplace shell using `MarketplaceDestination` in `lib/features/app_shell/presentation/marketplace_shell.dart`
- [x] T024 [US1] Integrate Phase 1 shell routes into `createAppRouter` while preserving required Phase 0 foundation routes in `lib/app/router/app_router.dart`
- [x] T025 [US1] Update app launch wiring if needed so `/` displays the Phase 1 marketplace shell without bypassing configuration validation in `lib/main.dart`
- [x] T026 [US1] Ensure placeholders use no backend calls, storage writes, analytics events, or raw provider/internal wording in `lib/features/app_shell/presentation/`

**Checkpoint**: User Story 1 is complete when the shell and four safe placeholders pass tests independently.

---

## Phase 4: User Story 2 - Review Reusable Marketplace Components (Priority: P1)

**Goal**: Provide the Design System Demo route and all required reusable marketplace UI components with normal, loading, disabled, and error-ready states where applicable.

**Independent Test**: Open the Design System Demo from Profile or a discoverable foundation/developer area and verify every required component appears with fake non-sensitive data and required state variants.

### Tests for User Story 2

- [x] T027 [P] [US2] Add widget tests for `BringlyButton` normal, loading, disabled, and error-ready behavior in `test/design_system/components/bringly_button_test.dart`
- [x] T028 [P] [US2] Add widget tests for `BringlyCard` spacing, long text, status slot, and disabled tap behavior in `test/design_system/components/bringly_card_test.dart`
- [x] T029 [P] [US2] Add widget tests for `BringlyTextField` label, helper, validation, disabled, and error states in `test/design_system/components/bringly_text_field_test.dart`
- [x] T030 [P] [US2] Add widget tests for `TrustBadge` and `StatusChip` allowed statuses and safe labels in `test/design_system/components/status_indicators_test.dart`
- [x] T031 [P] [US2] Add widget tests for marketplace cards and tiles using fake data in `test/design_system/components/marketplace_cards_test.dart`
- [x] T032 [P] [US2] Add widget tests for `CupertinoBottomActionSheet` title, message, primary, secondary, destructive, and cancel actions in `test/design_system/components/cupertino_bottom_action_sheet_test.dart`
- [x] T033 [P] [US2] Add widget tests for Design System Demo reachability from Profile and non-primary route behavior in `test/features/app_shell/presentation/design_system_demo_navigation_test.dart`
- [x] T034 [P] [US2] Add widget tests that Design System Demo contains all required components and fake non-sensitive labels in `test/features/app_shell/presentation/design_system_demo_screen_test.dart`

### Implementation for User Story 2

- [x] T035 [P] [US2] Implement reusable button component in `lib/design_system/components/bringly_button.dart`
- [x] T036 [P] [US2] Implement reusable card component in `lib/design_system/components/bringly_card.dart`
- [x] T037 [P] [US2] Implement reusable text field component in `lib/design_system/components/bringly_text_field.dart`
- [x] T038 [P] [US2] Implement trust badge component in `lib/design_system/components/trust_badge.dart`
- [x] T039 [P] [US2] Implement status chip component in `lib/design_system/components/status_chip.dart`
- [x] T040 [P] [US2] Implement price breakdown card with fake-display-only API in `lib/design_system/components/price_breakdown_card.dart`
- [x] T041 [P] [US2] Implement traveler card with fake-display-only API in `lib/design_system/components/traveler_card.dart`
- [x] T042 [P] [US2] Implement request card with fake-display-only API in `lib/design_system/components/request_card.dart`
- [x] T043 [P] [US2] Implement evidence tile with no upload/download/storage behavior in `lib/design_system/components/evidence_tile.dart`
- [x] T044 [P] [US2] Implement verification status banner with safe non-authoritative wording in `lib/design_system/components/verification_status_banner.dart`
- [x] T045 [P] [US2] Implement Cupertino bottom action sheet helper in `lib/design_system/components/cupertino_bottom_action_sheet.dart`
- [x] T046 [US2] Replace or extend reusable state screen coverage from `BaselineStateView` for loading, empty, blocked, and error in `lib/design_system/components/bringly_state_view.dart`
- [x] T047 [US2] Create deterministic fake demo data and demo sections in `lib/features/app_shell/presentation/design_system_demo_data.dart`
- [x] T048 [US2] Implement Design System Demo screen rendering all required components and states in `lib/features/app_shell/presentation/design_system_demo_screen.dart`
- [x] T049 [US2] Add Profile entry point and route navigation to Design System Demo in `lib/features/app_shell/presentation/profile_placeholder_screen.dart`
- [x] T050 [US2] Add non-primary `/design-system` route to `createAppRouter` in `lib/app/router/app_router.dart`
- [x] T051 [US2] Verify demo actions are local only and do not call Supabase, storage, analytics, or backend state-changing APIs in `lib/features/app_shell/presentation/design_system_demo_screen.dart`

**Checkpoint**: User Story 2 is complete when the demo route renders every component and required state with fake safe data.

---

## Phase 5: User Story 3 - Validate Trustworthy Mobile UX Quality (Priority: P2)

**Goal**: Ensure the shell and components remain readable, accessible, and trustworthy with increased text scaling, compact layouts, long labels, state screens, and original marketplace-inspired styling.

**Independent Test**: Review shell and demo under increased text scaling and compact mobile constraints; verify text and controls do not overlap and loading, empty, blocked, and error states use clear safe wording.

### Tests for User Story 3

- [x] T052 [P] [US3] Add text scaling widget tests for marketplace shell placeholders in `test/features/app_shell/presentation/marketplace_shell_accessibility_test.dart`
- [x] T053 [P] [US3] Add compact viewport and long-label widget tests for Design System Demo sections in `test/features/app_shell/presentation/design_system_demo_accessibility_test.dart`
- [x] T054 [P] [US3] Add widget tests for loading, empty, blocked, and error state wording and action safety in `test/design_system/components/bringly_state_view_test.dart`
- [x] T055 [P] [US3] Add privacy/trade-dress regression test scanning demo labels for forbidden sensitive or third-party-brand wording in `test/features/app_shell/presentation/demo_content_safety_test.dart`

### Implementation for User Story 3

- [x] T056 [US3] Refine shell and placeholder layouts for increased text scaling and compact devices in `lib/features/app_shell/presentation/marketplace_shell.dart`
- [x] T057 [US3] Refine component layouts for long labels and stable dimensions in `lib/design_system/components/bringly_button.dart`, `lib/design_system/components/bringly_card.dart`, `lib/design_system/components/bringly_text_field.dart`, `lib/design_system/components/trust_badge.dart`, `lib/design_system/components/status_chip.dart`, `lib/design_system/components/price_breakdown_card.dart`, `lib/design_system/components/traveler_card.dart`, `lib/design_system/components/request_card.dart`, `lib/design_system/components/evidence_tile.dart`, `lib/design_system/components/verification_status_banner.dart`, `lib/design_system/components/cupertino_bottom_action_sheet.dart`, and `lib/design_system/components/bringly_state_view.dart`
- [x] T058 [US3] Refine demo screen section structure for scrollability and non-overlap under compact constraints in `lib/features/app_shell/presentation/design_system_demo_screen.dart`
- [x] T059 [US3] Add safe loading, empty, blocked, and error copy examples to demo data in `lib/features/app_shell/presentation/design_system_demo_data.dart`
- [x] T060 [US3] Review and adjust Bringly color/token usage to avoid copied third-party branding or one-note palettes in `lib/design_system/tokens/bringly_colors.dart`

**Checkpoint**: User Story 3 is complete when accessibility, compact layout, and safe-content tests pass.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Finish validation and documentation across Phase 1.

- [x] T061 [P] Update Phase 1 quickstart implementation notes with final routes and test commands in `specs/002-design-system-shell/quickstart.md`
- [x] T062 [P] Update any stale Phase 0 route wording affected by Phase 1 shell integration in `specs/001-foundation-security-baseline/quickstart.md`
- [x] T063 Run `dart format lib test` and fix formatting issues in `lib/` and `test/`
- [x] T064 Run `flutter analyze` and fix all analyzer findings in `lib/` and `test/`
- [x] T065 Run `flutter test` and fix failing tests in `test/`
- [x] T066 Perform final security/privacy review for no hardcoded secrets, no real PII/payment/document/travel/receipt/token/risk data, no sensitive logs, and no backend state-changing demo calls in `lib/`
- [x] T067 Perform Clean Architecture review that reusable UI remains in `lib/design_system/` and shell-specific presentation remains in `lib/features/app_shell/`

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies; start immediately.
- **Foundational (Phase 2)**: Depends on Setup; blocks all user stories.
- **US1 Marketplace Shell (Phase 3)**: Depends on Foundational; MVP increment.
- **US2 Design System Demo (Phase 4)**: Depends on Foundational and integrates with Profile entry from US1, but component implementation tasks can begin after Foundational if shell route wiring is coordinated.
- **US3 UX Quality (Phase 5)**: Depends on US1 and US2 because it validates the shell and demo together.
- **Polish (Phase 6)**: Depends on desired user stories being complete.

### User Story Dependencies

- **US1 (P1)**: First MVP slice; no dependency on US2 or US3.
- **US2 (P1)**: Can build components independently after Foundational; final route/demo acceptance depends on US1 Profile entry point.
- **US3 (P2)**: Depends on visible shell and demo components from US1 and US2.

### Within Each User Story

- Write tests first and confirm they fail before implementation.
- Domain/value objects before presentation wiring.
- Shared components before demo composition.
- Router integration after target screens exist.
- Story checkpoint must pass before moving to lower-priority story work.

## Parallel Opportunities

- T003 and T004 can run in parallel after T001.
- T006 through T010 can run in parallel because they touch separate domain/test files.
- T011 and T012 can run in parallel if token/theme changes are coordinated before component styling.
- T015 through T018 can run in parallel as tests before US1 implementation.
- T019 through T022 can run in parallel because each placeholder screen is separate.
- T027 through T034 can run in parallel as component/demo tests.
- T035 through T045 can run in parallel by component file.
- T052 through T055 can run in parallel as UX/privacy tests.
- T061 and T062 can run in parallel after implementation routes stabilize.

## Parallel Example: User Story 1

```text
Task: "T015 [US1] Add widget test for four primary shell tabs only in test/features/app_shell/presentation/marketplace_shell_test.dart"
Task: "T016 [US1] Add widget test for switching Shopper, Traveler, Activity, and Profile placeholders in test/features/app_shell/presentation/marketplace_shell_navigation_test.dart"
Task: "T017 [US1] Add widget test that future marketplace action labels are absent from placeholders in test/features/app_shell/presentation/placeholder_safety_test.dart"
Task: "T018 [US1] Update router contract test to expect Phase 1 routes including four primary shell routes and demo route in test/app/router/app_router_test.dart"
```

## Parallel Example: User Story 2

```text
Task: "T035 [US2] Implement reusable button component in lib/design_system/components/bringly_button.dart"
Task: "T036 [US2] Implement reusable card component in lib/design_system/components/bringly_card.dart"
Task: "T037 [US2] Implement reusable text field component in lib/design_system/components/bringly_text_field.dart"
Task: "T038 [US2] Implement trust badge component in lib/design_system/components/trust_badge.dart"
Task: "T039 [US2] Implement status chip component in lib/design_system/components/status_chip.dart"
```

## Implementation Strategy

### MVP First

1. Complete Setup and Foundational tasks T001-T014.
2. Complete US1 tasks T015-T026.
3. Validate the shell with `flutter test test/features/app_shell/presentation/marketplace_shell_test.dart test/features/app_shell/presentation/marketplace_shell_navigation_test.dart test/features/app_shell/presentation/placeholder_safety_test.dart test/app/router/app_router_test.dart`.
4. Stop and review before building the component demo.

### Incremental Delivery

1. Deliver US1 shell and placeholders.
2. Add US2 reusable components and demo route.
3. Add US3 accessibility, compact layout, content safety, and visual-quality hardening.
4. Finish Phase 1 with formatting, analysis, full tests, and security/privacy review.

### Implementation Guardrails for Claude Sonnet 4.6

- Do not introduce backend calls for Phase 1 demo or placeholders.
- Do not add dependencies unless a task explicitly requires it; use Flutter, Cupertino, Riverpod/go_router, and existing Phase 0 abstractions.
- Do not store demo data in secure storage, normal storage, analytics, logs, or crash contexts.
- Keep `Design System Demo` out of the primary tab bar.
- Prefer small, focused widgets with stable keys and constructor-driven display values.
- Preserve user or prior-agent changes in unrelated Phase 0 files.
- If `flutter analyze` or `flutter test` exposes pre-existing Phase 0 failures, report them separately instead of rewriting unrelated code.

## Notes

- `[P]` tasks touch different files and can run in parallel after their phase prerequisites.
- `[US1]`, `[US2]`, and `[US3]` map directly to the user stories in `spec.md`.
- Every task includes an exact path or path group.
- Avoid vague implementation: each component must have tests, stable labels/keys, safe fake data, and no business logic.
