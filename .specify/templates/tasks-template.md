---

description: "Task list template for feature implementation"
---

# Tasks: [FEATURE NAME]

**Input**: Design documents from `/specs/[###-feature-name]/`

**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, contracts/

**Tests**: Tests are REQUIRED for Bringly features. Include success, failure, loading, empty, unauthorized, blocked, and relevant edge states.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Path Conventions

- **Flutter app**: `lib/features/[feature]/`, `lib/core/`, `lib/design_system/`, `test/features/[feature]/`, `integration_test/`
- **Feature internals**: `presentation/`, `application/`, `domain/`, `data/`
- **Supabase/backend boundary**: backend-controlled actions belong behind repositories/data sources, Edge Functions, RPCs, or backend API clients

<!--
  ============================================================================
  IMPORTANT: The tasks below are SAMPLE TASKS for illustration purposes only.

  The /speckit-tasks command MUST replace these with actual tasks based on:
  - User stories from spec.md (with their priorities P1, P2, P3...)
  - Feature requirements from plan.md
  - Entities from data-model.md
  - Endpoints from contracts/

  Tasks MUST be organized by user story so each story can be:
  - Implemented independently
  - Tested independently
  - Delivered as an MVP increment

  DO NOT keep these sample tasks in the generated tasks.md file.
  ============================================================================
-->

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Project initialization and basic structure

- [ ] T001 Create Flutter feature structure per implementation plan
- [ ] T002 Configure required Flutter dependencies and generated-code tooling
- [ ] T003 [P] Configure linting, formatting, and analysis rules

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core infrastructure that MUST be complete before ANY user story can be implemented

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

Examples of foundational tasks (adjust based on your project):

- [ ] T004 Establish Clean Architecture boundaries for the feature
- [ ] T005 [P] Implement repository/data-source abstractions for Supabase or backend APIs
- [ ] T006 [P] Add privacy-safe error handling, logging, and analytics paths
- [ ] T007 Create domain entities/value objects that all stories depend on
- [ ] T008 Configure environment-specific Supabase/backend configuration without hardcoded secrets
- [ ] T009 Verify backend-controlled authorization and state-transition assumptions

**Checkpoint**: Foundation ready - user story implementation can now begin in parallel

---

## Phase 3: User Story 1 - [Title] (Priority: P1) 🎯 MVP

**Goal**: [Brief description of what this story delivers]

**Independent Test**: [How to verify this story works on its own]

### Tests for User Story 1

> **NOTE: Write these tests FIRST, ensure they FAIL before implementation**

- [ ] T010 [P] [US1] Unit tests for domain/use-case behavior in test/features/[feature]/[name]_test.dart
- [ ] T011 [P] [US1] Widget tests for loading, empty, error, blocked, and success states in test/features/[feature]/[screen]_test.dart
- [ ] T012 [P] [US1] Authorization or backend-boundary test for unauthorized and tampered-state attempts

### Implementation for User Story 1

- [ ] T013 [P] [US1] Create domain entity/value object in lib/features/[feature]/domain/
- [ ] T014 [P] [US1] Create immutable DTO/model in lib/features/[feature]/data/ if needed
- [ ] T015 [US1] Implement use case in lib/features/[feature]/application/ (depends on T013)
- [ ] T016 [US1] Implement repository/data source in lib/features/[feature]/data/ (depends on T014, T015)
- [ ] T017 [US1] Implement UI in lib/features/[feature]/presentation/
- [ ] T018 [US1] Add safe validation, user-safe errors, and redacted logging

**Checkpoint**: At this point, User Story 1 should be fully functional and testable independently

---

## Phase 4: User Story 2 - [Title] (Priority: P2)

**Goal**: [Brief description of what this story delivers]

**Independent Test**: [How to verify this story works on its own]

### Tests for User Story 2

- [ ] T019 [P] [US2] Unit tests for domain/use-case behavior in test/features/[feature]/[name]_test.dart
- [ ] T020 [P] [US2] Widget tests for loading, empty, error, blocked, and success states in test/features/[feature]/[screen]_test.dart

### Implementation for User Story 2

- [ ] T021 [P] [US2] Create or extend domain model in lib/features/[feature]/domain/
- [ ] T022 [US2] Implement use case/repository changes in lib/features/[feature]/
- [ ] T023 [US2] Implement UI state and navigation in lib/features/[feature]/presentation/
- [ ] T024 [US2] Integrate with User Story 1 components if needed

