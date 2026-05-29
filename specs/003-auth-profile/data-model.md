# Data Model: Authentication and User Profile

## User Account

Represents a registered Bringly account.

**Fields**:

- `id`: Stable backend account identifier; never logged in raw form.
- `email`: User email address; shown only to the account owner where needed.
- `emailConfirmationStatus`: Pending, confirmed, expired, or unavailable.
- `accountRestriction`: Active, suspended, blocked, or forced logout.
- `createdAt`: Account creation timestamp if safely available.

**Relationships**:

- Owns one current `User Profile`.
- May have one current `Session`.
- Has one `Email Confirmation Status`.
- Has zero or one active `Account Restriction`.

**Validation rules**:

- Account status and restriction are backend authoritative.
- The client must not edit account restriction, risk, or eligibility fields.
- Raw account identifiers must not be logged or sent to analytics.

## Session

Represents current authenticated access after successful email/password login or
session restoration.

**Fields**:

- `state`: Signed out, restoring, signed in, expired, unauthorized, or blocked.
- `expiresAt`: Expiry timestamp if available.
- `requiresLocalUnlock`: True after login/session restoration before account
  content is shown.
- `forcedLogoutRequired`: True when backend requires local authenticated access
  to end.

**Relationships**:

- Belongs to one `User Account`.
- Requires `Local App Unlock` before account content is visible.

**Validation rules**:

- Token contents are never represented in domain entities.
- Sensitive session values are stored only through `ProtectedStorage`.
- Expired, revoked, malformed, or missing sessions transition to signed out or
  re-authentication.

## Local App Unlock

Represents device-level biometric or device PIN gating after login.

**Fields**:

- `availability`: Available, unavailable, disabled, locked out, or unknown.
- `method`: Biometric, device PIN, platform fallback, or unavailable.
- `state`: Required, in progress, unlocked, failed, cancelled, locked out, or
  signed out.
- `lastAttemptResult`: Safe result label for UI and tests.

**Relationships**:

- Gates display of account content for a valid `Session`.
- Does not change backend account state.

**Validation rules**:

- Local unlock success must not be treated as backend authorization.
- Failed, cancelled, or locked-out local unlock keeps account content hidden.
- Unlock errors must not expose platform internals beyond safe user guidance.

## Password Reset Request

Represents a user request to recover access by email.

**Fields**:

- `emailInput`: Email submitted by the user.
- `requestState`: Idle, submitting, submitted, rate limited, invalid input, or
  safe failure.
- `safeMessage`: Account-enumeration-safe result message.

**Relationships**:

- May correspond to a `User Account`, but the UI must not reveal whether it
  does.

**Validation rules**:

- Responses for known and unknown email addresses use the same safe
  confirmation pattern.
- Expired, invalid, and already-used reset links are safe failures.
- Password reset inputs and tokens are never logged.

## User Profile

Represents non-sensitive user-facing profile information for Phase 2.

**Fields**:

- `displayName`: User-facing display name.
- `avatar`: User avatar reference or placeholder; must not embed sensitive file
  data.
- `countryCity`: User-selected country/city display value.
- `preferredLanguage`: User-selected app language preference.
- `marketplaceRole`: Shopper, traveler, or both.
- `profileCompleteness`: Safe completeness status for current phase.

**Relationships**:

- Belongs to one `User Account`.
- References one `Marketplace Role`.
- Displays `Verification Status`, `Email Confirmation Status`, and
  `Account Restriction`.

**Validation rules**:

- Only permitted profile fields may be edited in Phase 2.
- Restricted trust, verification, account, and eligibility fields are read-only.
- Profile display cache, if used, contains only non-sensitive display values.

## Marketplace Role

Represents how the user intends to participate in the marketplace.

**States**:

- Shopper
- Traveler
- Both
- Unavailable

**Validation rules**:

- Role selection is subject to backend eligibility.
- Role changes do not grant protected marketplace access by themselves.
- If role data is missing or no longer permitted, protected actions remain
  blocked until refreshed state allows them.

## Verification Status

Represents backend-owned trust readiness shown in Phase 2.

**States**:

- Incomplete
- Under review
- Verified
- Rejected
- Blocked
- Unavailable

**Validation rules**:

- Status is read-only in Phase 2.
- Identity document submission and detailed verification flows are out of
  scope.
- Protected marketplace actions are blocked when required verification is not
  complete.

## Email Confirmation Status

Represents whether the account email is confirmed for protected marketplace
access.

**States**:

- Pending
- Confirmed
- Expired
- Unavailable

**Validation rules**:

- Protected marketplace actions are blocked unless email is confirmed.
- Email confirmation status is refreshed after login and session restoration.
- Pending or expired confirmation shows safe guidance.

## Account Restriction

Represents backend-controlled account restrictions.

**States**:

- Active
- Suspended
- Blocked
- Forced logout required

**Validation rules**:

- Restrictions are backend authoritative and read-only.
- Suspended and blocked accounts cannot perform protected marketplace actions.
- Forced logout clears sensitive local session values and returns to signed out.
- User-facing copy must not expose internal risk scores or operational notes.

## State Transitions

### Auth Session

```text
signed_out
  -> registering
  -> signed_in_requires_unlock
  -> signed_in_unlocked
  -> signed_out

signed_out
  -> logging_in
  -> signed_in_requires_unlock
  -> signed_in_unlocked
  -> signed_out

signed_in_unlocked
  -> restoring
  -> signed_in_requires_unlock
  -> signed_in_unlocked

signed_in_unlocked
  -> forced_logout
  -> signed_out
```

### Local App Unlock

```text
required
  -> in_progress
  -> unlocked

required
  -> in_progress
  -> failed
  -> required

required
  -> in_progress
  -> cancelled
  -> required

required
  -> in_progress
  -> locked_out
  -> required_or_sign_out
```

### Profile Access Gate

```text
email_pending OR verification_incomplete OR suspended
  -> protected_actions_blocked
  -> safe_guidance

email_confirmed AND verification_verified AND active
  -> protected_actions_allowed_by_backend_check
```
