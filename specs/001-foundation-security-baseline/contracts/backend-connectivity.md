# Contract: Backend Connectivity Boundary

## Purpose

Define the Phase 0 backend boundary used only for configuration validation and
non-sensitive reachability checks.

## Operation: Validate Environment Profile

**Input**:

- Environment name: `development`, `staging`, or `production`
- Supabase URL
- Supabase publishable anon key presence

**Output**:

- `valid`
- `invalidConfiguration`
- Safe validation issue codes

**Rules**:

- Do not print or persist the full publishable key.
- Do not attempt connectivity when configuration is invalid.
- Do not accept service-role keys, private keys, payment credentials, or admin
  credentials.

## Operation: Run Connectivity Check

**Input**:

- Valid environment profile
- Network availability as observed by the app

**Output Statuses**:

- `success`
- `unavailable`
- `timeout`
- `offline`
- `invalidConfiguration`
- `failed`

**Rules**:

- Must not require a signed-in user.
- Must not expose session state.
- Must not use privileged backend credentials.
- Must not read, write, or display marketplace, identity, payment, document,
  receipt, travel, risk, or user records.
- Raw provider errors must be converted to safe result codes and messages.

## Failure Handling

- Invalid configuration returns blocked state.
- Offline returns offline state with retry affordance.
- Timeout returns timeout state with retry affordance.
- Unexpected failures return safe error state and redacted diagnostics.

## Test Expectations

- Valid configuration plus reachable backend returns `success`.
- Missing URL or key returns `invalidConfiguration`.
- Network unavailable returns `offline` or `unavailable`.
- Timeout is testable independently from generic failure.
- No sensitive values appear in logs, analytics, UI text, or normal storage.