**Checkpoint**: At this point, User Stories 1 AND 2 should both work independently

---

## Phase 5: User Story 3 - [Title] (Priority: P3)

**Goal**: [Brief description of what this story delivers]

**Independent Test**: [How to verify this story works on its own]

### Tests for User Story 3

- [ ] T025 [P] [US3] Unit tests for domain/use-case behavior in test/features/[feature]/[name]_test.dart
- [ ] T026 [P] [US3] Widget tests for loading, empty, error, blocked, and success states in test/features/[feature]/[screen]_test.dart

### Implementation for User Story 3

- [ ] T027 [P] [US3] Create or extend domain model in lib/features/[feature]/domain/
- [ ] T028 [US3] Implement use case/repository changes in lib/features/[feature]/
- [ ] T029 [US3] Implement UI state and navigation in lib/features/[feature]/presentation/

**Checkpoint**: All user stories should now be independently functional

---

[Add more user story phases as needed, following the same pattern]

---

## Phase N: Polish & Cross-Cutting Concerns

**Purpose**: Improvements that affect multiple user stories

- [ ] TXXX [P] Documentation updates in docs/ or README.md
- [ ] TXXX Code cleanup and Clean Architecture boundary review
- [ ] TXXX Performance optimization across all stories
- [ ] TXXX [P] Additional unit/widget/integration tests for risk areas
- [ ] TXXX Security and privacy hardening
- [ ] TXXX Supabase RLS/storage policy or backend authorization verification
- [ ] TXXX Run quickstart.md validation

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion - BLOCKS all user stories
- **User Stories (Phase 3+)**: All depend on Foundational phase completion
  - User stories can then proceed in parallel (if staffed)
  - Or sequentially in priority order (P1 → P2 → P3)
- **Polish (Final Phase)**: Depends on all desired user stories being complete

### User Story Dependencies

- **User Story 1 (P1)**: Can start after Foundational (Phase 2) - No dependencies on other stories
- **User Story 2 (P2)**: Can start after Foundational (Phase 2) - May integrate with US1 but should be independently testable
- **User Story 3 (P3)**: Can start after Foundational (Phase 2) - May integrate with US1/US2 but should be independently testable

### Within Each User Story

- Tests MUST be written and FAIL before implementation where behavior is new
- Domain entities before use cases
- Use cases before repositories and presentation wiring
- Core implementation before integration
- Story complete before moving to next priority

### Parallel Opportunities

- All Setup tasks marked [P] can run in parallel
- All Foundational tasks marked [P] can run in parallel (within Phase 2)
- Once Foundational phase completes, all user stories can start in parallel (if team capacity allows)
- All tests for a user story marked [P] can run in parallel
- Domain and data files within a story marked [P] can run in parallel
- Different user stories can be worked on in parallel by different team members

---

## Parallel Example: User Story 1

```bash
# Launch all tests for User Story 1 together:
Task: "Unit tests for domain/use-case behavior in test/features/[feature]/[name]_test.dart"
Task: "Widget tests for loading, empty, error, blocked, and success states"

# Launch all models for User Story 1 together:
Task: "Create domain entity/value object in lib/features/[feature]/domain/"
Task: "Create immutable DTO/model in lib/features/[feature]/data/"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational (CRITICAL - blocks all stories)
3. Complete Phase 3: User Story 1
4. **STOP and VALIDATE**: Test User Story 1 independently
5. Deploy/demo if ready

### Incremental Delivery

1. Complete Setup + Foundational → Foundation ready
2. Add User Story 1 → Test independently → Deploy/Demo (MVP!)
3. Add User Story 2 → Test independently → Deploy/Demo
4. Add User Story 3 → Test independently → Deploy/Demo
5. Each story adds value without breaking previous stories

### Parallel Team Strategy

With multiple developers:

1. Team completes Setup + Foundational together
2. Once Foundational is done:
   - Developer A: User Story 1
   - Developer B: User Story 2
   - Developer C: User Story 3
3. Stories complete and integrate independently

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to specific user story for traceability
- Each user story should be independently completable and testable
- Verify tests fail before implementing
- Commit after each task or logical group
- Stop at any checkpoint to validate story independently
- Avoid: vague tasks, same file conflicts, cross-story dependencies that break independence
