# 01-project-setup: design

## Structure
lib/features/<feature>/{domain,data,presentation}, lib/shared, lib/main.dart.
Features: auth, catalog, player.

## Dependency rules
- domain: pure Dart. No Flutter, no data, no presentation.
- data: depends on domain only.
- presentation: depends on domain and shared.
- A feature never imports another feature's data/presentation (only its domain).
- shared never imports features.

## Enforcement
- `arch_test` tests in test/architecture/ (run by `flutter test` in CI).
- Lints: `very_good_analysis`; CI uses `flutter analyze --fatal-infos`.
- Optional later: `import_lint` for in-IDE feedback.

## CI / Release
- ci.yml: verify (analyze+test), build-android (debug), build-windows (release).
- release.yml: on tag v*, build APK, zip + Inno Setup installer, publish with softprops/action-gh-release and .github/release.yml categories.
- Android signing via secrets ANDROID_KEYSTORE_BASE64 / _PASSWORD / ANDROID_KEY_ALIAS / _PASSWORD.

## Repo protection
Ruleset on main: PR required, status checks (verify, build-android, build-windows), no force push, no deletion, CODEOWNERS review.
