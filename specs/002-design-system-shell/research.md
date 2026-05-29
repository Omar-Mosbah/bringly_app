# Research: Phase 1 Design System and App Experience Shell

## Decision: Use a four-tab marketplace shell with a non-primary demo route

**Rationale**: The clarification for Phase 1 selects Shopper, Traveler,
Activity, and Profile as the only primary tabs. The Design System Demo remains
reachable from Profile or a clearly discoverable foundation/developer area so
reviewers can validate components without making an internal tool look like a
production marketplace destination.

**Alternatives considered**:

- Five primary tabs including Design System Demo: rejected because the demo is
  implementation support, not a future user-facing marketplace area.
- Keep Phase 0 foundation shell primary: rejected because Phase 1 must establish
  the future app experience shell.

## Decision: Keep reusable components in `lib/design_system/`

**Rationale**: Buttons, cards, text fields, badges, chips, price breakdown,
evidence tiles, verification banners, action sheets, and state screens will be
used by many later features. Shared UI belongs in `design_system/` so future
features can compose it without duplicating visual and accessibility behavior.

**Alternatives considered**:

- Store components under `features/app_shell/`: rejected because it would make
  later business features depend on shell internals.
- Store all components in `core/widgets/`: rejected because these widgets are
  Bringly product UI, not generic technical utilities.

## Decision: Use a dedicated `features/app_shell/` feature for placeholders

**Rationale**: The shell has feature behavior: destinations, placeholder
messages, navigation tests, and demo route reachability. Keeping it under
`features/app_shell/` preserves feature-first Clean Architecture while leaving
`app/router/` responsible only for route composition.

**Alternatives considered**:

- Put all shell screens directly under `app/`: rejected because it would mix
  app composition with feature presentation.
- Reuse `features/foundation/` for Phase 1 shell screens: rejected because
  Phase 0 foundation diagnostics and Phase 1 marketplace placeholders have
  different scope and acceptance tests.

## Decision: Use static fake demo data and no backend calls

**Rationale**: Phase 1 validates UI components, not auth, transactions, or
marketplace state. Static fake data makes widget tests deterministic and avoids
leaking or simulating sensitive real workflows. Demo actions may open local
action sheets or toggle local UI state, but must not call backend
state-changing APIs.

**Alternatives considered**:

- Pull sample records from Supabase: rejected because it introduces data access,
  RLS, privacy, and schema concerns outside Phase 1.
- Use realistic user/payment/document samples: rejected because fake demo
  content must not resemble real sensitive data.

## Decision: Provide component state coverage through deterministic variants

**Rationale**: The design system demo and widget tests should render normal,
loading, disabled, error, empty, blocked, pending, success, and warning variants
in stable sections. This lets designers and implementers compare states quickly
and gives tests predictable labels and keys.

**Alternatives considered**:

- Only show interactive toggles: rejected because reviewers could miss states
  and tests would become more sequence-dependent.
- Only show static screenshots/goldens: rejected because component behavior such
  as disabled and loading semantics needs widget-level validation.

## Decision: Defer golden tests unless implementation changes visual risk

**Rationale**: Widget tests are required for Phase 1 acceptance. Golden tests
can be valuable for design systems but add asset churn and environment
stability concerns. They should be introduced only for components whose layout
or visual regression risk warrants it during implementation.

**Alternatives considered**:

- Require golden tests for every component now: rejected because it may slow
  Phase 1 without improving the core contract.
- Avoid any visual regression approach permanently: rejected as a future option
  because the design system may later need stable visual snapshots.

## Decision: Use Cupertino-first widgets with Bringly-owned styling

**Rationale**: `PLAN.md` calls for an iOS-first Cupertino experience and
marketplace clarity. Components should use Cupertino interaction patterns,
Bringly tokens, and original layout choices while avoiding copied colors,
assets, icons, protected layouts, or trade dress from third-party products.

**Alternatives considered**:

- Material-first shell: rejected because the product direction is iOS-first.
- Copy a known marketplace design closely: rejected because the plan explicitly
  permits inspiration but prohibits copying protected branding or trade dress.
