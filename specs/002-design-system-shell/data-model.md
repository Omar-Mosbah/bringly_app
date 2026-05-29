# Data Model: Phase 1 Design System and App Experience Shell

## MarketplaceDestination

Represents one primary app shell tab.

**Fields**:

- `id`: `shopper`, `traveler`, `activity`, or `profile`
- `label`: safe tab label
- `icon`: stable icon identifier
- `routePath`: route path owned by the app router
- `placeholder`: `PlaceholderMessage`

**Validation Rules**:

- Only Shopper, Traveler, Activity, and Profile may be primary destinations.
- Destination labels must not imply that auth, verification, payment, delivery,
  disputes, ratings, or notifications are implemented.
- Each destination must render a safe placeholder in Phase 1.

## DesignSystemDemoRoute

Represents the non-primary route used to review reusable UI.

**Fields**:

- `routePath`: route path for the demo screen
- `entryPointLabel`: safe label shown from Profile or foundation/developer area
- `sections`: ordered list of `DesignSystemDemoSection`
- `isPrimaryTab`: always `false`

**Validation Rules**:

- The demo route must be reachable within 2 minutes from the app shell.
- The demo route must not appear as a fifth primary tab.
- Demo actions must not perform backend state-changing APIs.

## DesignSystemDemoSection

Represents a grouped section in the demo screen.

**Fields**:

- `id`: stable section identifier
- `title`: safe display title
- `components`: ordered list of design system component examples
- `stateCoverage`: list of represented `ComponentState` values

**Validation Rules**:

- Section titles must be stable enough for widget tests.
- Sections must use fake non-sensitive content only.
- Every required Phase 1 component must appear in at least one section.

## DesignSystemComponent

Represents a reusable UI component required by Phase 1.

**Fields**:

- `name`: one of `BringlyButton`, `BringlyCard`, `BringlyTextField`,
  `TrustBadge`, `StatusChip`, `PriceBreakdownCard`, `TravelerCard`,
  `RequestCard`, `EvidenceTile`, `VerificationStatusBanner`,
  `CupertinoBottomActionSheet`, `StateScreen`
- `purpose`: short safe usage description
- `supportedStates`: list of `ComponentState`
- `requiredSemantics`: accessibility labels or roles where applicable
- `testKey`: stable widget test key

**Validation Rules**:

- Components must contain no marketplace business decision logic.
- Components must be reusable by later features through properties and domain
  display values, not hardcoded scenario logic.
- Components must not write to storage, logs, analytics, or crash contexts.

## ComponentState

Represents the visible state of a component or screen.

**Values**:

- `normal`
- `loading`
- `disabled`
- `error`
- `empty`
- `blocked`
- `pending`
- `success`
- `warning`

**Validation Rules**:

- Interactive components must demonstrate `normal` and `disabled`.
- Async or validation-oriented components must demonstrate `loading` or
  `error` where applicable.
- Standard state screens must demonstrate `loading`, `empty`, `blocked`, and
  `error`.

## DemoDataItem

Represents fake content used by the demo screen.

**Fields**:

- `label`: fake display text
- `amount`: optional fake amount for UI formatting only
- `status`: optional `ComponentState`
- `description`: optional fake marketplace-style summary
- `privacyClassification`: always `fakeNonSensitive`

**Validation Rules**:

- Must not contain real personal data, auth tokens, payment data, identity
  documents, travel proof, receipts, or internal risk data.
- Must not use real email addresses, phone numbers, document numbers, booking
  references, transaction IDs, card numbers, passport numbers, or risk scores.
- Must not imply completed approval, verified identity, payment secured,
  delivery complete, dispute resolved, or payout released.

## PlaceholderMessage

Represents safe copy for Phase 1 unavailable marketplace flows.

**Fields**:

- `title`: safe placeholder title
- `message`: safe explanatory body copy
- `primaryActionLabel`: optional safe local action, such as opening the demo
- `blockedReason`: stable reason code for tests

**Validation Rules**:

- Must clearly communicate that future functionality is not available yet.
- Must not imply marketplace success or backend approval.
- Must not expose raw backend, Supabase, payment, provider, token, or internal
  error details.

## ComponentStateTransition

Represents local UI-only state demonstrations.

**Fields**:

- `from`: `ComponentState`
- `to`: `ComponentState`
- `trigger`: local UI trigger, such as opening an action sheet or showing a
  validation example

**Validation Rules**:

- Transitions are local demonstrations only.
- No transition may create, update, approve, pay, deliver, dispute, rate, notify,
  or otherwise mutate marketplace state.
