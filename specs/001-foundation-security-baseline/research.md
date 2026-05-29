# Research: Phase 0 Foundation and Security Baseline

## Decision: Use runtime environment configuration for Supabase public values

**Rationale**: Phase 0 must support development, staging, and production
configuration names while avoiding secrets in source. Flutter compile-time
environment values can supply the public Supabase URL and publishable anon key
per environment, and invalid or missing values can produce the required blocked
state.

**Alternatives considered**:

- Hardcoded public values in source: rejected because it scatters configuration
  through feature code and weakens environment separation.
- Checked-in config files: rejected for Phase 0 because they increase the risk
  of accidentally committing private or production values.

## Decision: Limit Supabase/backend interaction to a non-sensitive connectivity check

**Rationale**: The clarified spec requires Option B: validate configuration and
perform a safe health-style reachability check. The check may initialize the
backend client and call a server-approved health endpoint or equivalent
non-sensitive route. It must not require login, expose session state, or read or
write marketplace records.

**Alternatives considered**:

- Configuration-only validation: rejected because it does not prove backend
  reachability.
- Session readiness check: rejected because session behavior belongs to the auth
  phase.
- Reading a public table: rejected because it introduces data policy and schema
  concerns before Phase 0 needs them.

## Decision: Use foundation-only navigation

**Rationale**: Phase 1 owns the shopper, traveler, activity, and profile
experience shell. Phase 0 only needs enough routing to prove startup,
configuration/status, connectivity, and reusable UI-state demo destinations.

**Alternatives considered**:

- Future top-level marketplace placeholders: rejected because it pulls Phase 1
  scope forward.
- Single screen only: rejected because it does not validate the routing
  foundation required by later phases.

## Decision: Implement protected storage as an abstraction with a harmless smoke test

**Rationale**: Phase 0 must prove secure-storage boundaries are injectable and
testable, but auth token persistence is out of scope. A harmless validation
value can verify read/write/delete behavior and cleanup without resembling
session or user data.

**Alternatives considered**:

- Interface only: rejected because it would not validate runtime storage
  availability.
- Auth-token-shaped keys: rejected because it blurs the boundary with the auth
  phase and increases leakage risk.

## Decision: Use privacy-safe logging and analytics abstractions from day one

**Rationale**: Bringly's later flows include identity, payment, receipt, travel,
and dispute evidence. Central redaction and allowlisted analytics properties
prevent feature teams from sending sensitive values by habit.

**Alternatives considered**:

- Direct `print`/provider logging: rejected because it bypasses redaction.
- No analytics abstraction in Phase 0: rejected because later features would add
  inconsistent event paths.

## Decision: Add minimal CI workflow for analysis and automated tests

**Rationale**: `PLAN.md` calls for CI setup and CI-ready commands in Phase 0.
The clarified scope requires repository checks that run analysis and tests on
changes. Build and security scanning can be added during hardening when release
configuration is known.

**Alternatives considered**:

- Documentation-only commands: rejected because it lacks an enforceable gate.
- Full build/security scanning: deferred because Phase 0 is foundation setup and
  release hardening is explicitly Phase 12.

## Decision: Defer generated DTO tooling until business data exists

**Rationale**: The constitution approves immutable generated models, but Phase 0
has simple foundation result types. Plain value objects or sealed result types
avoid unnecessary generated-code churn until shopper/auth/business DTOs exist.

**Alternatives considered**:

- Add `freezed` immediately for all foundation types: rejected as avoidable
  complexity for Phase 0.
- Use untyped maps for all outcomes: rejected because it weakens tests and
  error handling.
