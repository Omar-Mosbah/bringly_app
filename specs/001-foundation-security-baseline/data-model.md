# Data Model: Phase 0 Foundation and Security Baseline

## EnvironmentProfile

Represents the selected runtime environment and the public configuration needed
to start safely.

**Fields**:

- `name`: one of `development`, `staging`, `production`
- `supabaseUrl`: public backend URL
- `supabaseAnonKeyPresent`: boolean indicating whether a publishable key was
  supplied
- `isValid`: derived boolean
- `validationIssues`: list of safe issue codes

**Validation Rules**:

- `name` must be one of the supported environment names.
- `supabaseUrl` must be a valid HTTPS URL.
- The publishable anon key must be present but must never be displayed in full,
  logged, analyzed, or persisted in normal local storage.
- Invalid profiles produce a blocked state and do not attempt connectivity.

## ConnectivityCheckResult

Represents the outcome of the Phase 0 non-sensitive backend reachability check.

**Fields**:

- `status`: `idle`, `loading`, `success`, `unavailable`, `timeout`,
  `invalidConfiguration`, `offline`, `failed`
- `checkedAt`: timestamp when a check completes
- `safeMessage`: user-facing message with no provider internals
- `retryAllowed`: boolean

**Validation Rules**:

- Result payload must not include marketplace records, user records, session
  details, tokens, raw provider errors, or privileged credentials.
- Timeout and unavailable outcomes must be distinguishable for user messaging
  and tests.

**State Transitions**:

```text
idle -> loading
loading -> success
loading -> unavailable
loading -> timeout
loading -> invalidConfiguration
loading -> offline
loading -> failed
failed/unavailable/timeout/offline -> loading
```

## FoundationDestination

Represents a Phase 0 route.

**Fields**:

- `id`: `startup`, `configurationStatus`, `connectivity`, `uiStateDemo`
- `title`: safe display label
- `isAccessible`: boolean
- `blockedReason`: safe reason code when inaccessible

**Validation Rules**:

- Phase 0 destinations must not include shopper, traveler, activity, profile,
  auth, verification, payment, delivery, dispute, or notification routes.
- Destination labels must not imply that marketplace workflows are implemented.

## BaselineUiState

Represents reusable UI states required by the foundation.

**Fields**:

- `kind`: `loading`, `empty`, `error`, `blocked`, `offline`, `success`
- `title`: safe user-facing title
- `message`: safe user-facing body copy
- `primaryAction`: optional safe action label
- `retryAllowed`: boolean

**Validation Rules**:

- Error and blocked messages must not expose raw backend, provider, token,
  payment, document, receipt, travel, or risk details.
- Text must be testable and stable enough for widget tests.

## SensitiveDataCategory

Represents values that redaction and analytics filtering must protect.

**Fields**:

- `category`: `token`, `personName`, `email`, `phone`, `payment`, `document`,
  `receipt`, `travelProof`, `riskData`, `backendSecret`, `providerError`
- `examplesForTests`: fake sample values only
- `redactionLabel`: safe replacement label

**Validation Rules**:

- Test examples must be clearly fake.
- Sensitive examples must never be sent through real analytics or crash
  reporting providers during tests.

## ProtectedStorageSmokeTestResult

Represents whether the harmless validation value was written, read, and deleted.

**Fields**:

- `status`: `notRun`, `running`, `passed`, `writeFailed`, `readFailed`,
  `deleteFailed`, `skipped`
- `safeMessage`: user-facing result
- `ranAt`: timestamp when the test completes

**Validation Rules**:

- The validation key and value must be harmless and non-sensitive.
- The value must not look like an auth token, session ID, payment credential, or
  user identifier.
- A passed result requires write, read, delete, and post-delete absence checks.

## ValidationChecklist

Represents the Phase 0 readiness checklist outcome.

**Fields**:

- `analysisPassed`: boolean
- `testsPassed`: boolean
- `securityBaselinePassed`: boolean
- `ciPassed`: boolean
- `remainingIssues`: list of safe issue summaries

**Validation Rules**:

- The checklist cannot pass while any required Phase 0 gate is failing.
- Remaining issues must not include secrets or sensitive values.

## RepositoryCheckResult

Represents repository-level check outcome.

**Fields**:

- `status`: `pending`, `running`, `passed`, `failed`, `cancelled`
- `analysisStatus`: `passed`, `failed`, `notRun`
- `testStatus`: `passed`, `failed`, `notRun`
- `safeSummary`: safe status message

**Validation Rules**:

- Repository checks must run analysis and automated tests.
- CI logs must not print environment secrets, tokens, or sensitive runtime
  values.
