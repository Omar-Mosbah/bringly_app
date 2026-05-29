# Contract: Phase 1 Design System Components

## Purpose

Define the reusable UI components and state coverage required before business
features build on top of them.

## Required Components

### BringlyButton

- Supports normal, loading, disabled, and error-ready presentation.
- Uses stable labels and semantics for widget tests.
- Does not execute business logic directly.

### BringlyCard

- Provides consistent spacing, hierarchy, status placement, and tap affordance
  where enabled.
- Handles long labels without overflow.
- Does not own marketplace decisions.

### BringlyTextField

- Supports label, helper text, validation text, disabled state, and error state.
- Does not store or log entered values.
- Demo examples must use fake non-sensitive text only.

### TrustBadge and StatusChip

- Represent verification, review, blocked, pending, success, error, and warning
  style statuses.
- Labels must not imply real approval, payment, delivery, dispute, or payout
  success in Phase 1.

### PriceBreakdownCard

- Shows fake line items and totals for formatting only.
- Must not represent real payment authorization, escrow, payout, refund, card,
  or provider state.

### TravelerCard and RequestCard

- Show fake marketplace-style summaries with safe placeholder content.
- Must not reveal or imply real identity, travel proof, contact details, request
  approval, match eligibility, or offer state.

### EvidenceTile

- Demonstrates evidence UI shape with fake labels only.
- Must not contain real document, receipt, file, travel proof, or metadata.
- Must not upload, download, persist, or preview sensitive files in Phase 1.

### VerificationStatusBanner

- Shows fake status messaging for UI demonstration.
- Must not claim that a user, trip, item, payment, or payout is truly verified
  or approved.

### CupertinoBottomActionSheet

- Supports title, message, primary action, secondary action, destructive action,
  and cancel behavior.
- Demo actions are local only and must not mutate marketplace state.

### State Screens

- Provide reusable loading, empty, blocked, and error screens.
- Wording must be actionable and safe without exposing raw backend or provider
  internals.

## State Coverage

- Interactive components must show normal and disabled variants.
- Components with async behavior must show loading.
- Components with validation or failure behavior must show error.
- State screens must show loading, empty, blocked, and error.

## Privacy Rules

- Components must not write sensitive values to logs, analytics, crash contexts,
  secure storage, or normal local storage.
- Demo data must be fake and must not resemble real PII, payment details,
  documents, receipts, travel proof, tokens, or internal risk scores.
- UI copy must not expose Supabase, payment provider, or backend internals.

## Test Expectations

- Each required component is visible in the demo screen.
- Required states are covered by widget tests.
- Disabled controls cannot invoke actions.
- Loading variants expose stable visible loading affordances.
- Long text and increased text scaling do not cause incoherent overlap.
