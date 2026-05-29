# Contract: Local App Unlock

## Purpose

Define the device-level local unlock contract for Phase 2. Local unlock protects
account content on the device after login, but it does not replace backend
authentication, account verification, or authorization.

## Operations

### Check Availability

**Input**:

- Current platform/device state

**Success result**:

- Available with biometric support
- Available with device PIN fallback
- Unavailable with safe reason

**Failure result**:

- Unknown availability
- Platform service unavailable

**Rules**:

- Availability checks must be mockable in tests.
- Safe reasons must not expose low-level platform internals.

### Request Unlock

**Input**:

- Unlock reason suitable for user-facing prompt

**Success result**:

- Unlocked

**Failure result**:

- Failed
- Cancelled
- Locked out
- Not available
- Platform error mapped to safe failure

**Rules**:

- Account content remains hidden until success.
- A failed, cancelled, locked-out, or unavailable unlock does not clear backend
  session automatically unless the user signs out or forced logout applies.
- Device PIN fallback is allowed where the platform supports it.
- Unlock attempts and platform responses must not log PII, tokens, credentials,
  or raw platform error internals.

### Reset Unlock State On Sign Out

**Input**:

- Sign-out event

**Success result**:

- Local unlock state returns to signed out/required for next login

**Rules**:

- Sign-out clears sensitive session values through secure storage.
- Returning to the app after sign-out must not show account content without
  login.
