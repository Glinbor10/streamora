# 07-security-hardening: design

## Release workflow
- android job: `Restore keystore` fails (exit 1) when `ANDROID_KEYSTORE_BASE64` is empty on tag builds.
- After the build, run `apksigner verify --print-certs` on each APK and compare the SHA-256 digest with `EXPECTED_CERT_SHA256` (c2138dc8bc2a5e929e12991e6e8e0b7130d879c85a4fc6dbcd0916c8e24b32aa, public fingerprint) before upload.
- `android/app/build.gradle.kts`: if `System.getenv("CI") == "true"` and `key.properties` is missing, throw GradleException.
- release job: generate `SHA256SUMS`, run `actions/attest-build-provenance` (needs `id-token: write` and `attestations: write` on that job only).
- Workflow-level `permissions: contents: read`; per-job overrides. `github.ref_name` and secrets via `env:`.
- ci.yml and screenshots.yml get explicit `permissions: contents: read`.

## Player
`Player(configuration: PlayerConfiguration(protocolWhitelist: ['tcp','tls','http','https','crypto']))`.

## Logout
AuthController.logout also: clears the progress repository (new `clear()` on ProgressRepository), calls `DefaultCacheManager().emptyCache()`, and invalidates the continue-watching provider. Orchestration in lib/app so features stay decoupled.

## Login
`checkXtreamAccount`: fail with unauthorized unless `user.auth == true`.

## Risks
- auth == true may reject non-standard servers that omit `auth`; documented in README.
- Pinning the expected certificate digest in the workflow means a key rotation needs a workflow edit (intended).
