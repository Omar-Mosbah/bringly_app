# Contract: Foundation UI and Navigation

## Purpose

Define the visible Phase 0 app shell and reusable baseline states. This contract
excludes all marketplace flows assigned to later phases.

## Destinations

### Startup

- Shows whether the app can initialize.
- Routes to blocked state when required configuration is invalid.
- Does not show shopper, traveler, auth, payment, or profile actions.

### Configuration Status

- Shows safe environment status.
- Masks or omits sensitive configuration values.
- Shows actionable blocked state for missing or invalid configuration.

### Connectivity

- Shows connectivity check status.
- Supports loading, success, unavailable, timeout, offline, and safe error
  states.
- Provides retry where appropriate.

### UI-State Demo

- Demonstrates loading, empty, error, blocked, offline, and success states using
  fake non-sensitive data only.
- Provides stable labels for widget tests.

## Navigation Rules

- Navigation is limited to Phase 0 foundation destinations.
- No route may simulate successful marketplace state transitions.
- Requests for future marketplace destinations must stay out of Phase 0 or show
  a safe out-of-scope state during planning/testing.

## Accessibility and UX Rules

- Text must be readable with platform text scaling.
- Blocked and error states must provide safe, actionable messages.
- Status changes must be visible without exposing sensitive internals.

## Test Expectations

- App shell launches.
- Each foundation destination is reachable.
- Invalid configuration blocks unsafe checks.
- All baseline UI states are rendered in widget tests.
- No future marketplace destination is exposed by Phase 0 navigation.
