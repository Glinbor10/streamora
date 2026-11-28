# 07-security-hardening: proposal

## What
Implement the agreed hardening items from the source-only security audit (run-1, commit 6e327b9).

## Scope
1. Release integrity: the Release workflow fails when the Android keystore secret is missing, verifies the APK signer certificate against the expected SHA-256 before publishing, and Gradle refuses the debug-key fallback when `CI` is set.
2. Player: restrict libmpv protocols to tcp, tls, http, https, crypto via `PlayerConfiguration(protocolWhitelist: ...)`.
3. Logout hygiene: clear watch progress and the cached artwork on logout.
4. Login: require `user.auth == true` (a 200 response without a valid Xtream account no longer passes).
5. Published checksums: `SHA256SUMS` plus build provenance attestation for every release asset.
6. Workflow least privilege: `contents: read` at workflow level, `contents: write` only in the release job; `ref_name` and secrets passed through `env:`.

## Out of scope (explicit)
- Windows code signing: needs a paid code-signing certificate.
- `tls-verify=yes`: cannot be validated here; enabling it blind could break https playback. Follow-up after a device test.
- Anything needing execution of libmpv.

## Success criteria
- A tag build without the keystore secret fails; a wrong signer fails.
- Release contains SHA256SUMS and an attestation.
- Tests cover logout clearing, the auth check and the whitelist.
- CI green; no regression in the existing tests.
