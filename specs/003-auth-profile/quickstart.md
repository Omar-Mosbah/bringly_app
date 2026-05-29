# Quickstart: Authentication and User Profile

## Prerequisites

- Runtime Supabase URL and publishable anon key are provided through
  environment-specific configuration.
- No service-role key, private key, payment credential, or admin credential is
  present in the mobile app.
- Phase 1 app shell and design-system components are available.

## New Computer Setup

See `specs/003-auth-profile/new-computer-setup.md` for the clone, branch,
dependency, runtime configuration, and validation steps needed on another
computer.

## Implementation Sequence

1. Add `core/security/LocalAppUnlock` abstraction and fake/test adapter.
2. Add `features/auth/domain` entities and value objects for session, failures,
   email, password, email confirmation, and local unlock state.
3. Add `features/auth/data` repositories wrapping Supabase auth, protected
   storage, safe error mapping, and local unlock integration.
4. Add auth use cases for registration, login, session restoration, local
   unlock, password reset, and logout.
5. Add `features/profile/domain` entities and value objects for user profile,
   role, verification status, email confirmation status, and account
   restrictions.
6. Add profile repositories and use cases for loading profile summary, updating
   basic profile fields, and updating marketplace role.
7. Add onboarding, register, login, password reset, local unlock, profile
   summary, profile edit, and role selection screens using existing design
   system components.
8. Update routing so invalid configuration still shows the Phase 0 blocked
   startup path, signed-out users see auth entry, signed-in locked users see
   local unlock, and signed-in unlocked users enter the marketplace shell.
9. Replace the Phase 1 profile placeholder with the Phase 2 profile summary.
10. Add protected marketplace gating for unconfirmed email, incomplete
    verification, blocked/suspended account, and forced logout states.

## Required Checks

Run:

```powershell
flutter analyze
flutter test
```

Add focused tests before implementation is considered complete:

- Registration success, invalid input, duplicate/failed account, loading, and
  safe error states.
- Login success, invalid credentials, offline, rate-limited, blocked, and raw
  provider error sanitization.
- Password reset success-safe response, unknown email, malformed email,
  rate-limited request, expired link, and already-used link states.
- Session restoration valid, expired, revoked, corrupted, missing token, backend
  unavailable, and forced logout states.
- Local unlock available, unavailable, disabled, cancelled, failed, locked out,
  device PIN fallback, and sign-out states.
- Logout clears secure storage and prevents protected screen access after app
  restart.
- Profile summary loading, empty, success, update success, update failure,
  unauthorized, blocked, and edge states.
- Role selection shopper, traveler, both, unavailable, unauthorized, and
  backend-rejected states.
- Email confirmation pending, confirmed, expired, unavailable, and completed on
  another device states.
- Verification incomplete, under review, verified, rejected, blocked, and
  unavailable display/gating states.
- Suspended, blocked, and forced logout account handling.
- Logging and analytics tests proving tokens, credentials, PII, raw provider
  errors, risk scores, and sensitive status internals are redacted or omitted.

## Manual Review

- Confirm auth screens use safe, actionable copy and do not expose raw backend
  messages.
- Confirm account content is hidden until biometric or device PIN unlock
  succeeds after login/session restoration.
- Confirm email confirmation and verification gates block protected actions but
  still provide safe next steps.
- Confirm suspended/blocked account UI does not expose risk details or internal
  operational notes.
- Confirm basic profile editing is limited to display name, avatar,
  country/city, and preferred language.
