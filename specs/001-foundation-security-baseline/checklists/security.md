# Phase 0 Security Checklist

- [x] No hardcoded secrets or service-role keys are present in app code.
- [x] Supabase URL and anon key remain runtime-configured rather than scattered.
- [x] No sensitive logs or raw provider errors are emitted.
- [x] No sensitive analytics metadata is accepted.
- [x] No direct marketplace table reads or writes occur in the connectivity client.
- [x] No sensitive values are stored in normal local storage.
- [x] Connectivity checks stay non-sensitive and unauthenticated.
- [x] Protected storage smoke-test values are harmless and cleaned up after use.
