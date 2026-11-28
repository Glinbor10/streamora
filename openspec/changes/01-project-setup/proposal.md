# 01-project-setup: proposal

## What
Bootstrap the Streamore repository: Flutter project (Android + Windows), layered architecture with automated enforcement, CI, tag-driven Release workflow, protected `main`.

## Why
Portfolio-grade public project. Quality gates must exist before features so architecture and releases stay clean.

## Scope
- Flutter project, lints, folder structure per feature.
- Architecture tests (`arch_test`) run in CI.
- CI: analyze, test, build Android + Windows on every PR.
- Release workflow on `v*` tags: signed-if-secrets APK, Windows setup `.exe` and portable `.zip`, GitHub Release with generated notes.
- Branch protection on `main`: PR + CI required, CODEOWNERS.

## Success criteria
- CI green on `main`; a PR that breaks a layer rule fails CI.
- Pushing tag `v0.1.0` creates a Release with APK, setup.exe and zip.
- Direct pushes to `main` are rejected.
