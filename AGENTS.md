<!-- SPECKIT START -->
Current Spec Kit plan: specs/001-foundation-security-baseline/plan.md
<!-- SPECKIT END -->

You are building Bringly, a security-first Flutter marketplace app using
Supabase as the backend-as-a-service foundation.

Non-negotiable rules:

1. Never add hardcoded secrets, private keys, service-role keys, passwords, or
   payment credentials.
2. Keep Supabase URL and publishable anon key in environment-specific runtime
   configuration, not scattered through feature code.
3. Never store sensitive identity documents, receipts, payment details, or
   travel documents in normal local storage.
4. Use secure storage only for small sensitive values such as auth/session
   tokens, behind a mockable abstraction.
5. Never log PII, tokens, documents, receipts, payment data, travel proof, or
   internal risk scores.
6. Never make authorization decisions only in the Flutter app.
7. Backend API, Supabase Edge Functions, RPCs with strict authorization, and
   Supabase policies are the source of truth for critical marketplace state.
8. All sensitive file uploads must use backend-issued signed upload URLs.
9. All critical state transitions must call backend-controlled APIs or
   server-side Supabase logic.
10. Follow feature-first Clean Architecture under `lib/features/`, with
    presentation, application, domain, and data concerns separated.
11. Every feature must include tests for success, failure, unauthorized,
    loading, empty, blocked, and edge states.
12. Any generated code that violates these rules must be rejected and
    redesigned.
