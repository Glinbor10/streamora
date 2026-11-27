# 06-brand-and-modern-ui: proposal

## What
A visual refresh: navy blue + electric cyan brand palette (replacing red), a logo/app icon, and a more modern, fintech-like navigation (floating pill bar on phones, slim icon rail on desktop). References: Trade Republic and Revolut for chrome and motion, Stremio for the content-first layout (large posters, minimal chrome, compact sidebar).

## Why
The first UI proved the structure; this gives the app its own identity and a more polished look for the public repo and LinkedIn.

## Scope
- Palette: background #0A1128, surface #121C3D, surface-high #1B2750, accent cyan #3DD6F5, text #F4F7FF, muted #8FA0C8. Gradients for hero scrims use the navy.
- Logo "play made of two waves" in cyan on navy: in-app widget (CustomPainter, no assets), Android adaptive icon, Windows .ico, README header.
- Navigation: floating rounded pill bar with blur and animated cyan indicator on phones; slim icon-only rail with tooltips on desktop (labels on hover); transparent app bar with the logo wordmark.
- Typography and shape polish: larger rounded corners, softer card elevation, chip and search field restyle, smoother page transitions.
- Splash/login: logo plus tagline, refined form.
- Re-render all README screenshots with the new look.
- Optional release improvement: publish a split-per-ABI arm64 APK (the universal APK is about 97 MB).

## Out of scope
Light theme, user-selectable accent, new features.

## Success criteria
- No red remains in the UI except semantic errors and the LIVE badge.
- Same adaptive behavior (breakpoint 600 px), no overflow at 360, 600 and 1280 px.
- App icon visible on Android launcher and Windows exe/installer.
- CI green; screenshots updated.
