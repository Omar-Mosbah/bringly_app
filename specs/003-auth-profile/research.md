# Phase 0 Research: Authentication and User Profile

## Decision: Email/password is the only Phase 2 account credential method

**Rationale**: The clarified spec selects email/password only. This keeps MVP
registration, login, session restoration, password reset, email confirmation,
and forced logout testable without pulling phone OTP, social login, or
passwordless magic links into Phase 2.

**Alternatives considered**:

- Phone OTP: Deferred to future trust/verification work because phone
  verification belongs to Phase 3.
- Passwordless magic link: Deferred to avoid mixing auth methods before the MVP
  baseline is stable.
- Social login: Deferred because it adds provider-specific failure modes and
  account-linking decisions not required for Phase 2.

## Decision: Use Supabase-backed auth through a feature repository abstraction

**Rationale**: The app already uses Supabase as the backend foundation and
runtime configuration is established in Phase 0. A repository abstraction keeps
Supabase provider details out of domain/application layers and allows tests to
cover success, failure, unauthorized, blocked, and edge states without network
access.

**Alternatives considered**:

- Direct Supabase calls from widgets: Rejected because it violates Clean
  Architecture and makes provider errors harder to sanitize.
- Custom auth service unrelated to Supabase: Rejected because it conflicts with
  the product backend foundation and adds avoidable integration scope.

## Decision: Store auth/session tokens only through `ProtectedStorage`

**Rationale**: Project rules require secure storage only for small sensitive
values such as auth/session tokens behind a mockable abstraction. The existing
`ProtectedStorage` interface satisfies the boundary and lets tests use memory
storage.

**Alternatives considered**:

- Normal local storage: Rejected because tokens are sensitive.
- Feature-owned storage implementation: Rejected because it duplicates Phase 0
  cross-cutting security code.

## Decision: Implement biometric/device PIN as local app unlock after login

**Rationale**: The clarification requires local app unlock after login. This is
a device access control, not identity verification or backend authorization. A
`LocalAppUnlock` abstraction can wrap a native biometric/PIN adapter and provide
deterministic tests for available, unavailable, cancelled, failed, locked out,
and fallback states.

**Alternatives considered**:

- Replace email/password with biometric/PIN: Rejected because biometrics do not
  establish backend account identity.
- Sensitive-action-only unlock: Rejected by clarification; Phase 2 requires
  unlock after login before account content is shown.
- No biometric/PIN in Phase 2: Rejected by clarification.

## Decision: Email confirmation gates protected marketplace actions

**Rationale**: The clarified spec requires email confirmation before protected
marketplace actions. This aligns with the verified-user MVP while keeping full
identity verification flows in Phase 3.

**Alternatives considered**:

- Display-only email status: Rejected because it would allow unconfirmed users
  to attempt protected actions.
- Allow actions before confirmation: Rejected because it weakens the controlled
  marketplace launch posture.

## Decision: Profile scope is limited to non-sensitive display fields

**Rationale**: Phase 2 profile management includes display name, avatar,
country/city, preferred language, role selection, verification status display,
and account status. Sensitive identity documents, phone verification, legal
identity, addresses, payment details, receipts, and travel proof belong to later
phases.

**Alternatives considered**:

- Legal name, phone, address: Rejected for Phase 2 because those fields
  increase privacy and verification scope.
- Display name/avatar only: Rejected because country/city and preferred
  language are useful low-risk profile context for the marketplace MVP.

## Decision: Use safe error taxonomy instead of raw backend/provider errors

**Rationale**: Auth and profile screens must show actionable messages without
revealing raw Supabase, policy, provider, account enumeration, or risk details.
Domain failures should distinguish invalid input, invalid credentials,
unauthorized, rate limited, offline, blocked, suspended, local unlock failed,
and unknown-safe failure states.

**Alternatives considered**:

- Pass provider messages directly to UI: Rejected because provider messages may
  reveal internals or account existence.
- Collapse all failures to one message: Rejected because users need safe but
  useful next steps.
