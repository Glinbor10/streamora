# Security policy

## Reporting a vulnerability
Please report vulnerabilities privately through GitHub:
**Security tab > Report a vulnerability** on this repository.
Do not open a public issue for security problems. Expect an acknowledgement within a few days.

## Supported versions
Only the latest release receives security fixes.

## What the app handles
- Xtream credentials are stored with the platform secure storage and never logged.
- Watch progress is stored locally and never contains playback URLs.
- The app can connect to plain HTTP servers because many Xtream providers do not offer HTTPS; traffic to those servers is not encrypted.

## Supply chain
- GitHub Actions are pinned to commit hashes and kept up to date by Dependabot.
- Dependabot alerts, secret scanning and push protection are enabled.
- Releases are built by the Release workflow from a tag; the Android APK is signed with the project's release key.
