# Release integrity

Scenario: missing keystore
- Given a v* tag build and an empty ANDROID_KEYSTORE_BASE64
- When the android job runs
- Then it fails before building

Scenario: wrong signer
- Given a built APK signed with a different certificate
- When the verification step runs
- Then the job fails and nothing is published

Scenario: checksums
- Given a successful release
- Then SHA256SUMS and a build provenance attestation are attached to the release

Scenario: least privilege
- Given the workflows
- Then build jobs run with contents: read and only the release job can write
