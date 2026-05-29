<!--
Sync Impact Report
Version change: template -> 1.0.0
Modified principles:
- Template principle 1 -> I. Security Before Features
- Template principle 2 -> II. Backend-Controlled Zero-Trust Lifecycle
- Template principle 3 -> III. Feature-First Clean Architecture
- Template principle 4 -> IV. Privacy and Data Minimization
- Template principle 5 -> V. Testable MVP Discipline
Added sections:
- Flutter and Supabase Technical Constraints
- Development Workflow and Quality Gates
Removed sections:
- Placeholder template guidance comments
Templates requiring updates:
- Updated: .specify/templates/plan-template.md
- Updated: .specify/templates/spec-template.md
- Updated: .specify/templates/tasks-template.md
- Updated: .specify/templates/checklist-template.md
- Not present: .specify/templates/commands/*.md
- Updated: AGENTS.md
- Updated: README.md
Follow-up TODOs:
- None
-->
# Bringly Mobile App Constitution

## Core Principles

### I. Security Before Features

Every feature MUST preserve the security model before adding user value. The
Flutter app MUST NOT contain service-role keys, private keys, payment
credentials, admin capabilities, or any other secret. Supabase publishable
configuration MAY be provided only through environment-specific runtime
configuration, never scattered through feature code. No sensitive decision may
be made only on the mobile client, and no endpoint may rely on client-provided
trust.

Rationale: Bringly handles identity, travel, payment, purchase, delivery, and
dispute workflows where a client-side bypass can create financial or safety
risk.

### II. Backend-Controlled Zero-Trust Lifecycle

The backend is the source of truth for all critical marketplace states. The
mobile app MUST request actions and render server state, while Supabase-backed
APIs, Edge Functions, RPCs, or backend services validate authorization and
perform state transitions. User verification, trip verification, item approval,
matching eligibility, offer acceptance, payment status, purchase evidence,
delivery handover, disputes, refunds, payouts, and suspension status MUST be
backend-controlled and auditable.

Rationale: Shoppers and travelers must not depend on blind trust or on mutable
client state during high-value marketplace interactions.

### III. Feature-First Clean Architecture

Flutter implementation MUST follow feature-first Clean Architecture. Feature
code MUST separate presentation, application/use-case, domain, and data
concerns. Domain entities and use cases MUST NOT depend on Flutter widgets,
Supabase clients, Dio clients, storage implementations, analytics, or routing.
Infrastructure integrations MUST sit behind abstractions that are mockable in
tests. Shared cross-cutting code belongs in `core/`, reusable UI belongs in
`design_system/`, and business capability code belongs under `features/`.

Rationale: The app will be implemented phase by phase; clear boundaries keep
security, tests, and future backend changes manageable.

### IV. Privacy and Data Minimization

The app MUST collect, store, display, log, and analyze only the data required
for the current marketplace workflow. Identity documents, travel proof,
receipts, payment details, auth tokens, internal risk scores, and sensitive
metadata MUST NOT be written to normal local storage, analytics, crash reports,
or logs. Sensitive files MUST use backend-issued signed upload URLs and MUST
NOT remain permanently on-device after upload.

Rationale: Trust in Bringly depends on protecting both parties from unnecessary
exposure of identity, payment, travel, and transaction data.

### V. Testable MVP Discipline

The MVP MUST stay within the controlled launch boundary defined in `PLAN.md`.
Features MUST be delivered in priority order with independently testable user
stories. Each feature MUST include tests for success, failure, loading, empty,
unauthorized, blocked, and relevant edge states. Critical flows involving
authorization, uploads, payments, evidence, OTP or QR handover, disputes, and
deep links MUST include abuse-case tests before release.

Rationale: Bringly must validate a controlled operating model before expanding
automation, categories, countries, or matching sophistication.

## Flutter and Supabase Technical Constraints

The product is a Flutter mobile app using Supabase as the backend-as-a-service
foundation. The approved mobile stack is Dart and Flutter, Riverpod for state
management, go_router for routing, freezed and json_serializable for immutable
models, flutter_secure_storage behind an abstraction for small sensitive values,
privacy-safe logging and analytics abstractions, and a Cupertino-first design
system.

Supabase access MUST use the project URL and publishable anon key through
environment-specific configuration. The current Supabase project URL is
`https://jeqfsnsnpigvdpmlhqmh.supabase.co`; its publishable anon key MUST be
provided through configuration such as `SUPABASE_ANON_KEY`. Private Supabase
service-role keys MUST NOT be present in the mobile app, repository, CI logs, or
client-delivered artifacts.

The Flutter app MUST NOT perform client-authoritative database writes for
critical marketplace actions. Critical actions MUST go through backend-controlled
APIs, Supabase Edge Functions, RPCs with strict authorization, or equivalent
server-side logic. Row-level security, storage policies, signed upload URLs, and
server-side validation are required for any Supabase table or bucket touched by
the mobile app.

The canonical project structure is:

```text
lib/
  app/
  core/
  design_system/
  features/
test/
integration_test/
```

Each feature under `lib/features/<feature>/` SHOULD use this internal structure
unless a documented reason exists:

```text
presentation/
application/
domain/
data/
```

## Development Workflow and Quality Gates

Spec Kit artifacts are the source of truth for implementation. Each phase MUST
produce or update a specification, plan, tasks, checklist, and analysis output
before implementation proceeds. Implementation MUST follow the phase order in
`PLAN.md` unless the plan is amended.

Before a feature is accepted:

- `flutter analyze` MUST pass.
- Unit and widget tests for the affected feature MUST pass.
- Integration tests MUST cover critical cross-feature flows when applicable.
- Generated code MUST be reproducible and committed only when needed by the
  Flutter toolchain.
- Logs, analytics events, and crash reports MUST be reviewed for sensitive data.
- Supabase access MUST be verified against RLS, storage policies, and
  server-side authorization rules.
- Any exception to these gates MUST be documented in the feature plan's
  Complexity Tracking section with a migration path.

## Governance

This constitution supersedes conflicting implementation habits, generated code,
and informal guidance. `PLAN.md` defines the current product and phase strategy;
this constitution defines the non-negotiable engineering rules for executing
that strategy.

Amendments MUST be made through the Spec Kit constitution workflow. Each
amendment MUST update this file, review dependent Spec Kit templates, and note
the impact in the Sync Impact Report. Versioning follows semantic versioning:
MAJOR for incompatible governance or principle changes, MINOR for new or
materially expanded principles or sections, and PATCH for clarifications that do
not change obligations.

Every feature plan MUST include a Constitution Check. Every task list MUST
include architecture, security, privacy, and test tasks where relevant. Reviewers
and implementation agents MUST reject work that bypasses backend authorization,
stores sensitive data unsafely, leaks PII, violates Clean Architecture
boundaries, or expands beyond the approved MVP boundary without a plan update.

**Version**: 1.0.0 | **Ratified**: 2026-05-29 | **Last Amended**: 2026-05-29
