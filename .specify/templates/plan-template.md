# Implementation Plan: [FEATURE]

**Branch**: `[###-feature-name]` | **Date**: [DATE] | **Spec**: [link]

**Input**: Feature specification from `/specs/[###-feature-name]/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command. See `.specify/templates/plan-template.md` for the execution workflow.

## Summary

[Extract from feature spec: primary requirement + technical approach from research]

## Technical Context

<!--
  ACTION REQUIRED: Replace the content in this section with the technical details
  for the project. The structure here is presented in advisory capacity to guide
  the iteration process.
-->

**Language/Version**: Dart [version] with Flutter [version] or NEEDS CLARIFICATION

**Primary Dependencies**: Flutter, Riverpod, go_router, Supabase client or backend API client, freezed/json_serializable, flutter_secure_storage abstraction or NEEDS CLARIFICATION

**Storage**: Supabase-backed backend state; secure storage for small sensitive values only; non-sensitive cache only if justified

**Testing**: flutter test, widget tests, integration_test, golden tests where UI risk warrants

**Target Platform**: iOS-first Flutter mobile app with Android compatibility or NEEDS CLARIFICATION

**Project Type**: Flutter mobile app using feature-first Clean Architecture

**Performance Goals**: Smooth mobile interactions, responsive marketplace lists/forms, efficient image upload flows, no avoidable rebuild hot spots

**Constraints**: Backend-controlled state transitions, no hardcoded secrets, no sensitive logs/analytics, signed uploads, privacy-safe local storage

**Scale/Scope**: Controlled MVP corridor and approved low-risk item categories unless PLAN.md is amended

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- Security before features: Does this plan avoid hardcoded secrets, private keys,
  payment credentials, sensitive logs, and client-only authorization decisions?
- Backend-controlled lifecycle: Are all critical marketplace state transitions
  performed by Supabase-backed server-side logic, Edge Functions, RPCs with
  strict authorization, or backend APIs?
- Clean Architecture: Are presentation, application/use-case, domain, and data
  concerns separated, with integrations behind testable abstractions?
- Privacy minimization: Are identity, travel, payment, receipt, document, and
  risk data collected, stored, displayed, logged, and analyzed only as required?
- Testable MVP discipline: Are success, failure, loading, empty, unauthorized,
  blocked, and edge states covered, and is the scope inside the current PLAN.md
  phase boundary?

## Project Structure

### Documentation (this feature)

```text
specs/[###-feature]/
├── plan.md              # This file (/speckit-plan command output)
├── research.md          # Phase 0 output (/speckit-plan command)
├── data-model.md        # Phase 1 output (/speckit-plan command)
├── quickstart.md        # Phase 1 output (/speckit-plan command)
├── contracts/           # Phase 1 output (/speckit-plan command)
└── tasks.md             # Phase 2 output (/speckit-tasks command - NOT created by /speckit-plan)
```

### Source Code (repository root)
<!--
  ACTION REQUIRED: Replace the placeholder tree below with the concrete layout
  for this feature. Delete unused options and expand the chosen structure with
  real paths (e.g., apps/admin, packages/something). The delivered plan must
  not include Option labels.
-->

```text
lib/
├── app/
│   ├── router/
│   ├── theme/
│   ├── localization/
│   └── config/
├── core/
│   ├── network/
│   ├── security/
│   ├── errors/
│   ├── logging/
│   ├── analytics/
│   ├── storage/
│   ├── widgets/
│   └── utils/
├── design_system/
│   ├── tokens/
│   ├── components/
│   ├── layouts/
│   └── cupertino_adapters/
└── features/
    └── [feature]/
        ├── presentation/
        ├── application/
        ├── domain/
        └── data/

test/
├── core/
├── design_system/
└── features/

integration_test/
```

**Structure Decision**: [Document the selected structure and reference the real
directories captured above]

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| [e.g., 4th project] | [current need] | [why 3 projects insufficient] |
| [e.g., Repository pattern] | [specific problem] | [why direct DB access insufficient] |
