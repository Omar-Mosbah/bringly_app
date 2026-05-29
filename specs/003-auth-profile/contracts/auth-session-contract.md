# Contract: Auth Session

## Purpose

Define the Phase 2 contract between presentation/application code and the auth
data layer. Provider-specific auth details must be hidden behind this contract.

## Operations

### Register With Email

**Input**:

- `email`
- `password`
- Initial `marketplaceRole`

**Success result**:

- Safe account identifier
- Session state: signed in and local unlock required, or pending confirmation if
  backend requires confirmation before session use
- Email confirmation status
- Initial account status

**Failure result**:

- Invalid input
- Email already unavailable for registration
- Weak password
- Rate limited
- Offline/service unavailable
- Safe unknown failure

**Rules**:

- Password and raw provider responses are never logged.
- User-facing messages do not expose raw backend/provider internals.

### Sign In With Email

**Input**:

- `email`
- `password`

**Success result**:

- Session state: signed in, local unlock required
- Account status summary
- Email confirmation status

**Failure result**:

- Invalid credentials
- Rate limited
- Suspended/blocked account
- Offline/service unavailable
- Safe unknown failure

**Rules**:

- Invalid credential responses must not reveal whether the email exists.
- Successful login must not show account content until local unlock succeeds.

### Restore Session

**Input**:

- Stored secure session values, if present

**Success result**:

- Session state: signed in, local unlock required
- Refreshed account status, role eligibility, email confirmation, verification,
  and suspension status

**Failure result**:

- No session
- Expired session
- Revoked/corrupted session
- Unauthorized
- Forced logout required
- Offline/service unavailable

**Rules**:

- Expired, revoked, corrupted, or forced-logout sessions clear sensitive local
  values when appropriate.
- Backend status refresh is required before protected marketplace access.

### Request Password Reset

**Input**:

- `email`

**Success-safe result**:

- Confirmation message that does not reveal whether the email belongs to an
  account.

**Failure result**:

- Malformed email
- Rate limited
- Offline/service unavailable
- Safe unknown failure

**Rules**:

- Known and unknown account emails use the same account-enumeration-safe
  confirmation pattern.
- Reset tokens or links are never logged.

### Sign Out

**Input**:

- Current session, if present

**Success result**:

- Signed-out state
- Sensitive local session values cleared

**Failure result**:

- Local sign-out succeeded but server confirmation unavailable
- Safe unknown failure

**Rules**:

- Local authenticated access ends even when server confirmation cannot complete.
- Sign-out must prevent protected screen access after restart.

## Safe Failure Taxonomy

- `invalidInput`
- `invalidCredentials`
- `weakPassword`
- `rateLimited`
- `offline`
- `unauthorized`
- `blocked`
- `suspended`
- `forcedLogout`
- `serviceUnavailable`
- `unknownSafeFailure`
