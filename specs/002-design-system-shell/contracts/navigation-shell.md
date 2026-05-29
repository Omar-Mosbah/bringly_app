# Contract: Phase 1 Navigation Shell

## Purpose

Define the Phase 1 app shell, primary destinations, demo route reachability, and
the limits that keep future marketplace behavior unavailable.

## Primary Tabs

### Shopper

- Route is reachable from the primary tab bar.
- Shows a safe placeholder for future shopper item request flows.
- Does not allow creating drafts, submitting requests, uploading item images, or
  starting compliance review.

### Traveler

- Route is reachable from the primary tab bar.
- Shows a safe placeholder for future traveler trip flows.
- Does not allow adding trips, uploading travel proof, setting capacity, or
  receiving matches.

### Activity

- Route is reachable from the primary tab bar.
- Shows a safe placeholder for future activity and notification flows.
- Does not show real transaction, notification, payment, dispute, payout, or
  delivery state.

### Profile

- Route is reachable from the primary tab bar.
- Shows a safe placeholder for future auth/profile functionality.
- Provides a clearly discoverable entry point to the Design System Demo route.
- Does not allow login, logout, profile editing, verification submission, or
  account status changes.

## Design System Demo Route

- Reached from Profile or a clearly discoverable foundation/developer area.
- Must not appear as a fifth primary tab.
- Must render all required reusable components and states using fake
  non-sensitive data.
- May demonstrate local UI interactions such as disabled controls, loading
  affordances, validation examples, and bottom action sheets.
- Must not call backend state-changing APIs or simulate completed marketplace
  transactions.

## Navigation Rules

- Rapid tab switching must preserve the shell and avoid layout overlap.
- Returning from the demo route must keep the four-tab shell intact.
- Unknown or future marketplace action attempts must show safe unavailable
  messaging or remain inaccessible.
- Route names and labels must be stable enough for widget tests.

## Accessibility and UX Rules

- Tab labels and placeholder text must remain readable with increased platform
  text scaling.
- Touch targets must remain usable on compact mobile layouts.
- Placeholder copy must be clear without exposing provider internals.

## Test Expectations

- App launches into the Phase 1 shell with four primary tabs.
- Shopper, Traveler, Activity, and Profile are reachable.
- Design System Demo is reachable from Profile or the chosen discoverable area.
- Design System Demo is not a primary tab.
- Placeholder destinations block future marketplace actions with safe copy.
- Navigation works after rapid tab switching and demo open/dismiss flows.
